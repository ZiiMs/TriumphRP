RegisterCommand('me', function(source, args)
    local text = '* ' -- edit here if you want to change the language : EN: the person / FR: la personne
    for i = 1,#args do
        text = text .. ' ' .. args[i]
    end
    text = text .. ' *'
    timerEnable = false
    TriggerServerEvent('3dme:shareDisplay', text)

end)

RegisterNetEvent('3dme:triggerDisplay')
AddEventHandler('3dme:triggerDisplay', function(text, source)
    local offset = 1 + 0.14
    Display(GetPlayerFromServerId(source), text, offset)
end)

