AddEventHandler('playerSpawned', function(spawn)
    print("Test!")
	TriggerServerEvent("serverPlayerSpawned", spawn)
end)