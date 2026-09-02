require "WishAttributes"
require "WishAction"

WishOptions.getWealthItems = function()
    local lotteryItems = {
        { label = "Lottery Ticket" , optionID = "GL_Wealth_LotteryTicket" },
        { label = "Money" ,          optionID = "GL_Wealth_Money" },
        { label = "Gold Bars",       optionID = "GL_Wealth_GoldBar" },
    }
    return lotteryItems
end

-- infinite wishes: joke wish that doesn't do anything  
WishEffects.infiniteWishes = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

-- slay zeds: slays all zombies in the cell
-- takes 3 wishes
WishEffects.slayZeds = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

local function create_winning_ticket(ticket)
    local modData = ticket:getModData()
    local randomizer = ZombRand(1,3+1)
    local winningValue = 0
    if randomizer == 1 then
        winningValue = 1000
    elseif randomizer == 2 then
        winningValue = 5000
    elseif randomizer == 3 then
        winningValue = 10000
    end
    modData["winning"] = "$"..tostring(winningValue)
    ticket:setName(getText("IGUI_ScratchingTicketNameWinner", ticket:getDisplayName(), modData["winning"]));
    -- ticket:setName(getText("IGUI_ScratchingTicketNameWinner", modData["winning"]));
end


local function genie_lamp_addActions()
    local effects = WishEffects
    WishAction:addEffect("GenieLamp_modifyTrait", effects.modifyTrait)
    WishAction:addEffect("GenieLamp_skillLevelUpUntil", effects.skillLevelUpUntil)
    WishAction:addEffect("GenieLamp_skillLevelUpOnce", effects.skillLevelUpOnce)
    WishAction:addEffect("GenieLamp_idealWeight", effects.setIdealWeight)
    WishAction:addEffect("GenieLamp_heal", effects.healUp)
    WishAction:addEffect("GenieLamp_cureSickness", effects.cureSickness)
    WishAction:addEffect("GenieLamp_obtainItem", effects.obtainItem)
    WishAction:addEffect("GenieLamp_infiniteWishesGenie", effects.infiniteWishes)
    WishAction:addEffect("GenieLamp_slayZombiesGenie", effects.slayZeds)

    WishWhitelist_ObtainItem["GL_Wealth_LotteryTicket"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.ScratchTicket_Winner" , itemDataModifier = create_winning_ticket}
    WishWhitelist_ObtainItem["GL_Wealth_Money"] = { minQuantity = 10 , maxQuantity = 100 , itemID = "Base.Money" }
    WishWhitelist_ObtainItem["GL_Wealth_GoldBar"] = { minQuantity = 1 , maxQuantity = 3 , itemID = "Base.GoldBar" }
end

genie_lamp_addActions()