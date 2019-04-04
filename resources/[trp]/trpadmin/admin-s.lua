RegisterServerEvent('saveMoney')
AddEventHandler('saveMoney', function(amount)
    local identifiers, steamIdentifier = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end
    MySQL.Async.execute("UPDATE accounts SET money=@money WHERE steamid=@steamid",
        {
            ['@money'] = amount,
            ['@steamid'] = steamIdentifier
        })
end)