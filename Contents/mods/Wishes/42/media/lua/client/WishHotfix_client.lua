DPWishes = DPWishes or {}

DPWishes.Fixes = DPWishes.Fixes or {}

local function clientFixXp(args)
    local player = getPlayer()
    local xp = player:getXp()
    for _, fix in ipairs(args.errors) do
        local perk = Perks.FromString(fix.perk)
        if perk then xp:setXPToLevel(perk, fix.level) end
    end
    SyncXp(player)
end

function DPWishes.Fixes.clientFixXp(args)
    clientFixXp(args)
end
local pendingTicks = nil

local function sendWhenReady()
    pendingTicks = pendingTicks - 1
    if pendingTicks > 0 then return end
    Events.OnTick.Remove(sendWhenReady)
    local player = getPlayer()
    if player then
        sendClientCommand(player, "DP_Wishes", "PlayerReady", {})
    end
end

local function askFixXp(_playerId, player)
    if isClient() then
        pendingTicks = 120
        Events.OnTick.Add(sendWhenReady)
    elseif not isServer() then
        local errors = DPWishes.Fixes.getPerkXpErrors(player)
        if #errors > 0 then
            clientFixXp({ errors = errors })
        end
    end
end

Events.OnCreatePlayer.Add(askFixXp)

local function OnServerCommand(module, command, args)
    if module ~= "DP_Wishes" then return end
    if command ~= "FixXp" then return end
    clientFixXp(args)
end

Events.OnServerCommand.Add(OnServerCommand)