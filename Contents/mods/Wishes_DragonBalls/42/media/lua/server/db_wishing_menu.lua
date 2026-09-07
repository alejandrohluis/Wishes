require "WishAction"
require "ISWishStyle"

local Recipe = RecipeCodeOnCreate;

function Recipe.SummonShenron(craftRecipeData, player)
    local sandbox = SandboxVars.WishesDragonBalls
    local playerID = player:getOnlineID()
    local shenron = DPWishes.Style:new("Shenron", sandbox.Setting_WishesPerSummoning, "media/textures/portrait/shenlong.png")

    local session = DPWishes.Session:new(playerID, shenron)
    session:addWish("Shenron_modifyTrait"       , sandbox.WishCost_ModifyTrait        , sandbox.WishEnable_ModifyTrait)
    session:addWish("Shenron_skillLevelUpUntil" , sandbox.WishCost_SkillLevelUpUntil  , sandbox.WishEnable_SkillLevelUpUntil)
    session:addWish("Shenron_skillLevelUpOnce"  , sandbox.WishCost_SkillLevelUpOnce   , sandbox.WishEnable_SkillLevelUpOnce)
    session:addWish("Shenron_heal"              , sandbox.WishCost_HealInjury         , sandbox.WishEnable_HealInjury)
    session:addWish("Shenron_cureSickness"      , sandbox.WishCost_HealSickness       , sandbox.WishEnable_HealSickness)
    session:addWish("Shenron_idealWeight"       , sandbox.WishCost_IdealWeight        , sandbox.WishEnable_Weight)
    session:addWish("Shenron_obtainItem"        , sandbox.WishCost_ObtainSpecialItem  , sandbox.WishEnable_ObtainSpecialItem)
    session:addWish("Shenron_potentialUnlock"   , sandbox.WishCost_PotentialUnlock    , sandbox.WishEnable_PotentialUnlock)
    session:addWish("Shenron_teleport"          , sandbox.WishCost_Teleport           , sandbox.WishEnable_Teleport)
    session:addWish("Shenron_inmortality"       , sandbox.WishCost_Inmortality        , sandbox.WishEnable_Inmortality)
    session:addWish("Shenron_upgrade"           , sandbox.WishCost_UpgradeDragonBalls , sandbox.WishEnable_UpgradeDragonBalls)

    local shenronData = {
        name = shenron.name,
        wishAmount = shenron.wishAmount,
        texturePath = shenron.texturePath,
    }
    DPWishes.Action:startWishingMenu(player, shenronData, session:getWishIDs())
end

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