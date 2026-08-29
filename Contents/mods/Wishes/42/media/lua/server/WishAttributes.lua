-----------------------
--- Wish Attributes ---
-----------------------
-- Current attribute categories:
--  - Options
--  - Effects


----------------------------------------------------------------------------------
--- Options
----------------------------------------------------------------------------------
-- WishOptions = table.newarray();
WishOptions = {};

WishOptions.getTraits = function(self, player)
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

WishOptions.getSkills = function(self, _player)
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
WishEffects = {};


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

-- function WishEffects:modifyTrait(char, selectedOptionID)
WishEffects.modifyTrait = function(char, traitID)
    if not WishWhitelist_ModifyTrait[traitID] then return false end
    local trait = getTraitFromID(traitID)
    local hasTrait = char:hasTrait(trait);
    if hasTrait then
        return removeTrait(char, trait)
    else
        return obtainTrait(char, trait)
    end
end

-- skills
WishEffects.skillLevelUpUntil = function(char, skillID)
    if not WishWhitelist_SkillLevelUntil[skillID] then return false end

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

WishEffects.skillLevelUpOnce = function(char, skillID)
    if not WishWhitelist_SkillLevelOnce[skillID] then return false end
    local perk = PerkFactory.Perks.FromString(skillID)
    local startingPerkLevel = char:getPerkLevel(perk);
    char:LevelPerk(perk);
    local perkLevel = char:getPerkLevel(perk);
    return perkLevel == (startingPerkLevel + 1)
end

-- player weight (NOT carry weight)
WishEffects.setIdealWeight = function(char, _selectedOptionID)
    local nutrition = char:getNutrition();
    nutrition:setWeight(80);
    nutrition:applyTraitFromWeight();
    return nutrition:getWeight() == 80
end

-- healing
WishEffects.healUp = function(char, _selectedOptionID)
    local bodyDamage = char:getBodyDamage();
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):RestoreToFullHealth();
    end
    bodyDamage:Update();
    return true
end

-- consumes 2 wishes
WishEffects.cureSickness = function(char, _selectedOptionID)
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
WishEffects.obtainItem = function(char, selectedOptionID)
    local selectedOption = WishWhitelist_ObtainItem[selectedOptionID]
    if not selectedOption then return false end

    local createItemMethod = instanceItem
    for i = 1, selectedOption.quantity do
        local item = createItemMethod(selectedOption.item)
        char:getInventory():AddItem(item)
    end
    return true
end

WishEffects.endWishing = function(_char, _selectedOptionID)
    -- todo
    return true
end

WishEffects.repairItem = function(_char, selectedOptionID)
    -- todo
    return true
end

WishEffects.obtainWeapons = function(_char, selectedOptionID)
    -- todo
    return true
end

WishEffects.extraWishes = function(_char, _selectedOptionID)
    -- todo
    return true
end


-- WishEffects.obtainWeapon = function(char, weapon)
--      return 0;
-- end

-- deseos no pedidos en dbz pero interesantes:
-- pastillas para niveles temporales
----------------------------------------------------------------------------------
--- All Existing Wishes
----------------------------------------------------------------------------------
-- modifyTrait (get / remove a trait)
-- skillLevelUpUntil (level up a skill until a certain level)
-- skillLevelUpOnce (level up a skill once)
-- healInjuries 
-- cureSickness 
-- idealWeight (set the player to the ideal weight, NOT carry weight)

-- wishes that need implementation:
-- 1. add a weapon/tool
-- 2. add a gun (with its corresponding ammo box)
-- 3. add materials
-- 4. godmode for a day
-- 5. 

----------------------------------------------------------------------------------
--- Wish Option Whitelists/Blacklists
----------------------------------------------------------------------------------
-- each wish which could have options has 3 lists
-- only one list needs to be present if one decides to hardcode the table

-- WishWhitelist_X : the full whitelisted options which it may have
WishWhitelist_ModifyTrait = {}
-- WishWhitelistForce_X : a whitelist to force certain options to appear in the list 
--                        even if they don't fulfill the filtering criteria
WishWhitelistForce_ModifyTrait = {}
-- WishBlacklist_X : a blacklist to ensure these specific traits don't appear in the list
--                   even if they do fulfill the filtering criteria
WishBlacklist_ModifyTrait = {}


WishWhitelist_SkillLevelUntil = {}
WishWhitelistForce_SkillLevelUntil = {}
WishBlacklist_SkillLevelUntil = {}

WishWhitelist_SkillLevelOnce = {}
WishWhitelistForce_SkillLevelOnce = {}
WishBlacklist_SkillLevelOnce = {}

WishWhitelist_ObtainItem = {}

-------------------------------------------------------------------------------
local function ModifyTrait_isTraitAllowed(trait, id)
    if WishBlacklist_ModifyTrait[id] then return false end
    if WishWhitelistForce_ModifyTrait[id] then return true end
    return trait:getCost() ~= 0
end

local function ModifyTrait_initWhitelist()
    WishWhitelist_ModifyTrait = {}

    local traitsArray = CharacterTraitDefinition.getTraits();
    for i = 0, traitsArray:size()-1 do
        local trait = traitsArray:get(i)
        local traitID = tostring(trait:getType())

        if ModifyTrait_isTraitAllowed(trait, traitID) then
            WishWhitelist_ModifyTrait[traitID] = true
        end
    end
end

local function SkillLevelUntil_isSkillAllowed(skill, id)
    if WishBlacklist_SkillLevelUntil[id] then return false end
    if WishWhitelistForce_SkillLevelUntil[id] then return true end
    local parent = skill:getParent();
    local skillNone = PerkFactory.Perks.None;
    return parent ~= skillNone
end

local function SkillLevelUntil_initWhitelist()
    WishWhitelist_SkillLevelUntil = {}

    local skillsArray = PerkFactory.PerkList;
    for i = skillsArray:size()-1, 0, -1 do
        local skill = skillsArray:get(i);
        local skillID = skill:getId()
        if SkillLevelUntil_isSkillAllowed(skill, skillID) then
            WishWhitelist_SkillLevelUntil[skillID] = true
        end
    end
end

local function SkillLevelOnce_isSkillAllowed(skill, id)
    if WishBlacklist_SkillLevelOnce[id] then return false end
    if WishWhitelistForce_SkillLevelOnce[id] then return true end
    local parent = skill:getParent();
    local skillNone = PerkFactory.Perks.None;
    return parent ~= skillNone
end

local function SkillLevelOnce_initWhitelist()
    WishWhitelist_SkillLevelOnce = {}

    local skillsArray = PerkFactory.PerkList;
    for i = skillsArray:size()-1, 0, -1 do
        local skill = skillsArray:get(i);
        local skillID = skill:getId()
        if SkillLevelOnce_isSkillAllowed(skill, skillID) then
            WishWhitelist_SkillLevelOnce[skillID] = true
        end
    end
end

------------------------------

local function initializeWhitelists()
    ModifyTrait_initWhitelist()
    SkillLevelUntil_initWhitelist()
    SkillLevelOnce_initWhitelist()
end

Events.OnGameStart.Add(initializeWhitelists)