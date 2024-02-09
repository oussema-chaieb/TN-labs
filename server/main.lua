local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("tn-labs:sv:getData", function(source, cb, labname)  
    local code = MySQL.Sync.fetchScalar('SELECT code FROM lab WHERE labname = ?', {labname})
    cb(code)
end)

RegisterNetEvent("tn-labs:sv:changePasscode",function(code, labname)
    MySQL.update('UPDATE lab SET code = ? WHERE labname = ?',{code, labname})
end)

