--||@SuperCoolDuarte.||--
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

ESX = nil

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Bienvenue: ", "")
_menuPool:Add(mainMenu)

function myNotification(title, subject, msg)

	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
  
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
  
	UnregisterPedheadshot(mugshot)
end

function AddMenuJobMenu(menu)

		--------------||SOUS MENU||----------------
		local submenu = _menuPool:AddSubMenu(menu, "~h~Liste des emplois sans ~b~diplome ~w~:", "")

		--------------||EVENT AUTRES||----------------
		local chome = NativeUI.CreateItem("Chômage", "")
		local fermierJob = NativeUI.CreateItem("Fermier", "")
		local slaughJob = NativeUI.CreateItem("Abatteur", "")
		local minerJob = NativeUI.CreateItem("Mineur", "")
		local textilJob = NativeUI.CreateItem("Couturier", "")
		
		submenu.SubMenu:AddItem(chome)
		submenu.SubMenu:AddItem(fermierJob)
		submenu.SubMenu:AddItem(slaughJob)
		submenu.SubMenu:AddItem(minerJob)
		submenu.SubMenu:AddItem(textilJob)

		--------------||Selection LISTE JOBS||----------------
		submenu.SubMenu.OnItemSelect = function(menu, item)
		
		if item == chome then 
			TriggerServerEvent('esx_joblisting:setJobChome')
			myNotification("Emploi", "", "Voici votre nouveau job!")
		elseif item == fermierJob then
			TriggerServerEvent('esx_joblisting:setJobMiner')
			myNotification("Emploi", "", "Voici votre nouveau job!")
		elseif item == slaughJob then
			TriggerServerEvent('esx_joblisting:setJobslaughterer')
			myNotification("Emploi", "", "Voici votre nouveau job!")
		elseif item == minerJob then
			TriggerServerEvent('esx_joblisting:setJobminer')
			myNotification("Emploi", "", "Voici votre nouveau job!")
		elseif item == minerJob then
			TriggerServerEvent('esx_joblisting:setJobminer')
			myNotification("Emploi", "", "Voici votre nouveau job!")
		elseif item == textilJob then
			TriggerServerEvent('esx_joblisting:setJobtextil')
			myNotification("Emploi", "", "Voici votre nouveau job!")
		end
	end
end

AddMenuJobMenu(mainMenu)
_menuPool:MouseEdgeEnabled (false);
_menuPool:RefreshIndex()