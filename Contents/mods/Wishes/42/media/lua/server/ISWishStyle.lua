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