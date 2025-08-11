-- resources/sunnyrp/inventory/client/main.lua
SRP = SRP or {}

local hotbar = {} -- { {slot=1,key='water',qty=3}, ... }
local markers = {} -- ground drops

-- Map 1..5 to use
for i=1,(tonumber(GetConvar('srp_inv_hotbar_slots','5')) or 5) do
  local cmd = 'srp_hotbar_'..i
  RegisterCommand(cmd, function()
    TriggerServerEvent('srp:inventory:use', i)
  end, false)
  RegisterKeyMapping(cmd, ('Use hotbar %d'):format(i), 'keyboard', tostring(i))
end

-- UI syncing
RegisterNetEvent('srp:inventory:hotbar', function(slots)
  hotbar = {}
  for _, s in ipairs(slots or {}) do table.insert(hotbar, s) end
  SendNUIMessage({ action='hotbar', payload=hotbar })
end)

-- Equip weapon (authorized by server)
RegisterNetEvent('srp:inventory:client:equipWeapon', function(payload)
  local key = payload.key
  local meta = payload.meta or {}
  GiveWeaponToPed(PlayerPedId(), joaat(key), tonumber(meta.ammo or 0), false, true)
end)

-- Consumable feedback
RegisterNetEvent('srp:inventory:client:consumed', function(data)
  -- could show a small toast; for now just flash the slot in UI
  SendNUIMessage({ action='consumed', payload=data })
end)

-- Ground drops
RegisterNetEvent('srp:inventory:drop:spawn', function(d)
  markers[d.id] = { x=d.x, y=d.y, z=d.z }
end)
RegisterNetEvent('srp:inventory:drop:despawn', function(id)
  markers[id] = nil
end)

-- Simple 3D markers + pickup key (E)
CreateThread(function()
  while true do
    local wait = 500
    local ped = PlayerPedId()
    local p = GetEntityCoords(ped)
    for id, m in pairs(markers) do
      local dx, dy, dz = m.x - p.x, m.y - p.y, m.z - p.z
      local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
      if dist < 5.0 then
        wait = 0
        DrawMarker(2, m.x, m.y, m.z + 0.2, 0,0,0, 0,0,0, 0.2,0.2,0.2, 88,166,255, 150, false, true, 2, nil, nil, false)
        if dist < 1.5 then
          SetTextCentre(true); SetTextOutline()
          BeginTextCommandDisplayText("STRING")
          AddTextComponentSubstringPlayerName("~g~E~s~ Pick up")
          EndTextCommandDisplayText(0.5, 0.9)
          if IsControlJustPressed(0, 38) then -- E
            TriggerServerEvent('srp:inventory:pickup', id)
          end
        end
      end
    end
    Wait(wait)
  end
end)