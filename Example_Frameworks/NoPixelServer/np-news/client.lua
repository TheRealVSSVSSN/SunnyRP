--[[
    -- Type: Variable
    -- Name: recentConvictions
    -- Use: Holds the latest conviction strings shown in the news UI.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local recentConvictions = {
  "LSPD have reported a major spike in drugs and locals are reporting a large increase in crime in their local area of South LS. Local crackhead 'Steve' has stated to Weazel News he has seen many individuals selling Weed and Crack in the southside, Weazel News stated he has been placed in protective custody for the safety of himself as they are assuming he is buying Crack.",
  "A huge increase in drug dealing has spiked in Vinewood BLVD for the product Cocaine. Police assume it has something to do with Dean supplying the streets from behind bars."
}

local guiEnabled = false

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Disables NUI focus and hides the news interface.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({ openSection = "close" })
  guiEnabled = false
  TriggerEvent("destroyProp")
  ClearPedTasksImmediately(PlayerPedId())
  SetPlayerControl(PlayerId(), true, 0)
end

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Enables NUI focus and displays the news interface.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function openGui(newsOne, newsTwo)
  SetPlayerControl(PlayerId(), false, 0)
  SetNuiFocus(true, true)
  guiEnabled = true
  SendNUIMessage({ openSection = "newsUpdate", string = newsOne, string2 = newsTwo })

  TriggerEvent("attachItem", "newspaper01")
  local origin = GetEntityCoords(PlayerPedId())

  CreateThread(function()
    while guiEnabled do
      if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_tourist_map@female@base", "base", 3) then
        RequestAnimDict("amb@world_human_tourist_map@female@base")
        while not HasAnimDictLoaded("amb@world_human_tourist_map@female@base") do
          Wait(0)
        end
        TaskPlayAnim(PlayerPedId(), "amb@world_human_tourist_map@female@base", "base", 8.0, -8.0, -1, 49, 0.0, false, false, false)
      end

      if #(origin - GetEntityCoords(PlayerPedId())) > 2.0 then
        closeGui()
      end
      Wait(1)
    end
  end)
end

-- NUI Callbacks
RegisterNUICallback("close", function(_, cb)
  closeGui()
  cb("ok")
end)

RegisterNetEvent("news:close", closeGui)

RegisterNetEvent("lastconvictionlist")
AddEventHandler("lastconvictionlist", function(newConv)
  recentConvictions = newConv
end)

RegisterNetEvent("NewsStandCheckFinish")
AddEventHandler("NewsStandCheckFinish", function(newsOne, newsTwo)
  if not guiEnabled then
    openGui(newsOne, newsTwo)
  end
end)

RegisterNetEvent("stringGangGlobalReputations")
AddEventHandler("stringGangGlobalReputations", function()
  local strg = "<font size='20'>Daily Crime News</font> <br><br> <br> <b> Dean Smith has been sentanced to life imprisonment for multiple murders and running a county line across the border. Sources say Dean has been supplying the streets from the inside of his cell. Police will continue to investigate his life from prison to crack down on the epidemic in the increase of drugs on the streets. </b>"
  strg = strg .. " <br><br><br><br><font size='10'>Recent News</font>"

  for i = #recentConvictions, 1, -1 do
    strg = strg .. "<br><br>" .. recentConvictions[i]
  end

  TriggerServerEvent("NewsStandCheckFinish", strg, "")
end)

RegisterCommand("news", function()
  TriggerEvent("NewsStandCheck")
end, false)

local newsStands = {
  1211559620,
  -1186769817,
  -756152956,
  720581693,
  -838860344
}

--[[
    -- Type: Function
    -- Name: checkForNewsStand
    -- Use: Verifies player proximity to predefined news stand objects.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function checkForNewsStand()
  local playerCoords = GetEntityCoords(PlayerPedId())
  for _, model in ipairs(newsStands) do
    local obj = GetClosestObjectOfType(playerCoords, 3.0, model, false, false, false)
    if DoesEntityExist(obj) then
      return true
    end
  end
  return false
end

--[[
    -- Type: Function
    -- Name: runNewsStand
    -- Use: Starts the news retrieval process.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function runNewsStand()
  TriggerEvent("stringGangGlobalReputations")
end

RegisterNetEvent("NewsStandCheck")
AddEventHandler("NewsStandCheck", function()
  if checkForNewsStand() then
    runNewsStand()
  else
    TriggerEvent("notification", "You are not near a News Stand.", 2)
  end
end)
