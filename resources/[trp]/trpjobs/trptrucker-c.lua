local trucking = {}
trucking.start = false
trucking.trailer = false
trucking.truck = false

trucking.hashTrailer = 0
trucking.hashTruck = 0
trucking.job = 0

trucking.jobs = {
    [1] = {x = 2667.166, y = 3519.705, z = 52.273, money = 700}
}

local blip = {}
blip.truckid = -1
blip.trailerid = -1
blip.jobid = -1

RegisterCommand("trucker", function(source, args, rawCommand)
    if trucking.start then
        Clear()
    else
        TriggerEvent("mt:missiontext", "Go pickup your trailer at the ~g~marker~w~.", 7500)
        blip.trailerid = AddBlipForCoord(600.201, 2799.307, 42.2)
        SetNewWaypoint(600.201, 2799.307)
        trucking.start = true
    end
end)

function truckerMsg(msg)
    TriggerEvent('chat:addMessage', { color = { 255, 0, 0}, multiline = true, args = {"Trucker", msg}})
end

function Clear()
    trucking.start = false
    if trucking.trailer then
        SetEntityAsNoLongerNeeded(trucking.trailer)
    end
    trucking.trailer = false
    trucking.truck = false
    trucking.hashTrailer = 0
    trucking.hashTruck = 0
    trucking.job = 0
    if blip.truckid ~= -1 then
        RemoveBlip(blip.truckid)
        blip.truckid = -1
    elseif blip.trailerid ~= -1 then
        RemoveBlip(blip.trailerid)
        blip.trailerid = -1
    elseif blip.jobid ~= -1 then
        RemoveBlip(blip.jobid)
        blip.jobid = -1
    end
    TriggerEvent("mt:missiontext", "Trucker mission ~r~stopped~w~.", 7500)
    SetWaypointOff()
    ClearGpsPlayerWaypoint()
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if trucking.start == true then
            if not IsEntityAttached(trucking.trailer) and blip.trailerid == -1 then
                blip.trailerid = AddBlipForEntity(trucking.trailer)
                SetBlipSprite(blip.trailerid, 479)
                SetBlipColour(blip.trailerid, 0)
            elseif IsEntityAttached(trucking.trailer) then
                RemoveBlip(blip.trailerid)
                blip.trailerid = -1
                if trucking.job == 0 then
                    local job = GetRandomIntInRange(1, #trucking.jobs)
                    print(job)
                    SetNewWaypoint(trucking.jobs[job].x, trucking.jobs[job].y, trucking.jobs[job].z)
                    blip.jobid = AddBlipForCoord(trucking.jobs[job].x, trucking.jobs[job].y, trucking.jobs[job].z)
                    TriggerEvent("mt:missiontext", "Bring your tailer to the~r~ destination~w~.", 10000)
                    trucking.job = job
                end
            end
            local ped = GetPlayerPed(-1)
            local blipCoords = GetBlipCoords(blip.trailerid)
            local pos = GetEntityCoords(ped, true)
            if GetDistanceBetweenCoords(blipCoords.x, blipCoords.y, blipCoords.z, pos.x, pos.y, pos.z, false) < 200.00 and trucking.trailer == false then
                print("Spawning!")
                local vehHash = GetHashKey("TRAILERS")
                trucking.hashTrailer = vehHash
                RequestModel(vehHash)
                trucking.trailer = CreateVehicle(vehHash, 600.201, 2799.307, 42.2, 282.86, true, false)
                RemoveBlip(blip.trailerid)
                blip.trailerid = AddBlipForEntity(trucking.trailer)
                SetBlipSprite(blip.trailerid, 479)
                SetBlipColour(blip.trailerid, 0)
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
