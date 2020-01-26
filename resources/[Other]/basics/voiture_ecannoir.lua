local isBlackedOut = false
local oldBodyDamage = 0
local oldSpeed = 0

local function blackout()
    if not isBlackedOut then
        isBlackedOut = true
        Citizen.CreateThread(function()
            DoScreenFadeOut(1)
            while not IsScreenFadedOut() do
                Citizen.Wait(0)
            end
            ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.5)
            SetTimecycleModifier("Barry1_Stoned")
            Citizen.Wait(2000)
            DoScreenFadeIn(4000)
            Citizen.Wait(3000)
            SetTimecycleModifier("")
            SetTransitionTimecycleModifier("")
            StopGameplayCamShaking()
            isBlackedOut = false
        end)
    end
end





Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if DoesEntityExist(vehicle) then

            local currentSpeed = GetEntitySpeed(vehicle) * 3.6
            if currentSpeed ~= oldSpeed then
                if not isBlackedOut and (currentSpeed < oldSpeed) and ((oldSpeed - currentSpeed) >= 90) then
                    blackout()
                end
                oldSpeed = currentSpeed
            end
        else
            oldBodyDamage = 0
            oldSpeed = 0
        end

        if isBlackedOut then
            DisableControlAction(0,71,true) 
            DisableControlAction(0,72,true) 
            DisableControlAction(0,63,true) 
            DisableControlAction(0,64,true) 
            DisableControlAction(0,75,true) 
        end
    end
end)


--[[------------------------------------------------------------------------
    Remove Reticle on ADS (Third Person) Resource created by TheLukasGran
------------------------------------------------------------------------]]--
local scopedWeapons = 
{
    100416529,  -- WEAPON_SNIPERRIFLE
    205991906,  -- WEAPON_HEAVYSNIPER
    3342088282  -- WEAPON_MARKSMANRIFLE
}

function HashInTable( hash )
    for k, v in pairs( scopedWeapons ) do 
        if ( hash == v ) then 
            return true 
        end 
    end 

    return false 
end 

function ManageReticle()
    local ped = GetPlayerPed( -1 )

    if ( DoesEntityExist( ped ) and not IsEntityDead( ped ) ) then
        local _, hash = GetCurrentPedWeapon( ped, true )

        if ( GetFollowPedCamViewMode() ~= 4 and IsPlayerFreeAiming() and not HashInTable( hash ) ) then 
            HideHudComponentThisFrame( 14 )
        end 
    end 
end 

Citizen.CreateThread( function()
    while true do 
	
		HideHudComponentThisFrame( 14 )		
		Citizen.Wait( 0 )

    end 
end )