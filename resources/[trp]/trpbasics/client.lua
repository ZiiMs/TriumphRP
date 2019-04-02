RegisterCommand('me', function(source, args)
    local text = '* ' .. args[1] .. ' *'
    timerEnable = false
    TriggerServerEvent('3dme:shareDisplay', text)

end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 1 + 0.14
    Display(GetPlayerFromServerId(source), text, offset)
end)

RegisterCommand("door", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped,false)
    local door = tonumber(args[1])
    local status = GetVehicleDoorAngleRatio(veh , door)

    if (veh == 0 ) then TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"You are not in a vehicle."}}) end
    if (door == nil or door >= 7 ) then 
        TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"Usage", "/door [doorid]"}}) 
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"FrontR: 0 | FrontL: 1 | BackR: 2 | BackL: 3 | Hood: 4 | Trunk: 5 | Trunk2: 6"}}) 
        return false
    end
    if status == 0.0 then
        SetVehicleDoorOpen(veh, door, true, true)
    else
        SetVehicleDoorShut(veh, door, true)
    end
end)

RegisterCommand("help", function(source, args, rawCommand)
    alert("~b~Help info   ~INPUT_VEH_HEADLIGHT~")
end)



