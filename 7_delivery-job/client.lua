local pointA = vector3(-1182.6364, -884.1368, 13.7614)
local deliveryPoints = {
    vector3(-1028.4941, -1017.6486, 2.1504),
    vector3(-1103.9067, -1059.8418, 2.7378),
    vector3(-1150.2551, -1116.5908, 2.3061),
    vector3(-1256.2938, -1330.8345, 4.0810),
    vector3(-886.2469, -1233.4291, 5.6559),
    vector3(-834.3220, -1107.6572, 9.0664),
    vector3(-598.3066, -928.1990, 23.8690),
    vector3(-820.3427, -902.0683, 18.8860)
}

local state = 'idle'
local interactDist = 2.0
local deliveryBlip = nil
local totalDeliveries = 6
local currentDelivery = 0
local currentTarget = nil

local function getRandomPoint()
    return deliveryPoints[math.random(#deliveryPoints)]
end

local function showDeliveryBlip(coords)
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end
    deliveryBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(deliveryBlip, 1)
    SetBlipColour(deliveryBlip, 5)
    SetBlipRoute(deliveryBlip, true)
    SetBlipRouteColour(deliveryBlip, 5)
end

CreateThread(function()
    local jobBlip = AddBlipForCoord(pointA.x, pointA.y, pointA.z)
    SetBlipSprite(jobBlip, 889)
    SetBlipColour(jobBlip, 2)
    SetBlipScale(jobBlip, 0.9)
    SetBlipAsShortRange(jobBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Livrari Mancare')
    EndTextCommandSetBlipName(jobBlip)
end)

local function DrawText3D(coords, text)
    SetTextScale(0.5, 0.5)
    SetTextFont(2)
    SetTextColour(255, 0, 0, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z + 0.6, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

local function showSubtitle(message, duration)
    BeginTextCommandPrint('STRING')
    AddTextComponentString(message)
    EndTextCommandPrint(duration, true)
end

CreateThread(function()
    while true do
        local sleep = 1000
        local playerCoords = GetEntityCoords(PlayerPedId())

        if state == 'idle' then
            local dist = #(playerCoords - pointA)
            if dist < 10.0 then
                sleep = 0
                DrawMarker(1, pointA.x, pointA.y, pointA.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 255,
                    0, 120, false, true, 2, nil, nil, false)

                if dist <= interactDist then
                    DrawText3D(pointA, 'Apasa E ca sa livrezi')
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent('ox_lib:notify', {
                            title = 'Job Livrare',
                            description = 'Ai inceput livrarea cu succes',
                            type = 'success',
                            position = 'top'
                        })
                        currentTarget = getRandomPoint()
                        showDeliveryBlip(currentTarget)
                        state = 'delivering'
                        showSubtitle('Du mancarea la ~y~adresa~s~.', 10000)
                        currentDelivery = 1
                    end
                end
            end
        elseif state == 'delivering' then
            local dist = #(playerCoords - currentTarget)
            if dist <= 10.0 then
                sleep = 0
                DrawMarker(1, currentTarget.x, currentTarget.y, currentTarget.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 255,
                    0, 120, false, true, 2, nil, nil, false)

                if dist <= interactDist then
                    DrawText3D(currentTarget, 'Apasa E ca sa lasi mancarea')
                    if IsControlJustReleased(0, 38) then
                        if lib.progressCircle({
                                duration = 5000,
                                label = 'Se livreaza...',
                                position = 'bottom',
                                canCancel = true,
                                disable = { move = true, combat = true },
                                anim = { dict = 'mp_common', clip = 'givetake1_a' }
                            }) then
                            if currentDelivery == totalDeliveries then
                                state = 'idle'
                                TriggerServerEvent('delivery:complete', true)
                                if deliveryBlip then
                                    RemoveBlip(deliveryBlip)
                                    deliveryBlip = nil
                                end
                            else
                                TriggerServerEvent('delivery:complete', false)
                                currentTarget = getRandomPoint()
                                currentDelivery = currentDelivery + 1
                                showDeliveryBlip(currentTarget)
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)