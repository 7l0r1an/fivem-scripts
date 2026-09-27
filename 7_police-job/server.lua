local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('7_police-job:toggleDuty', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if Player.PlayerData.job.name ~= Config.JobName then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Eroare',
            description = 'Nu faci parte din factiune pentru a putea face aceasta actiune',
            type = 'error',
            position = 'top'
        })
        return
    end
    local newDuty = not Player.PlayerData.job.onduty
    Player.Functions.SetJobDuty(newDuty)
    if newDuty then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Politie',
            description = 'Acum esti on duty',
            type = 'success',
            position = 'top'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Politie',
            description = 'Acum esti off duty',
            type = 'error',
            position = 'top'
        })
    end
end)

local calls = {}
local callIdCounter = 0

RegisterNetEvent('7_police-job:createCall', function(message, coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    callIdCounter = callIdCounter + 1
    local newCall = {
        id = callIdCounter,
        sender = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
        coords = coords,
        message = message,
        status = 'nou',
        claimedBy = nil
    }
    calls[newCall.id] = newCall
    local players = QBCore.Functions.GetQBPlayers()
    for _, targetPlayer in pairs(players) do
        if targetPlayer.PlayerData.job.name == Config.JobName and targetPlayer.PlayerData.job.onduty then
            TriggerClientEvent('ox_lib:notify', targetPlayer.PlayerData.source, {
                title = 'Apel Nou',
                description = message,
                type = 'inform',
                position = 'center-right'
            })
        end
    end
end)

lib.callback.register('7_police-job:getCalls', function(source)
    local available = {}
    for id, call in pairs(calls) do
        if call.status == 'nou' then
            available[#available + 1] = call
        end
    end
    return available
end)

RegisterNetEvent('7_police-job:acceptCall', function(callId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local call = calls[callId]

    if not call or call.status ~= 'nou' then
        TriggerClientEvent('ox_lib:notify', src, {
                title = 'Eroare',
                description = 'Apel indisponibil',
                type = 'error',
                position = 'center-right'
            })
            return
    end
    for id, c in pairs(calls) do
        if c.claimedBy == src and c.status == 'activ' then
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Eroare',
                description = 'Ai deja un apel activ',
                type = 'error',
                position = 'center-right'
            })
            return
        end
    end
    call.status = 'activ'
    call.claimedBy = src
    TriggerClientEvent('7_police-job:setBlip', src, call.coords)
    TriggerClientEvent('ox_lib:notify', src, {
                title = 'Apel Preluat',
                description = 'Ai preluat apelul lui ' .. call.sender,
                type = 'success',
                position = 'center-right'
            })

end)
