RegisterCommand('weapon', function(source, args)
    local weaponName = args[1] or 'WEAPON_PISTOL'
    if not IsWeaponValid(weaponName) then
        TriggerEvent('chat:addMessage', {
            color = { 255,0,0},
            args = { 'Sistem', 'Nume de arma ' .. weaponName .. ' invalid'}
        })
        return
    end

    TriggerEvent('chat:addMessage', {
        color = { 0,255,0},
        args = { 'Sistem', 'Ai primit arma: ' .. weaponName}
    })

    local playerPed = PlayerPedId()
    GiveWeaponToPed(playerPed, GetHashKey(weaponName), 20, false, true)

end, false)