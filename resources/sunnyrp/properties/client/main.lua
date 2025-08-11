-- resources/sunnyrp/properties/client/main.lua
local interactDist = tonumber(GetConvar('srp_prop_interaction_dist','2.2')) or 2.2
local nearProps = {}  -- optional cache / debug blips

-- HUD prompts + basic interaction example (bind E near a property entry)
CreateThread(function()
  while true do
    Wait(0)
    -- In a proper build, you'd stream property markers from server or config
    -- For Phase M DoD, rely on server command /prop_list to learn ids/entries.
  end
end)

-- Entered: teleport to interior coords; (server sets bucket)
RegisterNetEvent('srp:properties:entered', function(data)
  local ped = PlayerPedId()
  local exit = data.interior and data.interior.exit_coords or nil
  if exit then
    SetEntityCoords(ped, exit.x+0.0, exit.y+0.0, exit.z+0.0, false, false, false, true)
    SetEntityHeading(ped, exit.h or 0.0)
  end
end)

-- Exited: place player back at exterior world_entry
RegisterNetEvent('srp:properties:exited', function(data)
  -- You can request exterior info again if needed
end)

-- Minimal helper to ask server to open a property stash later:
-- SRP.Inventory.OpenContainer('property:'..propertyId)  -- (Phase G+ container support)