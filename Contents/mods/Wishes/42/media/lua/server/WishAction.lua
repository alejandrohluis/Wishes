DPWishes = DPWishes or {}

----------------------------------------------------------------------------------
--- WishAction
----------------------------------------------------------------------------------
--- Looking to make your own wish summoning mod using this base ?
--- If you are looking at this on steam's version of the code and there is no 
--- explanation then check the github. If you are looking at this on github
--- and there is no explanation, then screw the author for procrastinating!!!
----------------------------------------------------------------------------------
DPWishes.Session = {}

local wishingSession = DPWishes.Session

function wishingSession:new(playerID, wishAmount, styleUsed)
    local playerSession = wishingSession[playerID]
    if playerSession then
        if playerSession.style == styleUsed then
            playerSession:addMoreWishes(wishAmount)
            return playerSession
        end
        playerSession:close()
    end
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.wishAmount = wishAmount
    o.player = playerID
    o.style = styleUsed
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
    if not isEnabled or self.whitelistedWishes[wishID] then return end
    self.whitelistedWishes[wishID] = { cost = wishCost }
end

function wishingSession:addMoreWishes(wishAmount)
    self.wishAmount = self.wishAmount + wishAmount
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

function wishAction:handleCommand(command, player, args)
    local wishingWindows = DPWishes.WindowsList
    local playerID = player:getOnlineID()
    local playerWishingWindow = wishingWindows[playerID]
    if not playerWishingWindow then
        local playerIndex = player:getPlayerNum()
        local x = getPlayerScreenLeft(playerIndex);
        local y = getPlayerScreenTop(playerIndex);
        playerWishingWindow = DPWishes.Window:new(x, y, player, playerID)
        wishingWindows[playerID] = playerWishingWindow
    end
    if command == "StartWishingMenu" then
        playerWishingWindow:initialise(args.styleName, args.wishAmount, args.texturePath, args.enabledWishes)
        playerWishingWindow:startMenu()
    end
    if command == "ConsumeWish" then
        playerWishingWindow:updateWishesRemaining(args.remainingWishes)
    end
    if command == "StopWishingMenu" then
        playerWishingWindow:forceClose()
    end
end

function wishAction:startWishingMenu(player, wishingData)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "StartWishingMenu", wishingData )
    else
        DPWishes.Action:handleCommand("StartWishingMenu", player, wishingData )
    end
end

function wishAction:stopWishingMenu(player)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "StopWishingMenu", nil)
    else
        DPWishes.Action:handleCommand("StopWishingMenu", player, nil)
    end
end

function wishAction:updateWishes(player, newWishes)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "ConsumeWish", { remainingWishes = newWishes })
    else
        DPWishes.Action:handleCommand("ConsumeWish", player, { remainingWishes = newWishes })
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
    local playerID = player:getOnlineID()
    local session = wishingSession[playerID]
    if session then
        session:close()
    end
end

Events.OnDisconnect.Add(OnPlayerDisconnect)