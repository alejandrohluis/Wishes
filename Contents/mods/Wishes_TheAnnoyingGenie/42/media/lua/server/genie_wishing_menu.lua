require "WishAction"
require "ISWishStyle"

local Recipe = RecipeCodeOnCreate;

function Recipe.GenieLamp(craftRecipeData, player)
    local sandbox = SandboxVars.WishesGenieLamp
    local playerID = player:getOnlineID()

    local genie = DPWishes.Style:new("The Genie of the Lamp", sandbox.MaxWishes, "media/textures/portrait/normal_genie.png")

    local session = DPWishes.Session:new(playerID, genie)
    session:addWish("GenieLamp_modifyTrait"         , sandbox.WishCost_ModifyTrait       , sandbox.WishEnable_ModifyTrait)
    session:addWish("GenieLamp_skillLevelUpUntil"   , sandbox.WishCost_SkillLevelUpUntil , sandbox.WishEnable_SkillLevelUpUntil)
    session:addWish("GenieLamp_skillLevelUpOnce"    , sandbox.WishCost_SkillLevelUp      , sandbox.WishEnable_SkillLevelUp)
    session:addWish("GenieLamp_idealWeight"         , sandbox.WishCost_Weight            , sandbox.WishEnable_Weight)
    session:addWish("GenieLamp_heal"                , sandbox.WishCost_HealInjury        , sandbox.WishEnable_HealInjury)
    session:addWish("GenieLamp_cureSickness"        , sandbox.WishCost_HealSickness      , sandbox.WishEnable_HealSickness)
    session:addWish("GenieLamp_obtainItem"          , sandbox.WishCost_Wealth            , sandbox.WishEnable_Wealth)
    session:addWish("GenieLamp_infiniteWishes"      , sandbox.WishCost_InfiniteWishes    , sandbox.WishEnable_InfiniteWishes)
    session:addWish("GenieLamp_slayZeds"            , sandbox.WishCost_KillNearbyZombies , sandbox.WishEnable_KillNearbyZombies)

    local genieData = {
        name = genie.name,
        wishAmount = genie.wishAmount,
        texturePath = genie.texturePath,
    }
    DPWishes.Action:startWishingMenu(player, genieData, session:getWishIDs())
end