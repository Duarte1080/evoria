ESX                   = nil
local PlayerData      = {}
local base64MoneyIcon = 'iVBORw0KGgoAAAANSUhEUgAAAFoAAABaCAMAAAAPdrEwAAAAIGNIUk0AAHolAACAgwAA+f8AAIDpAAB1MAAA6mAAADqYAAAXb5JfxUYAAAMAUExURQAAACmvPCmwPCuwPiywPi2wPy6xQC6xQS+yQTCxQTCyQTCyQjGyQzKyRDOzRTSzRTSzRjW0RjW0Rza0SDe0STi0STm1Sjq1Szq2Szu2TDy2TDy2TT22Tj63Tz+3UEC4UEG4UUG4UkK4U0O5VES5VEW6VUa6Vke6V0i7WEm7WUu8Wku8W0y8W028XE29XU++XlC9X1C+X1G+YFK+YVO/YlW/ZFXAZFfAZVfAZljBZlnBZ1rBaVvCaVvCalzDal7CbF/DbV/EbWHEbmLEb2LEcGTFcWfGdGjHdWrHd2vId2vIeGzIeW3JenHKfXLKfnPLf3TLgHXLgXXMgHXMgXbMgnjNg3nMhHrNhnrOhnzOiH7PiYLQjYPRjoTRjoTRj4XRkIXSkIfSkojSk4rUlYzUlo7VmJDWmpHWm5LXnJTXnZTXnpXYnpbYn5nZopzapJ3bpZ7bpp7bp6DcqKLcqqPcq6Tcq6TdrKberqjfr6jfsKnfsavgs6zgs6zgtK7hta/htrDit7LiuLLiubPjurTjurXju7bkvLbkvbnlv7rlwLrmwLzmwr3nw77nxMDnxcLox8PpyMTpycXpysXqysbqy8fqzMnrzcrrz8vsz8vs0Mzs0c3t0tHu1dHu1tPv19Tv2NXv2dXw2dbw2tfw29jw3Nnx3drx3t7z4d/z4uD04+H05OP15eP15uT15uT15+X16OX26Of26en36+r37Ov37er47Ov47ez47e347u347+758PD58fD68fD68vL69PT79fX79vb79/b89vb89/f8+Pj9+fn9+vr9+/v++/v+/Pz+/P3+/f3+/v7//wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALfZHJgAAAEAdFJOU////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////wBT9wclAAAACXBIWXMAAA7DAAAOwwHHb6hkAAAAGHRFWHRTb2Z0d2FyZQBwYWludC5uZXQgNC4xLjb9TgnoAAAGdUlEQVRoQ7WZ93sURRiAFZO76O1eklt215OgBwqJgmgCRhAhRrAAiogBK4gBJEFEgWAEYiGIYEGp1kjXQECkiF0OWyjJ/k34zcy3db7Zu8fHe3/KTXnzPbPT56orRTEYAhMLUFgNKkeiGH8BNaV1KWSPVXveU9s3LW9pvhdoblm+afspTHZi5Wo1BnzpaOfcnFmWSBv29YBtpBNlZm5u59FLPDsmdJUaxQeXNugZw5IwMnrD0oO8iFKuUHNx/+bGZLWNMgm7Otm4uZ/LsVIEUs3F+Y5a3USNAlOv7cgr5ZSamQffyOnKgH1sPdfFi2PVILKaReEcmKwVIWbY2uQDvApW95HULIb+Ng0rFoXWxppcCjyqZuZjk4oNWWBrk44R7oiamXdkC3w9GTO7Q3aH1cy8OkWFnHtitstM4j/bqdWSO6Rm5nYdS4e5FbKQwxlMC6G3Q1bIHVQz8+IKLBphJLdydlRjWpiKxZAXdAfUPOak4gOO4FZOdxWmhbGTkbh9NTOvoVsDuGmAaxkdlZgWRV8Dub7bV0PyzhQWkqk5z7WMdjpqILUTslEXUEPQJ7Lq7pz9WXiBZ4iZUGBnTwTCdtVgvjgxpj+b3vTvTEteq5KbEy/6blcNVZapR3cmdc9Z4QV6Pnxzdr1GF9aWQQFUohqCPqQc3ZV17X3C6tP31kyL+Jy2dsgLW6jBPDgVc6OkR3XxCV/i9IqRRFedylxc6qk30L3DNF7ikz1Jft0oLOaT2hBSg/l8jmwOo24/amimYzkfOwfdlLtdNT1YjIaf0EFzgGhuNnB8teNcqCWDvs3vzSSLqC9Ze0F0EqaGoDeSQWt7UaHgXA0WDKFvFGEzNRS6mxot6VZhUNJNdm7zbsgSagj6UAKTQ5hnhEHJffRISIi+LdRLyNn9cTSoOExP3FZmiat2nIF66t9Xb0GFz8Df+AenVTEF2vUwAzM1BN1LfsTkcVS4bJs+fnRj84z3joqf+eFYUELvZWFzdSfZHjeeEwqXl6/myWaZ0bSVDf3uJP9NkOn01HPISXIMTJAB/hiB6WBPN+xxBpvxl4wxR6ihll8pSL1QupwLLhR22YL9ysVGrKRcfZJeAu4QSo+1yWA3rla2NGCeZGpoj13lmBJm1F/odDm+fv68phorU0l+miDlu6BFmLqbHDCWdhqVQQb/zPesW1inqxdoRqIb1SvSmBJG+wR1BF+/NkmLWUnTK1DdQq+i5gvoIbn85QPqtdRoQfU0TIgy4h/UKOi+gZ5DgGmonqIoob2CDhXHblE0ij2lgNo2YMcSy7fkhF2E2rIm/IoOFV/Q+78i1JkJheJ+jOzjnlr1GRk18swa4iC9t3U/o6LzCVLTP4dlVM14LBfC63yKIYOYeuMqcRoneZFqEW/IKAY6Q8xumla3YP2+PNnNt1Jqb6Arpifg5kXuHjNTaVi1s5/eJs0r+6gFUkxP6kkV2mKBs8UMZSYMdmAJcpxqTTGpqpcCEO1znCMTwlPFNbuF0uUs1UVwKYAWoRcwGDHsbNS/algwu+J1bvToI9TuAgZqetm1roPVk/FDazbhjaryr0SiSw/R1oFll94sWNnfsLrzS1eTkawyjKrE6HcwyeVtIix3s6Dc4ljzsTbnx74P1na83+uf8ZBn5cb0tjgsbHJjlvoMa8dxWT4XBDZmoCa3k7eH9yE0u4l9jr+dZN2P2ASnVorK8TwoVwxsglnYxNY9852oHMseogMEt+4QtnzgGDoTa8eRH4ulA4QOHCxs6ZhUBdNAIS7NIjp1+JgEaulwZzwsnXCjDDxPzB+Rwx1zS0fSoVZb/Mp4/lFqQxk5kjI1cZDWa179HTUEe8eRW9XoQZq5qeN/5fCFigWmd14VNRXLx3/et8lLC7N8XNtH0VP6mXfvV+z4iEsLFrbqqkXXho2Z8dynwgo8NdZK0SXpqxbmjrsgquhCsXrhgOYgL4h4k8Rca5VvFV7gTkySUVxrsbBjLuOGfMy1jCZFa6gv47hbeYU4ZA/XMmbRy13MFaJwqy4+Ez1cy3iSVsddfGLcdJvo33Ato5VcSeOva4WbvmQ2v+daxkrqfqXQJbNwk1fj9kOPuNwlZxdxNS7c5IW+MdRFMhd3oS/cpXmG4EOnRI8nAAt8sKsETz4AK1yahyqAy0vxvAaU7lEQcJ8yj9BPmUf+81MmR8iB//kBllOyZ2NOqR67XUAVABNjuXLlX2rCcoFjOcGoAAAAAElFTkSuQmCC'

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
end)


function OpenBossFactionMenu(society, close, options)

  local options  = options or {}
  local elements = {}

  local defaultOptions = {
    withdraw  = true,
    deposit   = true,
    wash      = true,
    employees = true,
    grades    = true
  }

  for k,v in pairs(defaultOptions) do
    if options[k] == nil then
      options[k] = v
    end
  end

  if options.withdraw then
    table.insert(elements, {label = _U('withdraw_society_money'), value = 'withdraw_society_money'})
  end

  if options.deposit then
    table.insert(elements, {label = _U('deposit_society_money'), value = 'deposit_money'})
  end

  if options.wash then
    table.insert(elements, {label = _U('wash_money'), value = 'wash_money'})
  end

  if options.employees then
    table.insert(elements, {label = _U('employee_management'), value = 'manage_employees'})
  end

  --if options.grades then
  --  table.insert(elements, {label = _U('salary_management'), value = 'manage_grades'})
  --end

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'boss_actions_' .. society,
    {
      css = 'faction',
      title    = 'Boss',
      elements = elements
    },
    function(data, menu)

      if data.current.value == 'withdraw_society_money' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'withdraw_society_money_amount_' .. society,
          {
            css = 'faction',
            title = _U('withdraw_amount')
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification(_U('invalid_amount'))
            else
              menu.close()
              TriggerServerEvent('esx_societyfaction:withdrawMoney', society, amount)
            end

          end,
          function(data, menu)
            menu.close()
          end
        )

      end

      if data.current.value == 'deposit_money' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'deposit_money_amount_' .. society,
          {
            css = 'faction',
            title = _U('deposit_amount')
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification(_U('invalid_amount'))
            else
              menu.close()
              TriggerServerEvent('esx_societyfaction:depositMoney', society, amount)
            end

          end,
          function(data, menu)
            menu.close()
          end
        )

      end

      if data.current.value == 'wash_money' then

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'wash_money_amount_' .. society,
          {
            css = 'faction',
            title = _U('wash_money_amount')
          },
          function(data, menu)

            local amount = tonumber(data.value)

            if amount == nil then
              ESX.ShowNotification(_U('invalid_amount'))
            else
              menu.close()
              TriggerServerEvent('esx_societyfaction:washMoney', society, amount)
            end

          end,
          function(data, menu)
            menu.close()
          end
        )

      end

      if data.current.value == 'manage_employees' then
        OpenManageEmployeesMenu(society)
      end

      if data.current.value == 'manage_grades' then
        OpenManageGradesMenu(society)
      end

    end,
    function(data, menu)

      if close then
        close(data, menu)
      end

    end
  )

end


function OpenManageEmployeesMenu(society)

  ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'manage_employees_' .. society,
    {
      css = 'faction',
      title    = _U('employee_management'),
      elements = {
        {label = _U('employee_list'), value = 'employee_list'},
        {label = _U('recruit'),       value = 'recruit'},
      }
    },
    function(data, menu)

      if data.current.value == 'employee_list' then
        OpenEmployeeList(society)
      end

      if data.current.value == 'recruit' then
        OpenRecruitMenu(society)
      end

    end,
    function(data, menu)
      menu.close()
    end
  )

end

function OpenEmployeeList(society)

  ESX.TriggerServerCallback('esx_societyfaction:getEmployees', function(employees)

    local elements = {
      head = {_U('employee'), _U('grade'), _U('actions')},
      rows = {}
    }

    for i=1, #employees, 1 do

      local gradeLabel = (employees[i].faction.grade_label == '' and employees[i].faction.label or employees[i].faction.grade_label)

      table.insert(elements.rows, {
        data = employees[i],
        cols = {
          employees[i].name,
          gradeLabel,
          '{{' .. _U('promote') .. '|promote}} {{' .. _U('fire') .. '|fire}}'
        }
      })
    end

    ESX.UI.Menu.Open(
      'list', GetCurrentResourceName(), 'employee_list_' .. society,
      elements,
      function(data, menu)

        local employee = data.data

        if data.value == 'promote' then
          menu.close()
          OpenPromoteMenu(society, employee)
        end

        if data.value == 'fire' then

          TriggerEvent('esx:showNotification', _U('you_have_fired', employee.name))

          ESX.TriggerServerCallback('esx_societyfaction:setFaction', function()
            OpenEmployeeList(society)
          end, employee.identifier, 'none', 0, 'fire')

        end

      end,
      function(data, menu)
        menu.close()
        OpenManageEmployeesMenu(society)
      end
    )

  end, society)

end

function OpenRecruitMenu(society)

  ESX.TriggerServerCallback('esx_societyfaction:getOnlinePlayers', function(players)

    local elements = {}

    for i=1, #players, 1 do
      if players[i].faction.name ~= society then
        table.insert(elements, {label = players[i].name, value = players[i].source, name = players[i].name, identifier = players[i].identifier})
      end
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'recruit_' .. society,
      {
        css = 'faction',
        title    = _U('recruiting'),
        elements = elements
      },
      function(data, menu)

        ESX.UI.Menu.Open(
          'default', GetCurrentResourceName(), 'recruit_confirm_' .. society,
          {
            css = 'faction', -- MENU
            title    = _U('do_you_want_to_recruit', data.current.name),
            elements = {
              {label = _U('yes'), value = 'yes'},
              {label = _U('no'),  value = 'no'},
            }
          },
          function(data2, menu2)

            menu2.close()

            if data2.current.value == 'yes' then

              TriggerEvent('esx:showNotification', _U('you_have_hired', data.current.name))

              ESX.TriggerServerCallback('esx_societyfaction:setFaction', function()
                OpenRecruitMenu(society)
              end, data.current.identifier, society, 0, 'hire')

            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end)

end

function OpenPromoteMenu(society, employee)

  ESX.TriggerServerCallback('esx_societyfaction:getFaction', function(faction)

    local elements = {}

    for i=1, #faction.grades, 1 do
      local gradeLabel = (faction.grades[i].label == '' and faction.label or faction.grades[i].label)
      table.insert(elements, {label = gradeLabel, value = faction.grades[i].grade, selected = (employee.faction.grade == faction.grades[i].grade)})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'promote_employee_' .. society,
      {
        css = ' faction',
        title    = _U('promote_employee', employee.name),
        elements = elements
      },
      function(data, menu)
        menu.close()

        TriggerEvent('esx:showNotification', _U('you_have_promoted', employee.name, data.current.label))

        ESX.TriggerServerCallback('esx_societyfaction:setFaction', function()
          OpenEmployeeList(society)
        end, employee.identifier, society, data.current.value, 'promote')

      end,
      function(data, menu)
        menu.close()
        OpenEmployeeList(society)
      end
    )

  end, society)

end

function OpenManageGradesMenu(society)

  ESX.TriggerServerCallback('esx_societyfaction:getFaction', function(faction)

    local elements = {}

    for i=1, #faction.grades, 1 do
      local gradeLabel = (faction.grades[i].label == '' and faction.label or faction.grades[i].label)
      table.insert(elements, {label = gradeLabel .. ' $' .. faction.grades[i].salary, value = faction.grades[i].grade})
    end

    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), 'manage_grades_' .. society,
      {
        css = 'faction',
        title    = _U('salary_management'),
        elements = elements
      },
      function(data, menu)

        ESX.UI.Menu.Open(
          'dialog', GetCurrentResourceName(), 'manage_grades_amount_' .. society,
          {
            css = 'faction',
            title = _U('salary_amount')
          },
          function(data2, menu2)

            local amount = tonumber(data2.value)

            if amount == nil then
              ESX.ShowNotification(_U('invalid_amount'))
            else
              menu2.close()

              ESX.TriggerServerCallback('esx_societyfaction:setFactionSalary', function()
                OpenManageGradesMenu(society)
              end, society, data.current.value, amount)
            end

          end,
          function(data2, menu2)
            menu2.close()
          end
        )

      end,
      function(data, menu)
        menu.close()
      end
    )

  end, society)

end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

  PlayerData = xPlayer


  if PlayerData.faction.grade_name == 'boss' then

    ESX.TriggerServerCallback('esx_societyfaction:getSocietyMoney', function(money)
    end, PlayerData.faction.name)

  end

end)

RegisterNetEvent('esx:setFaction')
AddEventHandler('esx:setFaction', function(faction)

  PlayerData.faction = faction


  if PlayerData.faction.grade_name == 'boss' then


    ESX.TriggerServerCallback('esx_societyfaction:getSocietyMoney', function(money)
    end, PlayerData.faction.name)

  end

end)

RegisterNetEvent('esx_addonaccount:setMoney')
AddEventHandler('esx_addonaccount:setMoney', function(society, money)

  if PlayerData.faction ~= nil and (PlayerData.faction.grade_name == 'boss') and 'society_' .. PlayerData.faction.name == society then
    UpdateSocietyMoneyHUDElement(money)
  end

end)

AddEventHandler('esx_societyfaction:openBossFactionMenu', function(society, close, options)
  OpenBossFactionMenu(society, close, options)
end)
