local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("tn-labs:sv:coke:removeandgiveitems",function(ings, rewards)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for ingredient, quantity in pairs(ings) do
        if not (Player.Functions.GetItemByName(ingredient) and Player.Functions.GetItemByName(ingredient).amount >= quantity) then 
            return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.missingingrediants'), 'error')
        end
        Player.Functions.RemoveItem(ingredient, quantity)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ingredient], "remove", quantity)
    end
    for ingredient, quantity in pairs(rewards) do
        Player.Functions.AddItem(ingredient, quantity)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ingredient], "add", quantity)
    end
end)

RegisterNetEvent("tn-labs:sv:coke:removeitems",function(ings)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local firstIteration = true
    for ingredient, quantity in pairs(ings) do
        if not firstIteration then
            if not (Player.Functions.GetItemByName(ingredient) and Player.Functions.GetItemByName(ingredient).amount >= quantity) then 
                return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.missingingrediants'), 'error')
            end
            Player.Functions.RemoveItem(ingredient, quantity)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[ingredient], "remove", quantity)
        end
        firstIteration = false
    end
end)

RegisterNetEvent("tn-labs:sv:coke:additem",function(item, amount, info)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, amount,false,info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], "add", amount)
end)

RegisterNetEvent('tn-labs:sv:coke:breakingcokefigure', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    Player.Functions.RemoveItem('coke_figure', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_figure'], "remove")
    Player.Functions.AddItem('coke_figurebroken', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_figurebroken'], "add")
    Player.Functions.AddItem('coke_pure', Config.coke.cokeparcokefigure)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_pure'], "add", Config.coke.cokeparcokefigure)
end)

RegisterNetEvent('tn-labs:sv:coke:repairfigurines', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    if Player.Functions.RemoveItem('coke_figurebroken', Config.coke.brokencokefigurecount) then
        Player.Functions.AddItem('coke_figure', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_figure'], "add")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_figurebroken'], "remove", Config.coke.brokencokefigurecount)
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.brokenfigureneeded', {count = Config.coke.brokencokefigurecount}), 'error')
    end
end)

RegisterNetEvent("tn-labs:sv:coke:addcokeleaf",function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    Player.Functions.RemoveItem(Config.coke.dryitem, amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.coke.dryitem], "remove", amount)
    MySQL.update('UPDATE lab SET ingrediants = ingrediants + ? WHERE labname = ?', { amount , "cokelab" })
end)

RegisterNetEvent("tn-labs:sv:coke:dryingStarted",function(quality)
    local time = os.time()
    local nextTime = tonumber(os.time() + Config.coke.cokeTime)
    MySQL.update('UPDATE lab SET rewardfirststage = ingrediants, ingrediants = 0 , quality = ?, time = ? WHERE labname = ?', { quality , nextTime, "cokelab" })
end)

RegisterNetEvent("tn-labs:sv:coke:tookdriedcoke",function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    local cokelab = MySQL.Sync.fetchAll("SELECT * FROM lab WHERE labname = 'cokelab'")
    if cokelab[1] then
        if cokelab[1].rewardfirststage == 0 then return TriggerClientEvent('QBCore:Notify', src, "empty", 'error') end
        local info = {
            quality = cokelab[1].quality
        }
        Player.Functions.AddItem(Config.coke.dryitem, cokelab[1].rewardfirststage,false,info)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.coke.dryitem], "add", cokelab[1].rewardfirststage)
    end
    MySQL.update('UPDATE lab SET rewardfirststage = 0, quality = 0 WHERE labname = ?', { "cokelab" })
end)

-- QBCore.Functions.CreateUseableItem('coke_figure', function(source)
--     TriggerClientEvent('tn-labs:cl:coke:usefigure', source)
-- end)

QBCore.Functions.CreateCallback('tn-labs:sv:checkDryIngrediants', function(source, cb)
    local status = MySQL.Sync.fetchScalar('SELECT ingrediants FROM lab WHERE labname = ?', { "cokelab"})
    cb(status)
end)

QBCore.Functions.CreateCallback('tn-labs:sv:checkTime', function(source, cb)
    local time = MySQL.Sync.fetchScalar('SELECT time FROM lab WHERE labname = ?', { "cokelab"})
    local currentTime = os.time()
    local timeToWait = tonumber(time) - currentTime
    cb(timeToWait)
end)

local function getFirstItemIndex(table)
    for index, _ in pairs(table) do
        return index
    end
    return nil -- Return nil if the table is empty
end

QBCore.Functions.CreateCallback('tn-labs:sv:checkstash', function(source, cb, stash, item, amount)
    local items = MySQL.Sync.fetchScalar('SELECT items FROM stashitems WHERE stash = ?', { stash })
    if items then
        local stashitems = json.decode(items)
        local firstItemIndex = getFirstItemIndex(stashitems)
        local firstitem = stashitems[firstItemIndex]
        local i = 0
        local toRemoveIndices = {}
        for k, v in pairs(stashitems) do 
            if v.name == firstitem.name and v.info.quality == firstitem.info.quality then
                i = i + 1
                table.insert(toRemoveIndices, k)
            end
            if i == amount then
                break
            end
        end
        if i == amount then
            for _, index in ipairs(toRemoveIndices) do
                stashitems[index] = nil -- Mark the item for removal
            end
            for k in pairs(stashitems) do
                if stashitems[k] == nil then
                    table.remove(stashitems, k) -- Remove marked items
                end
            end
            MySQL.update('UPDATE stashitems SET items = ? WHERE stash = ?', {json.encode(stashitems), stash})
            cb(true, firstitem.info.quality)
        else
            cb(false)
        end
    else
        cb(nil)
    end
end)