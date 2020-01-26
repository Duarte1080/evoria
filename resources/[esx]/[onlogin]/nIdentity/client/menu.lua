--||@SuperCoolDuarte.||--
local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

ESX = nil
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Mairie", "")
_menuPool:Add(mainMenu)

function myNotification(title, subject, msg)
	local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(-1))
	ESX.ShowAdvancedNotification(title, subject, msg, mugshotStr, 1)
	UnregisterPedheadshot(mugshot)
end

local nameInput, prenomInput,tailleInput,sexInput,ageInput = nil, nil, nil, nil

local function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		return result --Returns the result
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function IdentityMenu(menu)
    local nomItem = NativeUI.CreateItem("Votre Nom: ", "~h~Veuillez saisir votre nom commençant par une lettre Majuscule.")
    menu:AddItem(nomItem)

    local prenomItem = NativeUI.CreateItem("Votre Prénom: ", "~h~Veuillez saisir votre prénom commençant par une lettre Majuscule.")
    menu:AddItem(prenomItem)
	
	local tailleItem = NativeUI.CreateItem("Votre Taille: ", "~h~Exemple 180 qui est égal à 1 mètre 80")
    menu:AddItem(tailleItem)

    local sexItem = NativeUI.CreateItem("Votre Sexe: ", "~h~Veuillez saisir votre sexe : Homme (M) / Femme (F)")
    menu:AddItem(sexItem)
    
    local ageItem = NativeUI.CreateItem("Votre Âge: ", "Veuillez saisir votre Âge exemple: 31/12/2005")
    menu:AddItem(ageItem)

    local saveIdentiter = NativeUI.CreateColouredItem("Valider votre identité", "", Colours.GreenDark, Colours.Green)
    menu:AddItem(saveIdentiter)

    menu.OnItemSelect = function(sender, item, index)
        if item == nomItem then
            local nameInput = KeyboardInput("Votre Nom :", "", 10)
            if tostring(nameInput) == nil then
                myNotification("Mairie: ", "", "Veuillez inserer un nombre correct !")
				return false
			else
				nomItem:RightLabel(tostring(nameInput))
				TriggerServerEvent("nIdentity:UpdateName", tostring(nameInput))
				print("Nom good !")
            end
        elseif item == prenomItem then
            local prenomInput = KeyboardInput("Votre Prénom :", "", 10)
            if tostring(prenomInput) == nil then
                myNotification("Mairie: ", "", "Veuillez inserer un nombre correct !")
				return false
			else
				prenomItem:RightLabel(tostring(prenomInput))
				TriggerServerEvent("nIdentity:UpdatePrenom", tostring(prenomInput))
				print("Prenom good !")
            end
        elseif item == tailleItem then
            local tailleInput = KeyboardInput("Votre Taille :", "", 3)
            if tonumber(tailleInput) == nil then
                myNotification("Mairie: ", "", "Veuillez inserer un nombre correct !")
				return false
			else
				tailleItem:RightLabel(tailleInput)
				TriggerServerEvent("nIdentity:UpdateTaille", tonumber(tailleInput))
				print("Taille good !")
			end
		elseif item == sexItem then
            local sexInput = KeyboardInput("Votre Sex :", "", 1)
            if tostring(sexInput) == nil then
                myNotification("Mairie: ", "", "Veuillez inserer un nombre correct !")
				return false
			else
				sexItem:RightLabel(sexInput)
				TriggerServerEvent("nIdentity:Updatesex", tostring(sexInput))
				print("sex good !")
            end
        elseif item == ageItem then
            local ageInput = KeyboardInput("Âge :", "", 10)
            if tostring(ageInput) == nil then
				myNotification("Mairie: ", "", "Veuillez inserer un nombre correct !")
				return false
			else
				ageItem:RightLabel(ageInput .." ans")
				TriggerServerEvent("nIdentity:UpdateAge", tostring(ageInput))
				print("age good !")
            end
        elseif item == saveIdentiter then
            _menuPool:CloseAllMenus(true)
        end
    end
end

IdentityMenu(mainMenu)
_menuPool:MouseEdgeEnabled(false);
_menuPool:RefreshIndex()