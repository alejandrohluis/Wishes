require "WishAttributes.lua"

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
end

-- slay zeds: slays all zombies in the cell
-- takes 3 wishes
WishEffects.slayZeds = function(char, _selectedOption, panel)
    panel:consumeWish(3)
end