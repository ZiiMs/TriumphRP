-- 1 == Left || 2 == Center || 3 == Right
local SBpos = 3

local function DrawPList()
    local players = {}
    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end
    local headerText = "Players Online ( " .. NetworkGetNumConnectedPlayers() .. " )"
    local headerSecondaryText = "Player ID"
    local scoreBoard = 0
    DrawRow(headerText, headerSecondaryText, _, 255, 255, 255, _, _, 0.35, 0);
    for k, v in pairs(players) do
        name = GetPlayerName(v)
        serverid = GetPlayerServerId(v)
        local bg
        if serverid % 2 == 0 then bg = 15 else bg = 20 end
        local pId = PlayerId()
        pId = pId + 1
        if k == pId then
            DrawRow(name, serverid, 0.04 * (scoreBoard + 1), 75, 150, 255, 0, bg)
            --print("k :" .. k .. " | PlayerID: " .. PlayerId())
        else 
            DrawRow(name, serverid, 0.04 * (scoreBoard + 1), _, _, _, 0, bg)
        end
        scoreBoard = scoreBoard + 1
    end
    --For testing scoreboard
    --[[for i = 0, 31 do
        name = "Player " .. i
        serverid = i
        local bg
        if serverid % 2 == 0 then bg = 15 else bg = 20 end
        local pId = PlayerId()
        pId = pId + 1
        if i == 1 then
            DrawRow(name, serverid, 0.04 * (scoreBoard + 1), 75, 150, 255, 0, bg)
            --print("k :" .. k .. " | PlayerID: " .. PlayerId())
        else 
            DrawRow(name, serverid, 0.04 * (scoreBoard + 1), _, _, _, 0, bg)
        end
        scoreBoard = scoreBoard + 1
    end]]

end


function DrawRow(leftText, rightText, starty, r, g, b, stars, bgColor,size, font)
    if font == nil then font = 6 end
    if size == nil then size = 0.45 end
    if stars == nil then stars = 0 end
    if r == nil then r = 255 end
    if b == nil then b = 255 end
    if g == nil then g = 255 end
    if starty == nil then starty = 0.0 end


    
    alpha = 200
    width = 0.2
    height = 0.04
    safeZoneOffset = (GetSafeZoneSize() / 2.5) - 0.4
    y = starty + (height / 2) - safeZoneOffset + 0.055
    x = (width / 2) - safeZoneOffset
    red = bgColor
    green = bgColor
    blue = bgColor

    if SBpos == 1 then
        x = (width / 2) - safeZoneOffset
    elseif SBpos == 2 then
        x = (width / 2) + 0.4
    else
        x = 1.0 - (width / 2) + safeZoneOffset
    end

    DrawRect(x, y, width, height, red, green, blue, alpha)

    DrawText(leftText, x - (width / 2) + 0.005, y - (height / 2) + 0.005, x + width, 1, r, g, b,size, font)
    DrawText(rightText, x - (width / 2), y - (height / 2) + 0.005, x + (width / 2) - 0.005, 2, r, g, b,size, font)



end

function DrawText(text, x, y, rightX, justification, r, g, b, size, font)
    if font == nil then font = 6 end
    if size == nil then size = 0.45 end
    if r == nil then r = 255 end
    if g == nil then g = 255 end
    if b == nil then b = 255 end
    if justification == nil then justification = 1 end

    SetTextWrap(x, rightX)
    SetTextFont(font)
    SetTextScale(1.0, size)
    SetTextJustification(justification);
    SetTextColour(r, g, b, 255)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

Citizen.CreateThread(function () 
    while true do 
        Wait(0)
<<<<<<< HEAD:resources/[trp]/trpsb/scoreboard.lua
        if IsControlPressed(0, 10) then
=======
        if IsControlPressed(0, 20) or IsControlPressed(0, 27) then
>>>>>>> 1944f7b0ae4524fefc47c1d881dfc019a9532de3:resources/[trp]/trpsb/scoreboard.lua
            DrawPList()
        end
    end
end)

local mpGamerTags = {}
Citizen.CreateThread(function () 
    while true do 
        Wait(0)
<<<<<<< HEAD:resources/[trp]/trpsb/scoreboard.lua
        if IsControlPressed(0, 10) then
=======
        if IsControlPressed(0, 20) or IsControlPressed(0, 27) then
>>>>>>> 1944f7b0ae4524fefc47c1d881dfc019a9532de3:resources/[trp]/trpsb/scoreboard.lua
            for i = 0, 255 do
                if NetworkIsPlayerActive(i) then
                    local ped = GetPlayerPed(i)

                    -- change the ped, because changing player models may recreate the ped
                    if not mpGamerTags[i] or mpGamerTags[i].ped ~= ped then
                    local nameTag = (GetPlayerServerId(i))

                    if mpGamerTags[i] then
                        RemoveMpGamerTag(mpGamerTags[i].tag)
                    end

                    mpGamerTags[i] = {
                        tag = CreateMpGamerTag(GetPlayerPed(i), nameTag, false, false, '', 0),
                        ped = ped
                    }
                    end
                else
                    RemoveMpGamerTag(mpGamerTags[i])

                    mpGamerTags[i] = nil
                end
            end
<<<<<<< HEAD:resources/[trp]/trpsb/scoreboard.lua
        elseif IsControlJustReleased(0, 10) then
=======
        elseif IsControlJustReleased(0, 20) or IsControlJustReleased(0, 27) then
>>>>>>> 1944f7b0ae4524fefc47c1d881dfc019a9532de3:resources/[trp]/trpsb/scoreboard.lua
            --print("Released" .. mpGamerTags[1])
            for i = 0, 255 do
                if NetworkIsPlayerActive(i) then
                    local ped = GetPlayerPed(i)
                    if mpGamerTags[i] then
                        RemoveMpGamerTag(mpGamerTags[i].tag)
                        mpGamerTags[i] = nil
                    end
                end
            end      
        end
    end
end)

