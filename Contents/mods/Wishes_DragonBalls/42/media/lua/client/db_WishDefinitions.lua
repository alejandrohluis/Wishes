require "WishDefinitions"

local function addGenieDefinitions()
    local options = WishOptions
    WishDefinitions:addWishDefinition("Shenron_modifyTrait"       , "Get/Remove a Trait", options.getTraits)
    WishDefinitions:addWishDefinition("Shenron_skillLevelUpUntil" , "Level up your skill up to level 5", options.getSkills)
    WishDefinitions:addWishDefinition("Shenron_skillLevelUpOnce"  , "Level up your skill once", options.getSkills)
    WishDefinitions:addWishDefinition("Shenron_heal"              , "Heal all injuries")
    WishDefinitions:addWishDefinition("Shenron_cureSickness"      , "Cure all sickness")
    WishDefinitions:addWishDefinition("Shenron_idealWeight"       , "Ideal Weight")
    WishDefinitions:addWishDefinition("Shenron_obtainItem"        , "Obtain special items", options.getDBItems)
    -- WishDefinitions:addWishDefinition("Shenron_potentialUnlock , "Unlock your body's potential")
    -- WishDefinitions:addWishDefinition("Shenron_teleport"       , "Teleport an ally")
    -- WishDefinitions:addWishDefinition("Shenron_inmortality"    , "Inmortality!")
    -- WishDefinitions:addWishDefinition("Shenron_upgrade"        , "Upgrade Dragon Balls")
end

Events.OnGameStart.Add(addGenieDefinitions)