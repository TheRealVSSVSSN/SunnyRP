-- Notify() route to backend which then fans out to Discord webhooks.
SRP_Notify = {}

function SRP_Notify.Emit(channel, payload)
  payload = payload or {}
  payload.channel = channel
  local res = SRP_HTTP.Fetch('POST', '/notify/emit', payload, { retries = 1 })
  if not res.ok then
    print(('^1[SRP][NOTIFY]^7 failed: %s'):format(res.error or 'unknown'))
  end
end

exports('Notify', SRP_Notify.Emit)