local tiempo = 3000
local isTazed = false
local ped
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		
		if IsPedBeingStunned(ped) then --Si le joueur est tazé
			SetPedToRagdoll(ped, 5000, 5000, 0, 0, 0, 0) --Ragdoll 
			ClearPedLastWeaponDamage(ped)
		end
		
		if IsPedBeingStunned(ped) and not isTazed then
			
			isTazed = true
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("HAND_SHAKE", 1.0)
			
		elseif not IsPedBeingStunned(ped) and isTazed then
			isTazed = false
			Wait(3000)
			
			SetTimecycleModifier("hud_def_desat_Trevor")
			
			Wait(10000)
			
      		SetTimecycleModifier("")
			SetTransitionTimecycleModifier("")
			StopGameplayCamShaking()
		end
	end
end)