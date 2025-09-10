--[[
    -- Type: Client Script
    -- Name: client.lua
    -- Use: Handles client-side NUI for fishing records
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]

local guiEnabled = false

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Enables NUI focus and shows fishing UI
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]
local function openGui()
  SetPlayerControl(PlayerId(), false, 0)
  SetNuiFocus(true, true)
  guiEnabled = true
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Disables NUI focus and hides fishing UI
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]
local function closeGui()
  SetNuiFocus(false, false)
  SendNUIMessage({ openSection = "close" })
  SetPlayerControl(PlayerId(), true, 0)
  guiEnabled = false
end

--[[
    -- Type: Thread
    -- Name: inputHandler
    -- Use: Disables player controls while GUI is open
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]
CreateThread(function()
  while true do
    if guiEnabled then
      DisableControlAction(0, 1, true) -- LookLeftRight
      DisableControlAction(0, 2, true) -- LookUpDown
      DisableControlAction(0, 18, true) -- Enter/Exit vehicle
      DisableControlAction(0, 142, true) -- MeleeAttackAlternate
      if IsControlJustReleased(0, 142) then
        SendNUIMessage({ type = "click" })
      end
      Wait(0)
    else
      Wait(500)
    end
  end
end)

--[[
    -- Type: Callback
    -- Name: close
    -- Use: Handles closing from NUI
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]
RegisterNUICallback("close", function(_, cb)
  closeGui()
  cb("ok")
end)

--[[
    -- Type: Event
    -- Name: FishList
    -- Use: Opens GUI and populates fish list
    -- Created: 2024-06-29
    -- By: VSSVSSN
--]]
RegisterNetEvent("FishList", function(metaData)
  openGui()
  SendNUIMessage({ openSection = "fishOpen", NUICaseId = metaData.caseId })
  for _, v in ipairs(metaData.data) do
    SendNUIMessage({ openSection = "fishUpdate", name = v.name, size = v.size })
  end
end)
