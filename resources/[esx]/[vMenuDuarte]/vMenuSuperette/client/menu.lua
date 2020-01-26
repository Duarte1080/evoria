--||@SuperCoolDuarte.||--

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Superette", " ")
_menuPool:Add(mainMenu)

function notification(title, subject, msg)

	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
  
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
  
	UnregisterPedheadshot(mugshot)
  
end

function AddMenuBraqueur(menu)
        local submenu = _menuPool:AddSubMenu(menu, "Actions", "")
        local shopsmenu = _menuPool:AddSubMenu(menu, "Faire ses achats", "")
        AddShopsMenu(shopsmenu)


        local robapumoney = NativeUI.CreateItem("Braquer le vendeur", "")
        robapumoney:RightLabel("~r~12500 ~g~$")

        submenu.SubMenu:AddItem(robapumoney)

        local robapufood = NativeUI.CreateItem("Voler de la nourriture", "")
        submenu.SubMenu:AddItem(robapufood)

        submenu.SubMenu.OnItemSelect = function(menu, item)
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if item == robapumoney then
        _menuPool:CloseAllMenus()
        if IsPedArmed(GetPlayerPed(-1), 4) then
            holdupon = true
            canotif = true
            TaskAimGunAtCoord(GetPlayerPed(), 24.129, -1345.156, 30.000, 21000, true, true)
            startAnim(cashier["entity"], "mp_am_hold_up", "holdup_victim_20s")

            missionText("~h~Me tuer, j'ai des enfants !", 7000)

            Citizen.Wait(21000)
            TriggerServerEvent('mrv_robapu:rewards')
            spawnbag()
        else
            canotif = false
            startAnim(cashier["entity"], "mp_player_int_upperfinger", "mp_player_int_finger_01_enter")
            missionText("~h~partez ou j'appelle la police !", 5000)
        
		end
            holdupon = false
        end

        if item == robapufood and canrobfood then
            notification("Voleur", "", "Vous avez volé, la police sera au courant d'ici peu !")
            holdupon = true
            Citizen.Wait(1000)
            robfoodmax = robfoodmax + 1
            startAnim(GetPlayerPed(-1), "anim@am_hold_up@male", "shoplift_low")
            TriggerServerEvent('mrv_robapu:rewardsfood')
        end

        if callpolice then
            TriggerServerEvent('mrv_robapu:callPolice')
        end

        holdupon = false
        end
	end
end

function AddShopsMenu(menu)
    foodcat = _menuPool:AddSubMenu(menu.SubMenu, "Nourriture")
    accesscat = _menuPool:AddSubMenu(menu.SubMenu, "Multimédia")

    -------------------||CATEGORIE FOOD||--------------------
	local proWater = NativeUI.CreateItem("Eau", "")
    foodcat.SubMenu:AddItem(proWater)
    proWater:RightLabel("~g~2$")

	local proCoca = NativeUI.CreateItem("Coca cola", "")
    foodcat.SubMenu:AddItem(proCoca)
    proCoca:RightLabel("~g~2$")

	local proPain = NativeUI.CreateItem("Sandwich", "")
    foodcat.SubMenu:AddItem(proPain)
    proPain:RightLabel("~g~2$")

	local proChip = NativeUI.CreateItem("Chips", "")
    foodcat.SubMenu:AddItem(proChip)
    proChip:RightLabel("~g~2$")


-------------------||CATEGORIE Multimedia||--------------------
	local proTel = NativeUI.CreateItem("Téléphone", "")
    accesscat.SubMenu:AddItem(proTel)
    proTel:RightLabel("~g~2$")

    local proSim = NativeUI.CreateItem("Carte Sim", "")
    accesscat.SubMenu:AddItem(proSim)
    proSim:RightLabel("~g~2$")


    -------------------||CATEGORIE FOOD||--------------------
	foodcat.SubMenu.OnItemSelect = function(sender, item, index)
		if item == proWater then
			TriggerServerEvent('buyWater', 1)
		elseif item == proCoca then
			TriggerServerEvent('buyCoca', 1)
		elseif item == proPain then
			TriggerServerEvent('buyPain', 1)
		elseif item == proChip then
			TriggerServerEvent('buyChips', 1)
		end
    end

    -------------------||CATEGORIE Multimedia||--------------------
    accesscat.SubMenu.OnItemSelect = function(sender, item, index)
        if item == proTel then
            TriggerServerEvent('buyTel', 1)
        elseif item == proSim then
            TriggerServerEvent('buySim', 1)
		end
	end
end

AddMenuBraqueur(mainMenu)
_menuPool:MouseEdgeEnabled (false);
_menuPool:RefreshIndex()
