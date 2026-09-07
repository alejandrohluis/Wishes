require "WishDefinitions"

local function addGenieDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    local sandbox = SandboxVars.WishesDragonBalls
    definitions:addWishDefinition("Shenron_modifyTrait"       , "UI_Shenron_modifyTrait"        , sandbox.WishCost_ModifyTrait, options.getTraits)
    definitions:addWishDefinition("Shenron_skillLevelUpUntil" , "UI_Shenron_skillLevelUpUntil"  , sandbox.WishCost_SkillLevelUpUntil , options.getSkills)
    definitions:addWishDefinition("Shenron_skillLevelUpOnce"  , "UI_Shenron_skillLevelUpOnce"   , sandbox.WishCost_SkillLevelUpOnce , options.getSkills)
    definitions:addWishDefinition("Shenron_heal"              , "UI_Shenron_heal"               , sandbox.WishCost_HealInjury )
    definitions:addWishDefinition("Shenron_cureSickness"      , "UI_Shenron_cureSickness"       , sandbox.WishCost_HealSickness )
    definitions:addWishDefinition("Shenron_idealWeight"       , "UI_Shenron_idealWeight"        , sandbox.WishCost_IdealWeight )
    definitions:addWishDefinition("Shenron_obtainItem"        , "UI_Shenron_obtainSpecialItem"  , sandbox.WishCost_ObtainSpecialItem , options.getDBItems)
    definitions:addWishDefinition("Shenron_potentialUnlock"   , "UI_Shenron_potentialUnlock"    , sandbox.WishCost_PotentialUnlock )
    definitions:addWishDefinition("Shenron_teleport"          , "UI_Shenron_teleport"           , sandbox.WishCost_Teleport )
    definitions:addWishDefinition("Shenron_inmortality"       , "UI_Shenron_inmortality"        , sandbox.WishCost_Inmortality )
    definitions:addWishDefinition("Shenron_upgrade"           , "UI_Shenron_upgradeDragonBalls" , sandbox.WishCost_UpgradeDragonBalls )
end

Events.OnGameStart.Add(addGenieDefinitions)