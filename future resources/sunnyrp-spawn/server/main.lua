SRP = SRP or {}
SRP.Spawn = SRP.Spawn or {}

-- Internal event used by characters resource once canonical state is ready
AddEventHandler('srp:spawn:internal:spawn', function(src, payload)
  local bucket = tonumber(payload.routing_bucket or 0)
  local useBuckets = GetConvar('srp_use_routing_buckets', 'false') == 'true'

  if useBuckets and bucket > 0 then
    SetPlayerRoutingBucket(src, bucket)
  else
    SetPlayerRoutingBucket(src, 0)
  end

  -- Save last position immediately (so "spawn at last" works next login)
  local body = {
    characterId = payload.characterId,
    position = payload.position,
    routing_bucket = bucket
  }
  local res = SRP.Fetch({ path = '/characters/state/position', method = 'POST', body = body })
  if not res or res.status ~= 200 then
    SRP.Warn('Failed to persist spawn position', { status = res and res.status })
  end

  -- Tell client to perform the actual spawn
  TriggerClientEvent('srp:spawn:do', src, payload.position)
end)

-- Optional: admin command to move someone to a named point (example)
RegisterCommand('srp_spawn_to', function(source, args)
  local tgt = tonumber(args[1] or 0); local name = tostring(args[2] or '')
  if tgt <= 0 or name == '' then return end
  local p = SRP.Spawn.Points[name]; if not p then return end
  TriggerClientEvent('srp:spawn:do', tgt, p)
end, true)