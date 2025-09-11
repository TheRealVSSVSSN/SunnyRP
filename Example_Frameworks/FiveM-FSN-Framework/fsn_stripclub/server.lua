--[[
    -- Type: Server Script
    -- Name: fsn_stripclub/server.lua
    -- Use: Manages booth ownership and synchronization for the strip club
    -- Created: 2024-04-20
    -- By: VSSVSSN
--]]

local positions = {
  [1] = {
    pos = { x = 112.29388427734, y = -1305.138671875, z = 29.269525527954 },
    sitpos = { x = 112.76410675049, y = -1305.7038574219, z = 29.269525527954, h = 21.393161773682 },
    dancerpos = {
      front = { x = 112.32679748535, y = -1305.0974121094, z = 29.269533157349, h = 200.47219848633 },
      back = { x = 112.40575408936, y = -1305.1303710938, z = 29.269533157349, h = 26.611642837524 },
    },
    inuse = false,
    player = nil,
  }
}

--[[
    -- Type: Function
    -- Name: broadcast
    -- Use: Sends booth state to all clients
    -- Created: 2024-04-20
    -- By: VSSVSSN
--]]
local function broadcast()
  TriggerClientEvent('fsn_stripclub:client:update', -1, positions)
end

RegisterNetEvent('fsn_stripclub:server:sync', function()
  TriggerClientEvent('fsn_stripclub:client:update', source, positions)
end)

RegisterNetEvent('fsn_stripclub:server:claimBooth', function(id)
  local src = source
  local booth = positions[id]
  if booth and not booth.inuse then
    booth.inuse = true
    booth.player = src
    broadcast()
  else
    TriggerClientEvent('fsn_stripclub:client:update', src, positions)
  end
end)

RegisterNetEvent('fsn_stripclub:server:releaseBooth', function(id)
  local src = source
  local booth = positions[id]
  if booth and booth.player == src then
    booth.inuse = false
    booth.player = nil
    broadcast()
  end
end)

AddEventHandler('playerDropped', function()
  local src = source
  local updated = false
  for _, booth in pairs(positions) do
    if booth.player == src then
      booth.inuse = false
      booth.player = nil
      updated = true
    end
  end
  if updated then
    broadcast()
  end
end)

