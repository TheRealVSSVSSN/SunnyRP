
local GuiOpened, inPhone, HasNuiFocus = false, false, false

local function formattedChannelNumber(number)
  local power = 10 ^ 1
  return math.floor(number * power) / power
end

local function closeGui()
  TriggerEvent("InteractSound_CL:PlayOnOne", "radioclick", 0.6)
  GuiOpened = false
  SetCustomNuiFocus(false, false)
  SendNUIMessage({ open = false })
  TriggerEvent("animation:radio", false)
end

local function hasRadio()
  return exports["np-inventory"]:hasEnoughOfItem("radio", 1, false)
end

local function openGui()
  if exports["isPed"]:isPed("incall") then
    TriggerEvent("DoShortHudText", "You can not do that while in a call!", 2)
    return
  end

  if not hasRadio() then return end

  local job = exports["isPed"]:isPed("myjob")
  local Emergency = job == "police" or job == "ems" or job == "doctor"

  GuiOpened = not GuiOpened
  SetCustomNuiFocus(GuiOpened, GuiOpened)
  SendNUIMessage({ open = GuiOpened, jobType = Emergency })
  TriggerEvent("animation:radio", GuiOpened)
end
RegisterNUICallback('click', function(_, cb)
  PlaySound(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
  cb('ok')
end)

RegisterNUICallback('volumeUp', function(_, cb)
  exports["np-voice"]:IncreaseRadioVolume()
  cb('ok')
end)

RegisterNUICallback('volumeDown', function(_, cb)
  exports["np-voice"]:DecreaseRadioVolume()
  cb('ok')
end)

RegisterNUICallback('cleanClose', function(_, cb)
  closeGui()
  cb('ok')
end)

local function handleConnectionEvent(pChannel)
  local newChannel = formattedChannelNumber(pChannel)

  if newChannel < 1.0 then
    TriggerServerEvent("np:voice:radio:removePlayerFromRadio", newChannel)
  else
    TriggerServerEvent("np:voice:radio:addPlayerToRadio", newChannel, true)
  end
end

RegisterNUICallback('poweredOn', function(_, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne", "radioon", 0.6)
  exports["np-voice"]:SetRadioPowerState(true)
  cb('ok')
end)

RegisterNUICallback('poweredOff', function(_, cb)
  TriggerEvent("InteractSound_CL:PlayOnOne", "radiooff", 0.6)
  exports["np-voice"]:SetRadioPowerState(false)
  cb('ok')
end)

RegisterNUICallback('close', function(data, cb)
  handleConnectionEvent(data.channel)
  closeGui()
  cb('ok')
end)


RegisterNetEvent('animation:radio')
AddEventHandler('animation:radio', function(enable)
  TriggerEvent("destroyPropRadio")
  local lPed = PlayerPedId()
  inPhone = enable

  RequestAnimDict("cellphone@")
  while not HasAnimDictLoaded("cellphone@") do
    Wait(0)
  end

  local intrunk = exports["isPed"]:isPed("intrunk")
  if not intrunk then
    TaskPlayAnim(lPed, "cellphone@", "cellphone_text_in", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
  end
  Wait(300)
  if inPhone then
    TriggerEvent("attachItemRadio", "radio01")
    Wait(150)
    while inPhone do
      if exports["isPed"]:isPed("dead") then
        closeGui()
        inPhone = false
      end
      intrunk = exports["isPed"]:isPed("intrunk")
      if not intrunk and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_text_read_base", 3) and not IsEntityPlayingAnim(lPed, "cellphone@", "cellphone_swipe_screen", 3) then
        TaskPlayAnim(lPed, "cellphone@", "cellphone_text_read_base", 2.0, 3.0, -1, 49, 0, 0, 0, 0)
      end
      Wait(500)
    end
    intrunk = exports["isPed"]:isPed("intrunk")
    if not intrunk then
      ClearPedTasks(PlayerPedId())
    end
  else
    intrunk = exports["isPed"]:isPed("intrunk")
    if not intrunk then
      Wait(100)
      ClearPedTasks(PlayerPedId())
      TaskPlayAnim(lPed, "cellphone@", "cellphone_text_out", 2.0, 1.0, 5.0, 49, 0, 0, 0, 0)
      Wait(400)
      TriggerEvent("destroyPropRadio")
      Wait(400)
      ClearPedTasks(PlayerPedId())
    else
      TriggerEvent("destroyPropRadio")
    end
  end
  TriggerEvent("destroyPropRadio")
end)

CreateThread(function()
  while true do
    if GuiOpened then
      Wait(0)
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 14, true) -- INPUT_WEAPON_WHEEL_NEXT
      DisableControlAction(0, 15, true) -- INPUT_WEAPON_WHEEL_PREV
      DisableControlAction(0, 16, true) -- INPUT_SELECT_NEXT_WEAPON
      DisableControlAction(0, 17, true) -- INPUT_SELECT_PREV_WEAPON
      DisableControlAction(0, 99, true) -- INPUT_VEH_SELECT_NEXT_WEAPON
      DisableControlAction(0, 100, true) -- INPUT_VEH_SELECT_PREV_WEAPON
      DisableControlAction(0, 115, true) -- INPUT_VEH_FLY_SELECT_NEXT_WEAPON
      DisableControlAction(0, 116, true) -- INPUT_VEH_FLY_SELECT_PREV_WEAPON
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
    else
      Wait(200)
    end
  end
end)


  function SetCustomNuiFocus(hasKeyboard, hasMouse)
    HasNuiFocus = hasKeyboard or hasMouse
    SetNuiFocus(hasKeyboard, hasMouse)
    SetNuiFocusKeepInput(HasNuiFocus)
    TriggerEvent("np-voice:focus:set", HasNuiFocus, hasKeyboard, hasMouse)
  end

RegisterNetEvent('radioGui')
AddEventHandler('radioGui', openGui)

RegisterNetEvent('ChannelSet')
AddEventHandler('ChannelSet', function(chan)
  SendNUIMessage({ set = true, setChannel = chan })
end)

RegisterNetEvent('radio:resetNuiCommand')
AddEventHandler('radio:resetNuiCommand', function()
  SendNUIMessage({ reset = true })
end)

