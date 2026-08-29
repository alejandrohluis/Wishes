require "WishActions.lua"

local Recipe = RecipeCodeOnCreate;

local function startWishingMenu(player, wishStyle)
    local window = WishingWindows[player];
    window:initialise(wishStyle);
    window:startMenu();
end

function Recipe.GenieLamp(craftRecipeData, player)
    local options = WishOptions;
    local sandbox = SandboxVars.Wishes
    local playerID = player:getPlayerNum()

    local wishes = {
        -- modify trait
        { label = "Get/Remove a Trait",                wishID = "modifyTrait"       , categories = options.getTraits },
        -- level up skill until
        { label = "Level up your skill up to level 5", wishID = "skillLevelUpUntil" , categories = options.getSkills },
        -- level up skill once
        { label = "Level up your skill once",          wishID = "skillLevelUpOnce"  , categories = options.getSkills },
        -- heal injuries
        { label = "Heal all injuries",                 wishID = "heal" },
        -- cure sickness
        { label = "Cure all sickness",                 wishID = "cureSickness" },
        -- ideal weight
        { label = "Ideal Weight",                      wishID = "idealWeight" },
        -- winning the lottery
        { label = "Infinite Wealth",                   wishID = "obtainItem"        , categories = options.getWealthItems },
        -- infinite wishes
        -- { label = "Infinite Wishes",                   wishID = "infiniteWishes" },
        -- kill zombies
        -- { label = "Kill nearby Zomboids",              wishID = "slayZeds" },
    };

    local wishStyle = WishStyle:new("The Genie of the Lamp", sandbox.GL_Setting_MaxWishes, "media/textures/portrait/normal_genie.png")

    local session = WishingSession:new(playerID, wishStyle)
    session:addWish("modifyTrait", 1, sandbox.GL_Wish_Trait)
    session:addWish("skillLevelUpUntil", 1, sandbox.GL_Wish_SkillLevelUpUntil)
    session:addWish("skillLevelUpOnce", 1, sandbox.GL_Wish_SkillLevelUp)
    session:addWish("idealWeight", 1, sandbox.GL_Wish_Weight)
    session:addWish("heal", 1, sandbox.GL_Wish_HealInjury)
    session:addWish("cureSickness", 2, sandbox.GL_Wish_HealSickness)
    session:addWish("obtainItem", 1, sandbox.GL_Wish_Wealth)
    session:addWish("infiniteWishes", 0, false)
    session:addWish("slayZeds", 0, false)
    wishStyle:setEnabledWishes(session:getWishes())

    startWishingMenu(player, wishStyle);
end