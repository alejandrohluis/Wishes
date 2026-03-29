WishingWindows = {}

local ISWishingWindow = ISCollapsableWindow:derive("ISWishingWindow")
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

function ISWishingWindow:toggleWindow()
    if self:getIsVisible() then
        self:close();
    else
        self:addToUIManager();
        self:setVisible(true);
        self:bringToTop();
        self.tooltipForced = nil;
    end
end

function ISWishingWindow:createChildren()
	ISCollapsableWindow.createChildren(self);

    self.panel = ISWishingPanel:new(0, 8, self.width, self.height, self.player, self.playerIndex, self, self.wishes, self.wishAmount);
    self.panel:initialise();
    self:addView(self.panel);

    -- Only save window layout for single player
    if (self.playerIndex == 0) then
        ISLayoutManager.RegisterWindow('wishingwindow', ISWishingWindow, self);
    end
    self.visibleOnStartup = self:getIsVisible();

    self.resizeWidget2:bringToTop();
	self.resizeWidget:bringToTop();
end

function ISWishingWindow:close()
    self:setVisible(false);
    self:removeFromUIManager();
end

function ISWishingWindow:initialise(windowName, wishList, wishAmount)
    ISCollapsableWindow.initialise(self);
    self.title = windowName;
    if not self.panel then
        self.wishes = wishList;
        self.wishAmount = wishAmount;
    else
        self.panel:updateWishData(wishList, wishAmount);
    end
end

function ISWishingWindow:startMenu()
    self:setVisible(true);
    self:addToUIManager();
end

function ISWishingWindow:new(x, y, player, playerIndex)
	local instance = ISCollapsableWindow:new(x + 200, y + 100, 1050, 600);
	setmetatable(instance, self);
	self.__index = self;

    instance.title = "Make your Wish";
	instance.backgroundColor.a = 0.9;
    instance.minimumWidth = 1050;
    instance.minimumHeight = 600;
	instance:setResizable(false);
    instance.visibleOnStartup = false;
    instance.player = player;
	instance.playerIndex = playerIndex;
	instance:setDrawFrame(true);

    return instance
end

function WishingSystemHandleOnCreatePlayer(playerIndex, player)
    if getCore():isDedicated() then
        return;
    end

    if (not (WishingWindows[player])) then
        local x = getPlayerScreenLeft(playerIndex);
        local y = getPlayerScreenTop(playerIndex);
        WishingWindows[player] = ISWishingWindow:new(x, y, player, playerIndex);
    end
end

function WishingSystemHandleOnPlayerDeath(player)
    local WishingWindow = WishingWindows[player];
	if WishingWindow then
		WishingWindow:setVisible(false);
		WishingWindow:removeFromUIManager();
	end
end

function WishingSystemHandleOnResolutionChange(oldw, oldh, neww, newh)
	if (getPlayer() == nil) then
        return;
    end

	for playerIndex=0, getNumActivePlayers() - 1 do
        local x = getPlayerScreenLeft(playerIndex);
        local y = getPlayerScreenTop(playerIndex);
        self:setX(x + 300);
        self:setY(y + 100);
	end
end

Events.OnCreatePlayer.Add(WishingSystemHandleOnCreatePlayer)
Events.OnPlayerDeath.Add(WishingSystemHandleOnPlayerDeath)
Events.OnResolutionChange.Add(WishingSystemHandleOnResolutionChange)