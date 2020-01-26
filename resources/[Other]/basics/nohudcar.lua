local inVehicle = false
local ped = PlayerPedId()
Citizen.CreateThread(function()
    while(true) do
        if inVehicle then
            DisplayRadar(true)
        else
        	DisplayRadar(false)
        end
        
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while(true) do
        inVehicle = IsPedInAnyVehicle(ped, true)
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		player = PlayerId()

	    SetPedDensityMultiplierThisFrame(0) -- La densité des PED
	    SetRandomVehicleDensityMultiplierThisFrame(0.1) --La densité des véhicule
	    SetParkedVehicleDensityMultiplierThisFrame(0.2) -- La densité des véhicule garer
		SetScenarioPedDensityMultiplierThisFrame(0, 0) --La densité des animation des PNJ

		SetPlayerWantedLevel(player, 0, false)
		SetPlayerWantedLevelNow(player, false)
	end
end)