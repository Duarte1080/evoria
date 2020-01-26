Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    if IsPauseMenuActive() and not IsPaused then
	  IsPaused = true
    SendNUIMessage({action = "toggle", show = false})
    elseif not IsPauseMenuActive() and IsPaused then 
    IsPaused = false
    SendNUIMessage({action = "toggle", show = true})
    end
  end
end)

RegisterNetEvent('ui:toggle')
AddEventHandler('ui:toggle', function(show)
	SendNUIMessage({action = "toggle", show = show})
end)

AddEventHandler('ui:updateStatus', function(status)
  SendNUIMessage({action = "updateStatus", status = status})
end)
