MySQL.ready(function ()
    print("Mysql Data: " .. MySQL.Sync.fetchScalar('SELECT @parameters', {
        ['@parameters'] =  'string'
    }))
    local identifier = PlayerIdentifier('steam', players_server_id)
    MySQL.Sync.execute("INSERT INTO accounts (name, steamid) VALUES(" .. GetPlayerName(-1) .. ", " .. Get)
    print("Loaded: ")
end)

function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end


--steamid, id, name