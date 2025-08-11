-- resources/sunnyrp/economy/server/main.lua
SRP = SRP or {}
SRP.Economy = SRP.Economy or {}
local CFG = SRP.Economy.Config

-- Helpers
local function cents(n) return math.floor((n or 0) * 100 + 0.5) end
local function idemKey() return ('%s-%s'):format(GetGameTimer(), math.random(10000,99999)) end
local function activeChar(src)
  return SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
end

-- ========== Core HTTP wrappers ==========
SRP.Economy.Transfer = function(params)
  local res = SRP.Fetch({
    path = '/economy/transfer',
    method = 'POST',
    body = params,
    headers = { ['X-Idempotency-Key'] = params.idem_key or idemKey() }
  })
  if res and res.status == 200 then
    local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
    if ok and obj and obj.ok then return obj end
  end
  return nil
end

SRP.Economy.RunPayroll = function(charId, grossCents, jobCode)
  local res = SRP.Fetch({
    path = '/economy/payroll/run',
    method = 'POST',
    body = { char_id = charId, gross_cents = grossCents, job_code = jobCode },
    headers = { ['X-Idempotency-Key'] = idemKey() }
  })
  if res and res.status == 200 then
    local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
    if ok and obj and obj.ok then return obj.data end
  end
  return nil
end

-- ========== Commands ==========
-- /pay <serverId> <amount>
RegisterCommand('pay', function(src, args)
  local fromSrc = src
  local toSrc = tonumber(args[1] or 0)
  local amt = tonumber(args[2] or 0)
  if toSrc == 0 or not amt or amt <= 0 then
    TriggerClientEvent('srp:notify', fromSrc, 'Usage: /pay [serverId] [amount]')
    return
  end
  local fromChar = activeChar(fromSrc); local toChar = activeChar(toSrc)
  if not fromChar or not toChar then return end

  local res = SRP.Economy.Transfer({
    kind = 'transfer',
    from = { type='char', charId=fromChar, pocket='cash' },
    to   = { type='char', charId=toChar,   pocket='cash' },
    amount_cents = cents(amt),
    meta = { memo = 'cash hand-to-hand', from_src = fromSrc, to_src = toSrc },
  })
  if res then
    TriggerClientEvent('srp:notify', fromSrc, ('Paid $%0.2f to %d'):format(amt, toSrc))
    TriggerClientEvent('srp:notify', toSrc,   ('Received $%0.2f from %d'):format(amt, fromSrc))
    TriggerClientEvent('srp:hud:money:refresh', fromSrc)
    TriggerClientEvent('srp:hud:money:refresh', toSrc)
  end
end)

-- Deposit/Withdraw (bank<->cash)
RegisterNetEvent('srp:atm:deposit', function(amount)
  local src = source
  local charId = activeChar(src); if not charId then return end
  local centsAmt = cents(tonumber(amount or 0))
  if not centsAmt or centsAmt <= 0 then return end
  local ok = SRP.Economy.Transfer({
    kind='transfer',
    from={ type='char', charId=charId, pocket='cash' },
    to  ={ type='char', charId=charId, pocket='bank' },
    amount_cents=centsAmt, meta={ memo='ATM deposit' }
  })
  if ok then TriggerClientEvent('srp:hud:money:refresh', src) end
end)

RegisterNetEvent('srp:atm:withdraw', function(amount)
  local src = source
  local charId = activeChar(src); if not charId then return end
  local centsAmt = cents(tonumber(amount or 0))
  if not centsAmt or centsAmt <= 0 then return end
  local ok = SRP.Economy.Transfer({
    kind='transfer',
    from={ type='char', charId=charId, pocket='bank' },
    to  ={ type='char', charId=charId, pocket='cash' },
    amount_cents=centsAmt, meta={ memo='ATM withdraw' }
  })
  if ok then TriggerClientEvent('srp:hud:money:refresh', src) end
end)

-- ========== Paycheck loop (server-authoritative trigger, backend calculates withholding) ==========
local function getJobCodeFor(src)
  if SRP.Jobs and SRP.Jobs.GetJobCode then return SRP.Jobs.GetJobCode(src) end
  return 'unemployed'
end

-- And compute gross from Jobs module instead of static config:
local hourlyCents = 0
if SRP.Jobs and SRP.Jobs.GetHourlyCentsFor then hourlyCents = SRP.Jobs.GetHourlyCentsFor(sid) end
local hours = 0.25
local gross = math.floor((hourlyCents * hours) + 0.5)

CreateThread(function()
  while true do
    Wait(CFG.syncMs)
    for _, sid in ipairs(GetPlayers()) do
      local charId = activeChar(sid)
      if charId then
        local job = getJobCodeFor(sid)
        local rate = (SRP.Economy.Config.Jobs[job] or CFG.minWage)
        if rate > 0 then
          -- We simulate 0.25 hr per tick by default (approx every 45s -> 15 min/hr in game time)
          local hours = 0.25
          local gross = cents(rate * hours)
          local result = SRP.Economy.RunPayroll(charId, gross, job)
          if result and result.net_cents and result.net_cents > 0 then
            TriggerClientEvent('srp:notify', sid, ('Paycheck: $%0.2f (net). Taxes: $%0.2f'):format(result.net_cents/100, (result.pit_cents+result.sdi_cents)/100))
            TriggerClientEvent('srp:hud:money:refresh', sid)
          end
        end
      end
    end
  end
end)