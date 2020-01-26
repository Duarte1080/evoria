--||@SuperCoolDuarte.||--

ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

local blips = {
    {title="Emplois", colour=29, id=590, x = -139.37, y = -631.857, z = 168.821}
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

local jobss = {
	{x = -139.37, y = -631.857, z = 168.821},
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()

        for k in pairs(jobss) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, jobss[k].x, jobss[k].y, jobss[k].z)

            if dist <= 3 then
                if GetLastInputMethod(0) then
                    ESX.ShowHelpNotification("~INPUT_TALK~ pour accéder a la recherche ~b~d'emplois") -- a rendre compatible
                else
                    ESX.ShowHelpNotification("~INPUT_CELLPHONE_RIGHT~ pour accéder a la recherche ~b~d'emplois") -- a rendre compatible
                end
                
				if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
					mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
    end
end)

_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end
Citizen.CreateThread(function()
    local defaultHash = 1567728751
    for i=1, #Config.Locations do
        local myPedemplois = Config.Locations[i]["myPedemplois"]
        if myPedemplois then
            myPedemplois["hash"] = myPedemplois["hash"] or defaultHash
            _RequestModel(myPedemplois["hash"])
            if not DoesEntityExist(myPedemplois["entity"]) then
                myPedemplois["entity"] = CreatePed(4, myPedemplois["hash"], myPedemplois["x"], myPedemplois["y"], myPedemplois["z"], myPedemplois["h"], 0, 0)
                SetEntityAsMissionEntity(myPedemplois["entity"])
                SetBlockingOfNonTemporaryEvents(myPedemplois["entity"], true)
                FreezeEntityPosition(myPedemplois["entity"], false)
				SetEntityInvincible(myPedemplois["entity"], true)
				SetPedDiesWhenInjured(myPedemplois["entity"], false)
				SetPedCanPlayAmbientAnims(myPedemplois["entity"], true)
				SetPedCanRagdollFromPlayerImpact(myPedemplois["entity"], false)
            end
            SetModelAsNoLongerNeeded(myPedemplois["hash"])
        end
    end
end)

DeleteMyPed = function()
    for i=1, #Config.Locations do
        local myPedemplois = Config.Locations[i]["myPedemplois"]
        if DoesEntityExist(myPedemplois["entity"]) then
            DeletePed(myPedemplois["entity"])
            SetPedAsNoLongerNeeded(myPedemplois["entity"])
        end
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteMyPed()
    end
end)