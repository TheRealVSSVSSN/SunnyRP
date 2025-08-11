-- Placeholder for future /events/poll bridge (web -> game)
-- For now we only expose handlers that might be called by other resources.

SRP_Inbox = {}

-- Example: features update via event bus (from backend relay or admin tool)
RegisterNetEvent('srp:features:update', function(changes)
  SRP_Utils.deepMerge(SRP_Config.Features, changes or {})
  print('^3[SRP][INBOX]^7 features updated live.')
end)