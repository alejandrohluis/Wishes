require 'Items/ProceduralDistributions'

local procList = ProceduralDistributions["list"]

local function tableContains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end

local function insertToDistribution(distributionID, item, chance)
    table.insert(procList[distributionID].items, item)
    table.insert(procList[distributionID].items, chance)
end

local function addDragonBallToDistributions(id_dragonBall)
    local special_spawn_chance = SandboxVars.WishesDragonBalls.Setting_ChanceToSpawnSpecial -- 1
    insertToDistribution("CrateToys"                , id_dragonBall, special_spawn_chance)
    insertToDistribution("ScienceMisc"              , id_dragonBall, special_spawn_chance)
    insertToDistribution("SurvivalGear"             , id_dragonBall, special_spawn_chance)
    insertToDistribution("CrateRandomJunk"          , id_dragonBall, special_spawn_chance * 2)
    insertToDistribution("CrateFitnessWeights"      , id_dragonBall, special_spawn_chance)
    insertToDistribution("Antiques"                 , id_dragonBall, special_spawn_chance * 4)
    insertToDistribution("ArtSupplies"              , id_dragonBall, special_spawn_chance * 4)
    insertToDistribution("CrateCamping"             , id_dragonBall, special_spawn_chance)
    insertToDistribution("CrateCostume"             , id_dragonBall, special_spawn_chance)
    insertToDistribution("CrateFishing"             , id_dragonBall, special_spawn_chance)
    insertToDistribution("GiftStoreFancy"           , id_dragonBall, special_spawn_chance * 2)
    insertToDistribution("Hobbies"                  , id_dragonBall, special_spawn_chance)
    insertToDistribution("JunkHoard"                , id_dragonBall, special_spawn_chance * 2)
    insertToDistribution("JewelerTools"             , id_dragonBall, special_spawn_chance)
    insertToDistribution("JewelryGems"              , id_dragonBall, special_spawn_chance)
    insertToDistribution("JewelryStorageAll"        , id_dragonBall, special_spawn_chance * 10)
    insertToDistribution("LostAndFoundItems"        , id_dragonBall, special_spawn_chance)
    insertToDistribution("PlankStashGold"           , id_dragonBall, special_spawn_chance)
    insertToDistribution("PlankStashMisc"           , id_dragonBall, special_spawn_chance)
    insertToDistribution("ToolStoreMisc"            , id_dragonBall, special_spawn_chance)
    insertToDistribution("LivingRoomShelfClassy"    , id_dragonBall, special_spawn_chance)
    insertToDistribution("OfficeDeskHomeClassy"     , id_dragonBall, special_spawn_chance)
    insertToDistribution("WardrobeClassy"           , id_dragonBall, special_spawn_chance)
    insertToDistribution("MayorWestPointDesk"       , id_dragonBall, special_spawn_chance * 10)
    insertToDistribution("MayorWestPointSafe"       , id_dragonBall, special_spawn_chance * 100)

    local general_spawn_chance = SandboxVars.WishesDragonBalls.Setting_ChanceToSpawnAnywhere -- 0.00001
    for distribution, _ in pairs(procList) do
        if not tableContains(procList[distribution].items, id_dragonBall) then
            insertToDistribution(distribution, id_dragonBall, general_spawn_chance)
        end
    end
end

local function addDragonBalls()
    addDragonBallToDistributions("DP.DragonBall_1")
    addDragonBallToDistributions("DP.DragonBall_2")
    addDragonBallToDistributions("DP.DragonBall_3")
    addDragonBallToDistributions("DP.DragonBall_4")
    addDragonBallToDistributions("DP.DragonBall_5")
    addDragonBallToDistributions("DP.DragonBall_6")
    addDragonBallToDistributions("DP.DragonBall_7")
end

Events.OnPreDistributionMerge.Add(addDragonBalls)
