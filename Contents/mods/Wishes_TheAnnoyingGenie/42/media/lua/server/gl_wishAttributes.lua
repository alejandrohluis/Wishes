require "WishAttributes"
require "WishAction"

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
    print("[Wishes] [addActions] Adding actions to the WishAction list...")
    local state = {}
    state[1] = WishAction:addEffect("GenieLamp_modifyTrait", effects.modifyTrait)
    state[2] = WishAction:addEffect("GenieLamp_skillLevelUpUntil", effects.skillLevelUpUntil)
    state[3] = WishAction:addEffect("GenieLamp_skillLevelUpOnce", effects.skillLevelUpOnce)
    state[4] = WishAction:addEffect("GenieLamp_idealWeight", effects.setIdealWeight)
    state[5] = WishAction:addEffect("GenieLamp_heal", effects.healUp)
    state[6] = WishAction:addEffect("GenieLamp_cureSickness", effects.cureSickness)
    state[7] = WishAction:addEffect("GenieLamp_obtainItem", effects.obtainItem)
    state[8] = WishAction:addEffect("GenieLamp_infiniteWishesGenie", effects.infiniteWishes)
    state[9] = WishAction:addEffect("GenieLamp_slayZombiesGenie", effects.slayZeds)
    local actionCompleted = false
    for i = 1, #state do
        if state[i] then
            actionCompleted = true
        else
            actionCompleted = false
            break
        end
    end
    if actionCompleted then
        print("[Wishes] [addActions] All actions added to the list")
    else
        print("[Wishes] [addActions] Not all actions were added to the list!!")
    end
end

addActions()