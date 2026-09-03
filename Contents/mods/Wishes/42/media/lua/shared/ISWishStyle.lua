-----------------------
---   Wish Styles   ---
-----------------------

DPWishes = DPWishes or {}

DPWishes.Style = {}

local wishStyle = DPWishes.Style

function wishStyle:new(name, wishesPerSummoning, texturePath)
    local o = {}
    setmetatable(o,self)
    self.__index = self

    o.name = name
    o.wishAmount = wishesPerSummoning
    o.texturePath = texturePath
    return o
end

function wishStyle:getTexturePath()
    return self.texturePath
end

function wishStyle:getWishesToDisplay()
    return self.wishList
end

function wishStyle:getWishAmount()
    return self.wishAmount
end