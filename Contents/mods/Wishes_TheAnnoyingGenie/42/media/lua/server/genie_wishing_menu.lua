require "WishAction"
require "ISWishStyle"

local Recipe = RecipeCodeOnCreate;

function Recipe.GenieLamp(craftRecipeData, player)
    local sandbox = SandboxVars.Wishes
    local playerID = player:getPlayerNum()

    local genie = DPWishes.Style:new("The Genie of the Lamp", sandbox.GL_Setting_MaxWishes, "media/textures/portrait/normal_genie.png")

    local session = DPWishes.Session:new(playerID, genie)
    session:addWish("GenieLamp_modifyTrait", 1, sandbox.GL_Wish_Trait)
    session:addWish("GenieLamp_skillLevelUpUntil", 1, sandbox.GL_Wish_SkillLevelUpUntil)
    session:addWish("GenieLamp_skillLevelUpOnce", 1, sandbox.GL_Wish_SkillLevelUp)
    session:addWish("GenieLamp_idealWeight", 1, sandbox.GL_Wish_Weight)
    session:addWish("GenieLamp_heal", 1, sandbox.GL_Wish_HealInjury)
    session:addWish("GenieLamp_cureSickness", 2, sandbox.GL_Wish_HealSickness)
    session:addWish("GenieLamp_obtainItem", 1, sandbox.GL_Wish_Wealth)
    session:addWish("GenieLamp_infiniteWishes", 0, false)
    session:addWish("GenieLamp_slayZeds", 0, false)

    local genieData = {
        name = genie.name,
        wishAmount = genie.wishAmount,
        texturePath = genie.texturePath,
    }
    DPWishes.Action:startWishingMenu(player, genieData, session:getWishIDs())
end