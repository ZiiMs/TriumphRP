MySQL.ready(function ()
    print("[MYSQL]: " .. MySQL.Sync.fetchScalar('SELECT @parameters', {
        ['@parameters'] =  'Successfully connected!'
    }))
end)
local wb
local money

function GetSteam(source)
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    return steamIdentifier
end

local function OnPlayerConnecting(name, setKickReason, deferrals)
    local lastSource = source
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    deferrals.defer()

    deferrals.update(string.format("Hello %s. Your steam id is being checked.", name))
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    MySQL.Async.fetchAll('SELECT * FROM accounts WHERE steamid=@steamid', {['@steamid'] = steamIdentifier}, function(gotInfo)
        if gotInfo[1] ~= nil then
            print("Info1: ".. gotInfo[1].id)
            print("Info2: ".. gotInfo[1].name)
            print("Info3: ".. gotInfo[1].steamid)
            print("Info4: "..gotInfo[1].money)
            money = gotInfo[1].money
            wb = true
        else 
            MySQL.Async.execute("INSERT INTO accounts (name, steamid) VALUES (@name, @steamid)",
                {
                    ['@name'] = name,
                    ['@steamid'] = steamIdentifier
                })
            TriggerClientEvent('setData', lastSource, steamIdentifier, 2500)
            wb = false
        end
    end)
    if not steamIdentifier then
        deferrals.done("You are not connected to steam.")
    else
        deferrals.done()
    end
end

local function onResourceStart(name, setKickReason)
    local lastSource = source
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    MySQL.Async.fetchAll('SELECT * FROM accounts WHERE steamid=@steamid', {['@steamid'] = steamIdentifier}, function(gotInfo)
        if gotInfo[1] ~= nil then
            print("Info1: ".. gotInfo[1].id)
            print("Info2: ".. gotInfo[1].name)
            print("Info3: ".. gotInfo[1].steamid)
            print("Info4: "..gotInfo[1].money)
            money = gotInfo[1].money
            TriggerClientEvent('setData', lastSource, gotInfo[1].steamid, tonumber(gotInfo[1].money))
        else 
            MySQL.Async.execute("INSERT INTO accounts (name, steamid) VALUES (@name, @steamid)",
                {
                    ['@name'] = name,
                    ['@steamid'] = steamIdentifier
                })
            TriggerClientEvent('setData', lastSource, steamIdentifier, 2500)
            wb = false
        end
    end)
end




RegisterNetEvent('serverPlayerSpawned')
AddEventHandler('serverPlayerSpawned', function(returning)
    if wb == false then
        TriggerClientEvent('chatMessage', source, "", { 255, 255, 255}, "Welcome " .. GetPlayerName(source) .. " to Triumph RP.")
        TriggerClientEvent('setData', source, GetSteam(source), 2500)
        print("Spawning!")
    else
        TriggerClientEvent('chatMessage', source, "", { 255, 255, 255}, "Welcome back to Triumph RP " .. GetPlayerName(source) .. ".")
        TriggerClientEvent('setData', source, GetSteam(source), money)
        print("Spawning!2")
    end
end)

AddEventHandler("playerConnecting", OnPlayerConnecting)

RegisterNetEvent('resourceStarted')
AddEventHandler("resourceStarted", onResourceStart)


--steamid, id, name