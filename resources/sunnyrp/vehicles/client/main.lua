-- resources/sunnyrp/vehicles/client/main.lua
SRP = SRP or {}

-- Basic lock/start enforcement hook (placeholder for your real system)
-- Idea: when player tries to enter driver seat, ask server if they have keys; if not, lock.
-- This is a stub showing where to integrate with your preferred flow.

local function isDriverSeat(seat) return seat == -1 end

CreateThread(function()
  while true do
    Wait(250)
    local ped = PlayerPedId()
    if IsPedTryingToEnterALockedVehicle(ped) then
      -- game handles lock sound; your server can decide locks based on keys
    end
    if IsPedInAnyVehicle(ped, false) then
      local veh = GetVehiclePedIsIn(ped, false)
      if GetPedInVehicleSeat(veh, -1) == ped then
        -- You can emit a server ping here to validate keys for the vehicle id if you
        -- attach statebags to link entity -> vehicle_id. For baseline we skip.
      end
    end
  end
end)