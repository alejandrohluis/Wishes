require "WishAttributes"

local wishOptions = DPWishes.Options
local wishEffects = DPWishes.Effects

wishOptions.getWealthItems = function()
    local getItemTranslation = getItemNameFromFullType
    local lotteryItems = {
        { label = getItemTranslation("Base.ScratchTicket"), optionID = "GL_Wealth_LotteryTicket" },
        { label = getItemTranslation("Base.Money"),         optionID = "GL_Wealth_Money" },
        { label = getItemTranslation("Base.GoldBar"),       optionID = "GL_Wealth_GoldBar" },
    }
    return lotteryItems
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