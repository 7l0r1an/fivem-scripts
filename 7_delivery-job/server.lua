local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('delivery:complete', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end
    local reward = math.random(350, 550)
    Player.Functions.AddMoney('cash', reward)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Job Livrari',
        description = 'Ai terminat de livrat. Ai primit ' .. reward ..' dolari',
        type = 'success'
    })
end)