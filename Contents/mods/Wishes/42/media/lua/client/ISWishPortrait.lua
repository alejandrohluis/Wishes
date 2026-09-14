-----------------------
---  Wish Portrait  ---
-----------------------
---
--- The image that will be used for each summoning style.
--- 
--- Currently includes:
--- Dragon Ball
DPWishes = DPWishes or {}

DPWishes.Portrait = ISUIElement:derive("DP_WishPortrait");

local ISWishPortrait = DPWishes.Portrait

function ISWishPortrait:render()
    -- local width = 230;
    -- local height = 560;
    self:drawRectBorder(self.x - 1, self.y - 1, self.w + 2, self.h + 2, 1.0, 0.4, 0.4, 0.4);
    self:drawTextureScaled(self.texture, self.x, self.y, self.w, self.h, 1, 1, 1, 1);
end

function ISWishPortrait:new(x,y, width, height, texturePath)
    local o = {};
    o = ISUIElement:new(x,y,width,height);
    setmetatable(o,self);
    self.__index = self;

    o.x = x;
    o.y = y;
    o.w = width;
    o.h = height;
    o.texture = getTexture(texturePath);
    return o;
end