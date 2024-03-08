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

QBCore.Functions.CreateUseableItem('coke_figure', function(source)
    TriggerClientEvent('tn-labs:cl:coke:usefigure', source)
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

