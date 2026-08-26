local Recipe = RecipeCodeOnCreate;

local function startWishingMenu(player, wishStyle)
    local window = WishingWindows[player];
    window:initialise(wishStyle);
    window:startMenu();
end

function Recipe.GenieLamp(craftRecipeData, player)
    local effects = WishEffects;
    local options = WishOptions;
    local sandbox = SandboxVars.Wishes

    local wishes = {
        -- modify trait
        { label = "Get/Remove a Trait",                isEnabled = sandbox.GL_Wish_Trait,             effect = effects.modifyTrait,       options = options.getTraits },
        -- level up skill until
        { label = "Level up your skill up to level 5", isEnabled = sandbox.GL_Wish_SkillLevelUpUntil, effect = effects.skillLevelUpUntil, options = options.getSkills },
        -- level up skill once
        { label = "Level up your skill once",          isEnabled = sandbox.GL_Wish_SkillLevelUp,      effect = effects.skillLevelUpOnce,  options = options.getSkills },
        -- heal injuries
        { label = "Heal all injuries",                 isEnabled = sandbox.GL_Wish_HealInjury,        effect = effects.healUp },
        -- cure sickness
        { label = "Cure all sickness",                 isEnabled = sandbox.GL_Wish_HealSickness,      effect = effects.cureSickness },
        -- ideal weight
        { label = "Ideal Weight",                      isEnabled = sandbox.GL_Wish_Weight,            effect = effects.setIdealWeight },
        -- winning the lottery
        { label = "Infinite Wealth",                   isEnabled = sandbox.GL_Wish_Wealth,            effect = effects.obtainItem,        options = options.getWealthItems },
        -- infinite wishes
        { label = "Infinite Wishes",                   isEnabled = sandbox.GL_Wish_InfiniteWishes,    effect = effects.infiniteWishes },
        -- kill zombies
        { label = "Kill nearby Zomboids",              isEnabled = sandbox.GL_Wish_KillNearbyZombies, effect = effects.slayZeds },
    };
    local wishAmount = sandbox.GL_Setting_MaxWishes;

    local wishStyle = WishStyle:new("The Genie of the Lamp", wishes, wishAmount, "media/textures/portrait/normal_genie.png")
    startWishingMenu(player, wishStyle);
end