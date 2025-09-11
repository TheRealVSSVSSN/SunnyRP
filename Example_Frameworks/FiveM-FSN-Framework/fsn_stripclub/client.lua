local positions = {
  [1] = {
    pos = {x = 112.29388427734, y = -1305.138671875, z = 29.269525527954},
    campos = {x = 113.06817626953, y = -1306.037109375, z = 29.718551635742, h = 34.424774169922},
    sitpos = {x = 112.76410675049, y = -1305.7038574219, z = 29.269525527954, h = 21.393161773682},
    dancerpos = {
      front = {x = 112.32679748535, y = -1305.0974121094, z = 29.269533157349, h = 200.47219848633},
      back = {x = 112.40575408936, y = -1305.1303710938, z = 29.269533157349, h = 26.611642837524},
    },
    inuse = false
  }
}
local hookers = {"s_f_y_stripper_01", "s_f_y_stripper_02", "s_f_y_stripperlite", "s_f_y_hooker_01", "s_f_y_hooker_02", "s_f_y_hooker_03"}
local curbooth = -1
local stripper = nil

RegisterNetEvent('fsn_stripclub:client:update')
AddEventHandler('fsn_stripclub:client:update', function(tbl)
  positions = tbl
end)

-- Request current booth state from the server on script load
CreateThread(function()
  TriggerServerEvent('fsn_stripclub:server:sync')
end)

--[[
    -- Type: Function
    -- Name: drawTxt
    -- Use: Render on-screen instructional text
    -- Created: 2024-04-20
    -- By: VSSVSSN
--]]
local function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
  SetTextFont(font)
  SetTextProportional(false)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0,255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  SetTextEntry("STRING")
  AddTextComponentString(text)
  DrawText(x , y)
end

--[[
    -- Type: Function
    -- Name: StartLapDance
    -- Use: Initiates lap dance sequence for given booth
    -- Created: 2024-04-20
    -- By: VSSVSSN
--]]
local function StartLapDance(id)
  if positions[id].inuse then
    TriggerEvent('fsn_notify:displayNotification', 'This booth is already in use numnuts', 'centerLeft', 3000, 'error')
    return
  end

  curbooth = id
  TriggerServerEvent('fsn_stripclub:server:claimBooth', id)

  local pos = positions[id]
  local ped = PlayerPedId()
  SetEntityHeading(ped, pos.sitpos.h)
  SetEntityCoords(ped, pos.sitpos.x, pos.sitpos.y, pos.sitpos.z, false, false, false, false)
  TriggerEvent('fsn_emotecontrol:play', 'anim', 'switch@michael@sitting', 'idle')

  local modelName = hookers[math.random(#hookers)]
  local model = GetHashKey(modelName)
  RequestModel(model)
  while not HasModelLoaded(model) do
    Wait(0)
  end
  stripper = CreatePed(1, model, pos.dancerpos.front.x, pos.dancerpos.front.y, pos.dancerpos.front.z, pos.dancerpos.front.h, false, true)
  SetModelAsNoLongerNeeded(model)
  SetBlockingOfNonTemporaryEvents(stripper, true)

  Citizen.CreateThread(function()
    local animDict = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
      Wait(0)
    end
    TaskPlayAnim(stripper, animDict, "ld_girl_a_song_a_p1_f", 8.0, -8.0, -1, 1, 0.0, false, false, false)
  end)

  Wait(500)
  DoScreenFadeIn(1000)
  FreezeEntityPosition(ped, true)
end

--[[
    -- Type: Function
    -- Name: StopLapDance
    -- Use: Ends lap dance and releases booth
    -- Created: 2024-04-20
    -- By: VSSVSSN
--]]
local function StopLapDance()
  if curbooth < 0 then return end

  local ped = PlayerPedId()
  FreezeEntityPosition(ped, false)
  TriggerServerEvent('fsn_stripclub:server:releaseBooth', curbooth)

  if stripper and DoesEntityExist(stripper) then
    DeleteEntity(stripper)
    stripper = nil
  end

  curbooth = -1
end
DoScreenFadeIn(1000)
CreateThread(function()
  local bleep = AddBlipForCoord(115.66896057129, -1296.7384033203, 29.269014358521)
  SetBlipSprite(bleep, 121)
  SetBlipScale(bleep, 0.8)
  SetBlipAsShortRange(bleep, true)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Strip Club")
  EndTextCommandSetBlipName(bleep)

  while true do
    Wait(0)
    if curbooth > 0 then
      drawTxt("Press ~INPUT_FRONTEND_CANCEL~ to stop", 4, 0, 0.45, 0.9, 0.5, 255, 255, 255, 200)
      if IsControlJustPressed(0, 202) then -- backspace
        StopLapDance()
      end
    else
      for k, v in pairs(positions) do
        if #(GetEntityCoords(PlayerPedId()) - vector3(v.pos.x, v.pos.y, v.pos.z)) < 5.0 then
          DrawMarker(1, v.pos.x, v.pos.y, v.pos.z - 1, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 0.5, 0, 155, 255, 175, false, true, 2, false, nil, nil, false)
          if #(GetEntityCoords(PlayerPedId()) - vector3(v.pos.x, v.pos.y, v.pos.z)) < 1.0 then
            if v.inuse then
              SetTextComponentFormat("STRING")
              AddTextComponentString("~r~This booth is already in use")
              DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            else
              SetTextComponentFormat("STRING")
              AddTextComponentString("Press ~INPUT_PICKUP~ to hire a stripper (~r~$500~w~)")
              DisplayHelpTextFromStringLabel(0, 0, 1, -1)
              if IsControlJustPressed(0, 51) then
                DoScreenFadeOut(1)
                StartLapDance(k)
              end
            end
          end
        end
      end
    end
  end
end)

-- Ensure booth is freed if the resource stops
AddEventHandler('onClientResourceStop', function(res)
  if res ~= GetCurrentResourceName() then return end
  StopLapDance()
end)
