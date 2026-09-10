require "WishAttributes"

local wishOptions = DPWishes.Options
local wishEffects = DPWishes.Effects

wishOptions.getWealthItems = function(_player, blacklist)
    if not blacklist then return end
    local getItemTranslation = getItemNameFromFullType
    local wealthItems = {}
    if not blacklist["GL_Wealth_LotteryTicket"] then
        local lotteryTicketData = { label = getItemTranslation("Base.ScratchTicket"), optionID = "GL_Wealth_LotteryTicket" }
        table.insert(wealthItems, lotteryTicketData)
    end
    if not blacklist["GL_Wealth_Money"] then
        local moneyData = { label = getItemTranslation("Base.Money"), optionID = "GL_Wealth_Money" }
        table.insert(wealthItems, moneyData)
    end
    if not blacklist["GL_Wealth_GoldBar"] then
        local goldData = { label = getItemTranslation("Base.GoldBar"), optionID = "GL_Wealth_GoldBar" }
        table.insert(wealthItems, goldData)
    end
    return wealthItems
end

-- infinite wishes: joke wish that doesn't do anything  
wishEffects.infiniteWishes = function(char, _selectedOption, panel)
    -- TODO. next big update!
    return false
end

-- slay zeds: slays all zombies in the cell
-- takes 3 wishes
wishEffects.slayZeds = function(char, _selectedOption, panel)
    -- TODO. next big update!
    return false
end