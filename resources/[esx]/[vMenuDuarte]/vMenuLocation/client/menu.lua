local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

ESX = nil


_menuPoolLoca = NativeUI.CreatePool()
mainMenuLoc = NativeUI.CreateMenu("Location de véhicule", "")
_menuPoolLoca:Add(mainMenuLoc)

function AddMenuLocation(menu)
	local carCaddy = GetHashKey("Caddy2")
	local playerPed = GetPlayerPed(-1)
	--------------||SOUS MENU||----------------
	local submenuVeh = _menuPoolLoca:AddSubMenu(menu, "~h~Liste des véhicules disponible", "")

	--------------||EVENT AUTRES||----------------
	local vehVONE = NativeUI.CreateItem("Véhicule de touriste", "")
	vehVONE:RightLabel("~h~0 ~g~$")

	
	submenuVeh.SubMenu:AddItem(vehVONE)

	--------------||Selection LISTE JOBS||----------------
	submenuVeh.SubMenu.OnItemSelect = function(menu, item)
	for i=1, #Config.Locations do
			local myPedLocation = Config.Locations[i]["myPedLocation"]
		if item == vehVONE then
			startAnim(myPedLocation["entity"], "anim@mp_player_intupperthumbs_up", "enter")
			_menuPoolLoca:CloseAllMenus()
			if playerPed and playerPed ~= -1 then
				RequestModel(carCaddy)
				while not HasModelLoaded(carCaddy) do
					Citizen.Wait(0)
				end
				lastvehAmbu = CreateVehicle(carCaddy, -709.05, -1406.93, 5.00053, 0.0, true, false)
				missionText("~g~Vendeur ~w~: ~h~ Votre véhicule vous attend derrière vous !", 7000)
			   end
			end
		end
	end
end

AddMenuLocation(mainMenuLoc)
_menuPoolLoca:MouseEdgeEnabled (false);
_menuPoolLoca:RefreshIndex()
_menuPoolLoca:MouseEdgeEnabled (false);
_menuPoolLoca:RefreshIndex()