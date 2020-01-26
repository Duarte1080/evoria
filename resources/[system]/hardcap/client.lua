Citizen.CreateThread(function()
	while true do
		Wait(10)

		if NetworkIsSessionStarted() then
			TriggerServerEvent('hardcap:playerActivated')

			return
		end
	end
end)