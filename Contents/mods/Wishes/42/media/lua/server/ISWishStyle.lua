-----------------------
---   Wish Styles   ---
-----------------------

WishStyle = {}

function WishStyle:new(name, wishesPerSummoning, texturePath)
    local o = {}
    setmetatable(o,self)
    self.__index = self

    o.name = name
    o.wishAmount = wishesPerSummoning
    o.texturePath = texturePath
    return o
end

function WishStyle:getTexturePath()
    return self.texturePath
end

function WishStyle:getWishesToDisplay()
    return self.wishList
end

function WishStyle:getWishAmount()
    return self.wishAmount
end

-- to be a valid wish it must have:
--  - label = string which indicates the name it will have when displayed  
--  - isEnabled = a boolean to check and make sure that the wish is allowed to be asked (typically as sandbox setting but can be hardcoded if needed)  
--  - effect = a function that grants the effect which the wish will perform.  
--             parameters:  
--               - player = the character that is currently asking for the wish  
--               - selectedOption = when the wish has options (for example, when wishing to level up a skill, the options are the skills), 
--                                  it serves the purpose of getting data from said option to perform actions  
--               - ISWishingPanel instance = the panel instance if anything is needed to do to it
local function isValidWish(wish)
    return wish.label ~= nil and wish.isEnabled ~= nil and wish.effect
end