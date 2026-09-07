require "WishAttributes"
require "WishAction"

local wishOptions = DPWishes.Options
local wishEffects = DPWishes.Effects

--[[ 
type of dragon balls:
    organic:
        can be looted in the world
    robotic:
        can be crafted after state 3 and state 5 of upgrading the dragon balls
        needs electronics level 5
        can be used as a replacement for organic dragon balls
]]--
-- deseos pedidos en dbz ; (!)[deseo] posibles deseos
-- revivir a un ser             (?)

-- que shen long se vaya        (!)[cerrar menu]

-- reparar potara               (!)[reparar un item]

-- deseos no pedidos en dbz pero interesantes:
-- pastillas para niveles temporales

wishOptions.getDBItems = function()
    local getTranslation = getText
    local getItemTranslation = getItemNameFromFullType
    local lotteryItems = {
        { label = getItemTranslation("Base.Icecream") , optionID = "DB_IceCream" },
        { label = getTranslation("UI_Shenron_Option_ItemUnderwear"), optionID = "DB_PairOfTrunks" }
    }
    return lotteryItems
end

--[[ potential unlocked: 
 - improves ALL physical abilities per wish  
    - physical skills: fitness ; lightfooted ; nimble ; running ; sneaking ; strength  
 - effects:
    - if a physical skill is not maxed, grants an XP multiplier  
    - if a physical skill is maxed, grants a perk related to it  
    - if all physical skills are maxed and there is no perk to be given, does not consume the wish.  
 - takes up 2 wishes
]]--  
wishEffects.potentialUnlock = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

--[[ teleport ally: 
 - teleports a player from the same faction to the current wisher's position
]]--
wishEffects.teleportAlly = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

--[[ inmortality: 
 - grants a temporary invisibility effect
 - takes up 3 wishes
]]--
wishEffects.inmortality = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

--[[ improveDragonBalls:  
 - improves the dragon ball wishing system  
 - takes up the improvement cost configured  
 - has multiple stages:
    + stage 1: grants an additional wish per summoning
    + stage 2: adds a wish option (potential unlock)
    + stage 3: lets you craft robotic db 1, 3, 5
    + stage 4: grants an additional wish per summoning
    + stage 5: adds a wish option (inmortality)
    + stage 6: lets you craft robotic db 2, 4, 6 ; also lets you turn any "organic" db into db 7  
]]--
wishEffects.improveDragonBalls = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

local function dragon_ball_addActions()
    local effects = wishEffects
    local action = DPWishes.Action
    action:addEffect("Shenron_modifyTrait", effects.modifyTrait)
    action:addEffect("Shenron_skillLevelUpUntil", effects.skillLevelUpUntil)
    action:addEffect("Shenron_skillLevelUpOnce", effects.skillLevelUpOnce)
    action:addEffect("Shenron_idealWeight", effects.setIdealWeight)
    action:addEffect("Shenron_heal", effects.healUp)
    action:addEffect("Shenron_cureSickness", effects.cureSickness)
    action:addEffect("Shenron_obtainItem", effects.obtainItem)
    action:addEffect("Shenron_potentialUnlock", effects.potentialUnlock)
    action:addEffect("Shenron_teleport", effects.teleportAlly)
    action:addEffect("Shenron_inmortality", effects.inmortality)
    action:addEffect("Shenron_upgrade", effects.improveDragonBalls)

    local itemWhitelist = DPWishes.FilteringLists.Whitelist_ObtainItem
    itemWhitelist["DB_IceCream"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.Icecream" }
    itemWhitelist["DB_PairOfTrunks"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.Underpants_White" }
end

Events.OnGameStart.Add(dragon_ball_addActions)