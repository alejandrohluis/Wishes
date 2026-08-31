require "WishAttributes"

ISWishingPanel = ISPanel:derive("ISWishingPanel");

local UIFontSmall = UIFont.Small
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFontSmall);
local UI_BORDER_SPACING = 10;
local BUTTON_HGT = FONT_HGT_SMALL + 6;

----------------------------------------------------------------------------------

local function hideListbox(listbox)
    if not listbox then return end
    listbox:clear();
    listbox.selected = -1;
    listbox:setVisible(false);
end

local function initialiseListbox(listbox, panel)
    listbox:initialise();
    listbox:instantiate();
    listbox.itemheight = BUTTON_HGT;
    listbox.selected = 1;
    listbox.doDrawItem = panel.doDrawWish;
    listbox:setOnMouseDownFunction(listbox, function(wish) panel:onClickWish(listbox, wish) end)
    listbox:setOnMouseDoubleClick(panel, panel.onDoubleClickItem);
    listbox.drawBorder = true
    listbox.owner = panel;
end

local function onDoWish(panel, button, wish)
    if button.internal ~= "YES" then
        return;
    end
    local wishData = { wishID = wish.wishID }
    if wish.optionID then
        wishData.optionID = wish.optionID
    end
    sendClientCommand(panel.player, "Wishes", "GrantWish", wishData )
    panel:clearCategories()
end

----------------------------------------------------------------------------------
--- ISWishingPanel
----------------------------------------------------------------------------------

function ISWishingPanel:initialise()
    ISPanel.initialise(self);
    self:updateWishesLabel();
    self.selectedList = nil;
    if self.listboxWishes then
        self.listboxWishes.selected = 1;
    end
    hideListbox(self.listboxCategory);
    hideListbox(self.listboxOptions);
end

function ISWishingPanel:createChildren()
    self.maxWidth = self.owner:getWidth();
    self.maxHeight = self.owner:getHeight();

    self.tablePad = 20;
    self.tableWidth = (self.maxWidth / 3.0) - (self.tablePad * 6.0);
    self.wishTableHeight = #self.wishes * (UI_BORDER_SPACING + BUTTON_HGT);
    self.tableMaxHeight = self.maxHeight - 60 - UI_BORDER_SPACING - (BUTTON_HGT * 2.0);
    self.topOfLists = UI_BORDER_SPACING + BUTTON_HGT;
    self.buttonHgt = 25;
    self.buttonPad = 6;

    local offset = self.tablePad + self.tableWidth;
    local tableOffsetX = self.tablePad + offset;

    self.portrait = ISWishPortrait:new(self.tablePad, UI_BORDER_SPACING, self.tableWidth, (self.maxHeight - UI_BORDER_SPACING * 4), self.texturePath);
    self.portrait:initialise();
    self:addChild(self.portrait);

    -- todo: add translation (using getText("UI_")...)
    -- available wishes label
    self.remainingWishesLabel = ISLabel:new(tableOffsetX, UI_BORDER_SPACING, BUTTON_HGT, ("Wishes remaining: " .. tostring(self.wishAmount)), 1, 1, 1, 1, UIFontSmall, true);
	self.remainingWishesLabel:initialise();
    self:addChild(self.remainingWishesLabel);

    -- wish list
    self.listboxWishes = ISScrollingListBox:new(tableOffsetX, self.topOfLists, self.tableWidth, self.wishTableHeight);
    initialiseListbox(self.listboxWishes, self)
    self:addChild(self.listboxWishes);

    tableOffsetX = tableOffsetX + offset;
    -- category list for wishes that have different type of options
    self.listboxCategory = ISScrollingListBox:new(tableOffsetX, self.topOfLists, self.tableWidth, self.tableMaxHeight)
    initialiseListbox(self.listboxCategory, self)
    self.listboxCategory:setVisible(false);
    self:addChild(self.listboxCategory);

    tableOffsetX = tableOffsetX + offset;
    -- options list
    self.listboxOptions = ISScrollingListBox:new(tableOffsetX, self.topOfLists, self.tableWidth, self.tableMaxHeight)
    initialiseListbox(self.listboxOptions, self)
    self.listboxOptions:setVisible(false);
    self:addChild(self.listboxOptions);

    self:addWishesToList();
end

function ISWishingPanel:updateWishData(wishes, wishAmount)
    self.wishes = wishes;
    self.wishAmount = wishAmount;
    self:updateWishesLabel();
    self.selectedList = nil;
    self.listboxWishes.selected = 1;
    self:clearCategories()
end

function ISWishingPanel:setRemainingWishes(remainingWishes)
    self.wishAmount = remainingWishes
    self:updateWishesLabel()
end

function ISWishingPanel:updateWishesLabel()
    if self.remainingWishesLabel then
        self.remainingWishesLabel.name = "Wishes remaining: " .. tostring(self.wishAmount);
    end
end

function ISWishingPanel:clearCategories()
    hideListbox(self.listboxCategory)
    hideListbox(self.listboxOptions)
end

function ISWishingPanel:onClickWish(listbox, wish)
    self:clearModal();
    -- this is for joypads
    self.selectedList = listbox;
    if (listbox == self.listboxWishes) then
        self:clearCategories()
    elseif (listbox == self.listboxCategory) then
        hideListbox(self.listboxOptions);
    end
end

function ISWishingPanel:clearModal()
    if self.modal then
        self.modal:destroy();
    end
end

function ISWishingPanel:onDoubleClickItem(item)
    local player = self.player;

    local hasCategories = item.categories ~= nil
    if hasCategories then
        self.listboxCategory:setVisible(true);
        self:addCategoryToList(item);
        return
    end
    local hasOptions = item.options ~= nil
    if hasOptions then
        self.listboxOptions:setVisible(true);
        self:addOptionsToList(item);
        return
    end

    local wish = item;
    local width = 250.0;
    local height = 150.0;
    local x = self.owner:getX() + (self.owner:getWidth() / 2.0) - (width / 2.0);
    local y = self.owner:getY() + (self.owner:getHeight() / 2.0) - (height / 2.0);

    self.modal = ISModalDialog:new(x, y, width, height, "Are you sure you wish to " .. wish.label .. "?", true, self, onDoWish, player:getPlayerNum(), wish);
    self.modal:initialise();
    self.modal:addToUIManager();
    self.modal:bringToTop();
end

function ISWishingPanel:doDrawWish(y, item, alt)
    self:drawRectBorder(0, y, self:getWidth(), self.itemheight - 1, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)
    local wish = item.item

    -- display rectangle over the selected wish
    local isMouseOver = (self.mouseoverselected == item.index)
    if self.selected == item.index then
        self:drawRect(0, y, self:getWidth(), self.itemheight - 1, 0.3, 0.7, 0.35, 0.15)
    elseif isMouseOver then
        self:drawRect(1, y + 1, self:getWidth() - 2, item.height - 4, 0.95, 0.1, 0.1, 0.1)
    end

    local offsetX = 16;
    local colorText = wish.color or { r = 0.8, g = 1, b = 0.8, a = 1 }
    local dy = (self.itemheight - FONT_HGT_SMALL) / 2.0;
    -- wish label
    self:drawText(wish.label, offsetX, y + dy, colorText.r, colorText.g, colorText.b, colorText.a, UIFontSmall);

    self.itemheightoverride[wish.label] = self.itemheight
    y = y + self.itemheightoverride[wish.label]
    return y
end

-- Wish panel workflow:
-- all wishes => category => options

--- ISWishingPanel:addWishesToList()  
--- Adds all existing wishes to its listbox
function ISWishingPanel:addWishesToList()
    local wishSelection = self.listboxWishes.selected;
    self.listboxWishes:clear();
    local allWishes = self.wishes;
    local wishDefinitions = WishDefinitions
    -- local getLabel = getText
    for i = 1, #allWishes do
        local wishID = allWishes[i];
        local wishDefinition = wishDefinitions[wishID]
        local wish = { wishID = wishID , label = wishDefinition.label , categories = wishDefinition.categories }
        local tooltip = "Wish to " .. wish.label;
        self.listboxWishes:addItem(wish.label, wish, tooltip);
    end
    self.listboxWishes.selected = wishSelection;
end


--- ISWishingPanel:addCategoryToList(wish)  
--- Adds all categories to its listbox
function ISWishingPanel:addCategoryToList(wish)
    local optionsCategorySelection = self.listboxCategory.selected;
    local optionsSelection = self.listboxOptions.selected;
    self.listboxCategory:clear();
    self.listboxOptions:clear();
    local categories = wish:categories(self.player);
    for i = 1, #categories do
        local category = categories[i];
        category.wishID = wish.wishID;
        self.listboxCategory:addItem(category.label, category);
    end
    self.listboxCategory.height = math.min(self.tableMaxHeight, #categories * BUTTON_HGT);
    self.listboxCategory.selected = optionsCategorySelection;
    self.listboxOptions.selected = optionsSelection;
end

--- ISWishingPanel:addOptionsToList(wish)  
--- Adds all options to its listbox
function ISWishingPanel:addOptionsToList(category)
    local optionsSelection = self.listboxOptions.selected;
    self.listboxOptions:clear();
    local options = category.options;
    for i = 1 , #options do
        local option = options[i];
        option.wishID = category.wishID
        if not option.color then
            option.color = category.color
        end
        self.listboxOptions:addItem(option.label, option, option.tooltip);
    end
    self.listboxOptions.height = math.min(self.tableMaxHeight, #options * BUTTON_HGT);
    self.listboxOptions.selected = optionsSelection;
end

----------------------------------------------------------------------------------

function ISWishingPanel:new(width, height, player, playerNum, owner, wishList, wishesPerSummoning, texturePath)
    local o = {}
    o = ISPanel:new(0, 8, width, height)
    setmetatable(o, self)
    self.__index = self

    o.player = player;
    o.playerNum = playerNum;
    o.owner = owner;
    o:noBackground();
    -- o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.variableColor = { r = 0.9, g = 0.55, b = 0.1, a = 1 };
    o.selectedList = nil;
    o.texturePath = texturePath
    o.wishAmount = wishesPerSummoning
    o.wishes = wishList
    return o
end

----------------------------------------------------------------------------------