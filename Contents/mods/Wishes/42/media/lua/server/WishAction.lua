require "WishAttributes.lua"

WishWhitelist = {
    modifyTrait       = { cost = 1, effect = WishEffects.modifyTrait },
    skillLevelUpUntil = { cost = 1, effect = WishEffects.skillLevelUpUntil },
    skillLevelUpOnce  = { cost = 1, effect = WishEffects.skillLevelUpOnce },
    idealWeight       = { cost = 1, effect = WishEffects.setIdealWeight },
    heal              = { cost = 1, effect = WishEffects.healUp },
    cureSickness      = { cost = 2, effect = WishEffects.cureSickness },
    obtainItem        = { cost = 1, effect = WishEffects.obtainItem },
    endWishing        = { cost = 1, effect = WishEffects.endWishing },
    repairItem        = { cost = 1, effect = WishEffects.repairItem },
    obtainWeapons     = { cost = 1, effect = WishEffects.obtainWeapons },
    extraWishes       = { cost = 1, effect = WishEffects.extraWishes },
}

----------------------------------------------------------------------------------
--- WishAction
----------------------------------------------------------------------------------
-- WishAction = {}

-- WishAction.GrantWish = function (player, args)
    
-- end

local function canPerformWish(player, wish)
    -- return wish.isEnabled and wish.cost - player:getModData().availableWishes >= 0
    return true
end

local function OnClientCommand(module, command, player, args)
    if module ~= "Wishes" then return end
    if command ~= "GrantWish" then return end
    if not args or not args.wishID then return end
    print("GrantWish command called")

    local wishToPerform = WishWhitelist[args.wishID]

    -- if wish is not in the whitelist
    if not wishToPerform then return end

    if not canPerformWish(player, wishToPerform) then return end

    wishToPerform:effect(player, args.optionID)
    print("GrantWish command effect done")
end

Events.OnClientCommand.Add(OnClientCommand)