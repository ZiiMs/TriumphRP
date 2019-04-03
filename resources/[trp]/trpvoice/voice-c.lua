local level = {normal = 5.0, yell = 12.0, whisper = 1.0, current = 0}
local voipDraw = 1

AddEventHandler('onClientMapStart', function()
    NetworkSetTalkerProximity(level.normal)
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        for id = 0, 31 do
            if  ((NetworkIsPlayerActive( id )) and GetPlayerPed( id ) ~= GetPlayerPed( -1 )) then
                ped = GetPlayerPed( id )
 
                x1, y1, z1 = table.unpack( GetEntityCoords( GetPlayerPed( -1 ), true ) )
                x2, y2, z2 = table.unpack( GetEntityCoords( GetPlayerPed( id ), true ) )
                distance = math.floor(GetDistanceBetweenCoords(x1,  y1,  z1,  x2,  y2,  z2,  true))
		        local takeaway = 0.95

                if ((distance < 10) and IsEntityVisible(GetPlayerPed(id))) ~= GetPlayerPed( -1 ) then
		    if NetworkIsPlayerTalking(id) then
			DrawMarker(25,x2,y2,z2 - takeaway, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 10.3, 55, 160, 205, 105, 0, 0, 2, 0, 0, 0, 0)
		    --else
			--DrawMarker(25, x2,y2,z2 - takeaway, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 239, 239, 239, 50, 0, 0, 2, 0, 0, 0, 0)
                    end
                end  
            end
        end
        if IsControlJustPressed(0, 20) then
            level.current = (level.current + 1) % 3
            if level.current == 0 then 
                NetworkSetTalkerProximity(level.normal)
            elseif level.current == 1 then
                NetworkSetTalkerProximity(level.yell)
            elseif level.current == 2 then
                NetworkSetTalkerProximity(level.whisper)
            end
            voipDraw = voipDraw + 1
            DrawVoipText()
        end 
    end
end)

function DrawVoipText()
    Citizen.CreateThread(function()
        if voipDraw >= 2 then
            local timer = GetGameTimer()
            while(GetGameTimer() < timer + 2500) do 
                Wait(0)
                if voipDraw == 3 then
                    break;
                end
                if (GetVehiclePedIsIn(GetPlayerPed(-1),false) ~= 0 ) then
                    if (GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1),false), -1) ~= playerPed) then
                        if level.current == 0 then
                            drawTxt(0.704, 1.370, 1.0,1.0,0.4, "Voice: Normal", 255,255,255,255)
                        elseif level.current == 1 then
                            drawTxt(0.704, 1.370, 1.0,1.0,0.4, "Voice: Yell", 255,255,255,255)
                        elseif level.current == 2 then
                            drawTxt(0.704, 1.370, 1.0,1.0,0.4, "Voice: Whisper", 255,255,255,255)
                        end
                    else
                        if level.current == 0 then
                            drawTxt(0.704, 1.345, 1.0,1.0,0.4, "Voice: Normal", 255,255,255,255)
                        elseif level.current == 1 then
                            drawTxt(0.704, 1.345, 1.0,1.0,0.4, "Voice: Yell", 255,255,255,255)
                        elseif level.current == 2 then
                            drawTxt(0.704, 1.345, 1.0,1.0,0.4, "Voice: Whisper", 255,255,255,255)
                        end
                    end
                else
                    if level.current == 0 then
                        drawTxt(0.704, 1.460, 1.0,1.0,0.4, "Voice: Normal", 255,255,255,255)
                    elseif level.current == 1 then
                        drawTxt(0.704, 1.460, 1.0,1.0,0.4, "Voice: Yell", 255,255,255,255)
                    elseif level.current == 2 then
                        drawTxt(0.704, 1.460, 1.0,1.0,0.4, "Voice: Whisper", 255,255,255,255)
                    end
                end
            end
            voipDraw = 1
        end
    end)
end

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