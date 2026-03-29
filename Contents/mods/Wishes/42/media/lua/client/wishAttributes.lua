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

WishOptions.getTraits = function()
    local traitsArray = CharacterTraitDefinition.getTraits();
    local traits = {
        { label = "Good Traits" , children = {} },
        { label = "Bad Traits" , children = {} }
    };
    for i = traitsArray:size()-1, 0, -1 do
        local trait = traitsArray:get(i);
        if trait then
            local cost = trait:getCost();
            if cost > 0 then
                table.insert(traits[1].children, trait);
            end
            if cost < 0 then
                table.insert(traits[2].children, trait);
            end
        end
    end
    return traits;
end

WishOptions.getSkills = function()
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
    return player:hasTrait(trait);
end

local function removeTrait(player, trait)
    player:getCharacterTraits():remove(trait);
    return not player:hasTrait(trait);
end

-- function WishEffects:modifyTrait(char, wish)
WishEffects.modifyTrait = function(char, wish)
    local player = char;
    local trait = wish.data:getType();
    local hasTrait = player:hasTrait(trait);
    if hasTrait then
        return removeTrait(player, trait);
    else
        return obtainTrait(player, trait);
    end
end

-- skills
WishEffects.skillLevelUpUntil = function(char, wish)
    local player = char;
    local perk = wish.data:getType();
    local perkLevel = player:getPerkLevel(perk);
    local startingPerkLevel = perkLevel;
    local maxLevel = 5;
    while perkLevel < maxLevel do
        player:LevelPerk(perk);
        perkLevel = perkLevel + 1;
    end
    return startingPerkLevel ~= perkLevel;
end

WishEffects.skillLevelUpOnce = function(char, wish)
    local player = char;
    local perk = wish.data:getType();
    local startingPerkLevel = player:getPerkLevel(perk);
    player:LevelPerk(perk);
    local perkLevel = player:getPerkLevel(perk);
    return perkLevel == (startingPerkLevel + 1);
end

-- player weight (NOT carry weight)
WishEffects.setIdealWeight = function(char)
    local nutrition = char:getNutrition();
    nutrition:setWeight(80);
    nutrition:applyTraitFromWeight();
    return nutrition:getWeight() == 80;
end

-- healing
WishEffects.healUp = function(char)
    local bodyDamage = char:getBodyDamage();
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):RestoreToFullHealth();
    end
    bodyDamage:Update();
    return bodyDamage:getHealth() == 100.0;
end

WishEffects.cureSickness = function(char)
    local bodyDamage = char:getBodyDamage();
    if not bodyDamage:IsInfected() then
        return false;
    end
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):SetInfected(false);
    end
    bodyDamage:setInfected(false);
    bodyDamage:setInfectionTime(-1.0);
    bodyDamage:setInfectionMortalityDuration(-1.0);
    return true;
end

-- WishEffects.obtainWeapon = function(char, weapon)
--      return false;
-- end

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
