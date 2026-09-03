require "WishDefinitions"

local function addGenieDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    definitions:addWishDefinition("GenieLamp_modifyTrait"       , "Get/Remove a Trait", options.getTraits)
    definitions:addWishDefinition("GenieLamp_skillLevelUpUntil" , "Level up your skill up to level 5", options.getSkills)
    definitions:addWishDefinition("GenieLamp_skillLevelUpOnce"  , "Level up your skill once", options.getSkills)
    definitions:addWishDefinition("GenieLamp_heal"              , "Heal all injuries")
    definitions:addWishDefinition("GenieLamp_cureSickness"      , "Cure all sickness")
    definitions:addWishDefinition("GenieLamp_idealWeight"       , "Ideal Weight")
    definitions:addWishDefinition("GenieLamp_obtainItem"        , "Infinite Wealth", options.getWealthItems)
    -- definitions:addWishDefinition("GenieLamp_infiniteWishes"    , "")
    -- definitions:addWishDefinition("GenieLamp_slayZeds"          , "")
end

Events.OnGameStart.Add(addGenieDefinitions)