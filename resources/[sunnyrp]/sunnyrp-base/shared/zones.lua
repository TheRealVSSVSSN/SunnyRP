-- Minimal PolyZone-compatible helpers (server-agnostic, client-only use expected)
-- We expose Circle/Box/Poly constructs with OnEnter/OnExit callbacks.
-- For heavy use, you can still vendor the real PolyZone; this is a light compat layer.

SRP_Zones = SRP_Zones or { zones = {}, lastInside = {} }

local function vec3(x,y,z) return vector3(x+0.0, y+0.0, z+0.0) end

local function pointInCircle(pt, center, radius)
  local dx, dy = pt.x - center.x, pt.y - center.y
  return (dx*dx + dy*dy) <= (radius*radius)
end

local function pointInBox(pt, min, max)
  return pt.x >= min.x and pt.x <= max.x and pt.y >= min.y and pt.y <= max.y and pt.z >= min.z and pt.z <= max.z
end

local function pointInPoly2D(pt, poly)
  -- even-odd rule (2D X/Y)
  local x, y = pt.x, pt.y
  local inside = false
  local j = #poly
  for i=1,#poly do
    local xi, yi = poly[i].x, poly[i].y
    local xj, yj = poly[j].x, poly[j].y
    local intersect = ((yi>y) ~= (yj>y)) and (x < (xj - xi) * (y - yi) / ((yj - yi) ~= 0 and (yj - yi) or 1e-9) + xi)
    if intersect then inside = not inside end
    j = i
  end
  return inside
end

local Zone = {}
Zone.__index = Zone

function Zone:IsPointInside(pt)
  if self.type == 'circle' then
    return pointInCircle(pt, self.center, self.radius)
  elseif self.type == 'box' then
    return pointInBox(pt, self.min, self.max)
  elseif self.type == 'poly' then
    if self.minZ and self.maxZ and (pt.z < self.minZ or pt.z > self.maxZ) then return false end
    return pointInPoly2D(pt, self.points)
  end
  return false
end

function Zone:OnEnter(cb) self.onEnter = cb end
function Zone:OnExit(cb)  self.onExit  = cb end
function Zone:OnInside(cb, tickMs) self.onInside = cb; self.insideTick = tickMs or 500 end

local function addZone(z)
  SRP_Zones.zones[z.name] = z
end

function SRP_Zones.AddCircle(name, center, radius, opts)
  local z = setmetatable({
    name = name, type = 'circle',
    center = vec3(center.x, center.y, center.z or 0.0),
    radius = radius+0.0, onEnter=nil, onExit=nil, onInside=nil, insideTick=500
  }, Zone)
  addZone(z); return z
end

function SRP_Zones.AddBox(name, center, w, h, minZ, maxZ)
  local halfW, halfH = (w/2.0), (h/2.0)
  local min = vec3(center.x - halfW, center.y - halfH, minZ or -1000.0)
  local max = vec3(center.x + halfW, center.y + halfH, maxZ or  1000.0)
  local z = setmetatable({
    name = name, type = 'box',
    min = min, max = max, onEnter=nil, onExit=nil, onInside=nil, insideTick=500
  }, Zone)
  addZone(z); return z
end

function SRP_Zones.AddPoly(name, points, minZ, maxZ)
  local pts = {}
  for _,p in ipairs(points or {}) do pts[#pts+1] = vec3(p.x, p.y, p.z or 0.0) end
  local z = setmetatable({
    name = name, type = 'poly',
    points = pts, minZ = minZ, maxZ = maxZ, onEnter=nil, onExit=nil, onInside=nil, insideTick=500
  }, Zone)
  addZone(z); return z
end

-- Zone ticking (client expected)
if IsDuplicityVersion and not IsDuplicityVersion() then
  CreateThread(function()
    local lastInside = {}
    while true do
      local ped = PlayerPedId()
      local pos = GetEntityCoords(ped)
      for name, z in pairs(SRP_Zones.zones) do
        local inside = z:IsPointInside(pos)
        local was = lastInside[name] == true
        if inside and not was and z.onEnter then pcall(z.onEnter) end
        if not inside and was and z.onExit then pcall(z.onExit) end
        if inside and z.onInside then
          -- throttle per-zone
          z._nextInside = z._nextInside or 0
          local now = GetGameTimer()
          if now >= z._nextInside then
            z._nextInside = now + (z.insideTick or 500)
            pcall(z.onInside)
          end
        end
        lastInside[name] = inside
      end
      Wait(300)
    end
  end)
end

exports('ZoneAddCircle', SRP_Zones.AddCircle)
exports('ZoneAddBox', SRP_Zones.AddBox)
exports('ZoneAddPoly', SRP_Zones.AddPoly)