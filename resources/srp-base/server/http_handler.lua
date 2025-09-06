local function handler(req, res)
  if not req.path or not req.path:find('^/srp%-base') then return end
  local path = req.path:sub(string.len('/srp-base') + 1)
  if path == '/v1/health' and req.method == 'GET' then
    res.writeHead(200, { ['Content-Type'] = 'application/json' })
    res.send(json.encode({ status = 'ok', service = 'srp-base', time = os.date('!%Y-%m-%dT%H:%M:%SZ') }))
    return true
  elseif path == '/internal/srp/rpc' and req.method == 'POST' then
    if req.headers['x-srp-internal-key'] ~= GetConvar('srp_internal_key', 'change_me') then
      res.writeHead(401, {})
      res.send('unauthorized')
      return true
    end
    local data = ''
    req.setDataHandler(function(body) data = data .. body end)
    req.setFinishHandler(function()
      local env = {}
      if data and #data > 0 then env = json.decode(data) or {} end
      local out = SRP.RPC.handle(env)
      res.writeHead(200, { ['Content-Type'] = 'application/json' })
      res.send(json.encode(out))
    end)
    return true
  end
  res.writeHead(404, {})
  res.send('not found')
  return true
end

SetHttpHandler(handler)
