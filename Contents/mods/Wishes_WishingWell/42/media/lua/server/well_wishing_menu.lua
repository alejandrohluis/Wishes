require "WishAction"


function DPWishes.Action:WishingWell_CreateSession(playerID)
    local sandbox = SandboxVars.WishesWishingWell
    local maxWishes = sandbox.WishesPerUse

    local session = DPWishes.Session:new(playerID, maxWishes, "well")
    session:addWish("WishingWell_modifyTrait"         , sandbox.WishCost_ModifyTrait       , sandbox.WishEnable_ModifyTrait)
    session:addWish("WishingWell_skillLevelUpUntil"   , sandbox.WishCost_SkillLevelUpUntil , sandbox.WishEnable_SkillLevelUpUntil)
    session:addWish("WishingWell_skillLevelUpOnce"    , sandbox.WishCost_SkillLevelUp      , sandbox.WishEnable_SkillLevelUp)
    session:addWish("WishingWell_idealWeight"         , sandbox.WishCost_IdealWeight       , sandbox.WishEnable_IdealWeight)
    session:addWish("WishingWell_heal"                , sandbox.WishCost_HealInjury        , sandbox.WishEnable_HealInjury)
    session:addWish("WishingWell_cureSickness"        , sandbox.WishCost_HealSickness      , sandbox.WishEnable_HealSickness)
    return session
end

local function WishingWell_StartMenu(player)
    local playerID = player:getOnlineID()

    local session = DPWishes.Action:WishingWell_CreateSession(playerID)

    local wishingWellData = {
        styleName = "UI_WishingWellStyle",
        wishAmount = session:getRemainingWishes(),
        texturePath = "media/textures/portrait/wishing_well.png",
        enabledWishes = session:getWishIDs(),
    }
    DPWishes.Action:startWishingMenu(player, wishingWellData)
end

local function WishingWell_addActions()
    local effects = DPWishes.Effects
    local actions = DPWishes.Action
    actions:addEffect("WishingWell_modifyTrait", effects.modifyTrait)
    actions:addEffect("WishingWell_skillLevelUpUntil", effects.skillLevelUpUntil)
    actions:addEffect("WishingWell_skillLevelUpOnce", effects.skillLevelUpOnce)
    actions:addEffect("WishingWell_idealWeight", effects.setIdealWeight)
    actions:addEffect("WishingWell_heal", effects.healUp)
    actions:addEffect("WishingWell_cureSickness", effects.cureSickness)
end

WishingWell_addActions()

------------------------------------

local function isPlayerClose(player, x, y, z)
    if not player then return false end
    if math.floor(player:getZ()) ~= z then return false end

    local distance_x = player:getX() - (x+0.5)
    local distance_y = player:getY() - (y+0.5)
    local distance = distance_x * distance_x + distance_y * distance_y
    local max_distance = 2.5 * 2.5

    return distance <= max_distance
end

local function validArgTypes(args)
    return
        args and type(args) == "table" and
        args.index and type(args.index) == "number" and
        args.x and type(args.x) == "number" and
        args.y and type(args.y) == "number" and
        args.z and type(args.z) == "number"
end

local function isItemAllowed(itemType)
    if type(itemType) ~= "string" then return false end

    local allowedItems = DPWishes.FilteringLists.Whitelists.AllowedItemsToThrowAtWell
    for i = 1, #allowedItems do
        local itemAllowed = allowedItems[i]
        if itemType == itemAllowed then
            return true
        end
    end
    return false
end

local function shouldStartMenu(player, args)
    return validArgTypes(args) and isItemAllowed(args.itemType) and isPlayerClose(player, args.x, args.y, args.z)
end

local function chanceForMenuSucceeded()
    local chanceToStartMenu = SandboxVars.WishesWishingWell.ChanceForWishes
    local random = ZombRandFloat(0, 100)
    return random < chanceToStartMenu
end

local function isWellTile(tile)
    local sprite = tile:getSprite()
    if not sprite then return end

    local spriteName = sprite:getName()
    if not spriteName then return end

    local wellSprite = "camping_01_16"
    return spriteName == wellSprite
end

local function startMenu(player, args)
    if( not shouldStartMenu(player, args) ) then return end

    local square = getCell():getGridSquare(args.x, args.y, args.z)
    if not square then return end

    local objectsInTile = square:getObjects()
    if args.index < 0 or args.index > objectsInTile:size() then return end

    local tile = objectsInTile:get(args.index)
    if not tile then return end

    if not isWellTile(tile) then return end


    local itemConsumed = player:getInventory():getItemFromTypeRecurse(args.itemType)
    if not itemConsumed then return end

    -- if the item is in a backpack or something else
    local inventoryContainer = itemConsumed:getContainer()
    inventoryContainer:Remove(itemConsumed)
    sendRemoveItemFromContainer(inventoryContainer, itemConsumed)

    if not chanceForMenuSucceeded() then return end

    WishingWell_StartMenu(player)
end

local function WishingWellTriggered(module, command, player, args)
    if module ~= "DP_Wishes" then return end
    if command ~= "WishingWellTriggered" then return end

    startMenu(player, args)
end

Events.OnClientCommand.Add(WishingWellTriggered)