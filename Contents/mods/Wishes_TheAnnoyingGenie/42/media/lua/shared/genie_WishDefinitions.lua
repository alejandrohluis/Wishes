require "WishDefinitions"

local function addGenieDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    local getTranslation = getText
    definitions:addWishDefinition("GenieLamp_modifyTrait"       , getTranslation("UI_GenieLamp_modifyTrait"), options.getTraits)
    definitions:addWishDefinition("GenieLamp_skillLevelUpUntil" , getTranslation("UI_GenieLamp_skillLevelUpUntil"), options.getSkills)
    definitions:addWishDefinition("GenieLamp_skillLevelUpOnce"  , getTranslation("UI_GenieLamp_skillLevelUpOnce"), options.getSkills)
    definitions:addWishDefinition("GenieLamp_heal"              , getTranslation("UI_GenieLamp_heal"))
    definitions:addWishDefinition("GenieLamp_cureSickness"      , getTranslation("UI_GenieLamp_cureSickness"))
    definitions:addWishDefinition("GenieLamp_idealWeight"       , getTranslation("UI_GenieLamp_idealWeight"))
    definitions:addWishDefinition("GenieLamp_obtainItem"        , getTranslation("UI_GenieLamp_wealth"), options.getWealthItems)
    -- definitions:addWishDefinition("GenieLamp_infiniteWishes"    , "")
    -- definitions:addWishDefinition("GenieLamp_slayZeds"          , "")
end

Events.OnGameStart.Add(addGenieDefinitions)