-----------------------
--- Wish Attributes ---
-----------------------
-- Current attribute categories:
--  - Options
--  - Effects

DPWishes = DPWishes or {}

----------------------------------------------------------------------------------
--- Options
----------------------------------------------------------------------------------
DPWishes.Options = {};

local wishOptions = DPWishes.Options

wishOptions.getTraits = function(self, player)
    local traitsArray = CharacterTraitDefinition.getTraits();
    local traits = {
        { label = "Get a Good Trait" , options = {} , color = { r = 0, g = 0.7, b = 0, a = 1 } },
        { label = "Remove a Good Trait", options = {} , color = { r = 0.7, g = 0, b = 0, a = 1 } },
        { label = "Get a Bad Trait", options = {} , color = { r = 0.7, g = 0, b = 0, a = 1 } },
        { label = "Remove a Bad Trait" , options = {} , color = { r = 0, g = 0.7, b = 0, a = 1 } },
    };
    for i = traitsArray:size()-1, 0, -1 do
        local trait = traitsArray:get(i);
        if trait then
            local traitType = trait:getType()
            local hasTrait = player:hasTrait(traitType)
            local cost = trait:getCost();
            local index = 0
            -- cost > 0 ==> good trait
            -- cost < 0 ==> bad trait
            if cost > 0 then
                index = 1
            elseif cost < 0 then
                index = 3
            end

            if hasTrait then
                index = index + 1
            end

            if index ~= 0 then
                local traitDisplay = { label = trait:getLabel() , optionID = tostring(traitType) , tooltip = trait:getDescription() }
                table.insert(traits[index].options, traitDisplay)
            end
        end
    end
    return traits;
end

wishOptions.getSkills = function(self, _player)
    local skillsArray = PerkFactory.PerkList;
    local arraySize = skillsArray:size()-1;
    local skillNone = PerkFactory.Perks.None;
    local skills = {};
    for i = arraySize, 0, -1 do
        local skill = skillsArray:get(i);
        if skill then
            local parent = skill:getParent();
            if parent == skillNone then
                local parentSkill = { label = skill:getName(), id = skill:getId(), options = {} , color = { r = 0.7, g = 0.7, b = 0.7, a = 1 } };
                table.insert(skills, parentSkill);
            end
        end
    end
    for i = arraySize, 0, -1 do
        local skill = skillsArray:get(i);
        if skill then
            local parent = skill:getParent();
            if parent ~= skillNone then
                for j = 1, #skills do
                    if skills[j].id == parent:getId() then
                        local skillDisplay = { label = skill:getName(), optionID = skill:getId() }
                        table.insert(skills[j].options, skillDisplay);
                    end
                end
            end
        end
    end
    return skills;
end

----------------------------------------------------------------------------------
--- Wish Effects
----------------------------------------------------------------------------------
-- effect(player, wish)   
-- Returns if the wish is consumed or not
DPWishes.Effects = {};

local wishEffects = DPWishes.Effects

-- traits
local function getTraitFromID(traitID)
    -- ensures that the type from the ID is a string for security
    if type(traitID) ~= "string" then return nil end

    local traitsArray = CharacterTraitDefinition.getTraits()
    for i = 0, traitsArray:size() - 1 do
        local trait = traitsArray:get(i)
        if trait then
            local traitType = trait:getType()
            if tostring(traitType) == traitID then
                return traitType
            end
        end
    end
    return nil
end

local function obtainTrait(player, trait)
    player:getCharacterTraits():add(trait);
    return player:hasTrait(trait)
end

local function removeTrait(player, trait)
    player:getCharacterTraits():remove(trait);
    return not player:hasTrait(trait)
end

-- adds/removes a selected trait to/from the player
wishEffects.modifyTrait = function(char, traitID)
    if not DPWishes.FilteringLists.Whitelist_ModifyTrait[traitID] then return false end
    local trait = getTraitFromID(traitID)
    local hasTrait = char:hasTrait(trait);
    if hasTrait then
        return removeTrait(char, trait)
    else
        return obtainTrait(char, trait)
    end
end

-- levels up a selected skill until reaching a certain level
wishEffects.skillLevelUpUntil = function(char, skillID)
    if not DPWishes.FilteringLists.Whitelist_SkillLevelUntil[skillID] then return false end

    local perk = PerkFactory.Perks.FromString(skillID)
    local perkLevel = char:getPerkLevel(perk);
    local startingPerkLevel = perkLevel;
    local maxLevel = 5;
    while perkLevel < maxLevel do
        char:LevelPerk(perk);
        perkLevel = perkLevel + 1;
    end
    return startingPerkLevel ~= perkLevel
end

-- levels up a selected skill once
wishEffects.skillLevelUpOnce = function(char, skillID)
    if not DPWishes.FilteringLists.Whitelist_SkillLevelOnce[skillID] then return false end
    local perk = PerkFactory.Perks.FromString(skillID)
    local startingPerkLevel = char:getPerkLevel(perk);
    char:LevelPerk(perk);
    local perkLevel = char:getPerkLevel(perk);
    return perkLevel == (startingPerkLevel + 1)
end

-- sets the player weight to the ideal weight
wishEffects.setIdealWeight = function(char, _selectedOptionID)
    local nutrition = char:getNutrition();
    nutrition:setWeight(80);
    nutrition:applyTraitFromWeight();
    return nutrition:getWeight() == 80
end

-- heals the player's health bar to full HP. does not heal any sickness 
wishEffects.healUp = function(char, _selectedOptionID)
    local bodyDamage = char:getBodyDamage();
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):RestoreToFullHealth();
    end
    bodyDamage:Update();
    return true
end

-- cure all sickness the player has (whether that may be Zombie Infection or queasy-type sickness)
wishEffects.cureSickness = function(char, _selectedOptionID)
    local bodyDamage = char:getBodyDamage();
    if not bodyDamage:IsInfected() then return false end

    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):SetInfected(false);
    end
    bodyDamage:setInfected(false);
    bodyDamage:setInfectionTime(-1.0);
    bodyDamage:setInfectionMortalityDuration(-1.0);
    return true
end

-- wish to obtain a specific item from a list of options
wishEffects.obtainItem = function(char, optionID)
    local itemData = DPWishes.FilteringLists.Whitelist_ObtainItem[optionID]
    if not itemData then return false end

    local minimumItemQuantity = itemData.minQuantity
    local maximumItemQuantity = itemData.maxQuantity
    if minimumItemQuantity > maximumItemQuantity then
        print("[Wishes] ERROR: Invalid obtainItem config for ".. optionID .. ": minQuantity > maxQuantity !")
        return false
    end

    local createItemMethod = instanceItem
    local updateInventoryMethod = sendAddItemToContainer
    local itemID = itemData.itemID
    local itemQuantity = minimumItemQuantity
    if minimumItemQuantity < maximumItemQuantity then
        itemQuantity = ZombRand(minimumItemQuantity, maximumItemQuantity + 1)
    end
    local itemDataModifier = itemData.itemDataModifier

    for _ = 1, itemQuantity do
        local generatedItem = createItemMethod(itemID)
        if not generatedItem then return false end
        if itemDataModifier then
            itemDataModifier(generatedItem)
        end
        char:getInventory():AddItem(generatedItem)
        updateInventoryMethod(char:getInventory(), generatedItem)
    end
    return true
end

wishEffects.endWishing = function(_char, _selectedOptionID)
    -- TODO. not a priority
    return false
end

wishEffects.repairItem = function(_char, selectedOptionID)
    -- TODO. not a priority
    return false
end

wishEffects.obtainWeapons = function(_char, selectedOptionID)
    -- TODO. not a priority
    return false
end

wishEffects.extraWishes = function(_char, _selectedOptionID)
    -- TODO. not a priority
    return false
end

-- deseos no pedidos en dbz pero interesantes:
-- pastillas para niveles temporales
-- carryweight infinito por una hora/dia

-- wishes that need implementation:
-- 1. adds a melee weapon/tool
-- 2. adds a gun (with its corresponding ammo box)
-- 3. adds materials (like planks, boxes of nails, etc...)
-- 4. untraceable from zombies for a day (basically activate the "invisible" cheat)
-- 5. infinite carryweight for a day/hour

----------------------------------------------------------------------------------
--- Wish Option Whitelists/Blacklists
----------------------------------------------------------------------------------
-- each wish which could have options has 3 lists
-- only one list needs to be present if one decides to hardcode the table

-- WishWhitelist_X : the full whitelisted options which it may have
DPWishes.FilteringLists = {}

local wishFilteringLists = DPWishes.FilteringLists

wishFilteringLists.Whitelist_ModifyTrait = {}
-- WishWhitelistForce_X : a whitelist to force certain options to appear in the list 
--                        even if they don't fulfill the filtering criteria
wishFilteringLists.WhitelistForce_ModifyTrait = {}
-- WishBlacklist_X : a blacklist to ensure these specific traits don't appear in the list
--                   even if they do fulfill the filtering criteria
wishFilteringLists.Blacklist_ModifyTrait = {}


wishFilteringLists.Whitelist_SkillLevelUntil = {}
wishFilteringLists.WhitelistForce_SkillLevelUntil = {}
wishFilteringLists.Blacklist_SkillLevelUntil = { Agility = true }

wishFilteringLists.Whitelist_SkillLevelOnce = {}
wishFilteringLists.WhitelistForce_SkillLevelOnce = {}
wishFilteringLists.Blacklist_SkillLevelOnce = { Agility = true }

wishFilteringLists.Whitelist_ObtainItem = {}

-------------------------------------------------------------------------------
local function ModifyTrait_isTraitAllowed(trait, id)
    if wishFilteringLists.Blacklist_ModifyTrait[id] then return false end
    if wishFilteringLists.WhitelistForce_ModifyTrait[id] then return true end
    return trait:getCost() ~= 0
end

local function ModifyTrait_initWhitelist()
    wishFilteringLists.Whitelist_ModifyTrait = {}

    local traitsArray = CharacterTraitDefinition.getTraits();
    for i = 0, traitsArray:size()-1 do
        local trait = traitsArray:get(i)
        local traitID = tostring(trait:getType())

        if ModifyTrait_isTraitAllowed(trait, traitID) then
            wishFilteringLists.Whitelist_ModifyTrait[traitID] = true
        end
    end
end

local function SkillLevelUntil_isSkillAllowed(skill, id)
    if wishFilteringLists.Blacklist_SkillLevelUntil[id] then return false end
    if wishFilteringLists.WhitelistForce_SkillLevelUntil[id] then return true end
    local parent = skill:getParent();
    local skillNone = PerkFactory.Perks.None;
    return parent ~= skillNone
end

local function SkillLevelUntil_initWhitelist()
    wishFilteringLists.Whitelist_SkillLevelUntil = {}

    local skillsArray = PerkFactory.PerkList;
    for i = skillsArray:size()-1, 0, -1 do
        local skill = skillsArray:get(i);
        local skillID = skill:getId()
        if SkillLevelUntil_isSkillAllowed(skill, skillID) then
            wishFilteringLists.Whitelist_SkillLevelUntil[skillID] = true
        end
    end
end

local function SkillLevelOnce_isSkillAllowed(skill, id)
    if wishFilteringLists.Blacklist_SkillLevelOnce[id] then return false end
    if wishFilteringLists.WhitelistForce_SkillLevelOnce[id] then return true end
    local parent = skill:getParent();
    local skillNone = PerkFactory.Perks.None;
    return parent ~= skillNone
end

local function SkillLevelOnce_initWhitelist()
    wishFilteringLists.Whitelist_SkillLevelOnce = {}

    local skillsArray = PerkFactory.PerkList;
    for i = skillsArray:size()-1, 0, -1 do
        local skill = skillsArray:get(i);
        local skillID = skill:getId()
        if SkillLevelOnce_isSkillAllowed(skill, skillID) then
            wishFilteringLists.Whitelist_SkillLevelOnce[skillID] = true
        end
    end
end

------------------------------

local function initializeWishWhitelists()
    ModifyTrait_initWhitelist()
    SkillLevelUntil_initWhitelist()
    SkillLevelOnce_initWhitelist()
end

Events.OnGameStart.Add(initializeWishWhitelists())