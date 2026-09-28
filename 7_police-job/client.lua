local textUIShown = false
local callBlip = nil
local QBCore = exports['qb-core']:GetCoreObject() 
local function spawnPoliceVehicle(car)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local model = GetHashKey(car)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    local masina = CreateVehicle(model, playerCoords.x, playerCoords.y, playerCoords.z, GetEntityHeading(playerPed), true, false)
    SetModelAsNoLongerNeeded(model)
    local plate = GetVehicleNumberPlateText(masina)
    TriggerEvent('vehiclekeys:client:SetOwner', plate)
    SetVehicleDoorsLocked(masina, 1)
    SetPedIntoVehicle(playerPed, masina, -1)
end
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

RegisterNetEvent('7_police-job:setBlip', function(coords)
    if callBlip then
        RemoveBlip(callBlip)
    end
    callBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(callBlip, 42)
    SetBlipColour(callBlip, 3)
    SetBlipScale(callBlip, 0.5)
    SetBlipRoute(callBlip, true)
    SetBlipRouteColour(callBlip, 1)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Apel Politie')
    EndTextCommandSetBlipName(callBlip)
end)


RegisterCommand('rezolvat', function()
    TriggerServerEvent('7_police-job:resolveCall')
end, false)

RegisterNetEvent('7_police-job:deleteBlip', function()
    RemoveBlip(callBlip)
    callBlip = nil
end)


lib.registerContext({
    id = 'police_garage',
    title = 'Garaj Politie',
    options = { {
        title = 'Police #1',
        icon = 'car',
        metadata = { { label = 'Viteza', value = 'Mediu' },
            { label = 'Locuri', value = '4' } },
        onSelect = function()
            spawnPoliceVehicle('police')
        end
    },
        {
            title = 'Police Van',
            icon = 'car',
            metadata = { { label = 'Viteza', value = 'Mica' },
                { label = 'Locuri', value = '4' } },
            onSelect = function()
                spawnPoliceVehicle('policet')
            end
        }
    }
})
local garageTextShown = false
CreateThread(function()
    for i = 1, #Config.GarageLocations do
        local loc = Config.GarageLocations[i]
        local model = `prop_sign_parking_1`
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(10)
        end
        local sign = CreateObject(model, loc.x, loc.y, loc.z - 1.0, false, false, false)
        SetEntityHeading(sign, 0.0)
        FreezeEntityPosition(sign, true)
        SetModelAsNoLongerNeeded(model)
    end
end)

local currentGarageText = nil
CreateThread(function()
    while true do
        local garageText = ''
        local playerJob = QBCore.Functions.GetPlayerData().job.name
        local nearGarage = false
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        for i = 1, #Config.GarageLocations do
            local loc = Config.GarageLocations[i]
            local dist = #(playerCoords - loc)
            if dist <= Config.GarageInteractDist and playerJob == Config.JobName and not IsPedInAnyVehicle(playerPed, false) then
                nearGarage = true
                garageText = '[E] Deschide garajul'
                sleep = 0
                if IsControlJustReleased(0, 38) then
                    lib.showContext('police_garage')
                end
            elseif dist <= Config.GarageInteractDist and playerJob == Config.JobName and IsPedInAnyVehicle(playerPed, false) then
                nearGarage = true
                sleep = 0
                garageText = '[E] Parcheaza masina'
                local masina = GetVehiclePedIsIn(playerPed, false)
                if IsControlJustReleased(0, 38) then
                    DeleteVehicle(masina)
                end
            end
        end
        if nearGarage then
            if currentGarageText ~= garageText then
                lib.showTextUI(garageText, {position = 'right-center', icon = 'warehouse', style = {borderRadius = 8, backgroundColor = '#1a1d29', color = 'white'}})
                currentGarageText = garageText
            end
        else
            if currentGarageText ~= nil then
                lib.hideTextUI()
                currentGarageText = nil
            end
        end
        Wait(sleep)
    end
end)
