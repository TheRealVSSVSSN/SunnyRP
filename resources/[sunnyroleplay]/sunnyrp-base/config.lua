-- resources/[sunnyrp]/sunnyrp-base/config.lua
-- Authoritative API settings + feature toggles for SunnyRP base.

SRP_CONFIG = SRP_CONFIG or {}

-- API configuration (read via ConVars so you can change without edits)
SRP_CONFIG.api = {
  baseUrl = GetConvar('srp_api_base_url', 'http://127.0.0.1:3010'),
  token   = GetConvar('srp_api_token', 'CHANGE-ME'),
  timeoutMs = tonumber(GetConvar('srp_api_timeout_ms', '5000')) or 5000,
  retries = tonumber(GetConvar('srp_api_retries', '1')) or 1,

  -- Optional HMAC replay guard; must match backend settings
  hmac = {
    enabled = (GetConvar('srp_api_hmac_enabled', '0') == '1'),
    secret  = GetConvar('srp_api_hmac_secret', ''),

    -- canonical string style used by backend replay guard:
    -- 'newline' => "ts\nnonce\nMETHOD\n/path\nrawBody"
    -- 'pipe'    => "METHOD|/path|rawBody|ts|nonce"
    style   = GetConvar('srp_api_hmac_style', 'newline'),
  },
}

-- Config sync polling
SRP_CONFIG.poll = {
  enabled = (GetConvar('srp_feature_config_sync_enabled', '1') == '1'),
  intervalMs = tonumber(GetConvar('srp_config_poll_ms', '10000')) or 10000,
}

-- Optional whitelist gating (honors backend response fields; purely cosmetic if backend already gates)
SRP_CONFIG.whitelist = {
  enforce = (GetConvar('srp_whitelist_enforce', '0') == '1'),
  message = GetConvar('srp_whitelist_message', 'You are not whitelisted.'),
}

-- Logging verbosity for this resource
SRP_CONFIG.logLevel = GetConvar('srp_log_level', 'info') -- 'debug' | 'info' | 'warn' | 'error'