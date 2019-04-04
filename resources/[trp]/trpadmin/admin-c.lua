

TriggerEvent('chat:addSuggestion', '/wep', 'Spawns a weapon', {
    { name="weapon", help="The name of the weapon" },
    { name="ammo", help="Amount of ammo" }
})
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

TriggerEvent('chat:addSuggestion', '/disarm', 'Removes player weapons.', {
    { name="targetID", help="Target playerID" },
    { name="weapon", help="Weapon to remove. Leave empty for all." }
})
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

RegisterCommand("gethealth", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    print(GetEntityHealth(ped))
end)

TriggerEvent('chat:addSuggestion', '/setmoney', 'Sets the money of target player.', {
    { name="TargetID", help="ID of Target player." },
    { name="money", help="Amount of money." }
})
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
        playerData.money = amount
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, multiline = true, args = {"You just set ".. GetPlayerName(targetid) .." money to ^*$".. amount.."."}})
        TriggerServerEvent('saveMoney', amount)
    end
end)

function checkMoney()
    local ped = GetPlayerPed(PlayerId())
    local money = tonumber(playerData.money)
    return "$"..money
end

TriggerEvent('chat:addSuggestion', '/cash', 'Outputs current cash.')
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

TriggerEvent('chat:addSuggestion', '/goto', 'Teleport to play.', {
    { name="playerID", help="The ID of player." }
})
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

TriggerEvent('chat:addSuggestion', '/gotowp', 'Teleport to waypoint.(sometimes fall through map)')
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

TriggerEvent('chat:addSuggestion', '/gotopos', 'Goto Vector3 coords.', {
    { name="X", help="X Coord" },
    { name="Y", help="Y Coord" },
    { name="Z", help="Z Coord" }
})
RegisterCommand("gotopos", function(source, args, rawCommand)
    local ped = GetPlayerPed(PlayerId())
    local posX, posY, posZ = tonumber(args[1]), tonumber(args[2]), tonumber(args[3])
    Citizen.CreateThread(function()
        SetFocusArea(posX, posY, posZ, 0.0, 0.0, 0.0)
        NetworkFadeOutEntity(ped, true, false)
        Wait(500)
        SetPedCoordsKeepVehicle(ped, posX, posY, posZ)
        ClearFocus()
        NetworkFadeInEntity(ped, 0)
    end)
end)

TriggerEvent('chat:addSuggestion', '/veh', 'Spawns a vehicle', {
    { name="vehicle", help="The name of the vehicle. Default is Panto." }
})
RegisterCommand("veh", function(source, args, rawCommand)
    local veh = args[1] or 'Panto'
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

TriggerEvent('chat:addSuggestion', '/repair', 'Repairs your current car.')
RegisterCommand("repair", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped,false)
    if (veh == 0 ) then TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"You are not in a vehicle."}}) end
    SetVehicleFixed(veh)
end)

TriggerEvent('chat:addSuggestion', '/dv', 'Deletes the nearest car or the car you are inside.(Nearest car is buggy)')
RegisterCommand("dv", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    local nearveh = GetClosestVehicle(pos, 5.0, 0, 0)
    local veh = GetVehiclePedIsIn(ped)
    if (nearveh == 0 and veh == 0) then TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"You are not in a vehicle or near a vehicle."}}) end
    if nearveh ~= 0 then
        SetEntityAsMissionEntity(nearveh, true, true)
        DeleteVehicle(nearveh)
    else
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end
end)

TriggerEvent('chat:addSuggestion', '/mod', 'Gives max EMS upgrades')
RegisterCommand("mod", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped,false)
    if (veh == 0 ) then TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"You are not in a vehicle."}}) end
    SetVehicleFixed(veh)
    SetVehicleModKit(veh,0)
    SetVehicleMod(veh,11,3)
    print(GetVehicleMod(veh, 11))
end)

TriggerEvent('chat:addSuggestion', '/pos', 'Gets your current Vector3 coords')
RegisterCommand("pos", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local pos = GetEntityCoords(ped, true)
    local zone = GetNameOfZone(pos.x, pos.y, pos.z)
    local heading = GetEntityHeading(ped)
    
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"Zone Name : ^*" .. zone}})
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"^*X: " .. round(pos.x, 3) .. " | Y: " .. round(pos.y, 3) .. " | Z: " .. round(pos.z, 3)}})
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"Heading: ^*" .. round(heading, 3)}})
end)

TriggerEvent('chat:addSuggestion', '/gotols', 'Teleports you to Los Santos')
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