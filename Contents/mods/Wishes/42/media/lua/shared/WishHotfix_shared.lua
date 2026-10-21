DPWishes = DPWishes or {}

DPWishes.Fixes = DPWishes.Fixes or {}

function DPWishes.Fixes.getPerkXpErrors(player)
    local badPerks = {}
    local xp = player:getXp()
    for i = 0, Perks.getMaxIndex() - 1 do
        local perk = Perks.fromIndex(i)
        local level = player:getPerkLevel(perk)
        if xp:getXP(perk) < perk:getTotalXpForLevel(level) then
            badPerks[#badPerks + 1] = { perk = tostring(perk), level = level }
        end
    end
    return badPerks
end