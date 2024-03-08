local QBCore = exports['qb-core']:GetCoreObject()

local metharraytoken = 0

RegisterNetEvent("tn-labs:sv:meth:removeMixageIngrediants",function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for ingredient, quantity in pairs(Config.meth.mixageIngredients) do
        Player.Functions.RemoveItem(ingredient, quantity)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ingredient], "remove", quantity)
    end
    MySQL.update('UPDATE lab SET ingrediants = ingrediants + 1 WHERE labname = ?', { "methlab" })
end)

RegisterNetEvent("tn-labs:sv:meth:processStarted",function(quality)
    local time = os.time()
    local nextTime = tonumber(os.time() + Config.meth.cokeTime)
    MySQL.update('UPDATE lab SET time = ?, quality = ?, ingrediants = ingrediants - 1 WHERE labname = ?', { nextTime, quality, "methlab" })
end)

RegisterNetEvent("tn-labs:sv:meth:passToMethArray",function(amount)
    MySQL.update('UPDATE lab SET qualitytwo = quality, quality = ?, rewardfirststage = ? WHERE labname = ?', { 0, amount, "methlab" })
end)

RegisterNetEvent("tn-labs:sv:meth:tookMethArray",function()
    metharraytoken = metharraytoken + 1
    MySQL.update('UPDATE lab SET rewardfirststage = rewardfirststage - 1 WHERE labname = ?', { "methlab" })
end)

RegisterNetEvent("tn-labs:sv:meth:addMethArray",function()
    metharraytoken = metharraytoken - 1
    MySQL.update('UPDATE lab SET rewardsecondstage = rewardsecondstage + 1 WHERE labname = ?', { "methlab" })
end)

RegisterNetEvent("tn-labs:sv:meth:toAddMethArray",function()
    if metharraytoken > 0 then
        TriggerClientEvent('tn-labs:cl:meth:toAddMethArray', source)
    else
        TriggerClientEvent('QBCore:Notify', source, Lang:t('error.tookmetharrayfirst'), 'error')
    end
end)

RegisterNetEvent("tn-labs:sv:meth:passMethArrayToStageTwo",function()
    local number = math.random(1,7)
    MySQL.update('UPDATE lab SET rewardsecondstage = rewardsecondstage - 1, rewardthirdstage = rewardthirdstage + ? WHERE labname = ?', { number,"methlab" })
end)

RegisterNetEvent("tn-labs:sv:meth:package",function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    MySQL.update('UPDATE lab SET rewardthirdstage = rewardthirdstage - 1 WHERE labname = ?', { "methlab" })
    local quality = MySQL.Sync.fetchScalar('SELECT qualitytwo FROM lab WHERE labname = ?', { "methlab"})
    local info = {
        quality = quality
    }
    local amount = math.random(4,6)
    Player.Functions.AddItem('methamine', amount, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['methamine'], "add", amount)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:getRemainingTime', function(source, cb)
    local time = MySQL.Sync.fetchScalar('SELECT time FROM lab WHERE labname = ?', { "methlab"})
    local currentTime = os.time()  -- Use os.time() to get the current Unix timestamp
    local timeToWait = tonumber(time) - currentTime
    cb(timeToWait)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:checkLabIngrediants', function(source, cb)
    local status = MySQL.Sync.fetchScalar('SELECT ingrediants FROM lab WHERE labname = ?', { "methlab"})
    cb(status)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:checkLabQuality', function(source, cb)
    local quality = MySQL.Sync.fetchScalar('SELECT quality FROM lab WHERE labname = ?', { "methlab"})
    cb(quality)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:CheckArraysCount', function(source, cb)
    local amount = MySQL.Sync.fetchScalar('SELECT rewardfirststage FROM lab WHERE labname = ?', { "methlab"})
    cb(amount)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:CheckArraysCountTwo', function(source, cb)
    local amount = MySQL.Sync.fetchScalar('SELECT rewardsecondstage FROM lab WHERE labname = ?', { "methlab"})
    cb(amount)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:CheckArraysCountThree', function(source, cb)
    local amount = MySQL.Sync.fetchScalar('SELECT rewardthirdstage FROM lab WHERE labname = ?', { "methlab"})
    cb(amount)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:CheckCanPassMethArray', function(source, cb)
    local query = "SELECT rewardfirststage, rewardsecondstage, rewardthirdstage FROM lab WHERE labname = ?"
    local values = {"methlab"}
    MySQL.Async.fetchAll(query, values, function(result)
        if result[1] then
            local rewardfirststage = tonumber(result[1].rewardfirststage) or 0
            local rewardsecondstage = tonumber(result[1].rewardsecondstage) or 0
            local rewardthirdstage = tonumber(result[1].rewardthirdstage) or 0

            if rewardfirststage == 0 and rewardsecondstage == 0 and rewardthirdstage == 0 then
                cb(true)
            else
                cb(false)
            end
        else
            cb(false)
        end
    end)
end)

