TriggerEvent('chat:addSuggestion', '/me', 'Used to display your character doing an action.', {
    {name="text", help="Text to output in /me."}
})
RegisterCommand('me', function(source, args)
    local text = '' .. table.concat(args, " ") .. ''
    TriggerServerEvent('3dme:shareDisplay', text)

end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 1 + 0.14
    Display(GetPlayerFromServerId(source), text, offset)
end)

TriggerEvent('chat:addSuggestion', '/door', 'Used to open/close doors.', {
    {name="Door", help="DoorID: FrontR: 0 | FrontL: 1 | BackR: 2 | BackL: 3 | Hood: 4 | Trunk: 5 | Trunk2: 6"}
})
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
        SetVehicleDoorOpen(veh, door, false, false)
    else
        SetVehicleDoorShut(veh, door, false)
    end
end)

TriggerEvent('chat:addSuggestion', '/seat', 'Used to change what seat you are in.', {
    {name="Seat", help="SeatID: FreePassenger: -2 | DriverSeat: -1 | Passenger: = 0 | LeftRear: 1 | RightRear: = 2"}
})
RegisterCommand("seat", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped,false)
    local seat = tonumber(args[1])

    if (veh == 0 ) then TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"You are not in a vehicle."}}) end
    --[[if (seat > GetVehicleModelNumberOfSeats(veh)) then 
        TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, args = {"Usage", "/seat [seatid]"}}) 
        TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"FrontR: 0 | FrontL: 1 | BackR: 2 | BackL: 3 | Hood: 4 | Trunk: 5 | Trunk2: 6"}}) 
        return false
    end]]
    if GetPedInVehicleSeat(veh, seat) ~= 0 then TriggerEvent('chat:addMessage', { color = { 255, 255, 255}, args = {"Someone is in that seat."}}) end
    SetPedIntoVehicle(ped, veh, seat)
end)





