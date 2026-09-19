require 'Items/ProceduralDistributions'
require 'Items/SuburbsDistributions'

local procList = ProceduralDistributions["list"]
local roomList = SuburbsDistributions

local function insertToDistribution(distributionID, item, chance)
    if not (procList[distributionID] and procList[distributionID].items) then return end
    table.insert(procList[distributionID].items, item)
    table.insert(procList[distributionID].items, chance)
end

local function copyTableElems(table)
    local new_table = {}
    for i = 1, #table do
        if table[i] then
            new_table[i] = table[i]
        end
    end
    return new_table
end

local function addGenieLampToStorageUnits(id_genieLamp, spawn_chance)
    local genieTableID = "DP_GenieLamp_Antiques"
    local antiques = procList["Antiques"]
    procList[genieTableID] = {
        rolls = antiques.rolls,
        items = copyTableElems(antiques.items),
        junk = {
            rolls = antiques.junk.rolls,
            items = copyTableElems(antiques.junk.items)
        }
    }

    insertToDistribution(genieTableID, id_genieLamp, spawn_chance * 40)

    local room = roomList["storageunit"]
    if not room then return end

    if room.toolcabinet and room.toolcabinet.procList then
        table.insert(room.toolcabinet.procList, { name = genieTableID, min = 0, max = 1, weightChance = 10 })
    end

    if room.other and room.other.procList then
        table.insert(room.other.procList, { name = genieTableID, min = 0, max = 1, weightChance = 40 })
    end
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

    addGenieLampToStorageUnits(id_genieLamp, general_spawn_chance)
end


Events.OnPreDistributionMerge.Add(addGenieLamp)