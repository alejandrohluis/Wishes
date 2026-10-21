require "WishAction"

local function onClientCommand(module, command, player, args)
    if module ~= "DP_Wishes" then return end
    if command ~= "PlayerReady" then return end
    local errors = DPWishes.Fixes.getPerkXpErrors(player)
    if #errors > 0 then
        DPWishes.Action:fixXp(player, { errors = errors })
    end
end

function DPWishes.Action:fixXp(player, errors)
    local isMultiplayer = isClient() or isServer()
    if isMultiplayer then
        sendServerCommand(player, "DP_Wishes", "FixXp", errors )
    else
        DPWishes.Action:handleCommand("FixXp", player, errors )
    end
end

Events.OnClientCommand.Add(onClientCommand)