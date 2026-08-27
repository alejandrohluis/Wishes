local Recipe = RecipeCodeOnCreate;

local function startWishingMenu(player, wishStyle)
    local window = WishingWindows[player];
    window:initialise(wishStyle);
    window:startMenu();
end

function Recipe.GenieLamp(craftRecipeData, player)
    local options = WishOptions;
    local sandbox = SandboxVars.Wishes

    local wishes = {
        -- modify trait
        { label = "Get/Remove a Trait",                wishID = "modifyTrait"       , isEnabled = sandbox.GL_Wish_Trait,              categories = options.getTraits },
        -- level up skill until
        { label = "Level up your skill up to level 5", wishID = "skillLevelUpUntil" , isEnabled = sandbox.GL_Wish_SkillLevelUpUntil,  categories = options.getSkills },
        -- level up skill once
        { label = "Level up your skill once",          wishID = "skillLevelUpOnce"  , isEnabled = sandbox.GL_Wish_SkillLevelUp,       categories = options.getSkills },
        -- heal injuries
        { label = "Heal all injuries",                 wishID = "heal"              , isEnabled = sandbox.GL_Wish_HealInjury },
        -- cure sickness
        { label = "Cure all sickness",                 wishID = "cureSickness"      , isEnabled = sandbox.GL_Wish_HealSickness },
        -- ideal weight
        { label = "Ideal Weight",                      wishID = "idealWeight"       , isEnabled = sandbox.GL_Wish_Weight },
        -- winning the lottery
        { label = "Infinite Wealth",                   wishID = "obtainItem"        , isEnabled = sandbox.GL_Wish_Wealth,             categories = options.getWealthItems },
        -- infinite wishes
        { label = "Infinite Wishes",                   wishID = "infiniteWishes"    , isEnabled = sandbox.GL_Wish_InfiniteWishes },
        -- kill zombies
        { label = "Kill nearby Zomboids",              wishID = "slayZeds"          , isEnabled = sandbox.GL_Wish_KillNearbyZombies },
    };
    local wishAmount = sandbox.GL_Setting_MaxWishes;

    local wishStyle = WishStyle:new("The Genie of the Lamp", wishes, wishAmount, "media/textures/portrait/normal_genie.png")
    startWishingMenu(player, wishStyle);
end