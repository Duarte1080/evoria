-----------------------------------||KO Systeme||-----------------------------------
local knockedOut = false
local wait = 15
local count = 60

function drawHelpTxt(x,y ,width,height,scale, text, r,g,b,a,font)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawTimerBar()
	maxvalue = 0.001
	width = 0.2
	height = 0.025
	xvalue = 0.38
	yvalue = 0.05
	outlinecolour = {0, 0, 0, 150}
	barcolour = {0, 0, 0}
	DrawRect(xvalue + (width/2), yvalue, width + 0.004, height + 0.006705, outlinecolour[1], outlinecolour[2], outlinecolour[3], outlinecolour[4]) -- Box that creates outline
	drawHelpTxt(xvalue + (((maxvalue/2)/((maxvalue/2)/width))/2), yvalue + 0.0275, 0.07, 0.1, 0.5, "Vous êtes ko !", 255, 255, 255, 255, 6) -- Text display of timer
	DrawRect(xvalue + (width/2), yvalue, width, height, barcolour[1], barcolour[2], barcolour[3], 255) --  Static full bar
	DrawRect(xvalue + ((maxvalue/width)/2), yvalue, (maxvalue/width), height, barcolour[1], barcolour[2], barcolour[3], 255)
end

Citizen.CreateThread(function()
	while true do
		Wait(1)
		local myPed = GetPlayerPed(-1)
		player = PlayerId()

		if IsPedInMeleeCombat(myPed) then
			if GetEntityHealth(myPed) < 125 then
				SetPlayerInvincible(player, true)
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				SetTimecycleModifier("REDMIST_blend")

				wait = 15
				knockedOut = true
				SetEntityHealth(myPed, 116)
			end
		end
		if knockedOut == true then
			DrawTimerBar()
			SetPlayerInvincible(player, true)
			DisablePlayerFiring(player, true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			SetTimecycleModifier("hud_def_desat_Trevor")
			DisableControlAction(0, 1,   true)
			DisableControlAction(0, 2,   true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 106, true)
			DisableControlAction(0, 12, true)
			DisableControlAction(0, 14, true)
			DisableControlAction(0, 15, true)
			DisableControlAction(0, 16, true)
			DisableControlAction(0, 17, true)
			ResetPedRagdollTimer(myPed)
			
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
				end
			else
				SetPlayerInvincible(player, false)
				knockedOut = false
				SetTimecycleModifier("")
				SetTransitionTimecycleModifier("")
				StopGameplayCamShaking()
			end
		end
	end
end)