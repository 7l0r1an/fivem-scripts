local pointA = vector3(-1182.6364, -884.1368, 13.7614)
local pointB = vector3(-1028.4941, -1017.6486, 2.1504)
local state = 'idle'
local interactDist = 2.0
local deliveryBlip = nil

CreateThread(function()
    local jobBlip = AddBlipForCoord(pointA.x, pointA.y, pointA.z)
    SetBlipSprite(jobBlip, 889)
    SetBlipColour(jobBlip, 2)
    SetBlipScale(jobBlip, 0.9)
    SetBlipAsShortRange(jobBlip, false)
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
                            type = 'success'
                        })
                        deliveryBlip = AddBlipForCoord(pointB.x, pointB.y, pointB.z)
                        SetBlipSprite(deliveryBlip, 1)
                        SetBlipColour(deliveryBlip, 5)
                        SetBlipRoute(deliveryBlip, true)
                        SetBlipRouteColour(deliveryBlip, 5)
                        state = 'delivering'
                        showSubtitle('Du mancarea la ~y~adresa~s~.', 10000)
                    end
                end
            end
        elseif state == 'delivering' then
            local dist = #(playerCoords - pointB)
            if dist <= 10.0 then
                sleep = 0
                DrawMarker(1, pointB.x, pointB.y, pointB.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.3, 255, 255,
                    0, 120, false, true, 2, nil, nil, false)

                if dist <= interactDist then
                    DrawText3D(pointB, 'Apasa E ca sa lasi mancarea')
                    if IsControlJustReleased(0, 38) then
                        if lib.progressCircle({
                                duration = 5000,
                                label = 'Se livreaza...',
                                position = 'bottom',
                                canCancel = true,
                                disable = { move = true, combat = true },
                                anim = { dict = 'mp_common', clip = 'givetake1_a' }
                            }) then
                            state = 'idle'
                            TriggerServerEvent('delivery:complete')
                            if deliveryBlip then
                                RemoveBlip(deliveryBlip)
                                deliveryBlip = nil
                            end
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)
