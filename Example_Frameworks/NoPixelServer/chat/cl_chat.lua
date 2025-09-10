local chatInputActive = false
local chatInputActivating = false
local chatHidden = false
local chatLoaded = false
local focusTaken = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent('chat:addSuggestions')

-- internal events
RegisterNetEvent('__cfx_internal:serverPrint')

RegisterNetEvent('_chat:messageEntered')

--deprecated, use chat:addMessage
AddEventHandler('chatMessage', function(author, color, text)
  local hud = exports["isPed"]:isPed("hud")
  if color == 8 then
    TriggerEvent("phone:addnotification",author,text)
    return
  end
  if hud < 3 then
    local args = { text }
    if author ~= "" then
      table.insert(args, 1, author)
    end
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = {
        color = color,
        multiline = true,
        args = args
      }
    })
  end
end)

--[[
    -- Type: Event
    -- Name: chat:showCID
    -- Use: Displays identification data when a nearby player shares their CID
    -- Created: 2024-06-07
    -- By: VSSVSSN
--]]
RegisterNetEvent('chat:showCID')
AddEventHandler('chat:showCID', function(cidInformation, srcId)
  local playerId = GetPlayerFromServerId(srcId)
  if playerId ~= -1 then
    local targetPed = GetPlayerPed(playerId)
    local myCoords = GetEntityCoords(PlayerPedId())
    local targetCoords = GetEntityCoords(targetPed)

    if #(myCoords - targetCoords) <= 1.5 then
      SendNUIMessage({
        type = 'ON_MESSAGE',
        message = {
          color = 9,
          multiline = false,
          args = cidInformation
        }
      })
    end
  end
end)

-- AddEventHandler('__cfx_internal:serverPrint', function(msg)
--   print(msg)

--   SendNUIMessage({
--     type = 'ON_MESSAGE',
--     message = {
--       color = { 0, 0, 0 },
--       multiline = true,
--       args = { msg }
--     }
--   })
-- end)



AddEventHandler('chat:addMessage', function(message)
  local hud = exports["isPed"]:isPed("hud")
  if hud and hud < 3 then
    SendNUIMessage({
      type = 'ON_MESSAGE',
      message = message
    })
  end
end)

AddEventHandler('chat:addSuggestion', function(name, help, params)
  SendNUIMessage({
    type = 'ON_SUGGESTION_ADD',
    suggestion = {
      name = name,
      help = help,
      params = params or nil
    }
  })
end)

AddEventHandler('chat:addSuggestions', function(suggestions)
  for _, suggestion in ipairs(suggestions) do
    TriggerEvent('chat:addSuggestion', suggestion.name, suggestion.help, suggestion.params)
  end
end)

AddEventHandler('chat:removeSuggestion', function(name)
  SendNUIMessage({
    type = 'ON_SUGGESTION_REMOVE',
    name = name
  })
end)

AddEventHandler('chat:addTemplate', function(id, html)
  SendNUIMessage({
    type = 'ON_TEMPLATE_ADD',
    template = {
      id = id,
      html = html
    }
  })
end)

RegisterNetEvent('chat:close')
AddEventHandler('chat:close', function()
  SendNUIMessage({
    type = 'ON_CLOSE_CHAT'
  })
end)

AddEventHandler('chat:clear', function(name)
  SendNUIMessage({
    type = 'ON_CLEAR'
  })
end)

RegisterNUICallback('chatResult', function(data, cb)
  chatInputActive = false
  SetNuiFocus(false)

  if not data.canceled then
    local id = PlayerId()
    local r, g, b = 0, 0x99, 255

    if data.message:sub(1, 1) == '/' then
      ExecuteCommand(data.message:sub(2))
    else
      TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
    end
  end

  cb('ok')
end)

Controlkey = {["generalChat"] = {245,"T"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
  Controlkey["generalChat"] = table["generalChat"]
end)

Citizen.CreateThread(function()
  SetTextChatEnabled(false)
  SetNuiFocus(false)
  chatInputActive = false
  chatInputActivating = false

  while true do
    Wait(0)

    if not chatInputActive then
      if IsControlPressed(0, Controlkey["generalChat"][1]) and not focusTaken then
        chatInputActive = true
        chatInputActivating = true

        SendNUIMessage({
          type = 'ON_OPEN'
        })
      end
    end

    if chatInputActivating then
      if not IsControlPressed(0, Controlkey["generalChat"][1]) then
        SetNuiFocus(true)
        chatInputActivating = false
      end
    end

    if chatLoaded then
      local shouldBeHidden = false

      if IsScreenFadedOut() or IsPauseMenuActive() then
        shouldBeHidden = true
      end

      if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
        chatHidden = shouldBeHidden

        SendNUIMessage({
          type = 'ON_SCREEN_STATE_CHANGE',
          shouldHide = shouldBeHidden
        })
      end
    end
  end
end)



--[[
    -- Type: Function
    -- Name: refreshCommands
    -- Use: Pulls available commands and sends them to the client suggestions list
    -- Created: 2024-06-07
    -- By: VSSVSSN
--]]
local function refreshCommands()
  if GetRegisteredCommands then
    local registeredCommands = GetRegisteredCommands()

    local suggestions = {}

    for _, command in ipairs(registeredCommands) do
        if IsAceAllowed(('command.%s'):format(command.name)) then
            table.insert(suggestions, {
                name = '/' .. command.name,
                help = ''
            })
        end
    end

    TriggerEvent('chat:addSuggestions', suggestions)
  end
end


AddEventHandler('onClientResourceStart', function(resName)
  Wait(500)

  refreshCommands()
end)

AddEventHandler('onClientResourceStop', function(resName)
  Wait(500)

  refreshCommands()
end)

RegisterNUICallback('loaded', function(data, cb)
  TriggerServerEvent('chat:init')
  refreshCommands()
  chatLoaded = true
  cb('ok')
end)
