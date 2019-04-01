RegisterCommand("wep", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    if args[1] == nil then
        TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"Usage", "/wep [weapon] [ammo(default 1000)]"}})
    end
    local wep = GetHashKey("WEAPON_" .. args[1])
    local ammo
    if args[2] == nil and GetWeapontypeModel(wep) ~= 0 then
        GiveWeaponToPed(ped, wep, 1000, false, false)
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You just gave yourself a " .. args[1] .. "."}})
    elseif GetWeapontypeModel(wep) == 0 then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {args[1] .. " is an invalid weapon."}})
    else
        ammo = tonumber(args[2])
        GiveWeaponToPed(ped, wep, ammo, false, false)
        SetPedAmmo(ped, wep, ammo)
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You just gave yourself a " .. args[1] .. ". With " .. args[2] .. " ammo."}})
    end     
end)

RegisterCommand("disarm", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    local targetid = GetPlayerFromServerId(tonumber(args[1]))
    local target = GetPlayerPed()
    local wep = GetHashKey("WEAPON_" .. args[2])
    if GetPlayerFromServerId(tonumber(args[1])) == -1 or args[1] == nil then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You specified a invalid ID."}})
        return false
    end
    if GetWeapontypeModel(wep) ~= 0 and args[2] ~= nil then
        RemoveWeaponFromPed(target, "WEAPON_" .. wep)
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You have removed " .. wep .. " from " .. GetPlayerName(targetid)}})
    elseif args[2] == nil then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You have removed all weaopns from " .. GetPlayerName(targetid)}})
        RemoveAllPedWeapons(target, true)
    else
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {wep .. " is not a valid weapon."}})
    end 
end)

RegisterCommand("listweapons", function(source, args, rawCommand)
    local weaponNames = {  
        "KNIFE", "NIGHTSTICK", "HAMMER", "BAT", "GOLFCLUB",  
        "CROWBAR", "PISTOL", "COMBATPISTOL", "APPISTOL", "PISTOL50",  
        "MICROSMG", "SMG", "ASSAULTSMG", "ASSAULTRIFLE",  
        "CARBINERIFLE", "ADVANCEDRIFLE", "MG", "COMBATMG", "PUMPSHOTGUN",  
        "SAWNOFFSHOTGUN", "ASSAULTSHOTGUN", "BULLPUPSHOTGUN", "STUNGUN", "SNIPERRIFLE",  
        "HEAVYSNIPER", "GRENADELAUNCHER", "GRENADELAUNCHER_SMOKE", "RPG", "MINIGUN",  
        "GRENADE", "STICKYBOMB", "SMOKEGRENADE", "BZGAS", "MOLOTOV",  
        "FIREEXTINGUISHER", "PETROLCAN", "FLARE", "SNSPISTOL", "SPECIALCARBINE",  
        "HEAVYPISTOL", "BULLPUPRIFLE", "HOMINGLAUNCHER", "PROXMINE", "SNOWBALL",  
        "VINTAGEPISTOL", "DAGGER", "FIREWORK", "MUSKET", "MARKSMANRIFLE",  
        "HEAVYSHOTGUN", "GUSENBERG", "HATCHET", "RAILGUN", "COMBATPDW",  
        "KNUCKLE", "MARKSMANPISTOL", "FLASHLIGHT", "MACHETE", "MACHINEPISTOL",  
        "SWITCHBLADE", "REVOLVER", "COMPACTRIFLE", "DBSHOTGUN", "FLAREGUN",  
        "AUTOSHOTGUN", "BATTLEAXE", "COMPACTLAUNCHER", "MINISMG", "PIPEBOMB",  
        "POOLCUE", "SWEEPER", "WRENCH"  
    };
    TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"Weapons List: "}})
    TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {table.concat(weaponNames, ", ")}})
    
end)

RegisterCommand("goto", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    local destped = GetPlayerPed(GetPlayerFromServerId(tonumber(args[1])))
    if PlayerId() == GetPlayerFromServerId(tonumber(args[1])) then 
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You can't TP to yourself."}}) 
        return false
    end
    if GetPlayerFromServerId(tonumber(args[1])) == -1 or args[1] == nil then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You specified a invalid ID."}})
        return false
    end
    local pos = GetEntityCoords(destped, true)
    SetEntityCoords(ped, pos, 1, 0, 0, 1)
end)

RegisterCommand("veh", function(source, args, rawCommand)
    local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 8.0, 0.5))
    local veh = args[1]
    local ped = GetPlayerPed(-1)
    if veh == nil then veh = "adder" end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    TriggerEvent('chat:addMessage', {
        color = { 255, 0, 0},
        multiline = true,
        args = {"Me", "Vehicle hash: " .. vehiclehash .. "."}
      })
    v = CreateVehicle(vehiclehash, x, y, z, GetEntityHeading(PlayerPedId())+90, 1, 0)
    SetPedIntoVehicle(ped, v, -1)
end)

RegisterCommand("pos", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    local zone = GetNameOfZone(pos.x, pos.y, pos.z)
    
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"Zone Name : ^*" .. zone}})
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"^*X: " .. round(pos.x, 3) .. " | Y: " .. round(pos.y, 3) .. " | Z: " .. round(pos.z, 3)}})
end)

RegisterCommand("gotols", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    SetPedCoordsKeepVehicle(ped, 192.662, -941.161, 30.692)
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"Tped to Los Santos, Legion Square."}})
end)

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

AddEventHandler("playerSpawned", function()
    NetworkSetFriendlyFireOption(true)
    SetCanAttackFriendly(PlayerPedId(), true, true)
end)