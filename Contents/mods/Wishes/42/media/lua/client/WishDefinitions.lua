----------------------------------------------------------------------------------
--- WishDefinitions
----------------------------------------------------------------------------------
--- This is a client-side table which has the information on the wish label and the categories
--- It's crucial to add your own wishes as without this info your wishes will not be displayed in the panel
--- For examples, check out any of the base addons for files named X_WishDefinitions.lua 

DPWishes = DPWishes or {}

DPWishes.Definitions = {}

local wishDefinitions = DPWishes.Definitions

-- WishDefinitions:addWishDefinition/3  
-- wishID = the ID the wish should be identified by 
--          (ideally use a ID style as follows: myMod_myWishingStyle_myWishID, for example: Wishes_GenieLamp_modifyTrait )  
-- label = the text displayed at the panel for this wish
-- categoriesGetter = a reference to a function for all selectable options for the wish
function wishDefinitions:addWishDefinition(wishID, label, categoriesGetter)
    wishDefinitions[wishID] = {}
    wishDefinitions[wishID].label = label
    if not categoriesGetter then return end
    wishDefinitions[wishID].categories = categoriesGetter
end