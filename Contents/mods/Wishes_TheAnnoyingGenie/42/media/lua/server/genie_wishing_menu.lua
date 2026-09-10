require "WishAction"
require "ISWishStyle"
require "genie_wishAttributes"

local Recipe = RecipeCodeOnCreate;
local OnBreak = OnBreak;

function OnBreak.ReplaceGenieLamp(genieLamp, player)
    local inventory = player:getInventory()

    local goldenLamp = instanceItem("DP.GoldLamp")
    if not goldenLamp then return false end
    inventory:Remove(genieLamp)
    sendRemoveItemFromContainer(inventory, genieLamp)

    inventory:AddItem(goldenLamp)
    sendAddItemToContainer(inventory, goldenLamp)
end


function Recipe.GenieLamp(craftRecipeData, player)
    local lamp = craftRecipeData:getAllInputItems():get(0)

    local sandbox = SandboxVars.WishesGenieLamp
    local playerID = player:getOnlineID()
    local maxWishes = sandbox.MaxWishes

    local session = DPWishes.Session:new(playerID, maxWishes)
    session:addWish("GenieLamp_modifyTrait"         , sandbox.WishCost_ModifyTrait       , sandbox.WishEnable_ModifyTrait)
    session:addWish("GenieLamp_skillLevelUpUntil"   , sandbox.WishCost_SkillLevelUpUntil , sandbox.WishEnable_SkillLevelUpUntil)
    session:addWish("GenieLamp_skillLevelUpOnce"    , sandbox.WishCost_SkillLevelUp      , sandbox.WishEnable_SkillLevelUp)
    session:addWish("GenieLamp_idealWeight"         , sandbox.WishCost_Weight            , sandbox.WishEnable_Weight)
    session:addWish("GenieLamp_heal"                , sandbox.WishCost_HealInjury        , sandbox.WishEnable_HealInjury)
    session:addWish("GenieLamp_cureSickness"        , sandbox.WishCost_HealSickness      , sandbox.WishEnable_HealSickness)
    session:addWish("GenieLamp_obtainItem"          , sandbox.WishCost_Wealth            , sandbox.WishEnable_Wealth)
    session:addWish("GenieLamp_infiniteWishes"      , sandbox.WishCost_InfiniteWishes    , sandbox.WishEnable_InfiniteWishes)
    session:addWish("GenieLamp_slayZeds"            , sandbox.WishCost_KillNearbyZombies , sandbox.WishEnable_KillNearbyZombies)

    local genieData = {
        styleName = "UI_GenieStyle",
        wishAmount = maxWishes,
        texturePath = "media/textures/portrait/normal_genie.png",
        enabledWishes = session:getWishIDs(),
    }
    DPWishes.Action:startWishingMenu(player, genieData)
    local lampCondition = lamp:getCondition()
    local lampMaxCondition = lamp:getConditionMax()
    lamp:setCondition(math.max(0, lampCondition - (lampMaxCondition / sandbox.LampUses)))
end

local function create_winning_ticket(ticket)
    local modData = ticket:getModData()
    if modData["genie_winner"] then return end

    local randomizer = ZombRand(1,3+1)
    local winningValue = 0
    if randomizer == 1 then
        winningValue = 1000
    elseif randomizer == 2 then
        winningValue = 5000
    elseif randomizer == 3 then
        winningValue = 10000
    end
    modData["genie_winner"] = "$"..tostring(winningValue)
    ticket:setName(getText("IGUI_ScratchingTicketNameWinner", getItemNameFromFullType("Base.ScratchTicket_Winner"), modData["genie_winner"]));
end

local function genie_lamp_addActions()
    local effects = DPWishes.Effects
    local actions = DPWishes.Action
    actions:addEffect("GenieLamp_modifyTrait", effects.modifyTrait)
    actions:addEffect("GenieLamp_skillLevelUpUntil", effects.skillLevelUpUntil)
    actions:addEffect("GenieLamp_skillLevelUpOnce", effects.skillLevelUpOnce)
    actions:addEffect("GenieLamp_idealWeight", effects.setIdealWeight)
    actions:addEffect("GenieLamp_heal", effects.healUp)
    actions:addEffect("GenieLamp_cureSickness", effects.cureSickness)
    actions:addEffect("GenieLamp_obtainItem", effects.obtainItem)
    actions:addEffect("GenieLamp_infiniteWishesGenie", effects.infiniteWishes)
    actions:addEffect("GenieLamp_slayZombiesGenie", effects.slayZeds)

    local itemWhitelist = DPWishes.FilteringLists.Whitelists.ObtainItem
    itemWhitelist["GL_Wealth_LotteryTicket"] = { minQuantity = 1 , maxQuantity = 1 , itemID = "Base.ScratchTicket_Winner" , itemDataModifier = create_winning_ticket}
    itemWhitelist["GL_Wealth_Money"] = { minQuantity = 5 , maxQuantity = 20 , itemID = "Base.MoneyBundle" }
    itemWhitelist["GL_Wealth_GoldBar"] = { minQuantity = 1 , maxQuantity = 3 , itemID = "Base.GoldBar" }
end

genie_lamp_addActions()