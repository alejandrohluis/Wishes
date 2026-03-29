local Recipe = RecipeCodeOnCreate;

local function startWishingMenu(player, wishes, wishAmount)
    local window = WishingWindows[player];
    window:initialise(wishes, wishAmount);
    window:startMenu();
end

function Recipe.SummonShenron(craftRecipeData, player)
    local effects = WishEffects;
    local options = WishOptions;
    local wishes = {
        -- modify trait
        { isEnabled = true, label = "Get/Remove a Trait",                effect = effects.modifyTrait,       options = options:getTraits() },
        -- level up skill until
        { isEnabled = true, label = "Level up your skill up to level 5", effect = effects.skillLevelUpUntil, options = options:getSkills() },
        -- level up skill once
        { isEnabled = true, label = "Level up your skill once",          effect = effects.skillLevelUpOnce,  options = options:getSkills() },
        -- heal injuries
        { isEnabled = true, label = "Heal all injuries",                 effect = effects.healUp },
        -- cure sickness
        { isEnabled = true, label = "Cure all sickness",                 effect = effects.cureSickness },
        -- ideal weight
        { isEnabled = true, label = "Ideal Weight",                      effect = effects.setIdealWeight }
    };
    local wishAmount = 3;
    startWishingMenu(player, wishes, wishAmount);
end