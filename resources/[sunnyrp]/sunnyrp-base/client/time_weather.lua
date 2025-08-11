local function setTime(h, m, s)
  NetworkOverrideClockTime(h or 12, m or 0, s or 0)
end

local function setWeather(wType)
  ClearOverrideWeather()
  ClearWeatherTypePersist()
  SetWeatherTypeOvertimePersist(wType or 'CLEAR', 10.0)
end

RegisterNetEvent('srp:world:time')
AddEventHandler('srp:world:time', function(cfg)
  if cfg and cfg.override and type(cfg.override) == 'string' then
    local hh, mm = cfg.override:match('^(%d%d?):(%d%d)$')
    if hh then setTime(tonumber(hh), tonumber(mm), 0) end
  end
end)

RegisterNetEvent('srp:world:weather')
AddEventHandler('srp:world:weather', function(cfg)
  if cfg and cfg.current and cfg.current.type then
    setWeather(cfg.current.type)
  end
end)