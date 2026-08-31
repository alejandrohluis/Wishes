WishingWindows = {}

local ISWishingWindow = ISCollapsableWindow:derive("ISWishingWindow")
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

function ISWishingWindow:toggleWindow()
    if self:getIsVisible() then
        self:close();
    else
        self:startMenu()
    end
end

function ISWishingWindow:createChildren()
	ISCollapsableWindow.createChildren(self);

    self.panel = ISWishingPanel:new(self.width, self.height, self.player, self.playerIndex, self, self.wishList, self.wishAmount, self.texturePath);
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
function ISWishingWindow:updateWishesRemaining(remainingWishes)
    if not self.panel then return end
    self.panel:setRemainingWishes(remainingWishes)
end

function ISWishingWindow:initialise(wishStyle)
    ISCollapsableWindow.initialise(self);
    self.title = wishStyle.name;
    if not self.panel then
        self.wishList = wishStyle.wishList;
        self.wishAmount = wishStyle.wishAmount;
        self.texturePath = wishStyle.texturePath
    else
        -- self.panel:updateWishData(wishStyle.wishList, wishStyle.wishAmount);
        self.panel:updateWishData(self.wishList, self.wishAmount);
    end
end

function ISWishingWindow:startMenu()
    self:setVisible(true);
    self:addToUIManager();
    self:bringToTop();
    self.tooltipForced = nil;
    print("[Wishes] [startMenu] player ID = "..self.playerIndex)
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

    if (not (WishingWindows[playerIndex])) then
        print("[Wishes] [CreatePlayer] creating player under id = "..playerIndex)
        local x = getPlayerScreenLeft(playerIndex);
        local y = getPlayerScreenTop(playerIndex);
        WishingWindows[playerIndex] = ISWishingWindow:new(x, y, player, playerIndex);
    end
end

function WishingSystemHandleOnPlayerDeath(player)
    local WishingWindow = WishingWindows[player:getPlayerNum()];
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

local function WishingSystemUpdateWindow(command, args)
    local player = getPlayer()
    local playerID = player:getPlayerNum()
    local wishingWindow = WishingWindows[playerID]
    if not wishingWindow then return end
    if command == "StartWishingMenu" then
        local wishStyle = WishStyle:new(args.wishStyle.name, args.wishStyle.wishAmount, args.wishStyle.texturePath)
        wishStyle.wishList = args.wishStyle.wishes
        wishingWindow:initialise(wishStyle)
        wishingWindow:startMenu()
    end
    if command == "ConsumeWish" then
        WishingWindows[playerID]:updateWishesRemaining(args.remainingWishes)
    end
    if command == "StopWishingMenu" then
        WishingWindows[playerID]:close()
    end
end

local function WishingSystemReceiveWindowUpdates(module, command, args)
    if module ~= "Wishes" then return end

    WishingSystemUpdateWindow(command, args)
end

Events.OnServerCommand.Add(WishingSystemReceiveWindowUpdates)