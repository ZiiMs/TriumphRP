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

RegisterCommand("setmoney", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    local targetid = GetPlayerFromServerId(tonumber(args[1]))
    local target = GetPlayerPed(targetid)
    local amount = tonumber(args[2])
    if args[1] == nil then
        TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"Usage", "/setmoney [playerid] [amount]"}})
        return false
    elseif GetPlayerFromServerId(tonumber(args[1])) == -1 then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You specified a invalid ID."}})
        return false
    end
    if amount == nil or amount <= 0 then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You have specified a invalid amount."}})
    else
        SetPedMoney(target, amount)
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You just set ".. GetPlayerName(targetid) .." money to ^*$".. amount.."."}})
        TriggerServerEvent('saveMoney', amount)
    end
end)

function checkMoney()
    local ped = GetPlayerPed(PlayerId())
    local money = GetPedMoney(ped)
    return "$"..money
end

RegisterCommand("cash", function(source, args, rawCommand)
    TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"Your Money: "}})
    TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {checkMoney()}})
    
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
    Citizen.CreateThread(function()
        --pos.z = pos.z + 1.0
        SetFocusArea(pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
        if (GetVehiclePedIsIn(destped,false) == 0 ) then
            local pos = GetEntityCoords(destped, true)
            NetworkFadeOutEntity(ped, true, false)
            Wait(500)
            pos = GetEntityCoords(destped, true)
            SetPedCoordsKeepVehicle(ped, pos.x, pos.y, pos.z + 1.0)
            ClearFocus()
            NetworkFadeInEntity(ped, 0)
        else
            local pos = GetEntityCoords(destped, true)
            NetworkFadeOutEntity(ped, true, false)
            Wait(500)
            SetPedCoordsKeepVehicle(ped, pos.x, pos.y, pos.z + 1.0)
            Wait(250)
            SetPedIntoVehicle(ped, GetVehiclePedIsIn(destped,false), -2)
            ClearFocus()
            NetworkFadeInEntity(ped, 0)
        end
    end)
end)

RegisterCommand("gotowp", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    local blip = GetFirstBlipInfoId(8)
    if blip ~= 0 then
        local blipPos = GetBlipCoords(blip)
        local zPos
        Citizen.CreateThread(function()
            SetFocusArea(blipPos.x, blipPos.y, blipPos.z, 0.0, 0.0, 0.0)
            NetworkFadeOutEntity(ped, true, false)
            Wait(500)
            _, zPos = GetGroundZFor_3dCoord(blipPos.x+.0, blipPos.y+.0, blipPos.z+9999.0, 1)
            SetPedCoordsKeepVehicle(ped, blipPos.x, blipPos.y, zPos)
            ClearFocus()
            NetworkFadeInEntity(ped, 0)
        end)
        --TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"Z: " .. 0.0 .. " Z2: " .. zPos}})
    else
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You don't have a waypoint placed."}})
    end
end)

RegisterCommand("veh", function(source, args, rawCommand)
    local veh = args[1] or 'adder'
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    if not IsModelInCdimage(veh) or not IsModelAVehicle(veh) then
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {veh .. " is not a vehicle model."}})
        return false
    end
    vehiclehash = GetHashKey(veh)
    RequestModel(vehiclehash)
    while not HasModelLoaded(veh) do
        Wait(500)
    end
    
    TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"You just spawned a ^*" .. veh:gsub("^%l", string.upper) .. "."}})
    v = CreateVehicle(vehiclehash, pos.x, pos.y, pos.z, GetEntityHeading(PlayerPedId())+90, 1, 0)
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