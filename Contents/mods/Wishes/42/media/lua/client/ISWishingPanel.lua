

ISWishingPanel = ISPanel:derive("ISWishingPanel");

local UIFontSmall = UIFont.Small
local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFontSmall);
-- local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium);
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
    local player = panel.player;
    local wasWishedConsumed = wish.effect(player,wish,panel);
    if wasWishedConsumed then
        panel.wishAmount = panel.wishAmount - 1;
    end
    if panel.wishAmount == 0 then
        panel:close();
        return
    end
    panel:updateWishesLabel();
end

local function getWishColor(wish, player)
    local colors = {
        wish = { r = 0.8, g = 1, b = 0.8, a = 1 },
        neutral = { r = 0.7, g = 0.7, b = 0.7, a = 1 },
        good = { r = 0, g = 0.7, b = 0, a = 1 },
        bad = { r = 0.7, g = 0, b = 0, a = 1 },
        bug = { r = 0, g = 0, b = 1, a = 1}
    }
    if not wish.data then
        return colors.wish;
    end
    local isTrait = wish.data.getLabel;
    if not isTrait then
        return colors.neutral;
    end
    local traitDefinition = wish.data;
    local trait = traitDefinition:getType();
    local cost = traitDefinition:getCost();
    if cost > 0 then
        if player:hasTrait(trait) then
            return colors.bad;
        else
            return colors.good;
        end
    end
    if cost < 0 then
        if player:hasTrait(trait) then
            return colors.good;
        else
            return colors.bad;
        end
    end
    if cost == 0 then
        return colors.bug;
    end
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
    local maxWidth = self.owner:getWidth();
    local maxHeight = self.owner:getHeight();

    local tablePad = 20;
    self.tableWidth = (maxWidth / 3.0) - (tablePad * 6.0);
    self.wishTableHeight = #self.wishes * (UI_BORDER_SPACING + BUTTON_HGT);
    self.tableMaxHeight = maxHeight - 60 - UI_BORDER_SPACING - (BUTTON_HGT * 2.0);
    self.topOfLists = UI_BORDER_SPACING + BUTTON_HGT;
    self.buttonHgt = 25;
    self.buttonPad = 6;

    -- wishes label
    self.remainingWishesLabel = ISLabel:new(tablePad, UI_BORDER_SPACING, BUTTON_HGT, "Wishes remaining: " .. tostring(self.wishAmount), 1, 1, 1, 1, UIFontSmall, true);
    -- self.remainingWishesLabel = ISLabel:new(self.tablePad, UI_BORDER_SPACING, BUTTON_HGT, getText("UI_characreation_choosentraits") , 1, 1, 1, 1, UIFontSmall, true);
	self.remainingWishesLabel:initialise();
    self.remainingWishesLabel:instantiate();
    self:addChild(self.remainingWishesLabel);

    -- wish list
    self.listboxWishes = ISScrollingListBox:new(tablePad, self.topOfLists, self.tableWidth, self.wishTableHeight);
    initialiseListbox(self.listboxWishes, self)
    self:addChild(self.listboxWishes);

    local offset = tablePad + self.tableWidth;
    local tableOffsetX = tablePad + offset;
    local noColor = {r=0,g=0,b=0,a=0}

    -- category list for wishes that have different type of options
    self.listboxCategory = ISScrollingListBox:new(tableOffsetX, self.topOfLists, self.tableWidth, self.tableMaxHeight)
    initialiseListbox(self.listboxCategory, self)
    self.listboxCategory.backgroundColor = noColor;
    self.listboxCategory:setVisible(false);
    self:addChild(self.listboxCategory);

    tableOffsetX = tableOffsetX + offset;
    -- options list
    self.listboxOptions = ISScrollingListBox:new(tableOffsetX, self.topOfLists, self.tableWidth, self.tableMaxHeight)
    initialiseListbox(self.listboxOptions, self)
    self.listboxOptions.backgroundColor = noColor;
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
    hideListbox(self.listboxCategory);
    hideListbox(self.listboxOptions)
end

function ISWishingPanel:updateWishesLabel()
    if self.remainingWishesLabel then
        self.remainingWishesLabel.name = "Wishes remaining: " .. tostring(self.wishAmount);
    end
end

function ISWishingPanel:onClickWish(listbox, wish)
    self:clearModal();
    -- this is for joypads
    self.selectedList = listbox;
    if (listbox == self.listboxWishes) then
        hideListbox(self.listboxCategory);
        hideListbox(self.listboxOptions);
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

    if not item.isOption then
        if item.options then
            self.listboxCategory:setVisible(true);
            self:addCategoryToList(item);
            return
        end
        if item.children then
            self.listboxOptions:setVisible(true);
            self:addOptionsToList(item);
            return
        end
        hideListbox(self.listboxOptions)
        hideListbox(self.listboxCategory)
    end

    local wish = item;
    if not wish.isEnabled then
        return
    end
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
    local colorText = getWishColor(wish, self.owner.player);
    local dy = (self.itemheight - FONT_HGT_SMALL) / 2.0;
    -- wish label
    self:drawText(wish.label, offsetX, y + dy, colorText.r, colorText.g, colorText.b, colorText.a, UIFontSmall);

    self.itemheightoverride[wish.label] = self.itemheight
    y = y + self.itemheightoverride[wish.label]
    return y
end

--- ISWishingPanel:addWishesToList()  
--- Adds all existing wishes to the listbox
function ISWishingPanel:addWishesToList()
    local wishSelection = self.listboxWishes.selected;
    self.listboxWishes:clear();
    local allWishes = self.wishes;
    for i = 1, #allWishes do
        -- local key = wishKeys[i];
        local wish = allWishes[i];
        if wish.isEnabled then
            local tooltip = "Wish to " .. wish.label;
            self.listboxWishes:addItem(wish.label, wish, tooltip);
        end
    end
    self.listboxWishes.selected = wishSelection;
end


--- ISWishingPanel:addCategoryToList(wish)  
--- Adds all categories to the listbox
function ISWishingPanel:addCategoryToList(wish)
    local optionsCategorySelection = self.listboxCategory.selected;
    local optionsSelection = self.listboxOptions.selected;
    self.listboxCategory:clear();
    self.listboxOptions:clear();
    local categories = wish.options;
    local effect = wish.effect;
    for i = 1, #categories do
        local category = categories[i];
        category.effect = effect;
        self.listboxCategory:addItem(category.label, category);
    end
    self.listboxCategory.height = math.min(self.tableMaxHeight, #categories * BUTTON_HGT);
    self.listboxCategory.selected = optionsCategorySelection;
    self.listboxOptions.selected = optionsSelection;
end

--- ISWishingPanel:addOptionsToList(wish)  
--- Adds all options to the listbox
function ISWishingPanel:addOptionsToList(wish)
    local optionsSelection = self.listboxOptions.selected;
    self.listboxOptions:clear();
    local options = wish.children;
    local effect = wish.effect;
    for i = 1 , #options do
        local option = {};
        option.isEnabled = true;
        option.isOption = true;
        option.data = options[i];
        local labelMethod = option.data.getLabel or option.data.getName;
        option.label = labelMethod(option.data);
        option.effect = effect;
        local tooltip = option.data.getDescription and option.data:getDescription();
        self.listboxOptions:addItem(option.label, option, tooltip);
    end
    self.listboxOptions.height = math.min(self.tableMaxHeight, #options * BUTTON_HGT);
    self.listboxOptions.selected = optionsSelection;
end

function ISWishingPanel:close()
    self.owner:close()
end

----------------------------------------------------------------------------------

function ISWishingPanel:new(x, y, width, height, player, playerNum, owner, wishList, wishAmount)
    local o = {}
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    o.player = player;
    o.playerNum = playerNum;
    o.owner = owner;
    o:noBackground();
    -- o.backgroundColor = { r = 0, g = 0, b = 0, a = 0.8 }
    o.variableColor = { r = 0.9, g = 0.55, b = 0.1, a = 1 };
    o.selectedList = nil;
    o.wishAmount = wishAmount;
    o.wishes = wishList;
    return o
end

----------------------------------------------------------------------------------