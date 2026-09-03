require "WishDefinitions"

local function addGenieDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    local getTranslation = getText
    definitions:addWishDefinition("Shenron_modifyTrait"       , getTranslation("UI_Shenron_modifyTrait"), options.getTraits)
    definitions:addWishDefinition("Shenron_skillLevelUpUntil" , getTranslation("UI_Shenron_skillLevelUpUntil"), options.getSkills)
    definitions:addWishDefinition("Shenron_skillLevelUpOnce"  , getTranslation("UI_Shenron_skillLevelUpOnce"), options.getSkills)
    definitions:addWishDefinition("Shenron_heal"              , getTranslation("UI_Shenron_heal") )
    definitions:addWishDefinition("Shenron_cureSickness"      , getTranslation("UI_Shenron_cureSickness") )
    definitions:addWishDefinition("Shenron_idealWeight"       , getTranslation("UI_Shenron_idealWeight") )
    definitions:addWishDefinition("Shenron_obtainItem"        , getTranslation("UI_Shenron_obtainSpecialItem"), options.getDBItems)
    definitions:addWishDefinition("Shenron_potentialUnlock"   , getTranslation("UI_Shenron_potentialUnlock") )
    definitions:addWishDefinition("Shenron_teleport"          , getTranslation("UI_Shenron_teleport") )
    definitions:addWishDefinition("Shenron_inmortality"       , getTranslation("UI_Shenron_inmortality") )
    definitions:addWishDefinition("Shenron_upgrade"           , getTranslation("UI_Shenron_upgradeDragonBalls") )
end

Events.OnGameStart.Add(addGenieDefinitions)