RegisterCommand('car', function(source, args)
    local vehicleName = args[1] or 'adder' 
    if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = { 'Error', 'Invalid vehicle model: ' .. vehicleName }
        })
        return
    end

    TriggerEvent('chat:addMessage', {
        color = { 0, 255, 0 },
        args = { 'Info', 'Spawning vehicle: ' .. vehicleName }
    })

    RequestModel(vehicleName)
    while not HasModelLoaded(vehicleName) do
        Wait(10)
    end


    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local vehicle = CreateVehicle(vehicleName, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetVehicleAsNoLongerNeeded(vehicle)
end, false)