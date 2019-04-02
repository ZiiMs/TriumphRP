local display = false
RegisterCommand("help", function(source, args, rawCommand)
    local time = GetGameTimer()
    Citizen.CreateThread(function()
        TriggerEvent('nui:on')
        Wait(5000)
        TriggerEvent('nui:off')
    end)
end)

RegisterNetEvent('nui:on')
AddEventHandler('nui:on', function()
  SendNUIMessage({
    type = "ui",
    display = true
  })
end)

RegisterNetEvent('nui:off')
AddEventHandler('nui:off', function()
  SendNUIMessage({
    type = "ui",
    display = false
  })
end)

AddEventHandler('onClientResourceStart', function (resourceName)
    if(GetCurrentResourceName() ~= resourceName) then
      return
    end
    SendNUIMessage({
        type = "ui",
        display = false
      })
  end)