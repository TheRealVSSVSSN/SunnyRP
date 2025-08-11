-- resources/sunnyrp/shops/server/main.lua
SRP = SRP or {}
SRP.Shops = SRP.Shops or {}
local CFG = SRP.Shops.Config
local lastBuyAt = {}

local function actorHeaders(src)
  local uid = (SRP.GetUserBySrc and SRP.GetUserBySrc(src) or {}).id
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src) or nil
  return { ['X-SRP-UserId']=tostring(uid or 0), ['X-SRP-CharId']=tostring(cid or 0) }
end

local function ratelimited(src)
  local now = GetGameTimer()
  if now - (lastBuyAt[src] or 0) < CFG.rateLimitMs then return true end
  lastBuyAt[src] = now; return false
end

-- Catalog fetch by slug
SRP.Shops.FetchCatalog = function(src, slug)
  local res = SRP.Fetch({ path='/shops/catalog?slug='..slug, method='GET' })
  if not res or res.status ~= 200 then return nil end
  local ok, obj = pcall(function() return json.decode(res.body) end)
  return ok and obj and obj.ok and obj.data or nil
end

-- Purchase flow (server-authoritative)
SRP.Shops.Purchase = function(src, slug, lines, payFrom)
  if ratelimited(src) then return TriggerClientEvent('srp:notify', src, 'Please wait...') end
  -- idempotency key for safety
  local idem = ('shop:%s:%s:%s'):format(slug, tostring(src), tostring(GetGameTimer()))
  local res = SRP.Fetch({
    path='/shops/purchase',
    method='POST',
    body={ slug=slug, lines=lines, idempotencyKey=idem, payFrom=payFrom or 'cash' },
    headers=actorHeaders(src)
  })
  if not res or res.status ~= 200 then return TriggerClientEvent('srp:notify', src, 'Purchase failed.') end
  local ok, obj = pcall(function() return json.decode(res.body or '{}') end)
  if not ok or not obj or not obj.ok then return TriggerClientEvent('srp:notify', src, 'Purchase declined.') end

  -- Add items to inventory via backend (Phase G)
  local cid = SRP.Characters and SRP.Characters.GetActiveCharId and SRP.Characters.GetActiveCharId(src)
  if cid then
    for _, ln in ipairs(obj.data.lines or {}) do
      SRP.Fetch({ path = '/inventory/'..tostring(cid)..'/add', method='POST',
        body = { item = ln.code, count = ln.qty, reason = 'shop_purchase', idempotencyKey = idem..':inv:'..ln.code } })
    end
  end

  TriggerClientEvent('srp:notify', src, ('Purchased items — total $%0.2f'):format((obj.data.totals.total_cents or 0)/100.0))
  TriggerClientEvent('srp:shops:receipt', src, obj.data)
end

-- Quick test commands
RegisterCommand('shop_catalog', function(src, args)
  local slug = tostring(args[1] or '247_vanilla_1')
  local data = SRP.Shops.FetchCatalog(src, slug)
  TriggerClientEvent('srp:shops:catalog', src, data or {})
end)

RegisterCommand('shop_buy', function(src, args)
  -- /shop_buy 247_vanilla_1 water 2 sandwich 1
  local slug = tostring(args[1] or '247_vanilla_1')
  local lines = {}
  local i = 2
  while i <= #args do
    local code = tostring(args[i]); local qty = tonumber(args[i+1] or 1) or 1
    lines[#lines+1] = { code = code, qty = qty }
    i = i + 2
  end
  if #lines == 0 then lines = { { code='water', qty=1 } } end
  SRP.Shops.Purchase(src, slug, lines, 'cash')
end)