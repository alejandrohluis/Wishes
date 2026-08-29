require "WishAttributes.lua"

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
-- calzones                     (!)[darle calzones]

-- revivir a un ser             (?)

-- helado                       (!)[darle helado]

-- que shen long se vaya        (!)[retirar a shenron]

-- reparar potara               (!)[reparar un item]

-- deseos no pedidos en dbz pero interesantes:
-- pastillas para niveles temporales

WishOptions.getDBItems = function()
    local lotteryItems = {
        { label = "Ice Cream" , data = "Base.IceCream" , quantity = 1 },
        { label = "The Best Pair of Underwear in the Whole World" , data = "Base.Trunks" , quantity = 1 }
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
-- WishEffects.potentialUnlock = function(char, _selectedOption, panel)
--     local maxWishesConsumed = 2
--     if not panel:canPerformWish(maxWishesConsumed) then return end
--     panel:consumeWish(maxWishesConsumed)
-- end

--[[ teleport friend: 
 - teleports a player to the current wisher's position
]]--
-- WishEffects.teleportFriend = function(char, _selectedOption, panel)
--     local maxWishesConsumed = 1
--     if not panel:canPerformWish(maxWishesConsumed) then return end
--     panel:consumeWish(maxWishesConsumed)
-- end

--[[ inmortality: 
 - grants a temporary god-mode style wish  
 - heals all injuries, acts like the god-mode cheat for combat only (without all the unrelated weight/trait stuff)  
 - takes up 3 wishes
]]--
WishEffects.inmortality = function(char, _selectedOption, panel)
    return true
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
WishEffects.improveDragonBalls = function(char, _selectedOption, panel)
    return true
end