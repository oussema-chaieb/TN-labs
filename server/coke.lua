local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("tn-labs:sv:coke:removeandgiveitems",function(ings, rewards)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for ingredient, quantity in pairs(ings) do
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
    Player.Functions.AddItem('coke_pure', 4)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_pure'], "add", 4)
end)

RegisterNetEvent('tn-labs:sv:coke:repairfigurines', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src) 
    if Player.Functions.RemoveItem('coke_figurebroken', 4) then
        Player.Functions.AddItem('coke_figure', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_figure'], "add")
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['coke_figurebroken'], "remove", 4)
    else
        TriggerClientEvent('QBCore:Notify', src, 'You need 4 broken figure', 'error')
    end
end)

