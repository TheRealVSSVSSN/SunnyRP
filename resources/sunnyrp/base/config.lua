SRP = SRP or {}

SRP.Config = {
  ApiUrl = GetConvar('srp_api_url', 'http://127.0.0.1:3301'),
  ApiToken = GetConvar('srp_api_token', 'changeme_please'),
  FeaturesCsv = GetConvar('srp_features', 'players,characters,inventory'),
  PrimaryIdentifier = GetConvar('srp_primary_identifier', 'license'),
  RequiredIdentifiersCsv = GetConvar('srp_required_identifiers', 'license,discord'),
  HttpTimeoutMs = tonumber(GetConvar('srp_http_timeout_ms', '5000')) or 5000,
  HttpRetries = tonumber(GetConvar('srp_http_retries', '3')) or 3,
  LogLevel = GetConvar('srp_log_level', 'info')
}

local function splitCsv(v)
  local out = {}
  for s in string.gmatch(v or '', '([^,]+)') do out[#out+1] = (s:gsub('^%s*(.-)%s*$', '%1')) end
  return out
end

SRP.Features = SRP.Features or {}
SRP.Features._set = {}
for _, name in ipairs(splitCsv(SRP.Config.FeaturesCsv)) do
  SRP.Features._set[name] = true
end

function SRP.Features.IsEnabled(name)
  return SRP.Features._set[name] == true
end