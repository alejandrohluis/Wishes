require "TimedActions/ISBaseTimedAction"

-- utils
local function isWellTile(tile)
    local sprite = tile:getSprite()
    if not sprite then return end

    local spriteName = sprite:getName()
    if not spriteName then return end

    local wellSprite = "camping_01_16"
    return spriteName == wellSprite
end


-- player action/animation of using the well
ISUseWishingWellAction = ISBaseTimedAction:derive("ISUseWishingWellAction")

function ISUseWishingWellAction:new(character, args, isoObject)
    local o = ISBaseTimedAction.new(self, character)

    o.args = args
    o.isoObject = isoObject

    -- how long the action takes in ticks
    o.maxTime = 20

    o.stopOnWalk = true
    o.stopOnRun = true

    return o
end

function ISUseWishingWellAction:isValid()
    if not self.character or not self.args or not self.isoObject then return false end

    local square = self.isoObject:getSquare()
    if not square then return false end

    return isWellTile(self.isoObject)
end

function ISUseWishingWellAction:start()
    self:setActionAnim("Pour")
end

function ISUseWishingWellAction:update()
    self.character:faceThisObject(self.isoObject)
end

function ISUseWishingWellAction:perform()
    sendClientCommand(self.character, "DP_Wishes", "WishingWellTriggered", self.args)
    ISBaseTimedAction.perform(self)
end


local function onWishingWellTriggerAction(itemConsumed, player, isoObject)
    if not player or not isoObject then return end

    local squareToWalk = isoObject:getSquare()

    -- walk to the well
    if not luautils.walkAdj(player, squareToWalk, true) then return end

    local args = {
        x = isoObject:getX(),
        y = isoObject:getY(),
        z = isoObject:getZ(),
        index = isoObject:getObjectIndex(),
        itemType = itemConsumed:getType()
    }

    ISTimedActionQueue.add(ISUseWishingWellAction:new(player, args, isoObject))
end

local function getAllowedItems()
    return DPWishes.FilteringLists.Whitelists.AllowedItemsToThrowAtWell
end

local function WishingWellOptionContextMenu(playerNum, context, worldobjects, test)
    if test then return end

    local clickedIsoObject = nil

    -- loop through clicked objects to find the well
    for _, obj in ipairs(worldobjects) do
        if isWellTile(obj) then
            clickedIsoObject = obj
            break
        end
    end

    if not clickedIsoObject then return end

    local wishingWellOptionLabel = getText("ContextMenu_WishingWell_AskWish")

    local player = getSpecificPlayer(playerNum)
    local allowedItems = getAllowedItems()
    local inventory = player:getInventory()

    local hasAnAllowedItem = false
    for i = 1, #allowedItems do
        local itemAllowed = allowedItems[i]
        if inventory:containsTypeRecurse(itemAllowed) then
            hasAnAllowedItem = true
            break
        end
    end

    if not hasAnAllowedItem then return end

    local wishingWellOption = context:addOption(wishingWellOptionLabel, nil)
    local vanillaWellOption = context:getOptionFromName(getText("Fluid_Name_Water"))
    if vanillaWellOption and vanillaWellOption.iconTexture then
        wishingWellOption.iconTexture = vanillaWellOption.iconTexture
    else
        wishingWellOption.iconTexture = getTexture(clickedIsoObject:getTextureName())
    end

    local usedItemSubMenu = ISContextMenu:getNew(context)
    context:addSubMenu(wishingWellOption, usedItemSubMenu)

    for i = 1, #allowedItems do
        local itemAllowed = allowedItems[i]
        if inventory:containsTypeRecurse(itemAllowed) then
            local item = inventory:getItemFromTypeRecurse(itemAllowed)
            local itemOptionName = item:getName()
            local prefix = getText("ContextMenu_WishingWell_prefix")
            if prefix ~= "ContextMenu_WishingWell_prefix" then
                itemOptionName = prefix .. " " .. itemOptionName
            end
            usedItemSubMenu:addOption(itemOptionName, item, onWishingWellTriggerAction, player, clickedIsoObject)
        end
    end
end

Events.OnFillWorldObjectContextMenu.Add(WishingWellOptionContextMenu)