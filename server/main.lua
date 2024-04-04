local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("tn-labs:sv:getData", function(source, cb, labname)  
    local code = MySQL.Sync.fetchScalar('SELECT code FROM lab WHERE labname = ?', {labname})
    cb(code)
end)

RegisterNetEvent("tn-labs:sv:changePasscode",function(code, labname)
    MySQL.update('UPDATE lab SET code = ? WHERE labname = ?',{code, labname})
end)

RegisterServerEvent('tn-labs:pickedUpCocaLeaf', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.AddItem("coke_leaf", 1) then 
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["coke_leaf"], "add")
		TriggerClientEvent('QBCore:Notify', src, "success", "success")
	else
		TriggerClientEvent('QBCore:Notify', src, "success", "error")
	end
end)

RegisterServerEvent('tn-labs:pickedUpHydrochloricAcid', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.AddItem("sodium_hydroxide", 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sodium_hydroxide"], "add")
	end
end)

RegisterServerEvent('tn-labs:pickedUpSulfuricAcid', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.AddItem("sulfuric_acid", 1) then
		TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["sulfuric_acid"], "add")
	end
end)

QBCore.Functions.CreateUseableItem("sodium_mask", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("tn-lab:client:putmaskhydro", src)
	end
end)

QBCore.Functions.CreateUseableItem("sulfuric_mask", function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.GetItemByName(item.name) ~= nil then
		TriggerClientEvent("tn-lab:client:putmasksulfuric", src)
	end
end)