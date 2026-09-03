require "WishAttributes"

DPWishes = DPWishes or {}

----------------------------------------------------------------------------------
--- WishAction
----------------------------------------------------------------------------------
DPWishes.Session = {}

local wishingSession = DPWishes.Session

function wishingSession:new(playerID, style)
    if wishingSession[playerID] then
        wishingSession[playerID]:close()
    end
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.wishStyle = style
    o.wishAmount = style.wishAmount
    o.player = playerID
    o.whitelistedWishes = {}
    wishingSession[playerID] = o
    return o
end

function wishingSession:removeNWishes(wishesToRemove)
    self.wishAmount = self.wishAmount - wishesToRemove
end

function wishingSession:hasRemainingWishes()
    return self.wishAmount > 0
end

function wishingSession:getRemainingWishes()
    return self.wishAmount
end

function wishingSession:getWishes()
    return self.whitelistedWishes
end

function wishingSession:getWishIDs()
    local ids = {}
    for wishID, _ in pairs(self.whitelistedWishes) do 
        table.insert(ids, wishID)
    end
    return ids
end

function wishingSession:getWish(wishID)
    return self.whitelistedWishes[wishID]
end

function wishingSession:addWish(wishID, wishCost, isEnabled)
    if not isEnabled then return end
    self.whitelistedWishes[wishID] = { cost = wishCost }
end

function wishingSession:close()
    self.whitelistedWishes = nil
    wishingSession[self.player] = nil
end

----------------------------------------------------------------------------------
--- WishAction
----------------------------------------------------------------------------------
DPWishes.Action = {}

local wishAction = DPWishes.Action

function wishAction:addEffect(identifier, effect)
    if wishAction[identifier] then
        return false
    end
    if not effect then
        return false
    end
    wishAction[identifier] = effect
    return wishAction[identifier] ~= nil
end

function wishAction:removeEffect(identifier)
    if not wishAction[identifier] then return end
    wishAction[identifier] = nil
end

function wishAction:handleCommand(command, args)
    local wishingWindows = DPWishes.WindowsList
    local player = getPlayer()
    local playerID = player:getOnlineID()
    local playerWishingWindow = wishingWindows[playerID]
    if not playerWishingWindow then
        -- local x = getPlayerScreenLeft(playerID);
        -- local y = getPlayerScreenTop(playerID);
        -- wishingWindows[playerID] = DPWishes.Window:new(x, y, player, playerID)
        return
    end
    if command == "StartWishingMenu" then
        local wishStyle = DPWishes.Style:new(args.wishStyle.name, args.wishStyle.wishAmount, args.wishStyle.texturePath)
        local wishes = args.enabledWishes
        playerWishingWindow:initialise(wishStyle, wishes)
        playerWishingWindow:startMenu()
    end
    if command == "ConsumeWish" then
        wishingWindows[playerID]:updateWishesRemaining(args.remainingWishes)
    end
    if command == "StopWishingMenu" then
        wishingWindows[playerID]:close()
    end
end

function wishAction:startWishingMenu(player, wishingData, wishes)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "StartWishingMenu", { wishStyle = wishingData , enabledWishes = wishes })
    else
        DPWishes.Action:handleCommand("StartWishingMenu", { wishStyle = wishingData , enabledWishes = wishes })
    end
end

function wishAction:stopWishingMenu(player)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "StopWishingMenu", nil)
    else
        DPWishes.Action:handleCommand("StopWishingMenu", nil)
    end
end

function wishAction:updateWishes(player, newWishes)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "ConsumeWish", { remainingWishes = newWishes })
    else
        DPWishes.Action:handleCommand("ConsumeWish", { remainingWishes = newWishes })
    end
end

local function canPerformWish(availableWishes, wishID, wish)
    return wishAction[wishID] ~= nil and availableWishes >= wish.cost
end

local function OnClientCommand(module, command, player, args)
    if module ~= "DP_Wishes" then return end
    if command ~= "GrantWish" then return end
    if not args or not args.wishID or type(args.wishID) ~= "string" then return end
    local playerID = player:getOnlineID()
    local playerSession = wishingSession[playerID]
    if not playerSession then return end

    local wishID = args.wishID
    local wishToPerform = playerSession:getWish(wishID)

    -- if wish is not enabled for this session
    if not wishToPerform then return end

    if not canPerformWish(playerSession:getRemainingWishes(), wishID, wishToPerform) then return end

    local consumeWish = wishAction[wishID](player, args.optionID)
    if consumeWish then
        playerSession:removeNWishes(wishToPerform.cost)
        wishAction:updateWishes(player, playerSession:getRemainingWishes())
    end
    if not playerSession:hasRemainingWishes() then
        playerSession:close()
        wishAction:stopWishingMenu(player)
    end
end

Events.OnClientCommand.Add(OnClientCommand)

local function OnPlayerDeath(character)
    if not instanceof(character, "IsoPlayer") then return end

    local playerID = character:getOnlineID()
    local session = wishingSession[playerID]
    if session then
        session:close()
    end
end

Events.OnCharacterDeath.Add(OnPlayerDeath)

local function OnPlayerDisconnect(player)
    print("[Wishes] Closing wishing session...")
    local playerID = player:getOnlineID()
    local session = wishingSession[playerID]
    if session then
        session:close()
        print("[Wishes] Session succesfully closed.")
    else
        print("[Wishes] No session found.")
    end
end

Events.OnDisconnect.Add(OnPlayerDisconnect)