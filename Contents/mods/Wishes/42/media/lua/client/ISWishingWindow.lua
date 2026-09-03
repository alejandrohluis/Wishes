DPWishes = DPWishes or {}

DPWishes.WindowsList = {}

local WishingWindows = DPWishes.WindowsList

DPWishes.Window = ISCollapsableWindow:derive("DP_ISWishingWindow")

local wishingWindow = DPWishes.Window
-- local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
-- local UI_BORDER_SPACING = 10
-- local BUTTON_HGT = FONT_HGT_SMALL + 6

function wishingWindow:createChildren()
	ISCollapsableWindow.createChildren(self);

    -- Only save window layout for single player
    if (self.playerIndex == 0) then
        ISLayoutManager.RegisterWindow('wishingwindow', wishingWindow, self);
    end
    self.visibleOnStartup = self:getIsVisible();

    self.resizeWidget2:bringToTop();
	self.resizeWidget:bringToTop();
end

function wishingWindow:close()
    ISPanel.close(self)
    self:removeFromUIManager();
    self:closePanel()
end

function wishingWindow:closePanel()
    if not self.panel then return end
    self.panel:close()
    self.panel:removeFromUIManager()
    self:removeChild(self.panel)
    self.panel = nil
end

function wishingWindow:updateWishesRemaining(remainingWishes)
    if not self.panel then return end
    self.panel:setRemainingWishes(remainingWishes)
end

function wishingWindow:initialise(wishStyle, wishes)
    ISCollapsableWindow.initialise(self);
    self.title = wishStyle.name;
    self.wishList = wishes
    self.wishAmount = wishStyle.wishAmount;
    self.texturePath = wishStyle.texturePath
    self.showCloseButton = false

    self:closePanel()
    self.panel = ISWishingPanel:new(self.width, self.height, self.player, self.playerIndex, self, self.wishList, self.wishAmount, self.texturePath);
    self.panel:initialise();
    if self.panel.closeButton then self.panel.closeButton:setVisible(false) end
    self:addChild(self.panel);
end

function wishingWindow:startMenu()
    self:setVisible(true);
    self:addToUIManager();
    self:bringToTop();
    self.tooltipForced = nil;
end

function wishingWindow:new(x, y, player, playerIndex)
	local instance = ISCollapsableWindow:new(x + 200, y + 100, 1050, 600);
	setmetatable(instance, self);
	self.__index = self;

    instance.showCloseButton = false
    instance.title = getText("UI_WishWindowTitle");
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

local function WindowOnCreatePlayer(playerIndex, player)
    if getCore():isDedicated() then return end

    if (not (WishingWindows[playerIndex])) then
        local x = getPlayerScreenLeft(playerIndex);
        local y = getPlayerScreenTop(playerIndex);
        WishingWindows[playerIndex] = wishingWindow:new(x, y, player, playerIndex);
    end
end

local function WindowOnPlayerDeath(player)
    local WishingWindow = WishingWindows[player:getOnlineID()];
	if WishingWindow then
		WishingWindow:setVisible(false);
		WishingWindow:removeFromUIManager();
	end
end

local function WindowOnResolutionChange(oldw, oldh, neww, newh)
	if not getPlayer() then return end

    local getScreenLeft = getPlayerScreenLeft
    local getScreenTop = getPlayerScreenTop

	for playerIndex=0, getNumActivePlayers() - 1 do
        local x = getScreenLeft(playerIndex);
        local y = getScreenTop(playerIndex);
        WishingWindows[playerIndex]:setX(x + 300);
        WishingWindows[playerIndex]:setY(y + 100);
	end
end

Events.OnCreatePlayer.Add(WindowOnCreatePlayer)
Events.OnPlayerDeath.Add(WindowOnPlayerDeath)
Events.OnResolutionChange.Add(WindowOnResolutionChange)

local function WindowReceiveUpdate(module, command, args)
    if module ~= "Wishes" then return end

    DPWishes.Action:handleCommand(command, args)
end

Events.OnServerCommand.Add(WindowReceiveUpdate)