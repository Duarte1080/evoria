ESX = nil
local grade = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
    grade = PlayerData.job.grade_name
    print("Grade:")
    print(grade)
end)

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("LSPD Armurerie", "~b~Armurerie LSPD")
_menuPool:Add(mainMenu)
_menuPool:WidthOffset(-50)

--Citizen.CreateThread(function()
--    while true do
--        while ESX == nil do
--            Wait(100)
--        end
--        if not _menuPool:IsAnyMenuOpen() then
--            mainMenu:Clear()
--            FirstItem(mainMenu)
--        end
--        Wait(5000)
--    end
--end)


local objets = {}

function FirstItem(menu) 

    local depose = NativeUI.CreateColouredItem("Déposer son équipement", "Déposez votre ~b~équipement.", Colours.RedDark, Colours.Red)
    depose:SetRightBadge(BadgeStyle.Alert)
    menu:AddItem(depose)

    --[[
    local submenu = _menuPool:AddSubMenu(menu, "Déposer objets illégaux")
    ESX.TriggerServerCallback('esx_policejob:getPlayerInventory', function(inventory)
        for i=1, #inventory, 1 do
            if inventory[i].count > 0 then
                local nom = inventory[i].name
                local label = ""..inventory[i].label.." x"..inventory[i].count
                objets[nom] = NativeUI.CreateItem(label, '')
                submenu.SubMenu:AddItem(objets[nom])   
            end
        end
        submenu.SubMenu.OnItemSelect = function(sender, item, index)
            for i=1, #inventory, 1 do
                local nom = inventory[i].name
                if item == objets[nom] then
                    DeposeObjets()
                    TriggerServerEvent("LSPD:DeposeObjets", inventory[i].name, inventory[i].count)
                    
                    _menuPool:CloseAllMenus()
                end
            end
        end
        
    end)
--]]
    if grade == 'recruit' then
        cadet = NativeUI.CreateItem("Equipement cadet", "~g~Permet de récupérer son équipement de Cadet.")

        menu:AddItem(cadet)
    elseif grade == 'officer' then
        officier = NativeUI.CreateItem("Equipement Officier", "~g~Permet de récupérer son équipement d'Officier.")
        officier:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(officier)
    elseif grade == 'sergeant' then
        sergeant = NativeUI.CreateItem("Equipement Sergent", "~g~Permet de récupérer son équipement de Sergent.")
        sergeant:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(sergeant)
    elseif grade == 'intendent' then
        intendent = NativeUI.CreateItem("Equipement Sergent-Chef", "~g~Permet de récupérer son équipement de Sergent-Chef.")
        intendent:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(intendent)
    elseif grade == 'lieutenant' then
        lieutenant = NativeUI.CreateItem("Equipement Lieutenant", "~g~Permet de récupérer son équipement de Lieutenant.")
        lieutenant:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(lieutenant)
    elseif grade == 'capitaine' then
        capitaine = NativeUI.CreateItem("Equipement Capitaine", "~g~Permet de récupérer son équipement de Capitaine.")
        capitaine:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(capitaine)
    elseif grade == 'bac' then
        bac = NativeUI.CreateItem("Equipement Bac", "~g~Permet de récupérer son équipement de la Bac.")
        bac:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(bac)
    elseif grade == 'chef' then
        chef = NativeUI.CreateItem("Equipement Capitaine", "~g~Permet de récupérer son équipement de Capitaine.")
        chef:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(chef)
    elseif grade == 'boss' then
        boss = NativeUI.CreateItem("Equipement Commandant", "~g~Permet de récupérer son équipement de Commandant.")
        boss:SetRightBadge(BadgeStyle.Gun)
        menu:AddItem(boss)
    end

    menu.OnItemSelect = function(sender, item, index)
        if item == cadet then
            if grade == 'recruit' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_STUNGUN", "pistol")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour cadet ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
        --	    GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
        	    GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)

        	    ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas cadet.', 'CHAR_AMMUNATION', 1)
            end
        elseif item == officier then
            if grade == 'officer' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_COMBATPISTOL", "pistol")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour officier ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas officier.', 'CHAR_AMMUNATION', 1)
            end 
        elseif item == sergeant then
            if grade == 'sergeant' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_ASSAULTSMG", "rifle")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour Sergent ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas sergent.', 'CHAR_AMMUNATION', 1)
            end 
        elseif item == intendent then
            if grade == 'intendent' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_PUMPSHOTGUN", "rifle")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour Sergent-Chef ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas Sheriff.', 'CHAR_AMMUNATION', 1)
            end 
        elseif item == lieutenant then
            if grade == 'lieutenant' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_PUMPSHOTGUN", "rifle")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour lieutenant ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas lieutenant.', 'CHAR_AMMUNATION', 1)
            end 
        elseif item == capitaine then
            if grade == 'capitaine' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_CARBINERIFLE", "rifle")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour capitaine ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas capitaine.', 'CHAR_AMMUNATION', 1)
            end
        elseif item == bac then
            if grade == 'bac' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_CARBINERIFLE", "rifle")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour bac? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas de la BAC.', 'CHAR_AMMUNATION', 1)
            end
        elseif item == chef then
            if grade == 'chef' then
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_CARBINERIFLE", "rifle")
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour Capitaine ? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas chef.', 'CHAR_AMMUNATION', 1)
            end
        elseif item == boss then
            if grade == 'boss' then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local clothesSkin = {
                        ['bags_1'] = 44
                    }
                    TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                end)
                GetWeaponByPed("WEAPON_CARBINERIFLE", "rifle")
                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Armes pour comissaire? Je te prépare ça.', 'CHAR_AMMUNATION', 1)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_COMBATPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_STUNGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_NIGHTSTICK", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHLIGHT", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_ASSAULTSMG", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_CARBINERIFLE", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_PUMPSHOTGUN", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_VINTAGEPISTOL", 255, false, false)
                GiveWeaponToPed(PlayerPedId(), "WEAPON_FLASHBANG", 25, false, false)
            
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Voila ton équipement, le perd pas.', 'CHAR_AMMUNATION', 1)
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", 0)
                
            else
                ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Mmh, désolé tu n\'est pas comissaire.', 'CHAR_AMMUNATION', 1)
            end
        elseif item == depose then
            PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
            ESX.ShowAdvancedNotification('LSPD INFO', '~b~Armurie LSPD', 'Vous voulez déposez vos armes de services ? Aucun problème je m\'en occupe.', 'CHAR_AMMUNATION', 1)
            local ped = GetPlayerPed(-1)
            DeposeEquipement("WEAPON_CARBINERIFLE", "rifle")
            RemoveAllPedWeapons(ped, false)
            TriggerEvent('skinchanger:getSkin', function(skin)
                local clothesSkin = {
                    ['bags_1'] = 0
                }
                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
            end)
        end
    end 

end


local count = 0
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        while ESX == nil do
            Citizen.Wait(10)
        end
        _menuPool:ProcessMenus()
        if count == 0 then
            FirstItem(mainMenu)
            count = 1
        end
    end
end)


_menuPool:RefreshIndex()
_menuPool:MouseControlsEnabled (false);
_menuPool:MouseEdgeEnabled (false);
_menuPool:ControlDisablingEnabled(false);



function OpenArmoryMenu(station)
    mainMenu:Clear()
    FirstItem(mainMenu)
    Wait(100)
    mainMenu:Visible(not mainMenu:Visible())
end

RegisterNetEvent('armory')
AddEventHandler('armory', function()
	OpenArmoryMenu(station)
end)