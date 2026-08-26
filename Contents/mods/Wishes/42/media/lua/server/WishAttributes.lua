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
WishEffects.modifyTrait = function(char, selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    local trait = selectedOption.data:getType();
    local hasTrait = char:hasTrait(trait);
    if hasTrait then
        removeTrait(char, trait)
    else
        obtainTrait(char, trait)
    end
    panel:consumeWish(maxWishesConsumed)
end

-- skills
WishEffects.skillLevelUpUntil = function(char, selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    local perk = selectedOption.data:getType();
    local perkLevel = char:getPerkLevel(perk);
    local startingPerkLevel = perkLevel;
    local maxLevel = 5;
    while perkLevel < maxLevel do
        char:LevelPerk(perk);
        perkLevel = perkLevel + 1;
    end
    if startingPerkLevel ~= perkLevel then
        panel:consumeWish(maxWishesConsumed)
    end
end

WishEffects.skillLevelUpOnce = function(char, selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    local perk = selectedOption.data:getType();
    local startingPerkLevel = char:getPerkLevel(perk);
    char:LevelPerk(perk);
    local perkLevel = char:getPerkLevel(perk);
    if perkLevel == (startingPerkLevel + 1) then
        panel:consumeWish(maxWishesConsumed)
    end
end

-- player weight (NOT carry weight)
WishEffects.setIdealWeight = function(char, _selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    local nutrition = char:getNutrition();
    nutrition:setWeight(80);
    nutrition:applyTraitFromWeight();
    panel:consumeWish(maxWishesConsumed)
end

-- healing
WishEffects.healUp = function(char, _selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    local bodyDamage = char:getBodyDamage();
    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):RestoreToFullHealth();
    end
    bodyDamage:Update();
    panel:consumeWish(maxWishesConsumed)
end

-- consumes 2 wishes
WishEffects.cureSickness = function(char, _selectedOption, panel)
    local maxWishesConsumed = 2
    if not panel:canPerformWish(maxWishesConsumed) then return end

    local bodyDamage = char:getBodyDamage();
    if not bodyDamage:IsInfected() then return end

    local bodyParts = bodyDamage:getBodyParts();
    for i = 0, bodyParts:size()-1 do
        bodyParts:get(i):SetInfected(false);
    end
    bodyDamage:setInfected(false);
    bodyDamage:setInfectionTime(-1.0);
    bodyDamage:setInfectionMortalityDuration(-1.0);
    panel:consumeWish(maxWishesConsumed)
end

-- wish to obtain a specific item from a list of options
WishEffects.obtainItem = function(char, selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    for i = 1, selectedOption.quantity do
        local item = instanceItem(selectedOption.data)
        char:getInventory():AddItem(item)
    end
    panel:consumeWish(maxWishesConsumed)
end

WishEffects.endWishing = function(_char, _selectedOption, panel)
    panel:close()
end

WishEffects.repairItem = function(_char, _selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    panel:consumeWish(maxWishesConsumed)
end

WishEffects.obtainWeapons = function(_char, _selectedOption, panel)
    local maxWishesConsumed = 1
    if not panel:canPerformWish(maxWishesConsumed) then return end
    panel:consumeWish(maxWishesConsumed)
end

WishEffects.extraWishes = function(_char, _selectedOption, panel)
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
