local textUIShown = false
CreateThread(function()
    while true do
        local nearStation = false
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for i = 1, #Config.DutyLocations do
            local loc = Config.DutyLocations[i]
            local dist = #(playerCoords - loc)
            if dist < 10.0 then
                sleep = 0
                DrawMarker(1, loc.x, loc.y, loc.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 0, 255, 150,
                    false,
                    false, 2, false, nil, nil)
                if dist <= Config.InteractDist then
                    nearStation = true
                    if IsControlJustReleased(0, 38) then
                        TriggerServerEvent('7_police-job:toggleDuty')
                    end
                end
            end
        end
        if nearStation and not textUIShown then
            lib.showTextUI('[E] ca sa intri duty', { position = 'right-center' })
            textUIShown = true
        elseif not nearStation and textUIShown then
            lib.hideTextUI()
            textUIShown = false
        end

        Wait(sleep)
    end
end)


RegisterCommand('politia', function(source, args)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local message = table.concat(args, ' ')
    TriggerServerEvent('7_police-job:createCall', message, coords)
end, false)

RegisterCommand('apel', function()
    local availableCalls = lib.callback.await('7_police-job:getCalls', false)
    local options = {}
    for i = 1, #availableCalls do
        local call = availableCalls[i]
        options[#options + 1] = {
            title = 'Apel #' .. call.id .. ': ' .. call.sender,
            description = call.message,
            onSelect = function()
                TriggerServerEvent('7_police-job:acceptCall', call.id)
            end
        }
    end
    lib.registerContext({
        id = 'police_calls',
        title = 'Apeluri Active',
        options = options
    })
    lib.showContext('police_calls')
end, false)
local callBlip = nil
RegisterNetEvent('7_police-job:setBlip', function(coords)
    if callBlip then
        RemoveBlip(callBlip)
    end
    callBlip = AddBlipForCoord(coords.x,coords.y,coords.z)
    SetBlipSprite(callBlip, 42)
    SetBlipColour(callBlip, 3)
    SetBlipScale(callBlip, 0.5)
    SetBlipRoute(callBlip, true)
    SetBlipRouteColour(callBlip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Apel Politie')
    EndTextCommandSetBlipName(callBlip)

end)
