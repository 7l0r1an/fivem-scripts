local noClipEnabled = false

local function GetCamDirection()
    local rot = GetGameplayCamRot(0)
    local rotInRad = vector3(math.rad(rot.x), math.rad(rot.y), math.rad(rot.z))
    local forward = vector3(
        -math.sin(rotInRad.z) * math.cos(rotInRad.x),
        math.cos(rotInRad.z) * math.cos(rotInRad.x),
        math.sin(rotInRad.x)
    )
    return forward
end

RegisterCommand('nc', function()
    if noClipEnabled then
        noClipEnabled = false
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = { 'Sistem', 'Ai iesit din noclip' }
        })
        local playerPed = PlayerPedId()
        SetEntityInvincible(playerPed, false)
        FreezeEntityPosition(playerPed, false)
        SetEntityCollision(playerPed, true, true)
    else
        noClipEnabled = true
        TriggerEvent('chat:addMessage', {
            color = { 255, 0, 0 },
            args = { 'Sistem', 'Ai intrat in noclip' }
        })
    end
end, false)


CreateThread(function()
    while true do
        local sleep = 500
        if noClipEnabled then
            sleep           = 0
            local playerPed = PlayerPedId()
            SetEntityInvincible(playerPed, true)
            SetEntityCollision(playerPed, false, false)
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetCamDirection()
            local right     = vector3(-forward.y, forward.x, 0.0)
            local speed     = 1.0
            local newCoords = coords

            if IsControlPressed(0, 32) then
                newCoords = newCoords + forward * speed
            end
            if IsControlPressed(0, 33) then
                newCoords = newCoords - forward * speed
            end
            if IsControlPressed(0, 34) then
                newCoords = newCoords + right * speed
            end
            if IsControlPressed(0, 35) then
                newCoords = newCoords - right * speed
            end
            if IsControlPressed(0, 22) then
                newCoords = newCoords + vector3(0.0, 0.0, speed)
            end
            if IsControlPressed(0, 36) then
                newCoords = newCoords - vector3(0.0, 0.0, speed)
            end
            SetEntityCoordsNoOffset(playerPed, newCoords.x, newCoords.y, newCoords.z, true, true, true)
        end
        Wait(sleep)
    end
end)
