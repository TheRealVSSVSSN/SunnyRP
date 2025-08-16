SRP = SRP or {}
SRP.Jobs = SRP.Jobs or {}

-- No static wages here: salaries come from DB via the core-api.
-- Provide simple caching knobs:
SRP.Jobs.Config = {
  refreshMs = 30000, -- periodic sanity refresh of on-duty cache
}