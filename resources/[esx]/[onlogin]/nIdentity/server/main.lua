--||@SuperCoolNinja.||--
RegisterServerEvent("nIdentity:UpdateName")
AddEventHandler("nIdentity:UpdateName", function(nameInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newName = nameInput
	if (tostring(newName) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET firstname=@nameInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@nameInput'] = tostring(newName)})
	--print(identifier)
end)

RegisterServerEvent("nIdentity:UpdatePrenom")
AddEventHandler("nIdentity:UpdatePrenom", function(prenomInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newPrenom = prenomInput
	if (tostring(newPrenom) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET lastname=@prenomInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@prenomInput'] = tostring(newPrenom)})
end)

RegisterServerEvent("nIdentity:UpdateTaille")
AddEventHandler("nIdentity:UpdateTaille", function(tailleInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newTaille = tailleInput
	if (tonumber(tailleInput) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET height=@tailleInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@tailleInput'] = tonumber(newTaille)})
end)


RegisterServerEvent("nIdentity:Updatesex")
AddEventHandler("nIdentity:Updatesex", function(sexInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newsex = sexInput
	if (tostring(sexInput) == nil) then
		return false
	  end
	MySQL.Async.execute("UPDATE users SET sex=@sexInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@sexInput'] = tostring(newsex)})
end)

RegisterServerEvent("nIdentity:UpdateAge")
AddEventHandler("nIdentity:UpdateAge", function(ageInput)
	local source = source
	local identifier = GetPlayerIdentifiers(source)[1]
	local newAge = ageInput
	if (tostring(ageInput) == nil) then
      return false
	end
	MySQL.Async.execute("UPDATE users SET age=@ageInput WHERE identifier=@identifier", {['@identifier'] = identifier,['@ageInput'] = tostring(newAge)})
end)