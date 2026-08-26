-----------------------
---  Wish Portrait  ---
-----------------------
---
--- The image that will be used for each summoning style.
--- 
--- Currently includes:
--- Dragon Ball

ISWishPortrait = ISUIElement:derive("WishPortrait");

function ISWishPortrait:render()
    -- local width = 240;
    -- local height = 465;
    self:drawRectBorder(self.x - 1, self.y - 1, self.w + 2, self.h + 2, 1.0, 0.4, 0.4, 0.4);
    self:drawTextureScaled(self.texture, self.x, self.y, self.w, self.h, 1, 1, 1, 1);
end

function ISWishPortrait:initialise()
    ISUIElement:initialise();
end

function ISWishPortrait:new(x,y, width, height, texture)
    local o = {};
    o = ISUIElement:new(x,y,width,height);
    setmetatable(o,self);
    self.__index = self;

    o.x = x/2;
    o.y = y/2;
    o.w = width;
    o.h = height;
    o.texture = texture;
    return o;
end