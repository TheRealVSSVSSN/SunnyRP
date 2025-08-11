-- Deferral orchestrator with registration polling via /registration/status/:id (fallback to /players/:id)

SRP_Deferrals = {}

local function update(def, msg) def.update(msg) end

local function getRegStatus(playerId)
  -- Try the dedicated registration status endpoint first
  local r = SRP_HTTP.Fetch('GET', ('/registration/status/%s'):format(playerId), nil, { retries = 1, timeout = 6000 })
  if r.ok and r.data and r.data.ok and r.data.status then
    local s = r.data.status
    return {
      verified = s.verified == true,
      phoneVerified = s.phoneVerified == true,
      emailVerified = s.emailVerified == true,
      discordVerified = s.discordVerified == true,
      ageVerified = s.ageVerified == true,
      tosAccepted = s.tosAccepted == true
    }
  end

  -- Fallback to legacy GET /players/:id returning a row with verified
  local r2 = SRP_HTTP.Fetch('GET', ('/players/%s'):format(playerId), nil, { retries = 1, timeout = 6000 })
  if r2.ok and r2.data then
    local s = r2.data
    return {
      verified = s.verified == true,
      phoneVerified = s.phone_verified == true,
      emailVerified = s.email_verified == true,
      discordVerified = s.discord_verified == true,
      ageVerified = s.age_verified == true,
      tosAccepted = s.tos_accepted == true
    }
  end
  return nil
end

local function waitUntilVerified(playerId, maxWaitMs, pollMs, url, def)
  local waited = 0
  while waited < maxWaitMs do
    update(def, ('Please complete verification to join.\n\nOpen: %s\n\nWaiting... (%ds)')
      :format(url, math.floor((maxWaitMs - waited)/1000)))

    local s = getRegStatus(playerId)
    if s and s.verified then return true end

    Citizen.Wait(pollMs)
    waited = waited + pollMs
  end
  return false
end

function SRP_Deferrals.handle(src, name, setKickReason, def)
  def.defer()

  -- Step 0: identifiers + link
  update(def, 'Linking your account...')
  local user, err = exports['srp_base']:getModule('Player').Link(src, name)
  if not user or not user.playerId then
    def.done(('Failed to link account (%s). Try again later.'):format(err or 'unknown'))
    return
  end

  -- Step 1: permissions
  update(def, 'Loading permissions...')
  exports['srp_base']:getModule('Player').RefreshPerms(src, user.playerId)

  -- Step 2: registration/verification gate
  local reg = SRP_Config.Registration or {}
  if reg.enabled and reg.requireVerified and not reg.allowJoinIfUnverified then
    if not user.verified then
      TriggerEvent('srp:registration:required', src, user.playerId)

      local url = reg.webBaseUrl or 'https://example.com/register'
      local ok = waitUntilVerified(user.playerId, reg.maxWaitMs or 300000, reg.pollIntervalMs or 2000, url, def)
      if not ok then
        def.done('Verification required. Please complete registration and try again.')
        return
      end
    end
  end

  -- Step 3: success
  update(def, 'Welcome to Sunny Roleplay!')
  def.done()
end

return SRP_Deferrals