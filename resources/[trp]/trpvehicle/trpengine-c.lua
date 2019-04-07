Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local veh = GetVehiclePedIsIn(ped, false)
        local dots = 0
        Wait(0)
        local veh = GetVehiclePedIsIn(ped, false)
        if GetSeatPedIsTryingToEnter(ped) == -1 then
            local newveh = GetVehiclePedIsTryingToEnter(ped)
            if not GetIsVehicleEngineRunning(newveh) then
                SetVehicleEngineOn(newveh, true, false, true)
                SetVehicleEngineOn(newveh, false, false, true)
                SetVehicleHalt(newveh, 5000.0, true, false)
                SetVehicleJetEngineOn(newveh, false)
            end
        end
        local safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
        if GetPedInVehicleSeat(veh, -1) == ped and IsPedInAnyVehicle(ped, false) then
            if IsThisModelACar(GetEntityModel(veh)) then
                local y = 1.345 + safeZoneOffset
                local x = 0.704 - safeZoneOffset
                if GetIsVehicleEngineRunning(veh) then
                    drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~g~On", 255,255,255,255)
                elseif GetIsVehicleEngineRunning(veh) == false then
                    drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~r~Off", 255,255,255,255)
                end
            else
                local y = 1.370 + safeZoneOffset
                local x = 0.704 - safeZoneOffset
                if GetIsVehicleEngineRunning(veh) then
                    drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~g~On", 255,255,255,255)
                elseif GetIsVehicleEngineRunning(veh) == false then
                    drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~r~Off", 255,255,255,255)
                end
            end
            if IsControlJustPressed(0, 47) and IsControlPressed(0, 21) then 
                if GetIsVehicleEngineRunning(veh) then
                    SetVehicleEngineOn(veh, false, false, true)
                    SetVehicleHalt(veh, 5000.0, true, false)
                    SetVehicleJetEngineOn(veh, false)
                elseif GetIsVehicleEngineRunning(veh) == false then
                local timer = GetGameTimer()
                    while GetGameTimer() < timer + 1500 do
                        Wait(0)
                        dots = (dots + 1) % 51
                        if IsThisModelACar(GetEntityModel(veh)) then
                            local y = 1.345 + safeZoneOffset
                            local x = 0.704 - safeZoneOffset
                            if dots <= 17 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting.", 255,255,255,255)
                            elseif dots <= 34 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting..", 255,255,255,255)
                            elseif dots <= 51 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting...", 255,255,255,255)
                            end
                        else
                            local y = 1.370 + safeZoneOffset
                            local x = 0.704 - safeZoneOffset
                            if dots <= 17 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting.", 255,255,255,255)
                            elseif dots <= 34 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting..", 255,255,255,255)
                            elseif dots <= 51 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting...", 255,255,255,255)
                            end
                        end  
                    end
                    SetVehicleEngineOn(veh, true, false, true)
                    SetVehicleJetEngineOn(veh, true)
                end
                dots = 0
            elseif IsControlPressed(0, 47) and IsControlJustPressed(0, 21) then 
                if GetIsVehicleEngineRunning(veh) then
                    SetVehicleEngineOn(veh, false, false, true)
                    SetVehicleHalt(veh, 5000.0, true, false)
                    SetVehicleJetEngineOn(veh, false)
                elseif GetIsVehicleEngineRunning(veh) == false then
                local timer = GetGameTimer()
                    while GetGameTimer() < timer + 1500 do
                        Wait(0)
                        dots = (dots + 1) % 150
                        if IsThisModelACar(GetEntityModel(veh)) then
                            local y = 1.345 + safeZoneOffset
                            local x = 0.704 - safeZoneOffset
                            if dots <= 50 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting.", 255,255,255,255)
                            elseif dots <= 100 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting..", 255,255,255,255)
                            elseif dots <= 150 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting...", 255,255,255,255)
                            end
                        else
                            local y = 1.370 + safeZoneOffset
                            local x = 0.704 - safeZoneOffset
                            if dots <= 50 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting.", 255,255,255,255)
                            elseif dots <= 100 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting..", 255,255,255,255)
                            elseif dots <= 150 then
                                drawTxt(x, y, 1.0,1.0,0.4, "Engine: ~o~Starting...", 255,255,255,255)
                            end
                        end  
                    end
                    SetVehicleEngineOn(veh, true, false, true)
                    SetVehicleJetEngineOn(veh, true)
                end
                dots = 0
            end
        end
    end
end)

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