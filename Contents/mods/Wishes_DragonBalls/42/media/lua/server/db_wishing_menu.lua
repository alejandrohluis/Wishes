require "WishAction"
require "ISWishStyle"

local Recipe = RecipeCodeOnCreate;

function Recipe.SummonShenron(craftRecipeData, player)
    local sandbox = SandboxVars.Wishes
    local playerID = player:getOnlineID()

    local shenron = DPWishes.Style:new("Shenron", sandbox.DB_Setting_MaxWishes, "media/textures/portrait/shenlong.png")

    local session = DPWishes.Session:new(playerID, shenron)
    session:addWish("Shenron_modifyTrait", 1, sandbox.DB_Wish_Trait)
    session:addWish("Shenron_skillLevelUpUntil", 1, sandbox.DB_Wish_SkillLevelUpUntil)
    session:addWish("Shenron_skillLevelUpOnce", 1, sandbox.DB_Wish_SkillLevelUp)
    session:addWish("Shenron_heal", 1, sandbox.DB_Wish_HealInjury)
    session:addWish("Shenron_cureSickness", 2, sandbox.DB_Wish_HealSickness)
    session:addWish("Shenron_idealWeight", 1, sandbox.DB_Wish_Weight)
    session:addWish("Shenron_obtainItem", 1, sandbox.DB_Wish_Upgrade)
    session:addWish("Shenron_potentialUnlock", 0, sandbox.DB_Wish_PotentialUnlock)
    session:addWish("Shenron_teleport", 0, sandbox.DB_Wish_Teleport)
    session:addWish("Shenron_inmortality", 0, sandbox.DB_Wish_Inmortality)
    session:addWish("Shenron_upgrade", 0, sandbox.DB_Wish_Upgrade)

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