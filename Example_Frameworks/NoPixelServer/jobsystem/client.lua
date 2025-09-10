---------------------------------- VAR ----------------------------------
local curJob = nil

local jobs = {
  {name="Unemployed", id="unemployed"},
  {name="Tow Truck Driver", id="towtruck"},  
  {name="Taxi Driver", id="taxi"},
  {name="Delivery Job", id="trucker"},
  {name="Entertainer", id = "entertainer"},
  {name="News Reporter", id = "news"},
  {name="Food Truck", id = "foodtruck"},
    --{name="EMS", id="ems"},
}

---------------------------------- FUNCTIONS ----------------------------------

--[[
    -- Type: Function
    -- Name: changeJob
    -- Use: Notify server to switch the player's job
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]
local function changeJob(id)
  TriggerServerEvent("jobssystem:jobs", id)
end

--[[
    -- Type: Function
    -- Name: menuJobs
    -- Use: Populate the job selection menu
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]
local function menuJobs()
  MenuTitle = "Jobs"
  ClearMenu()
  for _, item in pairs(jobs) do
    Menu.addButton(item.name, changeJob, item.id)
  end
end

--[[
    -- Type: Function
    -- Name: drawTxt
    -- Use: Render simple 2D text on screen
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]
local function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
  SetTextFont(font)
  SetTextProportional(false)
  SetTextScale(scale, scale)
  SetTextColour(r, g, b, a)
  SetTextDropShadow(0, 0, 0, 0, 255)
  SetTextEdge(1, 0, 0, 0, 255)
  SetTextDropShadow()
  SetTextOutline()
  SetTextCentre(centre)
  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(text)
  EndTextCommandDisplayText(x, y)
end

---------------------------------- CITIZEN ----------------------------------
local inGurgle = false
RegisterNetEvent('event:control:jobSystem', function(useID)
  if useID == 1 then
    TriggerServerEvent("server:paySlipPickup")
    Wait(1000)

  elseif useID == 2 and not inGurgle then
    TriggerEvent("Gurgle:open")
    inGurgle = true

  elseif useID == 3 then
    menuJobs()
    Menu.hidden = not Menu.hidden

  end
end)

-- #MarkedForMarker
CreateThread(function()
  while true do
    Wait(0)
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply)

    local jobDst = #(vector3(-1381.527, -477.8708, 72.04207) - plyCoords)
    local gurDst = #(vector3(-1062.96, -248.24, 44.03) - plyCoords)
    local payDst = #(vector3(-1082.81, -248.19, 37.77) - plyCoords)

    if jobDst > 30 and gurDst > 30 and payDst > 30 then
      Wait(1000)
    else
      DrawMarker(27, -1082.81, -248.19, 36.77, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.5001, 0, 155, 255, 200, false, false, 2, false, nil, nil, false)
      DrawMarker(27, -1062.96, -248.24, 43.03, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.5001, 0, 155, 255, 200, false, false, 2, false, nil, nil, false)
      DrawMarker(27, -1381.527, -477.8708, 72.04207, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.5001, 0, 155, 255, 200, false, false, 2, false, nil, nil, false)

      if payDst < 1 then
        drawTxt('Push ~b~E~s~ to pick up your paycheck!', 0, 1, 0.5, 0.8, 0.35, 255, 255, 255, 255)
      end

      if gurDst < 1 then
        drawTxt('Push ~b~E~s~ to create a Gurgle.cum website.', 0, 1, 0.5, 0.8, 0.35, 255, 255, 255, 255)
      else
        inGurgle = false
      end

      if jobDst < 1 then
        if Menu.hidden then
          drawTxt('Push ~b~E~s~ to access jobs (Tow / Taxi / News require your own specific vehicle)', 0, 1, 0.5, 0.8, 0.35, 255, 255, 255, 255)
        else
          drawTxt('Push ~b~Arrows~s~ to change selection, ~b~Enter~s~ to select, ~b~Backspace~s~ to quit.', 0, 1, 0.5, 0.8, 0.35, 255, 255, 255, 255)
        end
      end
      Menu.renderGUI()
    end
  end
end)




RegisterNetEvent('enableGurgleText', function()
  inGurgle = false
end)
RegisterNetEvent('jobssystem:getJob', function(cb)
  cb(curJob)
end)

RegisterNetEvent('jobssystem:updateJob', function(nameJob)
  if nameJob ~= curJob then
    TriggerEvent('clearJobBlips')
  end

  local id = PlayerId()
  local playerName = GetPlayerName(id)

  SendNUIMessage({
    updateJob = true,
    job = nameJob,
    player = playerName
  })

  curJob = nameJob

  if nameJob == "unemployed" then
    TriggerEvent('nowUnemployed')
  end

  if nameJob == "news" then
    TriggerEvent("DoLongHudText", "Press H to pull item news items.")
  end
  
end)

RegisterNetEvent('jobssystem:current', function(cb)
  local LocalPlayer = exports["np-base"]:getModule("LocalPlayer")
  cb(LocalPlayer:getVar("job"))
end)
