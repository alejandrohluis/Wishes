require 'Items/ProceduralDistributions'

local procList = ProceduralDistributions["list"]

local function insertToDistribution(distributionID, item, chance)
    table.insert(procList[distributionID].items, item)
    table.insert(procList[distributionID].items, chance)
end

local function addGenieLamp()
    local id_genieLamp = "DP.GenieLamp"
    local general_spawn_chance = SandboxVars.WishesGenieLamp.ChanceToSpawn

    insertToDistribution("CrateToys"                , id_genieLamp , general_spawn_chance)
    insertToDistribution("ScienceMisc"              , id_genieLamp , general_spawn_chance)
    insertToDistribution("CrateRandomJunk"          , id_genieLamp , general_spawn_chance)
    insertToDistribution("Antiques"                 , id_genieLamp , general_spawn_chance)
    insertToDistribution("ArtSupplies"              , id_genieLamp , general_spawn_chance)
    insertToDistribution("GiftStoreFancy"           , id_genieLamp , general_spawn_chance)
    insertToDistribution("JunkHoard"                , id_genieLamp , general_spawn_chance)
    insertToDistribution("LostAndFoundItems"        , id_genieLamp , general_spawn_chance)
    insertToDistribution("PlankStashGold"           , id_genieLamp , general_spawn_chance)
    insertToDistribution("PlankStashMisc"           , id_genieLamp , general_spawn_chance)
    insertToDistribution("LivingRoomShelfClassy"    , id_genieLamp , general_spawn_chance)
    insertToDistribution("OfficeDeskHomeClassy"     , id_genieLamp , general_spawn_chance)
    insertToDistribution("WardrobeClassy"           , id_genieLamp , general_spawn_chance)
    insertToDistribution("MayorWestPointDesk"       , id_genieLamp , general_spawn_chance * 10)
    insertToDistribution("MayorWestPointSafe"       , id_genieLamp , general_spawn_chance * 100)
end


Events.OnPreDistributionMerge.Add(addGenieLamp)