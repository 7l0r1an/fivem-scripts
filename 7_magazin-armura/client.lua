local shopCoords = vector3(18.3668, -1110.2134, 29.7970)
local interactDist = 2.0

RegisterNetEvent('armor:apply', function(amount)
    SetPedArmour(PlayerPedId(), amount)
end)

local function openArmorShop()
    local stock = lib.callback.await('armor:getStock', false)

    lib.registerContext({
        id = 'armor_shop',
        title = 'Magazin Armura',
        options = {
            {
                title = 'Armura mica',
                description = '$' .. stock.mica.price .. ' | Stoc: ' .. stock.mica.stock,
                onSelect = function()
                    TriggerServerEvent('armor:buy', 'mica')
                end
            },
            {
                title = 'Armura medie',
                description = '$' .. stock.medie.price .. ' | Stoc: ' .. stock.medie.stock,
                onSelect = function()
                    TriggerServerEvent('armor:buy', 'medie')
                end
            },
            {
                title = 'Armura mare',
                description = '$' .. stock.mare.price .. ' | Stoc: ' .. stock.mare.stock,
                onSelect = function()
                    TriggerServerEvent('armor:buy', 'mare')
                end
            }
        }
    })

    lib.showContext('armor_shop')
end

CreateThread(function()
    local armorBlip = AddBlipForCoord(shopCoords.x, shopCoords.y, shopCoords.z)
    SetBlipSprite(armorBlip, 58)
    SetBlipColour(armorBlip, 57)
    SetBlipScale(armorBlip, 0.9)
    SetBlipAsShortRange(armorBlip, false)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString('Magazin Armura')
    EndTextCommandSetBlipName(armorBlip)
end)

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - shopCoords)
        if dist < 10.0 then
            sleep = 0
            DrawMarker(1, shopCoords.x, shopCoords.y, shopCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0,
                0, 255, 150, false, true, 2, nil, nil, false)
            if dist <= interactDist then
                if IsControlJustReleased(0, 38) then
                    openArmorShop()
                end
            end
        end

        Wait(sleep)
    end
end)
