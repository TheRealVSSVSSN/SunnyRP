-- https://github.com/ImagicTheCat/vRP
-- MIT license (see LICENSE or vrp/vRPShared.lua)

if not vRP.modules.admin then return end

local Admin = class("Admin", vRP.Extension)

-- METHODS

function Admin:__construct()
  vRP.Extension.__construct(self)

  self.noclip = false
  self.noclipEntity = nil
  self.noclip_speed = 1.0

  -- noclip task
  CreateThread(function()
    local Base = vRP.EXT.Base

    while true do
      Wait(0)
      if self.noclip then
        local ped = PlayerPedId()
        local x,y,z = Base:getPosition(self.noclipEntity)
        local dx,dy,dz = Base:getCamDirection(self.noclipEntity)
        local speed = self.noclip_speed

        -- reset velocity
        SetEntityVelocity(self.noclipEntity, 0.0001, 0.0001, 0.0001)

        -- forward
        if IsControlPressed(0,32) then -- MOVE UP
          x = x+speed*dx
          y = y+speed*dy
          z = z+speed*dz
        end

        -- backward
        if IsControlPressed(0,269) then -- MOVE DOWN
          x = x-speed*dx
          y = y-speed*dy
          z = z-speed*dz
        end

        SetEntityCoordsNoOffset(self.noclipEntity,x,y,z,true,true,true)
      end
    end
  end)
end

function Admin:toggleNoclip()
  self.noclip = not self.noclip

  local ped = PlayerPedId()
  
  if IsPedInAnyVehicle(ped, false) then
      self.noclipEntity = GetVehiclePedIsIn(ped, false)
  else
      self.noclipEntity = ped
  end
  
  SetEntityCollision(self.noclipEntity, not self.noclip, not self.noclip)
  SetEntityInvincible(self.noclipEntity, self.noclip)
  SetEntityVisible(self.noclipEntity, not self.noclip, false)
  
  -- rotate entity to match camera heading
  local vx, vy, vz = table.unpack(GetGameplayCamRot(2))
  SetEntityRotation(self.noclipEntity, vx, vy, vz, 0, false)
end

--[[
    -- Type: Function
    -- Name: teleportToMarker
    -- Use: Teleports the player to the first waypoint on the map
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
function Admin:teleportToMarker()
  local ped = PlayerPedId()

  -- find GPS blip
  local it = GetBlipInfoIdIterator()
  local blip = GetFirstBlipInfoId(it)
  local ok, done
  repeat
    ok = DoesBlipExist(blip)
    if ok then
      if GetBlipInfoIdType(blip) == 4 then
        ok = false
        done = true
      else
        blip = GetNextBlipInfoId(it)
      end
    end
  until not ok

  if done then
    local x, y, z = table.unpack(GetBlipInfoIdCoord(blip))

    local gz, ground = 0.0, false
    for zz = 0.0, 800.0, 50.0 do
      SetEntityCoordsNoOffset(ped, x, y, zz, 0, 0, 1)
      ground, gz = GetGroundZFor_3dCoord(x, y, zz)
      if ground then break end
    end

    if ground then
      vRP.EXT.Base:teleport(x, y, gz + 3.0)
    else
      vRP.EXT.Base:teleport(x, y, 1000.0)
      GiveDelayedWeaponToPed(ped, 0xFBAB5776, 1, 0)
    end
  end
end

-- TUNNEL

Admin.tunnel = {}
Admin.tunnel.toggleNoclip = Admin.toggleNoclip
Admin.tunnel.teleportToMarker = Admin.teleportToMarker

vRP:registerExtension(Admin)
