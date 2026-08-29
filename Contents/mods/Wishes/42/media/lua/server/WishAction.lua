require "WishAttributes.lua"

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
    if WishAction[identifier] or not effect then return end
    WishAction[identifier] = effect
end

function WishAction:removeEffect(identifier)
    if not WishAction[identifier] then return end
    WishAction[identifier] = nil
end

local function canPerformWish(availableWishes, wishID, wish)
    return WishAction[wishID] ~= nil and availableWishes >= wish.cost
end

local function OnClientCommand(module, command, player, args)
    if module ~= "Wishes" then return end
    if command ~= "GrantWish" then return end
    if not args or not args.wishID then return end
    local playerID = player:getPlayerNum()
    local playerSession = WishingSession[playerID]
    if not playerSession then return end

    local wishID = args.wishID
    local wishToPerform = playerSession:getWish(wishID)

    -- if wish is not in the whitelist
    if not wishToPerform then return end

    if not canPerformWish(playerSession:getRemainingWishes(), wishID, wishToPerform) then return end

    local consumeWish = WishAction[wishID](player, args.optionID)
    if consumeWish then
        playerSession:removeNWishes(wishToPerform.cost)
        sendServerCommand(player, "Wishes", "ConsumeWish", { remainingWishes = playerSession:getRemainingWishes() })
    end
    if not playerSession:hasRemainingWishes() then
        playerSession:close()
        sendServerCommand(player, "Wishes", "CloseWindow")
    end
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