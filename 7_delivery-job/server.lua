local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('delivery:complete', function(isFinal)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then
        return
    end
    local reward
    local message

    if isFinal then
        reward = math.random(1050, 1500)
        message = 'Ai terminat tura! Ai primit ' .. reward .. ' dolari'
    else
        reward = math.random(350, 550)
        message = 'Livrare completa. Ai primit ' .. reward .. ' dolari. Mergi la urmatorul punct'
    end
    Player.Functions.AddMoney('cash', reward)
    TriggerClientEvent('ox_lib:notify', src, {
        title = 'Job Livrari',
        description = message,
        type = 'success'
    })
end)
