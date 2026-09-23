
local QBCore = exports['qb-core']:GetCoreObject()

local armorTypes = {
    mica  = { price = 250, amount = 50,  stock = 5 },
    medie = { price = 500, amount = 75,  stock = 3 },
    mare  = { price = 750, amount = 100, stock = 1 }
}



RegisterCommand('addarmorstock', function(source, args)
    local tip = args[1]
    local cantitate = tonumber(args[2])
    if not tip or not cantitate then
        return
    end
    local selected = armorTypes[tip]
    if not selected then
        return
    end
    selected.stock = selected.stock + cantitate
    TriggerClientEvent('ox_lib:notify', source, {
    title = 'Stoc',
    description = 'Ai adaugat ' .. cantitate .. ' la ' .. tip .. '. Stoc nou: ' .. selected.stock,
    type = 'success'
})
end, true)

lib.callback.register('armor:getStock', function(source)
    return armorTypes   -- trimite tot tabelul cu stoc
end)

RegisterNetEvent('armor:buy', function(tip)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local selected = armorTypes[tip]
    if not selected then return end

    if selected.stock <= 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Magazin Armura',
            description = 'Stoc epuizat pentru aceasta armura',
            type = 'error'
        })
        return
    end

    local price = selected.price
    local amount = selected.amount

    if Player.PlayerData.money['cash'] >= price then
        Player.Functions.RemoveMoney('cash', price)
        selected.stock = selected.stock - 1  
        TriggerClientEvent('armor:apply', src, amount)   
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Magazin Armura',
            description = 'Armura ' .. tip .. ' cumparata. Stoc ramas: ' .. selected.stock,
            type = 'success'
        })
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Magazin Armura',
            description = 'Nu ai bani destui',
            type = 'error'
        })
    end
end)