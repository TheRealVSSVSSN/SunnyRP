SRP = SRP or {}

local json = json or {}

function SRP._log(level, msg, data)
  if data ~= nil then
    print(('[SRP][%s] %s | %s'):format(level, msg, json.encode(data)))
  else
    print(('[SRP][%s] %s'):format(level, msg))
  end
end

function SRP.Info(msg, data) SRP._log('INFO', msg, data) end
function SRP.Warn(msg, data) SRP._log('WARN', msg, data) end
function SRP.Error(msg, data) SRP._log('ERROR', msg, data) end

function SRP.TableClone(tbl)
  local t = {}; for k,v in pairs(tbl or {}) do t[k] = v end; return t
end

function SRP.GenerateUUID()
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  return string.gsub(template, '[xy]', function (c)
      local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
      return string.format('%x', v)
  end)
end