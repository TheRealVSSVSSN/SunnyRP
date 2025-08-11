-- srp_base: server/guard.lua
-- GuardNetEvent: register a protected net event with scopes / rate-limit / pcall.

local RATE = {
  -- per-source -> eventName -> { last=ms, tokens, refillTs }
  perSource = {}
}

local function nowMs() return GetGameTimer() end

local function ensureBucket(src, name)
  RATE.perSource[src] = RATE.perSource[src] or {}
  RATE.perSource[src][name] = RATE.perSource[src][name] or { last = 0, tokens = 0, refillTs = 0 }
  return RATE.perSource[src][name]
end

local function defaultOpts()
  return {
    scopes = nil,               -- array of required scopes, OR nil for public
    anyScope = false,           -- if true, any(one) scope passes (instead of all)
    cooldownMs = 750,           -- simple cooldown
    bucket = { capacity = 5, refill = 5, perMs = 5000 }, -- token-bucket anti-spam
    validate = nil,             -- function(source, payload) -> ok, errMsg
    logName = nil,              -- optional log label
    dropOnPanic = false         -- if handler errors, drop player (false by default)
  }
end

local function hasAllScopes(src, scopes)
  for _, sc in ipairs(scopes or {}) do
    if not SRP_Perms.hasScope(src, sc) then return false end
  end
  return true
end
local function hasAnyScope(src, scopes)
  for _, sc in ipairs(scopes or {}) do
    if SRP_Perms.hasScope(src, sc) then return true end
  end
  return (#(scopes or {}) == 0)
end

local function passScopes(src, scopes, anyScope)
  if not scopes or #scopes == 0 then return true end
  return anyScope and hasAnyScope(src, scopes) or hasAllScopes(src, scopes)
end

local function passCooldown(slot, ms)
  if ms <= 0 then return true end
  local t = nowMs()
  if (t - (slot.last or 0)) < ms then return false end
  slot.last = t
  return true
end

local function passBucket(slot, cfg)
  local t = nowMs()
  local cap = cfg.capacity or 5
  local perMs = cfg.perMs or 5000
  local refill = cfg.refill or cap

  if slot.refillTs == 0 then
    slot.tokens = cap
    slot.refillTs = t + perMs
  end

  if t >= slot.refillTs then
    slot.tokens = math.min(cap, slot.tokens + refill)
    slot.refillTs = t + perMs
  end

  if slot.tokens <= 0 then return false end
  slot.tokens = slot.tokens - 1
  return true
end

local function safeHandler(evName, src, payload, handler, dropOnPanic)
  local ok, err = pcall(handler, src, payload)
  if not ok then
    print(('[SRP:GUARD] Handler panic in "%s" from %s: %s'):format(evName, tostring(src), tostring(err)))
    if dropOnPanic then
      DropPlayer(src, 'Protocol violation.')
    end
  end
end

function GuardNetEvent(eventName, opts, handler)
  local o = defaultOpts()
  for k,v in pairs(opts or {}) do o[k] = v end

  RegisterNetEvent(eventName)
  AddEventHandler(eventName, function(payload)
    local src = source
    local slot = ensureBucket(src, eventName)

    -- scopes
    if not passScopes(src, o.scopes, o.anyScope) then
      return
    end
    -- cooldown
    if not passCooldown(slot, o.cooldownMs or 0) then
      return
    end
    -- token bucket
    if o.bucket and not passBucket(slot, o.bucket) then
      return
    end
    -- validate
    if o.validate then
      local ok, msg = o.validate(src, payload)
      if not ok then
        if o.logName then
          print(('[SRP:GUARD] %s rejected from %s: %s'):format(o.logName, tostring(src), tostring(msg or 'bad_payload')))
        end
        return
      end
    end

    safeHandler(eventName, src, payload, handler, o.dropOnPanic == true)
  end)
end

exports('GuardNetEvent', GuardNetEvent)