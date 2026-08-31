require "WishAttributes"

WishingSession = {}

function WishingSession:new(playerID, style)
    local o = {}
    setmetatable(o, self)
    self.__index = self

    o.wishStyle = style
    o.wishAmount = style.wishAmount
    o.player = playerID
    o.whitelistedWishes = {}
    if WishingSession[playerID] then
        WishingSession[playerID]:close()
    end
    WishingSession[playerID] = o
    return o
end

function WishingSession:removeNWishes(wishesToRemove)
    self.wishAmount = self.wishAmount - wishesToRemove
end

function WishingSession:hasRemainingWishes()
    return self.wishAmount > 0
end

function WishingSession:getRemainingWishes()
    return self.wishAmount
end

function WishingSession:getWishes()
    return self.whitelistedWishes
end

function WishingSession:getWishIDs()
    local ids = {}
    for wishID, _ in pairs(self.whitelistedWishes) do 
        table.insert(ids, wishID)
    end
    return ids
end

function WishingSession:getWish(wishID)
    return self.whitelistedWishes[wishID]
end

function WishingSession:addWish(wishID, wishCost, isEnabled)
    if not isEnabled then return end
    self.whitelistedWishes[wishID] = { cost = wishCost }
end

function WishingSession:close()
    self.whitelistedWishes = nil
    WishingSession[self.player] = nil
end

----------------------------------------------------------------------------------
--- WishAction
----------------------------------------------------------------------------------
WishAction = {}

function WishAction:addEffect(identifier, effect)
    if WishAction[identifier] then
        print("[Wishes] [addEffect] The action already exists with this id = " .. identifier)
        return false
    end
    if not effect then
        print("[Wishes] [addEffect] There is no effect to add")
        return false
    end
    WishAction[identifier] = effect
    print("[Wishes] [addEffect] Action added with id = ".. identifier)
    return WishAction[identifier] ~= nil
end

function WishAction:removeEffect(identifier)
    if not WishAction[identifier] then return end
    WishAction[identifier] = nil
end

local function canPerformWish(availableWishes, wishID, wish)
    if not WishAction[wishID] then
        print("[Wishes] [canPerformWish] The action does not exist with id = " .. wishID)
    end
    if availableWishes < wish.cost then
        print("[Wishes] [canPerformWish] player does not have enough wishes to perform this action ("..availableWishes.." < "..wish.cost..")")
    end
    return WishAction[wishID] ~= nil and availableWishes >= wish.cost
end

local function OnClientCommand(module, command, player, args)
    print("[Wishes] [ServerCommand] A command has been received")
    if module ~= "Wishes" then return end
    if command ~= "GrantWish" then return end
    print("[Wishes] [ServerCommand] Command " .. command .. " has been received within module " .. module)
    if not args or not args.wishID then return end
    local playerID = player:getPlayerNum()
    local playerSession = WishingSession[playerID]
    print("[Wishes] [ServerCommand] Command received with: playerID = " .. tostring(playerID))
    if not playerSession then return end

    local wishID = args.wishID
    print("[Wishes] [ServerCommand] Command received with: wishID = ".. wishID)
    local wishToPerform = playerSession:getWish(wishID)

    -- if wish is not enabled for this session
    if not wishToPerform then return end
    print("[Wishes] [ServerCommand] Wish is indeed enabled for this session")
    
    if not canPerformWish(playerSession:getRemainingWishes(), wishID, wishToPerform) then return end
    print("[Wishes] [ServerCommand] Wish can be performed")

    local consumeWish = WishAction[wishID](player, args.optionID)
    if consumeWish then
        playerSession:removeNWishes(wishToPerform.cost)
        sendServerCommand(player, "Wishes", "ConsumeWish", { remainingWishes = playerSession:getRemainingWishes() })
        print("[Wishes] [ServerCommand] ConsumeWish command sent")
    end
    if not playerSession:hasRemainingWishes() then
        playerSession:close()
        sendServerCommand(player, "Wishes", "StopWishingMenu", nil)
        print("[Wishes] [ServerCommand] StopWishingMenu command sent")
    end
    print("[Wishes] [ServerCommand] Remaining wishes: "..playerSession:getRemainingWishes())
end

Events.OnClientCommand.Add(OnClientCommand)

local function OnPlayerDeath(character)
    if not instanceof(character, "IsoPlayer") then return end

    local playerID = character:getPlayerNum()
    local session = WishingSession[playerID]
    if session then
        session:close()
    end
end

Events.OnCharacterDeath.Add(OnPlayerDeath)

local function OnDisconnectedPlayer(player)
    local playerID = player:getPlayerNum()
    WishingSession[playerID]:close()
end