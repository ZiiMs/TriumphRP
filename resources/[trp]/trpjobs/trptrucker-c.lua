local trucking = {}
trucking.start = false
trucking.trailer = false
trucking.truck = false

trucking.hashTrailer = 0
trucking.hashTruck = 0

local blip = {}

blip.id = -1

RegisterCommand("trucker", function(source, args, rawCommand)
    TriggerEvent("mt:missiontext", "Go pickup your trailer at the ~g~marker~w~.", 7500)
    local vhash = GetHashKey("TRAILERS")
    RequestModel(vhash)
    trucking.hashTrailer = vhash
    trucking.trailer = CreateVehicle(vhash, 600.201, 2799.307, 42.2, 282.86, true, false)
    blip.id = AddBlipForEntity(trucking.trailer)
    SetNewWaypoint(600.201, 2799.307)
    trucking.start = true
end)

function truckerMsg(msg)
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"Trucker", msg}})
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if trucking.start == true then
            if not IsEntityAttached(trucking.trailer) and blip.id == 0 then
                blip.id = AddBlipForEntity(trucking.trailer)
            elseif IsEntityAttached(trucking.trailer) then
                RemoveBlip(blip.id)
                blip.id = 0
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        Wait(0)
        if IsVehicleAttachedToTrailer(veh) then
            if IsControlJustPressed(0, 182) then
                DetachVehicleFromTrailer(veh)
            end
        end
    end
end)
