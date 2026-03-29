local Recipe = RecipeCodeOnCreate;

local function startWishingMenu(summonType, player, wishes, wishAmount)
    local window = WishingWindows[player];
    window:initialise(summonType, wishes, wishAmount);
    window:startMenu();
end

function Recipe.SummonShenron(craftRecipeData, player)
    local effects = WishEffects;
    local options = WishOptions;
    local sandbox = SandboxVars.Wishes
    local wishes = {
        -- modify trait
        { label = "Get/Remove a Trait",                isEnabled = sandbox.DB_Wish_Trait,             effect = effects.modifyTrait,       options = options:getTraits() },
        -- level up skill until
        { label = "Level up your skill up to level 5", isEnabled = sandbox.DB_Wish_SkillLevelUpUntil, effect = effects.skillLevelUpUntil, options = options:getSkills() },
        -- level up skill once
        { label = "Level up your skill once",          isEnabled = sandbox.DB_Wish_SkillLevelUp,      effect = effects.skillLevelUpOnce,  options = options:getSkills() },
        -- heal injuries
        { label = "Heal all injuries",                 isEnabled = sandbox.DB_Wish_HealInjury,        effect = effects.healUp },
        -- cure sickness
        { label = "Cure all sickness",                 isEnabled = sandbox.DB_Wish_HealSickness,      effect = effects.cureSickness },
        -- ideal weight
        { label = "Ideal Weight",                      isEnabled = sandbox.DB_Wish_Weight,            effect = effects.setIdealWeight },
        -- extra wishes
        { label = "Extra Wishes",                      isEnabled = sandbox.DB_Wish_MoreWishes,        effect = effects.extraWishes , style = "Shenron" }
    };
    local wishAmount = sandbox.DB_Setting_MaxWishes;
    startWishingMenu("Shenron", player, wishes, wishAmount);
end