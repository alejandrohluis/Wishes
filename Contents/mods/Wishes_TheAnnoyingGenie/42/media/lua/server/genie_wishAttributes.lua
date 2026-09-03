require "WishAttributes"
require "WishAction"

local wishOptions = DPWishes.Options
local wishEffects = DPWishes.Effects

wishOptions.getWealthItems = function()
    local lotteryItems = {
        { label = "Lottery Ticket" , optionID = "GL_Wealth_LotteryTicket" },
        { label = "Money" ,          optionID = "GL_Wealth_Money" },
        { label = "Gold Bars",       optionID = "GL_Wealth_GoldBar" },
    }
    return lotteryItems
end

-- infinite wishes: joke wish that doesn't do anything  
wishEffects.infiniteWishes = function(char, _selectedOption, panel)
    -- TODO. not a priority
    return false
end

-- slay zeds: slays all zombies in the cell
-- takes 3 wishes
wishEffects.slayZeds = function(char, _selectedOption, panel)
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
    local effects = DPWishes.Effects
    local actions = DPWishes.Action
    actions:addEffect("GenieLamp_modifyTrait", effects.modifyTrait)
    actions:addEffect("GenieLamp_skillLevelUpUntil", effects.skillLevelUpUntil)
    actions:addEffect("GenieLamp_skillLevelUpOnce", effects.skillLevelUpOnce)
    actions:addEffect("GenieLamp_idealWeight", effects.setIdealWeight)
    actions:addEffect("GenieLamp_heal", effects.healUp)
    actions:addEffect("GenieLamp_cureSickness", effects.cureSickness)
    actions:addEffect("GenieLamp_obtainItem", effects.obtainItem)
    actions:addEffect("GenieLamp_infiniteWishesGenie", effects.infiniteWishes)
    actions:addEffect("GenieLamp_slayZombiesGenie", effects.slayZeds)

    local itemWhitelist = DPWishes.FilteringLists.Whitelist_ObtainItem
    itemWhitelist["GL_Wealth_LotteryTicket"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.ScratchTicket_Winner" , itemDataModifier = create_winning_ticket}
    itemWhitelist["GL_Wealth_Money"] = { minQuantity = 10 , maxQuantity = 100 , itemID = "Base.Money" }
    itemWhitelist["GL_Wealth_GoldBar"] = { minQuantity = 1 , maxQuantity = 3 , itemID = "Base.GoldBar" }
end

Events.OnGameStart.Add(genie_lamp_addActions)