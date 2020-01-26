--||@SuperCoolNinja.||--

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

local blips = {
    {title="Passeport", colour=5, id=498, -8.5653, y = -1510.04, z = 29.9257}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)

local idenPos = {
	{x = -8.5653, y = -1510.04, z = 29.9257},
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()

        for k in pairs(idenPos) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, idenPos[k].x, idenPos[k].y, idenPos[k].z)

            if dist <= 3 then
                if GetLastInputMethod(0) then
                    ESX.ShowHelpNotification("~INPUT_TALK~ pour créer votre ~b~passeport")
                else
                    ESX.ShowHelpNotification("~INPUT_CELLPHONE_RIGHT~ pour créer votre ~b~passeport")
                end
                
				if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
					mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
    end
end)