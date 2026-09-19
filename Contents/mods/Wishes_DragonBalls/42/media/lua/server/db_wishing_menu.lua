require "WishAction"
require "db_wishAttributes"

local Recipe = RecipeCodeOnCreate;

function Recipe.SummonShenron(craftRecipeData, player)
    local sandbox = SandboxVars.WishesDragonBalls
    local playerID = player:getOnlineID()

    local session = DPWishes.Session:new(playerID, sandbox.Setting_WishesPerSummoning, "shenron")
    session:addWish("Shenron_modifyTrait"       , sandbox.WishCost_ModifyTrait        , sandbox.WishEnable_ModifyTrait)
    session:addWish("Shenron_skillLevelUpUntil" , sandbox.WishCost_SkillLevelUpUntil  , sandbox.WishEnable_SkillLevelUpUntil)
    session:addWish("Shenron_skillLevelUpOnce"  , sandbox.WishCost_SkillLevelUpOnce   , sandbox.WishEnable_SkillLevelUpOnce)
    session:addWish("Shenron_heal"              , sandbox.WishCost_HealInjury         , sandbox.WishEnable_HealInjury)
    session:addWish("Shenron_cureSickness"      , sandbox.WishCost_HealSickness       , sandbox.WishEnable_HealSickness)
    session:addWish("Shenron_idealWeight"       , sandbox.WishCost_IdealWeight        , sandbox.WishEnable_IdealWeight)
    session:addWish("Shenron_obtainItem"        , sandbox.WishCost_ObtainSpecialItem  , sandbox.WishEnable_ObtainSpecialItem)
    session:addWish("Shenron_potentialUnlock"   , sandbox.WishCost_PotentialUnlock    , sandbox.WishEnable_PotentialUnlock)
    session:addWish("Shenron_teleport"          , sandbox.WishCost_Teleport           , sandbox.WishEnable_Teleport)
    session:addWish("Shenron_inmortality"       , sandbox.WishCost_Inmortality        , sandbox.WishEnable_Inmortality)
    session:addWish("Shenron_upgrade"           , sandbox.WishCost_UpgradeDragonBalls , sandbox.WishEnable_UpgradeDragonBalls)

    local shenronData = {
        styleName = "UI_ShenronStyle",
        wishAmount = session:getRemainingWishes(),
        texturePath = "media/textures/portrait/shenlong.png",
        enabledWishes = session:getWishIDs(),
    }
    DPWishes.Action:startWishingMenu(player, shenronData, session:getWishIDs())
end


local function dragon_ball_addActions()
    local effects = DPWishes.Effects
    local actions = DPWishes.Action
    actions:addEffect("Shenron_modifyTrait", effects.modifyTrait)
    actions:addEffect("Shenron_skillLevelUpUntil", effects.skillLevelUpUntil)
    actions:addEffect("Shenron_skillLevelUpOnce", effects.skillLevelUpOnce)
    actions:addEffect("Shenron_idealWeight", effects.setIdealWeight)
    actions:addEffect("Shenron_heal", effects.healUp)
    actions:addEffect("Shenron_cureSickness", effects.cureSickness)
    actions:addEffect("Shenron_obtainItem", effects.obtainItem)
    actions:addEffect("Shenron_potentialUnlock", effects.potentialUnlock)
    actions:addEffect("Shenron_teleport", effects.teleportAlly)
    actions:addEffect("Shenron_inmortality", effects.inmortality)
    actions:addEffect("Shenron_upgrade", effects.improveDragonBalls)

    local itemWhitelist = DPWishes.FilteringLists.Whitelists.ObtainItem
    itemWhitelist["DB_IceCream"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.Icecream" }
    itemWhitelist["DB_PairOfTrunks"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.Underpants_White" }
end

dragon_ball_addActions()

-- deseos pedidos en dbz ; (!)[deseo] posibles deseos
-- calzones                     (!)[darle calzones]
-- revivir a un ser

-- conocimiento de como obtener SSG
-- plata

-- helado                       (!)[darle helado]

-- que shen long se vaya        (!)[retirar a shenron]

-- inmortalidad                 (!)[godmode temporal]

-- teletransportacion           (!)[tpear a otro jugador a vos]

-- potencial desbloqueado       (!)[que las stats fisicas tengan mas XP]

-- reparar potara               (!)[reparar un item]