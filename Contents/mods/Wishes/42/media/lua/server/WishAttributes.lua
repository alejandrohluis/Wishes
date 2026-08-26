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
        { label = "Get a Good Trait" , children = {} },
        { label = "Remove a Good Trait", children = {}},
        { label = "Get a Bad Trait", children = {}},
        { label = "Remove a Bad Trait" , children = {} },
    };
    for i = traitsArray:size()-1, 0, -1 do
        local trait = traitsArray:get(i);
        local hasTrait = player:hasTrait(trait:getType())
        if trait then
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
                table.insert(traits[index].children, trait)
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
                local parentSkill = { label = skill:getName(), children = {} };
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
                    if skills[j].label == parent:getName() then
                        table.insert(skills[j].children, skill);
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
local function obtainTrait(player, trait)
    player:getCharacterTraits():add(trait);
    return player:hasTrait(trait)
end

local function removeTrait(player, trait)
    player:getCharacterTraits():remove(trait);
    return not player:hasTrait(trait)
end

-- function WishEffects:modifyTrait(char, wish)
WishEffects.modifyTrait = function(char, selectedOptionID)
    local selectedOption = WishWhitelist_ModifyTrait[selectedOptionID]
    if not selectedOption then return end

    local trait = selectedOption:getType();
    local hasTrait = char:hasTrait(trait);
    if hasTrait then
        removeTrait(char, trait)
    else
        obtainTrait(char, trait)
    end
end

-- skills
WishEffects.skillLevelUpUntil = function(char, selectedOptionID)
    local selectedOption = WishWhitelist_SkillLevelUntil[selectedOptionID]
    if not selectedOption then return end

    local perk = selectedOption:getType();
    local perkLevel = char:getPerkLevel(perk);
    -- local startingPerkLevel = perkLevel;
    local maxLevel = 5;
    while perkLevel < maxLevel do
        char:LevelPerk(perk);
        perkLevel = perkLevel + 1;
    end
    -- if startingPerkLevel ~= perkLevel then
    -- end
end

WishEffects.skillLevelUpOnce = function(char, selectedOptionID)
    local selectedOption = WishWhitelist_SkillLevelOnce[selectedOptionID]
    if not selectedOption then return end

    local perk = selectedOption:getType();
    -- local startingPerkLevel = char:getPerkLevel(perk);
    char:LevelPerk(perk);
    -- local perkLevel = char:getPerkLevel(perk);
    -- if perkLevel == (startingPerkLevel + 1) then
    -- end
end

-- player weight (NOT carry weight)
WishEffects.setIdealWeight = function(char, _selectedOptionID)
    local nutrition = char:getNutrition();
    nutrition:setWeight(80);
    nutrition:applyTraitFromWeight();
end

-- healing
WishEffects.healUp = function(char, _selectedOptionID)
    local bodyDamage = char:getBodyDamage();
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):RestoreToFullHealth();
    end
    bodyDamage:Update();
end

-- consumes 2 wishes
WishEffects.cureSickness = function(char, _selectedOptionID)

    local bodyDamage = char:getBodyDamage();
    if not bodyDamage:IsInfected() then return end

    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):SetInfected(false);
    end
    bodyDamage:setInfected(false);
    bodyDamage:setInfectionTime(-1.0);
    bodyDamage:setInfectionMortalityDuration(-1.0);
end

-- wish to obtain a specific item from a list of options
WishEffects.obtainItem = function(char, selectedOptionID)
    local selectedOption = WishWhitelist_ObtainItem[selectedOptionID]
    if not selectedOption then return end

    local createItemMethod = instanceItem
    for i = 1, selectedOption.quantity do
        local item = createItemMethod(selectedOption.item)
        char:getInventory():AddItem(item)
    end
end

WishEffects.endWishing = function(_char, _selectedOptionID)
end

WishEffects.repairItem = function(_char, selectedOptionID)
end

WishEffects.obtainWeapons = function(_char, selectedOptionID)
end

WishEffects.extraWishes = function(_char, _selectedOptionID)
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
