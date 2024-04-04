local QBCore = exports['qb-core']:GetCoreObject()

if not Config.UseTNAddiction then
    QBCore.Functions.CreateUseableItem("coke_pure", function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local citizenid = Player.PlayerData.citizenid
        if Player.Functions.RemoveItem(item.name, 1) then
            TriggerClientEvent("tn-labs:cl:coke", src, item.info.quality)      
        end
    end)
    
    QBCore.Functions.CreateUseableItem("methamine", function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        local citizenid = Player.PlayerData.citizenid
        Player.Functions.RemoveItem(item.name, 1)     
        TriggerClientEvent("tn-labs:cl:methamine", src, item.info.quality)
    end)

    RegisterNetEvent('tn-labs:sv:removesyringandmeth', function()
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.RemoveItem("empty_syringe", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['empty_syringe'], "remove")
    end)
end