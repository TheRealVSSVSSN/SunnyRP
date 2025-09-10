local currentJob = "Unemployed"
local myBlips = {}
local showDispatchLog = false
local isDead = false
local disableNotifications = false
local disableNotificationSounds = false

--[[
    -- Type: Function
    -- Name: randomizeBlipLocation
    -- Use: Adds slight randomization to a blip's coordinates
    -- Created: 2024-05-15
    -- By: VSSVSSN
--]]
local function randomizeBlipLocation(pOrigin)
    local x, y, z = pOrigin.x, pOrigin.y, pOrigin.z
    local luck = math.random(2)
    y = y + math.random(25)
    if luck == 1 then
        x = x + math.random(25)
    end
    return { x = x, y = y, z = z }
end

--[[
    -- Type: Function
    -- Name: sendNewsBlip
    -- Use: Registers blip data with phone system for dispatch alerts
    -- Created: 2024-05-15
    -- By: VSSVSSN
--]]
local function sendNewsBlip(pNotificationData)
    TriggerEvent("phone:registerBlip", {
        currentJob = currentJob,
        isImportant = pNotificationData.isImportant,
        blipTenCode = pNotificationData.dispatchCode,
        blipDescription = pNotificationData.dispatchMessage,
        blipLocation = pNotificationData.origin,
        blipSprite = pNotificationData.blipSprite,
        blipColor = pNotificationData.blipColor
    })
end

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        isDead = false
    end
end)

RegisterNetEvent('dispatch:clNotify')
AddEventHandler('dispatch:clNotify', function(pNotificationData)
    if pNotificationData ~= nil then
        if pNotificationData.recipientList then
            for job, enabled in pairs(pNotificationData.recipientList) do
                if job == currentJob and enabled and not disableNotifications then
                    if pNotificationData.origin then
                        if not pNotificationData.originStatic then
                            pNotificationData.origin = randomizeBlipLocation(pNotificationData.origin)
                        end
                    end

                    if currentJob ~= "news" then
                        SendNUIMessage({
                            mId = "notification",
                            eData = pNotificationData
                        })
                        sendNewsBlip(pNotificationData)
                    elseif currentJob == "news" and exports["np-inventory"]:getQuantity("scanner") > 0 then
                        local newsObject = {
                            dispatchMessage = "A 911 call has been picked up on your radio scanner!",
                            displayCode = nil,
                            isImportant = false,
                            priority = 1
                        }
                        SendNUIMessage({ mId = "notification", eData = newsObject })
                        sendNewsBlip(pNotificationData)
                    end

                    if pNotificationData.playSound and currentJob ~= "news" and not disableNotificationSounds then
                        TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, pNotificationData.soundName, 0.3)
                    end
                end
            end
        end
    else
        print("I didnt receive any data")
    end
end)

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    currentJob = job
end)

Controlkey = {["showDispatchLog"] = {20, "HOME"}}
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
	Controlkey["showDispatchLog"] = table["showDispatchLog"]
end)

RegisterNetEvent('dispatch:toggleNotifications')
AddEventHandler('dispatch:toggleNotifications', function(state)
    state = string.lower(state)
    if state == "on" then
        disableNotifications = false
        disableNotificationSounds = false
        TriggerEvent('DoLongHudText', "Dispatch is now enabled.")
    elseif state == "off" then
        disableNotifications = true
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now disabled.")
    elseif state == "mute" then
        disableNotifications = false
        disableNotificationSounds = true
        TriggerEvent('DoLongHudText', "Dispatch is now muted.")
    else
        TriggerEvent('DoLongHudText', "You need to type in 'on', 'off' or 'mute'.")
    end
end)

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 20) and currentJob == "police" then
            showDispatchLog = not showDispatchLog
            SetNuiFocus(showDispatchLog, showDispatchLog)
            SetNuiFocusKeepInput(showDispatchLog)
            SendNUIMessage({
                mId = "showDispatchLog",
                eData = showDispatchLog
            })
        end
        if showDispatchLog then
            DisableControlAction(0, 1, true)
            DisableControlAction(0, 2, true)
            DisableControlAction(0, 263, true) -- disable melee
            DisableControlAction(0, 264, true) -- disable melee
            DisableControlAction(0, 257, true) -- disable melee
            DisableControlAction(0, 140, true) -- disable melee
            DisableControlAction(0, 141, true) -- disable melee
            DisableControlAction(0, 142, true) -- disable melee
            DisableControlAction(0, 143, true) -- disable melee
            DisableControlAction(0, 24, true) -- disable attack
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 47, true) -- disable weapon
            DisableControlAction(0, 58, true) -- disable weapon
            DisablePlayerFiring(PlayerPedId(), true) -- Disable weapon firing
        end
    end
end)

RegisterNetEvent('phone:assistClear')
AddEventHandler('phone:assistClear', function(id,jobsent)
  TriggerEvent('jobssystem:current', function(job)
    if myBlips[id] ~= nil and not myBlips[id].onRoute and (job == jobsent or (job == "police" and jobsent == "911")) then
      clearBlip(myBlips[id])
    end
  end)
end)

RegisterNetEvent("clearJobBlips")
AddEventHandler("clearJobBlips", function()
  -- Clear all our blips as our job has changed
  for key, item in pairs(myBlips) do
    if (key ~= nil and item ~= nil) then
      clearBlip(item)
    end
  end
end)

RegisterNUICallback('disableGui', function(data, cb)
    showDispatchLog = not showDispatchLog
    SetNuiFocus(showDispatchLog, showDispatchLog)
    SetNuiFocusKeepInput(showDispatchLog)
end)

RegisterNUICallback('setGPSMarker', function(data, cb)
    TriggerEvent('notification', "GPS marked!", 1)
    SetNewWaypoint(data.gpsMarkerLocation.x, data.gpsMarkerLocation.y)
end)

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        SetNuiFocus(false, false)
    end
end)

RegisterNetEvent('phone:registerBlip')
AddEventHandler('phone:registerBlip', function(pData)
  addBlip(pData)
end)


function addBlip(data)
    local blip = AddBlipForCoord(data.blipLocation.x, data.blipLocation.y, data.blipLocation.z)
    SetBlipScale(blip, 1.7)
    if data.isImportant then
      SetBlipFlashesAlternate(blip,true)
    end
    SetBlipSprite(blip, data.blipSprite)
    SetBlipColour(blip, data.blipColor)
    if currentJob == "news" then
      SetBlipSprite(blip, 459)
    end
    SetBlipAlpha(blip, 180)
    SetBlipHighDetail(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    local displayText = data.blipDescription
    if currentJob == "news" then
      displayText = 'Scanner | ' .. data.blipDescription
    else
      displayText = data.blipTenCode .. " | " .. data.blipDescription
    end
    AddTextComponentString(displayText)
    EndTextCommandSetBlipName(blip)
  
    local blipId = math.random(1,6000)-- GetCloudTimeAsInt() + math.random(1,5)
    myBlips[blipId] = {
      timestamp = GetGameTimer(),
      pos = {
        x = data.blipLocation.x,
        y = data.blipLocation.y,
        z = data.blipLocation.z
      },
      blip = blip,
      id = blipId,
      jobType = currentJob
    }
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
  end
  
  function clearBlip(item)
    if item == nil then
      return
    end
  
    local id = item.id
    local pedb = item.blip
  
    if item.onRoute then
      SetBlipRoute(pedb, false) 
    end
  
    if pedb ~= nil and DoesBlipExist(pedb) then
      myBlips[id] = nil
      SetBlipSprite(pedb, 2)
      SetBlipDisplay(pedb, 3)
      RemoveBlip(dblip)
    end
  end


  Citizen.CreateThread(function()
    local timer = 0
    local canPay = true
    while true do
      local ped = PlayerPedId()
      local pos = GetEntityCoords(ped)
      local curTime = GetGameTimer()
      if timer >= 300 then canPay = true end -- Time limit ,300 = 5 min ,1000 ms * 300 = 5 min 
      timer = timer +1
  
      for key, item in pairs(myBlips) do
        if (key ~= nil and item ~= nil) then
          -- If we are within 10 units of a blip that is not our own, clear the blip and message the server to clear for everyone
          if #(vector2(pos.x, pos.y) - vector2(item.pos.x, item.pos.y)) < 50.0 then
            if currentJob == "ems" then
              if currentJob == "ems" then
                TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
                clearBlip(item)
                if GetTimeDifference(curTime, item.timestamp) > 2000 then
                  if canPay then
                    canPay = false
                    timer = 0
                    TriggerServerEvent('phone:checkJob')
                  end
                end
              end
            elseif currentJob == "news" then 
              if currentJob == "news" then
                TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
                clearBlip(item)
                if GetTimeDifference(curTime, item.timestamp) > 2000 then
                  if canPay then
                    canPay = false
                    timer = 0
                    TriggerServerEvent('phone:checkJob')
                  end
                end
              end
            else
               TriggerServerEvent('phone:assistRemove', item.id, item.jobType) -- Send message of clear to others
                clearBlip(item)
                if GetTimeDifference(curTime, item.timestamp) > 2000 then
                  if canPay then
                    canPay = false
                    timer = 0
                    TriggerServerEvent('phone:checkJob')
                  end
  
                end
            end
          elseif GetTimeDifference(curTime, item.timestamp) > 600000 and not item.onRoute then
            -- If its been passed 10 minutes, clear the bip locally unless it's a blip we are on route to
            clearBlip(item)
          end
        end
      end
  
      Citizen.Wait(1000)
    end
  end)

--[[
    -- Type: Function
    -- Name: GetStreetAndZone
    -- Use: Returns player's current street and zone using modern natives
    -- Created: 2024-05-15
    -- By: VSSVSSN
--]]
local function GetStreetAndZone()
    local plyPos = GetEntityCoords(PlayerPedId())
    local streetHash, crossHash = GetStreetNameAtCoord(plyPos.x, plyPos.y, plyPos.z)
    local street1 = GetStreetNameFromHashKey(streetHash)
    local zone = GetLabelText(GetNameOfZone(plyPos.x, plyPos.y, plyPos.z))
    return (street1 .. ", " .. zone)
end

RegisterCommand('death', function(source, args)
  TriggerEvent("civilian:alertPolice",1000.0,"death",0)
  TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3.0, "10-1314", 0.6)
 -- PlaySoundFrontend(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0)
end)

RegisterCommand('bankrob', function(source, args)
  TriggerEvent("alert:noPedCheck","banktruck")
  --TriggerEvent("civilian:alertPolice",1000.0,"lockpick",0)
end)



RegisterCommand('policedist', function(source, args)
  local newsObject = {}
  newsObject.dispatchCode = 'CarFleeing'
  newsObject.relatedCode  = "test"
  newsObject.dispatchMessage = "Escaping"
  newsObject.firstStreet = "STREET HERE"
  newsObject.gender = "Male"
  newsObject.model = "Kuruma"
  newsObject.plate = "KS13SA"
  --newsObject.displayCode = "10-56"
  newsObject.origin = {
      x = 12.12121,
      y = 31.21112,
      z = 312.121
  }
  newsObject.firstColor = "Red"
  newsObject.secondColor = "Black"
  newsObject.isImportant = false
  newsObject.priority = 1
  
  print(json.encode(newsObject))

  SendNUIMessage({
      mId = "notification",
      eData = newsObject
  })
end)


RegisterCommand('policedown', function(source,args)

  local pos = GetEntityCoords(PlayerPedId(),  true)
  TriggerServerEvent("dispatch:svNotify", {
    dispatchCode = "10-13A",
    dispatchMessage = "URGENT!",
    firstStreet = GetStreetAndZone(),
    callSign = 'Officer',
    recipientList = {
      police = true
    },
    playSound = true,
    isImportant = true,
    priority = 3,
    cid = 103,
    blipSprite = 84,
    blipColor = 1,
    origin = {
      -- x = pos.x,
      x = 221.6159362793,
      -- y = pos.y,
      y = -898.234375,
      -- z = pos.z
      z = 30.692338943481
      }
  })

end)

-- RegisterNetEvent('police:tenThirteenA')
-- AddEventHandler('police:tenThirteenA', function()
-- local callSign = ""
--   if(isCop) then
--     callSign = "Officer"
--   end
--   if(isEms) then
--     callSign = "EMS"
--   end
-- firstStreet = GetStreetAndZone()
--   local pos = GetEntityCoords(PlayerPedId(),  true)
--   origin = {
--     x = pos.x,
--     y = pos.y,
--     z = pos.z
--     }

--   TriggerServerEvent('OfficerDown', "10-13A", firstStreet, callSign, true, true, 3,origin)
--   end)