require "WishDefinitions"

local function addGenieDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    -- local getTranslation = getText
    definitions:addWishDefinition("Shenron_modifyTrait"       , "Get/Remove a Trait", options.getTraits)
    definitions:addWishDefinition("Shenron_skillLevelUpUntil" , "Level up your skill up to level 5", options.getSkills)
    definitions:addWishDefinition("Shenron_skillLevelUpOnce"  , "Level up your skill once", options.getSkills)
    definitions:addWishDefinition("Shenron_heal"              , "Heal all injuries")
    definitions:addWishDefinition("Shenron_cureSickness"      , "Cure all sickness")
    definitions:addWishDefinition("Shenron_idealWeight"       , "Ideal Weight")
    definitions:addWishDefinition("Shenron_obtainItem"        , "Obtain special items", options.getDBItems)
    definitions:addWishDefinition("Shenron_potentialUnlock"   , "Unlock your body's potential")
    definitions:addWishDefinition("Shenron_teleport"          , "Teleport an ally")
    definitions:addWishDefinition("Shenron_inmortality"       , "Inmortality!")
    definitions:addWishDefinition("Shenron_upgrade"           , "Upgrade Dragon Balls")
end

Events.OnGameStart.Add(addGenieDefinitions)