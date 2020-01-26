--||@SuperCoolNinja.& Duarte||--

ESX = nil
holdupon = false
robfoodmax = 0
canrobfood = false
chancecall = math.random(1, 100)
callpolice = false
canotif = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end


    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
	for shop = 1, #Config.Locations do
			local cashier = Config.Locations[shop]["cashier"]
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
			local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), cashier["x"], cashier["y"], cashier["z"], true)

            if dist <= 2 and holdupon == false then
                ESX.ShowHelpNotification("~INPUT_TALK~ pour intéragir avec le ~b~Vendeur~s~")
			if IsControlJustPressed(1,51) then 
				mainMenu:Visible(not mainMenu:Visible())
            end
        end
	end
        local v1 = vector3(24.129, -1345.156, 30.650)

        if robfoodmax >= Config.RobFoodMax then
            canrobfood = false
        else
            canrobfood = true
        end

        if chancecall <= Config.ChanceOfCallPolice and canotif then
            callpolice = true
        else
            callpolice = false
        end
        
    end
end)

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

function spawnbag()
    local object = GetHashKey("p_poly_bag_01_s")

    RequestModel(object)
    while (not HasModelLoaded(object)) do
        Wait(1)
    end
    
    local playerped = GetPlayerPed(-1)
    local x,y,z = table.unpack(GetEntityCoords(playerped))

    prop = CreateObject(object, 26.266, -1345.581, 28.497, true, false, true)

    Citizen.Wait(1000)

    DeleteEntity(prop)
end

--[[ Requests specified model ]]--
_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

--[[ Deletes the cashiers ]]--
DeleteCashier = function()
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if DoesEntityExist(cashier["entity"]) then
            DeletePed(cashier["entity"])
            SetPedAsNoLongerNeeded(cashier["entity"])
        end
    end
end

Citizen.CreateThread(function()
    local defaultHash = 416176080
    for i=1, #Config.Locations do
        local cashier = Config.Locations[i]["cashier"]
        if cashier then
            cashier["hash"] = cashier["hash"] or defaultHash
            _RequestModel(cashier["hash"])
            if not DoesEntityExist(cashier["entity"]) then
                cashier["entity"] = CreatePed(4, cashier["hash"], cashier["x"], cashier["y"], cashier["z"], cashier["h"])
                SetEntityAsMissionEntity(cashier["entity"])
                SetBlockingOfNonTemporaryEvents(cashier["entity"], true)
                FreezeEntityPosition(cashier["entity"], true)
                SetEntityInvincible(cashier["entity"], true)
            end
            SetModelAsNoLongerNeeded(cashier["hash"])
        end
    end
end)

--[[ Creates cashiers and blips ]]--
Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local blip = Config.Locations[i]["blip"]

        if blip then
            if not DoesBlipExist(blip["id"]) then
                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
                SetBlipSprite(blip["id"], 52)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 1.0)
                SetBlipColour(blip["id"], 25)
                SetBlipAsShortRange(blip["id"], true)

                BeginTextCommandSetBlipName("shopblip")
                AddTextEntry("shopblip", "Superette")
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end
end)


--[[ Deletes the peds when the resource stops ]]--
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        --TriggerServerEvent('esx:clientLog', "[99kr-shops]: Deleting peds...")
        DeleteCashier()
    end
end)