--------||DEATH SCREEN||---------
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

_nDrawTimeRea = function()
	maxvalue = 0.001
	width = 0.2
	height = 0.025
	xvalue = 0.38
	yvalue = 0.05
	outlinecolour = {0, 0, 0, 150}
	barcolour = {0, 0, 0}
	DrawRect(xvalue + (width/2), yvalue, width + 0.004, height + 0.006705, outlinecolour[1], outlinecolour[2], outlinecolour[3], outlinecolour[4]) -- Box that creates outline
	drawHelpTxt(xvalue + (((maxvalue/2)/((maxvalue/2)/width))/2), yvalue , 0.15, 0.05, 0.5, "~r~réapparition ~w~possible dans ~g~2 minutes ~w~.", 255, 255, 255, 255, 6) -- Text display of timer
	DrawRect(xvalue + (width/2), yvalue, width, height, barcolour[1], barcolour[2], barcolour[3], 255) --  Static full bar
	DrawRect(xvalue + ((maxvalue/width)/2), yvalue, (maxvalue/width), height, barcolour[1], barcolour[2], barcolour[3], 255)
end

_nDrawRea = function()
	maxvalue = 0.001
	width = 0.3
	height = 0.030
	xvalue = 0.38
	yvalue = 0.05
	outlinecolour = {0, 0, 0, 150}
	barcolour = {0, 0, 0}
	DrawRect(xvalue + (width/2), yvalue, width + 0.004, height + 0.006705, outlinecolour[1], outlinecolour[2], outlinecolour[3], outlinecolour[4]) -- Box that creates outline
	drawHelpTxt(xvalue + (((maxvalue/3)/((maxvalue/2)/width))/2), yvalue , 0.15, 0.05, 0.5, "Maintenir [~b~E~s~] pour ~r~respawn ~w~ou patientez l'arrivé des ~y~urgence~w~.", 255, 255, 255, 255, 6) -- Text display of timer
	DrawRect(xvalue + (width/2), yvalue, width, height, barcolour[1], barcolour[2], barcolour[3], 255) --  Static full bar
	DrawRect(xvalue + ((maxvalue/width)/2), yvalue, (maxvalue/width), height, barcolour[1], barcolour[2], barcolour[3], 255)
end

_nDrawComa = function()
	maxvalue = 0.001
	width = 0.5
	height = 0.09
	xvalue = 0.25
	yvalue = 0.5
	outlinecolour = {0, 0, 0, 150}
	barcolour = {0, 0, 0}
	DrawRect(xvalue + (width/2), yvalue, width + 0.004, height + 0.006705, outlinecolour[1], outlinecolour[2], outlinecolour[3], outlinecolour[4]) -- Box that creates outline
	drawHelpTxt(xvalue + (((maxvalue/2)/((maxvalue/2)/width))/2), yvalue , 0.4, 0.14, 2.0, "Vous êtes dans le ~r~coma ~w~!", 255, 255, 255, 255, 6) -- Text display of timer
	DrawRect(xvalue + (width/2), yvalue, width, height, barcolour[1], barcolour[2], barcolour[3], 255) --  Static full bar
	DrawRect(xvalue + ((maxvalue/width)/2), yvalue, (maxvalue/width), height, barcolour[1], barcolour[2], barcolour[3], 255)
end

HideHUDThisFrame = function()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1)
	HideHudComponentThisFrame(2)
	HideHudComponentThisFrame(3)
	HideHudComponentThisFrame(4)
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

DrawGenericTextThisFrame = function()
	SetTextFont(4)
	SetTextScale(0.0, 0.5)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end