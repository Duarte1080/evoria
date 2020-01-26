--||@SuperCoolNinja.& Duarte||--
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

local blips = {
    {title="Location de véhicule", colour=69, id=225, x = -704.023, y = -1398.23, z = 5.49529}
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
	{x = -704.023, y = -1398.23, z = 5.49529},
}

function missionText(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function startAnim(entity, lib, anim)
	ESX.Streaming.RequestAnimDict(lib, function()
		TaskPlayAnim(entity, lib, anim, 8.0, -8.0, -1, 0, 0, false, false, false)
	end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPoolLoca:ProcessMenus()

        for k in pairs(jobss) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, jobss[k].x, jobss[k].y, jobss[k].z)

            if dist <= 3 then
                if GetLastInputMethod(0) then
                    ESX.ShowHelpNotification("~INPUT_TALK~ pour faire une location de ~b~véhicule") -- a rendre compatible
                else
                    ESX.ShowHelpNotification("~INPUT_CELLPHONE_RIGHT~ pour faire une location de ~b~véhicule") -- a rendre compatible
                end
                
                if (IsControlJustReleased(0, 54) or IsControlJustReleased(0, 175)) then
                    missionText("~h~Vendeur: Hey !", 7000)
                    mainMenuLoc:Visible(not mainMenuLoc:Visible())
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
    local defaultHash = -261389155
    for i=1, #Config.Locations do
        local myPedLocation = Config.Locations[i]["myPedLocation"]
        if myPedLocation then
            myPedLocation["hash"] = myPedLocation["hash"] or defaultHash
            _RequestModel(myPedLocation["hash"])
            if not DoesEntityExist(myPedLocation["entity"]) then
                myPedLocation["entity"] = CreatePed(4, myPedLocation["hash"], myPedLocation["x"], myPedLocation["y"], myPedLocation["z"], myPedLocation["h"], 0, 0)
                SetEntityAsMissionEntity(myPedLocation["entity"])
                SetBlockingOfNonTemporaryEvents(myPedLocation["entity"], true)
                FreezeEntityPosition(myPedLocation["entity"], false)
				SetEntityInvincible(myPedLocation["entity"], true)
				SetPedDiesWhenInjured(myPedLocation["entity"], false)
				SetPedCanPlayAmbientAnims(myPedLocation["entity"], true)
				SetPedCanRagdollFromPlayerImpact(myPedLocation["entity"], false)
            end
            SetModelAsNoLongerNeeded(myPedLocation["hash"])
        end
    end
end)

DeleteMyPed = function()
    for i=1, #Config.Locations do
        local myPedLocation = Config.Locations[i]["myPedLocation"]
        if DoesEntityExist(myPedLocation["entity"]) then
            DeletePed(myPedLocation["entity"])
            SetPedAsNoLongerNeeded(myPedLocation["entity"])
        end
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        DeleteMyPed()
    end
end)