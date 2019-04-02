RegisterNetEvent('loadMoney')
AddEventHandler('loadMoney', function(amount)
    local ped = GetPlayerPed(-1)
    SetPedMoney(ped, amount)
end)

AddEventHandler('playerSpawned', function(spawn)
    TriggerServerEvent("serverPlayerSpawned", spawn)
end)
