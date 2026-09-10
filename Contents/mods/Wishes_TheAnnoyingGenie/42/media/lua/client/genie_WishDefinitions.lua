require "WishDefinitions"

local function addGenieDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    local blacklists = DPWishes.FilteringLists.Blacklists
    local sandboxCost = SandboxVars.WishesGenieLamp
    definitions:addWishDefinition("GenieLamp_modifyTrait"       , "UI_GenieLamp_modifyTrait", sandboxCost.WishCost_ModifyTrait , options.getTraits , blacklists.ModifyTrait)
    definitions:addWishDefinition("GenieLamp_skillLevelUpUntil" , "UI_GenieLamp_skillLevelUpUntil", sandboxCost.WishCost_SkillLevelUpUntil , options.getSkills, blacklists.SkillLevelUntil)
    definitions:addWishDefinition("GenieLamp_skillLevelUpOnce"  , "UI_GenieLamp_skillLevelUpOnce", sandboxCost.WishCost_SkillLevelUp , options.getSkills, blacklists.SkillLevelOnce)
    definitions:addWishDefinition("GenieLamp_heal"              , "UI_GenieLamp_heal", sandboxCost.WishCost_HealInjury  )
    definitions:addWishDefinition("GenieLamp_cureSickness"      , "UI_GenieLamp_cureSickness", sandboxCost.WishCost_HealSickness  )
    definitions:addWishDefinition("GenieLamp_idealWeight"       , "UI_GenieLamp_idealWeight", sandboxCost.WishCost_IdealWeight  )
    definitions:addWishDefinition("GenieLamp_obtainItem"        , "UI_GenieLamp_wealth", sandboxCost.WishCost_Wealth , options.getWealthItems, blacklists.ObtainItem)
    -- definitions:addWishDefinition("GenieLamp_infiniteWishes"    , "")
    -- definitions:addWishDefinition("GenieLamp_slayZeds"          , "")
end

Events.OnGameStart.Add(addGenieDefinitions)