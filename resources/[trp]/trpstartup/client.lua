RegisterNetEvent('loadMoney')
AddEventHandler('loadMoney', function(amount)
    local ped = GetPlayerPed(-1)
    SetPedMoney(ped, amount)
end)
local firstSpawn = true

AddEventHandler('playerSpawned', function(spawn)
    if firstSpawn == true then
        TriggerServerEvent("serverPlayerSpawned", spawn)
        firstSpawn = false
    end
end)
