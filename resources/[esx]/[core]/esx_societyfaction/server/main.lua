ESX                 = nil
Jobs                = {}
RegisteredSocieties = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function stringsplit(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function GetSociety(name)
  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      return RegisteredSocieties[i]
    end
  end
end

AddEventHandler('onMySQLReady', function()

  local result = MySQL.Sync.fetchAll('SELECT * FROM faction', {})

  for i=1, #result, 1 do
    Jobs[result[i].name]        = result[i]
    Jobs[result[i].name].grades = {}
  end

  local result2 = MySQL.Sync.fetchAll('SELECT * FROM faction_grades', {})

  for i=1, #result2, 1 do
    Jobs[result2[i].faction_name].grades[tostring(result2[i].grade)] = result2[i]
  end

end)

AddEventHandler('esx_societyfaction:registerSociety', function(name, label, account, datastore, inventory, data)

  local found = false

  local society = {
    name      = name,
    label     = label,
    account   = account,
    datastore = datastore,
    inventory = inventory,
    data      = data,
  }

  for i=1, #RegisteredSocieties, 1 do
    if RegisteredSocieties[i].name == name then
      found                  = true
      RegisteredSocieties[i] = society
      break
    end
  end

  if not found then
    table.insert(RegisteredSocieties, society)
  end

end)

AddEventHandler('esx_societyfaction:getSocieties', function(cb)
  cb(RegisteredSocieties)
end)

AddEventHandler('esx_societyfaction:getSociety', function(name, cb)
  cb(GetSociety(name))
end)

RegisterServerEvent('esx_societyfaction:withdrawMoney')
AddEventHandler('esx_societyfaction:withdrawMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)

    if amount > 0 and account.money >= amount then

      account.removeMoney(amount)
      xPlayer.addMoney(amount)

      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_withdrawn') .. amount)

    else
      TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
    end

  end)

end)

RegisterServerEvent('esx_societyfaction:depositMoney')
AddEventHandler('esx_societyfaction:depositMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local society = GetSociety(society)

  if amount > 0 and xPlayer.get('money') >= amount then

    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
      xPlayer.removeMoney(amount)
      account.addMoney(amount)
    end)

    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('have_deposited') .. amount)

  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end

end)

RegisterServerEvent('esx_societyfaction:washMoney')
AddEventHandler('esx_societyfaction:washMoney', function(society, amount)

  local xPlayer = ESX.GetPlayerFromId(source)
  local account = xPlayer.getAccount('black_money')

  if amount > 0 and account.money >= amount then
    TriggerEvent("esx:washingmoneyalert",xPlayer.name,amount)
    xPlayer.removeAccountMoney('black_money', amount)

      MySQL.Async.execute(
        'INSERT INTO faction_moneywash (identifier, society, amount) VALUES (@identifier, @society, @amount)',
        {
          ['@identifier'] = xPlayer.identifier,
          ['@society']    = society,
          ['@amount']     = amount
        },
        function(rowsChanged)
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have') .. amount .. '~s~ en attente de ~r~blanchiement~s~ (24h)')
        end
      )

  else
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('invalid_amount'))
  end

end)

RegisterServerEvent('esx_societyfaction:putVehicleInGarage')
AddEventHandler('esx_societyfaction:putVehicleInGarage', function(societyName, vehicle)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    local garage = store.get('garage') or {}
    table.insert(garage, vehicle)
    store.set('garage', garage)
  end)

end)

RegisterServerEvent('esx_societyfaction:removeVehicleFromGarage')
AddEventHandler('esx_societyfaction:removeVehicleFromGarage', function(societyName, vehicle)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)

    local garage = store.get('garage') or {}

    for i=1, #garage, 1 do
      if garage[i].plate == vehicle.plate then
        table.remove(garage, i)
        break
      end
    end

    store.set('garage', garage)

  end)

end)

ESX.RegisterServerCallback('esx_societyfaction:getSocietyMoney', function(source, cb, societyName)

  local society = GetSociety(societyName)

  if society ~= nil then

    TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
      cb(account.money)
    end)

  else
    cb(0)
  end

end)

ESX.RegisterServerCallback('esx_societyfaction:getEmployees', function(source, cb, society)

  if Config.EnableESXIdentity then
    MySQL.Async.fetchAll(
      'SELECT characters.*, users.faction, users.faction_grade FROM characters JOIN users ON characters.identifier = users.identifier WHERE users.faction = @faction ORDER BY users.faction_grade DESC',
      { ['@faction'] = society },
      function (results)
        local employees = {}

        for i=1, #results, 1 do
          table.insert(employees, {
            name                 = results[i].firstname .. ' ' .. results[i].lastname,
            identifier  = results[i].identifier,
            faction = {
              name        = results[i].faction,
              label       = Jobs[results[i].faction].label,
              grade       = results[i].faction_grade,
              grade_name  = Jobs[results[i].faction].grades[tostring(results[i].faction_grade)].name,
              grade_label = Jobs[results[i].faction].grades[tostring(results[i].faction_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  else
    MySQL.Async.fetchAll(
      'SELECT * FROM users WHERE faction = @faction ORDER BY faction_grade DESC',
      { ['@faction'] = society },
      function (result)
        local employees = {}

        for i=1, #result, 1 do
          table.insert(employees, {
            name        = result[i].name,
            identifier  = result[i].identifier,
            faction = {
              name        = result[i].faction,
              label       = Jobs[result[i].faction].label,
              grade       = result[i].faction_grade,
              grade_name  = Jobs[result[i].faction].grades[tostring(result[i].faction_grade)].name,
              grade_label = Jobs[result[i].faction].grades[tostring(result[i].faction_grade)].label,
            }
          })
        end

        cb(employees)
      end
    )
  end
end)

ESX.RegisterServerCallback('esx_societyfaction:getFaction', function(source, cb, society)

  local faction    = json.decode(json.encode(Jobs[society]))
  local grades = {}

  for k,v in pairs(faction.grades) do
    table.insert(grades, v)
  end

  table.sort(grades, function(a, b)
    return a.grade < b.grade
  end)

  faction.grades = grades

  cb(faction)

end)


ESX.RegisterServerCallback('esx_societyfaction:setFaction', function(source, cb, identifier, faction, grade, type)

  local xPlayer = ESX.GetPlayerFromIdentifier(identifier)

  if type == 'hire' then
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_hired', faction))
  elseif type == 'promote' then
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_promoted'))
  elseif type == 'fire' then
    TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_been_fired', xPlayer.getFaction().label))
  end

  if xPlayer ~= nil then
    xPlayer.setFaction(faction, grade)
  end

  MySQL.Async.execute(
    'UPDATE users SET faction = @faction, faction_grade = @faction_grade WHERE identifier = @identifier',
    {
      ['@faction']        = faction,
      ['@faction_grade']  = grade,
      ['@identifier']     = identifier
    },
    function(rowsChanged)
      cb()
    end
  )

end)

ESX.RegisterServerCallback('esx_societyfaction:setFactionSalary', function(source, cb, faction, grade, salary)

  MySQL.Async.execute(
    'UPDATE faction_grades SET salary = @salary WHERE faction_name = @faction_name AND grade = @grade',
    {
      ['@salary']       = salary,
      ['@faction_name'] = faction,
      ['@grade']        = grade
    },
    function(rowsChanged)

      Jobs[faction].grades[tostring(grade)].salary = salary

      local xPlayers = ESX.GetPlayers()

      for i=1, #xPlayers, 1 do

        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

        if xPlayer.faction.name == faction and xPlayer.faction.grade == grade then
          xPlayer.setFaction(faction, grade)
        end

      end

      cb()
    end
  )

end)

ESX.RegisterServerCallback('esx_societyfaction:getOnlinePlayers', function(source, cb)

  local xPlayers = ESX.GetPlayers()
  local players  = {}

  for i=1, #xPlayers, 1 do

    local xPlayer = ESX.GetPlayerFromId(xPlayers[i])

    table.insert(players, {
      source     = xPlayer.source,
      identifier = xPlayer.identifier,
      name       = xPlayer.name,
      faction    = xPlayer.faction
    })

  end

  cb(players)

end)

ESX.RegisterServerCallback('esx_societyfaction:getVehiclesInGarage', function(source, cb, societyName)

  local society = GetSociety(societyName)

  TriggerEvent('esx_datastore:getSharedDataStore', society.datastore, function(store)
    local garage = store.get('garage') or {}
    cb(garage)
  end)

end)

function WashMoneyCRON(d, h, m)

  MySQL.Async.fetchAll(
    'SELECT * FROM faction_moneywash',
    {},
    function(result)

      local xPlayers = ESX.GetPlayers()

      for i=1, #result, 1 do

        local foundPlayer = false
        local xPlayer     = nil
        local society     = GetSociety(result[i].society)

        for j=1, #xPlayers, 1 do
          local xPlayer2 = ESX.GetPlayerFromId(xPlayers[j])
          if xPlayer2.identifier == result[i].identifier then
            foundPlayer = true
            xPlayer     = xPlayer2
          end
        end

        TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
          account.addMoney(result[i].amount)
        end)

        if foundPlayer then
          TriggerClientEvent('esx:showNotification', xPlayer.source, _U('you_have_laundered') .. result[i].amount)
        end

        MySQL.Async.execute(
          'DELETE FROM faction_moneywash WHERE id = @id',
          {
            ['@id'] = result[i].id
          }
        )

      end

    end
  )

end

TriggerEvent('cron:runAt', 6, 0, WashMoneyCRON)
