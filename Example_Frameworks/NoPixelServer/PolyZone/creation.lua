local createdShape
local drawShape = false

local GetEntityCoords = GetEntityCoords
local PlayerPedId = PlayerPedId

RegisterNetEvent("pz_startshape")
AddEventHandler("pz_startshape", function(pName)
  if createdShape ~= nil then
    return
  end

  local coords = GetEntityCoords(PlayerPedId())

  createdShape = {
    points = {vector2(coords.x, coords.y)},
    options = {name = tostring(pName)}
  }

  drawShape = true
  drawThread()
end)

RegisterNetEvent("pz_addpoint")
AddEventHandler("pz_addpoint", function()
  local coords = GetEntityCoords(PlayerPedId())
  createdShape.points[#createdShape.points + 1] = vector2(coords.x, coords.y)
end)

RegisterNetEvent("pz_removepoint")
AddEventHandler("pz_removepoint", function()
  createdShape.points[#createdShape.points] = nil
end)

RegisterNetEvent("pz_endshape")
AddEventHandler("pz_endshape", function()
  TriggerServerEvent("polyzone:printShape", createdShape)
  drawShape = false
  createdShape = nil
end)

-- Drawing
function drawThread()
  CreateThread(function()
    while drawShape do
      PolyZone.drawPoly(createdShape, {drawPoints=true})
      Wait(1)
    end
  end)
end
