Citizen.CreateThread(function()
	while true do
            SetVehicleDensityMultiplierThisFrame(0.01)
            --SetPedDensityMultiplierThisFrame(0)
            SetRandomVehicleDensityMultiplierThisFrame(0.01)
            SetParkedVehicleDensityMultiplierThisFrame(0.01)
            --SetScenarioPedDensityMultiplierThisFrame(0, 5)
            SetGarbageTrucks(0)
            SetRandomBoats(0)
		Citizen.Wait(1)
	end
end)