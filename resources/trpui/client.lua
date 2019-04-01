-- Speedometer
local SPEEDO = {
	Speed 			= 'mph', -- "kmh" or "mph"
    SpeedIndicator 	= true,
}
local UI = { 
    x =  0.000 ,
    y = -0.001 ,
}
    
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function drawRct(x,y,width,height,r,g,b,a)
	DrawRect(x + width/2, y + height/2, width, height, r, g, b, a)
end

Citizen.CreateThread(function()
    while true do Citizen.Wait(1)
    
        local MyPed = GetPlayerPed(-1)
            
        if(IsPedInAnyVehicle(MyPed, false))then

			local MyPedVeh = GetVehiclePedIsIn(GetPlayerPed(-1),false)
			local PlateVeh = GetVehicleNumberPlateText(MyPedVeh)
			local VehStopped = IsVehicleStopped(MyPedVeh)
			local VehEngineHP = GetVehicleEngineHealth(MyPedVeh) 
			local VehBodyHP = GetVehicleBodyHealth(MyPedVeh)
            local VehBurnout = IsVehicleInBurnout(MyPedVeh)
            
            --[[if SPEEDO.Speed == 'kmh' then
                Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6 ]]-- remove box brackets to make a thing if needed for "kmh"
                
			if SPEEDO.Speed == 'mph' then -- if you change to "kmh" make sure to change this to "elseif" rather then "if"
				Speed = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 2.236936
			else
				Speed = 0.0
			end
        
            if SPEEDO.SpeedIndicator then
                --[[drawRct(UI.x + 0.153, 	UI.y + 0.96, 0.046,0.03,0,0,0,150)

                --[[if SPEEDO.Speed == 'kmh' then
                    drawTxt(UI.x + 0.61, 	UI.y + 1.42, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255) -- remove box brackets to make a thing if needed for "kmh"
                    drawTxt(UI.x + 0.633, 	UI.y + 1.432, 1.0,1.0,0.4, "~w~ km/h", 255, 255, 255, 255)]]--

                if SPEEDO.Speed == 'mph' then -- if you change to "kmh" make sure to change this to "elseif" rather then "if"
                    drawTxt(UI.x + 0.670, 	UI.y + 1.420, 1.0,1.0,0.64 , "~w~" .. math.ceil(Speed), 255, 255, 255, 255)
                    drawTxt(UI.x + 0.690, 	UI.y + 1.427, 1.0,1.0,0.4, "~w~ mph", 255, 255, 255, 255)
                else
                    drawTxt(UI.x + 0.81, 	UI.y + 1.438, 1.0,1.0,0.64 , [[Carhud ~r~ERROR~w~ ~c~in ~w~SPEEDO Speed~c~ config (something else than ~y~'kmh'~c~ or ~y~'mph'~c~)]], 255, 255, 255, 255)
                end
            end
        end
    end
end)


-- Player Location Display
function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['GALLI'] = "Vinewood Sign", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "Rockford Hills & Golf Course", [' GOLF'] = "Rockford Hills & Golf Course", [' GOLF '] = "Rockford Hills & Golf Course", ['GOLF '] = "Rockford Hills & Golf Course", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['BAYTRE'] = "Vinewood Hills", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

local directions = { [0] = 'North', [45] = 'North West', [90] = 'West', [135] = 'South West', [180] = 'South', [225] = 'South East', [270] = 'East', [315] = 'North East', [360] = 'North', } 

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())

		for k,v in pairs(directions)do
			direction = GetEntityHeading(GetPlayerPed(-1))
			if(math.abs(direction - k) < 22.5)then
				direction = v
				break;
			end
        end
        --[[print("GZone: " .. GetNameOfZone(pos.x, pos.y, pos.z))
        print("Zone: " .. zones[GetNameOfZone(pos.x, pos.y, pos.z)])]]
        if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0 ) then
            if (GetStreetNameFromHashKey(var1)) and (GetStreetNameFromHashKey(var2)) and GetNameOfZone(pos.x, pos.y, pos.z) then
                if var2 == nil or tostring(GetStreetNameFromHashKey(var2)) == "" then 
                    if zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1)) then
                        drawTxt(0.670, 1.46, 1.0,1.0,0.4, direction .. "~b~ | ~w~" .. tostring(GetStreetNameFromHashKey(var1)) .. "~w~" .. "~b~ | ~w~" .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], 255, 255, 255, 255)
                    end 
                else
                    if zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1)) and tostring(GetStreetNameFromHashKey(var2)) then
                        drawTxt(0.670, 1.46, 1.0,1.0,0.4, direction .. "~b~ | ~w~" .. tostring(GetStreetNameFromHashKey(var2)) .. "~b~ | ~w~" .. tostring(GetStreetNameFromHashKey(var1)) .. "~w~" .. "~b~ | ~w~" .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], 255, 255, 255, 255)
                        --print("Zones: " .. zones[GetNameOfZone(pos.x, pos.y, pos.z)] .. " | StreetName: " .. tostring(GetStreetNameFromHashKey(var1)))
                    end 
                end
            end
		end
	end
end)