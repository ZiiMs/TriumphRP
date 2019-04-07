playerData = {name, steamid, money}
RegisterNetEvent('setData')
AddEventHandler('setData', function(steamid, amount)
    local name = GetPlayerName(GetPlayerServerId(-1))
    playerData.name = name
    playerData.steamid = steamid
    playerData.money = amount
end)
local firstSpawn = true

AddEventHandler('playerSpawned', function(spawn)
    if firstSpawn == true then
        TriggerServerEvent("serverPlayerSpawned", spawn)
        firstSpawn = false
    end
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    print("Resource Started")
    firstSpawn = false
    TriggerServerEvent("resourceStarted")
end)
