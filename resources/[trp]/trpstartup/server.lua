MySQL.ready(function ()
    print("[MYSQL]: " .. MySQL.Sync.fetchScalar('SELECT @parameters', {
        ['@parameters'] =  'Successfully connected!'
    }))
end)
local wb
local money

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
            TriggerClientEvent('loadMoney', lastSource, 2500)
            wb = false
        end
    end)
    if not steamIdentifier then
        deferrals.done("You are not connected to steam.")
    else
        deferrals.done()
    end
end

RegisterNetEvent('serverPlayerSpawned')
AddEventHandler('serverPlayerSpawned', function(returning)
    if wb == false then
        TriggerClientEvent('chatMessage', source, "", { 255, 255, 255}, "Welcome " .. GetPlayerName(source) .. " to Triumph RP.")
        TriggerClientEvent('loadMoney', source, 2500)
    else
        TriggerClientEvent('chatMessage', source, "", { 255, 255, 255}, "Welcome back to Triumph RP " .. GetPlayerName(source) .. ".")
        TriggerClientEvent('loadMoney', source, money)
    end
end)

AddEventHandler("playerConnecting", OnPlayerConnecting)


--steamid, id, name