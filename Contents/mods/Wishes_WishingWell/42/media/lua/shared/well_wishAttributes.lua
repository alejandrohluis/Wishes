require "WishAttributes"

DPWishes.FilteringLists.Whitelists.AllowedItemsToThrowAtWell = {}

local function AllowedItemsToThrowAtWell_initWhitelist()
    DPWishes.FilteringLists.Whitelists.AllowedItemsToThrowAtWell = { "GoldCoin", "SilverCoin" }
end

------------------------------

local function initializeWishWhitelists()
    AllowedItemsToThrowAtWell_initWhitelist()
end

initializeWishWhitelists()
Events.OnGameStart.Add(initializeWishWhitelists)