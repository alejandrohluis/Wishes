WishActions = {}

WishActions.skillLevelUpOnce = function ()
    
end


local function grantWish()
end

local function OnClientCommand(module, wish, player, args)
    if module == "Wishes" and WishActions[wish] then
        WishActions[wish](player, args)
    end
end

Events.OnClientCommand.Add(OnClientCommand)