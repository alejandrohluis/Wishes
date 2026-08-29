require "WishAttributes.lua"
require "WishAction.lua"

WishOptions.getWealthItems = function()
    local lotteryItems = {
        { label = "Lottery Ticket" , data = "Base.LotteryTicket" , quantity = 1 },
        { label = "Money" ,          data = "Base.Money" ,         quantity = ZombRand(100, 1000) },
        { label = "Gold Bars",       data = "Base.GoldBar" ,       quantity = ZombRand(1,10) },
    }
    return lotteryItems
end

-- infinite wishes: joke wish that doesn't do anything  
WishEffects.infiniteWishes = function(char, _selectedOption, panel)
    -- todo
    return true
end

-- slay zeds: slays all zombies in the cell
-- takes 3 wishes
WishEffects.slayZeds = function(char, _selectedOption, panel)
    -- todo
    return true
end


local function addActions()
    local effects = WishEffects
    WishAction:addEffect("modifyTrait", effects.modifyTrait)
    WishAction:addEffect("skillLevelUpUntil", effects.skillLevelUpUntil)
    WishAction:addEffect("skillLevelUpOnce", effects.skillLevelUpOnce)
    WishAction:addEffect("idealWeight", effects.setIdealWeight)
    WishAction:addEffect("heal", effects.healUp)
    WishAction:addEffect("cureSickness", effects.cureSickness)
    WishAction:addEffect("obtainItem", effects.obtainItem)
    WishAction:addEffect("infiniteWishesGenie", effects.infiniteWishes)
    WishAction:addEffect("slayZombiesGenie", effects.slayZeds)
end

Events.OnGameStart.Add(addActions)