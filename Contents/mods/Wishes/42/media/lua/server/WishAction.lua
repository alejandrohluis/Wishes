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

WishWhitelist_ModifyTrait = {}
WishBlacklist_ModifyTrait = {}
WishWhitelist_SkillLevelUntil = {}
WishWhitelist_SkillLevelOnce = {}
WishWhitelist_ObtainItem = {}

local function initializeModifyTraitWhitelist()
    local traitsArray = CharacterTraitDefinition.getTraits();
    local traits = {}
    for i = traitsArray:size()-1, 0, -1 do
        local trait = traitsArray:get(i)
        if trait:getCost() ~= 0 then
            traits[i] = trait
        end
    end
    WishWhitelist_ModifyTrait = traits
end

Wisheffects = {}

Wisheffects.GrantWish = function (player, args)
    
end

local function canPerformWish(player, wish)
    
end

local function OnClientCommand(module, command, player, args)
    if module ~= "Wishes" then return end
    if command ~= "GrantWish" then return end
    if not args or not args.wishID then return end

    local wishToPerform = WishWhitelist[args.wishID]
    -- if wish is not in the whitelist
    if not wishToPerform then return end

    if not canPerformWish(player, wishToPerform) then return end

    wishToPerform.effect(player, args.label)
end

Events.OnClientCommand.Add(OnClientCommand)