require "WishDefinitions"

local function addWishingWellDefinitions()
    local options = DPWishes.Options
    local definitions = DPWishes.Definitions
    local blacklists = DPWishes.FilteringLists.Blacklists
    local sandboxCost = SandboxVars.WishesWishingWell
    definitions:addWishDefinition("WishingWell_modifyTrait"       , "UI_WishingWell_modifyTrait"        , sandboxCost.WishCost_ModifyTrait          , options.getTraits , blacklists.ModifyTrait)
    definitions:addWishDefinition("WishingWell_skillLevelUpUntil" , "UI_WishingWell_skillLevelUpUntil"  , sandboxCost.WishCost_SkillLevelUpUntil    , options.getSkills , blacklists.SkillLevelUntil)
    definitions:addWishDefinition("WishingWell_skillLevelUpOnce"  , "UI_WishingWell_skillLevelUpOnce"   , sandboxCost.WishCost_SkillLevelUp         , options.getSkills , blacklists.SkillLevelOnce)
    definitions:addWishDefinition("WishingWell_heal"              , "UI_WishingWell_heal"               , sandboxCost.WishCost_HealInjury   )
    definitions:addWishDefinition("WishingWell_cureSickness"      , "UI_WishingWell_cureSickness"       , sandboxCost.WishCost_HealSickness )
    definitions:addWishDefinition("WishingWell_idealWeight"       , "UI_WishingWell_idealWeight"        , sandboxCost.WishCost_IdealWeight  )
end

Events.OnGameStart.Add(addWishingWellDefinitions)