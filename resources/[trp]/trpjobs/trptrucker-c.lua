local trucking = {}
trucking.start = false
trucking.trailer = false
trucking.truck = false

trucking.hashTrailer = 0
trucking.hashTruck = 0
trucking.job = 0

trucking.jobs = {
    [1] = {x = 2667.166, y = 3519.705, z = 52.273, money = 700},
    [2] = {x = 600.352, y = -1863.972, z = 24.737, money = 1000},
    [3] = {x = -569.735, y = -1782.927, z = 22.451, money = 1000},
    [4] = {x = -1059, y = -2007.078, z = 12.487, money = 1000}
}

local trucks = {
    "HAULER",
    "PACKER",
    "PHANTOM"
}

local Selected = 0

local blip = {}
blip.truckid = -1
blip.trailerid = -1
blip.jobid = -1

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Truck Garage", "Please select a truck below.")
_menuPool:Add(mainMenu)

function FirstItem(menu)
    local Description = "1"
    local hauler = NativeUI.CreateItem("HAULER", Description)
    menu:AddItem(hauler)
    local packer = NativeUI.CreateItem("PACKER", Description)
    menu:AddItem(packer)
    local phantom = NativeUI.CreateItem("PHANTOM", Description)
    menu:AddItem(phantom)
    menu.OnItemSelect = function(menu, item)
        if item == hauler then
            SpawnVeh(1)
        elseif item == packer then
            SpawnVeh(2)
        elseif item == phantom then
            SpawnVeh(3)
        end
    end
end

function SpawnVeh(car)
    mainMenu:Visible(not mainMenu:Visible())
    local ped = GetPlayerPed(-1)
    print(ped)
    print(trucks[car])
    local VehHash = GetHashKey(trucks[car])
    RequestModel(VehHash)
    trucking.truck = CreateVehicle(VehHash, 948.365, -1698.2, 30.170, 266.414, true, false)
    print(VehHash)
    SetPedIntoVehicle(ped, trucking.truck, -1)
    Start()
    print(trucking.truck)
end

RegisterCommand("trucker", function(source, args, rawCommand)
    local ped = GetPlayerPed(-1)
    local found = false
    if trucking.start then
        Clear()
    elseif not trucking.start then
        for i = 1, 3 do
            if GetHashKey(trucks[i]) == GetEntityModel(GetVehiclePedIsIn(ped, false)) then
                found = true
                break;
            end
        end
        if found then
            Start()
            --print(GetEntityModel(GetVehiclePedIsIn(ped, false)))
        elseif blip.truckid == -1 then
            truckerMsg("You need to get a truck. Type /trucker to remove blip and route.")
            blip.truckid = AddBlipForCoord(947.77, -1698.022, 30.087)
            SetBlipRoute(blip.truckid, true)
            SetBlipRouteColour(blip.truckid, 6)
            --print(GetEntityModel(GetVehiclePedIsIn(ped, false)))
            SetBlipSprite(blip.truckid, 477)
            SetBlipColour(blip.truckid, 0)
            AddTextEntry('Truck', 'Truck Garage')
            BeginTextCommandSetBlipName('Truck')
            EndTextCommandSetBlipName(blip.truckid)
        elseif blip.truckid ~= -1 then
            Clear()
        end
    end
end)

RegisterCommand("testtimer", function(source, args, rawCommand)
    Citizen.CreateThread(function()
        while true do 
            Wait(0)
            i = 6000
            i = i - 1
            DrawTimerBar(GetGameTimer(),i, 255, 255, 255)
        end
    end)
end)

FirstItem(mainMenu)
_menuPool:RefreshIndex()


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
    end
    if blip.trailerid ~= -1 then
        RemoveBlip(blip.trailerid)
        blip.trailerid = -1
    end
    if blip.jobid ~= -1 then
        RemoveBlip(blip.jobid)
        blip.jobid = -1
        print("JobID Gone")
    end
    TriggerEvent("mt:missiontext", "Trucker mission ~r~stopped~w~.", 7500)
    SetWaypointOff()
    ClearGpsPlayerWaypoint()
end

function Start()
    TriggerEvent("mt:missiontext", "Go pickup your trailer at the ~g~marker~w~.", 7500)
    blip.trailerid = AddBlipForCoord(600.201, 2799.307, 42.2)
    SetBlipSprite(blip.trailerid, 479)
    SetBlipColour(blip.trailerid, 0)
    AddTextEntry('TrailerName', 'Trailer')
    BeginTextCommandSetBlipName('TrailerName')
    EndTextCommandSetBlipName(blip.trailerid)
    SetBlipRoute(blip.trailerid, true)
    SetBlipRouteColour(blip.trailerid, 3)
    --SetNewWaypoint(600.201, 2799.307)
    trucking.start = true
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped, true)
        if GetDistanceBetweenCoords(947.77, -1698.022, 30.087, pos.x, pos.y, pos.z, false) < 5.50 then 
            DrawText3Ds(947.77, -1698.022, 30.087, "Press G to select truck")   
            DrawMarker(39, 947.77, -1698.022, 30.087, 0, 0, 0, 0, 0, 0.0, 1.0, 1.0, 1.0, 55, 160, 205, 255, 0, true, 2, 0, 0, 0, 0)
            if GetDistanceBetweenCoords(947.77, -1698.022, 30.087, pos.x, pos.y, pos.z, false) < 1.00 then 
                _menuPool:ProcessMenus()
                if IsControlJustReleased(0, 47) then
                    mainMenu:Visible(not mainMenu:Visible())
                    --[[rTruck = GetRandomIntInRange(1, #trucks)
                    print(rTruck)
                    local VehHash = GetHashKey(trucks[rTruck])
                    trucking.truck = CreateVehicle(VehHash, 948.365, -1698.2, 30.170, 266.414, true, false)
                    SetPedIntoVehicle(ped, trucking.truck, -1)
                    RemoveBlip(blip.truckid)
                    blip.truckid = -1
                    Start()]]
                end
            end
        end
        if trucking.start == true then
            if not IsEntityAttached(trucking.trailer) and blip.trailerid == -1 then
                blip.trailerid = AddBlipForEntity(trucking.trailer)
                SetBlipSprite(blip.trailerid, 479)
                SetBlipColour(blip.trailerid, 0)
                if trucking.job ~= 0 then
                    local timer = GetGameTimer()
                    while(GetGameTimer() < timer + 120000) do
                        Wait(0)
                        if IsEntityAttached(trucking.trailer) then
                            break;
                        end
                        local time = (timer + 120000 - GetGameTimer()) / 1000
                        if time <= 0 then
                            time = 0
                            Clear()
                            print(1)
                        end
                        TriggerEvent("mt:missiontext", "You have ~r~".. math.floor(time) .."~w~ seconds to re-attach your trailer.", 0)
                    end
                end        
            elseif IsEntityAttached(trucking.trailer) then
                RemoveBlip(blip.trailerid)
                blip.trailerid = -1
                if trucking.job == 0 then
                    local job = math.random(1, #trucking.jobs)
                    print(job)
                    --SetNewWaypoint(trucking.jobs[job].x, trucking.jobs[job].y, trucking.jobs[job].z)
                    blip.jobid = AddBlipForCoord(trucking.jobs[job].x, trucking.jobs[job].y, trucking.jobs[job].z)
                    SetBlipRoute(blip.jobid, true)
                    SetBlipRouteColour(blip.jobid, 3)
                    DrawMarker(39, trucking.jobs[job].x, trucking.jobs[job].y, trucking.jobs[job].z, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 55, 160, 205, 105, 0, 0, 2, 0, 0, 0, 0)
                    TriggerEvent("mt:missiontext", "Bring your tailer to the~r~ destination~w~.", 10000)
                    trucking.job = job
                    AddTextEntry('Job', 'Dropoff Spot')
                    BeginTextCommandSetBlipName('Job')
                    EndTextCommandSetBlipName(blip.jobid)
                end
            end
            if trucking.trailer == false and trucking.job == 0 and blip.trailerid ~= -1 then
                --local ped = GetPlayerPed(-1)
                local blipCoords = GetBlipCoords(blip.trailerid)
                --local pos = GetEntityCoords(ped, true)
                if GetDistanceBetweenCoords(blipCoords.x, blipCoords.y, blipCoords.z, pos.x, pos.y, pos.z, false) < 100.00 then
                    print("Spawning!")
                    local vehHash = GetHashKey("TRAILERS")
                    trucking.hashTrailer = vehHash
                    RequestModel(vehHash)
                    trucking.trailer = CreateVehicle(vehHash, 600.201, 2799.307, 42.2, 282.86, true, false)
                    RemoveBlip(blip.trailerid)
                    SetEntityAsMissionEntity(trucking.trailer, true, true)
                    blip.trailerid = AddBlipForEntity(trucking.trailer)
                    SetBlipSprite(blip.trailerid, 479)
                    SetBlipColour(blip.trailerid, 0)
                    AddTextEntry('TrailerName', 'Trailer')
                    BeginTextCommandSetBlipName('TrailerName')
                    EndTextCommandSetBlipName(blip.trailerid)
                end
            end
            if trucking.trailer ~= false and trucking.job ~= 0 and IsEntityAttached(trucking.trailer) then
                local blipCoords = GetBlipCoords(blip.jobid)
                local tPos = GetEntityCoords(trucking.trailer, true)
                local pos = GetEntityCoords(ped, true)
                local dist = GetDistanceBetweenCoords(blipCoords.x, blipCoords.y, blipCoords.z, tPos.x, tPos.y, tPos.z, false)
                print(dist)
                if GetDistanceBetweenCoords(blipCoords.x, blipCoords.y, blipCoords.z, pos.x, pos.y, pos.z, false) < 50.00 then
                    DrawMarker(20, blipCoords.x, blipCoords.y, blipCoords.z, 0, 0, 0, 0, 0, 0.0, 1.0, 1.0, 1.0, 55, 160, 205, 255, 0, true, 2, 0, 0, 0, 0)
                    if dist < 7.00 then
                        local timer = GetGameTimer()
                        local UnLoaded = false
                        while(GetGameTimer() < timer + 6000) do
                            Wait(0)
                            local time = (timer + 6000 - GetGameTimer()) / 1000
                            if time <= 0 then
                                time = 0
                                UnLoaded = true
                                print(1)
                            end
                            TriggerEvent("mt:missiontext", "Unloading the trailer. Stay in still for ~r~".. math.floor(time) .."~w~ seconds.", 0)
                        end
                        if UnLoaded then
                            local money = trucking.jobs[trucking.job].money
                            local currMoney = tonumber(playerData.money)
                            print(money)
                            print(currMoney)
                            playerData.money = currMoney + money
                            local money = currMoney + money
                            TriggerServerEvent('saveMoney', money)
                            Clear()
                        end
                    end
                end
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

RegisterNetEvent("mt:missiontext")
AddEventHandler("mt:missiontext", function(text, time)
        ClearPrints()
        SetTextEntry_2("STRING")
        AddTextComponentString(text)
        DrawSubtitleTimed(time, 1)
end)

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end

function DrawTimerBar(startT, endT, r, g, b)
	local value = math.floor(((startT + endT) - GetGameTimer())*0.001)
	local maxvalue = math.floor(endT*0.001)
	local width = 0.2
	local height = 0.025
	local xvalue = 0.38
	local yvalue = 0.05
	local outlinecolour = {0, 0, 0, 150}
	local barcolour = {r, g, b}
	local minutes = math.floor(value/60)
	local time = ""..minutes.." minutes and "..math.floor(value - (minutes*60)).." seconds"
	DrawRect(xvalue + (width/2), yvalue, width + 0.004, height + 0.006705, outlinecolour[1], outlinecolour[2], outlinecolour[3], outlinecolour[4]) -- Box that creates outline
	drawHelpTxt(xvalue + (((maxvalue/2)/((maxvalue/2)/width))/2), yvalue + 0.0275, 0.1, 0.1, 0.5, time, 255, 255, 255, 255, 6) -- Text display of timer
	DrawRect(xvalue + (width/2), yvalue, width, height, barcolour[1], barcolour[2], barcolour[3], 75) --  Static full bar
	DrawRect(xvalue + ((value/(maxvalue/width))/2), yvalue, value/(maxvalue/width), height, barcolour[1], barcolour[2], barcolour[3], 255) -- Moveable Bar  
end

function drawHelpTxt(x,y ,width,height,scale, text, r,g,b,a,font)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

