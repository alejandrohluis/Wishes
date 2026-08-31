require "WishDefinitions"

local function addGenieDefinitions()
    local options = WishOptions
    WishDefinitions:addWishDefinition("GenieLamp_modifyTrait"       , "Get/Remove a Trait", options.getTraits)
    WishDefinitions:addWishDefinition("GenieLamp_skillLevelUpUntil" , "Level up your skill up to level 5", options.getSkills)
    WishDefinitions:addWishDefinition("GenieLamp_skillLevelUpOnce"  , "Level up your skill once", options.getSkills)
    WishDefinitions:addWishDefinition("GenieLamp_heal"              , "Heal all injuries")
    WishDefinitions:addWishDefinition("GenieLamp_cureSickness"      , "Cure all sickness")
    WishDefinitions:addWishDefinition("GenieLamp_idealWeight"       , "Ideal Weight")
    WishDefinitions:addWishDefinition("GenieLamp_obtainItem"        , "Infinite Wealth", options.getWealthItems)
    -- WishDefinitions:addWishDefinition("GenieLamp_infiniteWishes"    , "")
    -- WishDefinitions:addWishDefinition("GenieLamp_slayZeds"          , "")
end

Events.OnGameStart.Add(addGenieDefinitions)