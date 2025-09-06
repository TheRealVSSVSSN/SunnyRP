SRP = SRP or {}

local rawExports = exports

function SRP.Export(name, fn)
  SRP[name] = fn
  if rawExports and type(rawExports) == 'function' then
    rawExports(name, fn)
  end
end

function exports(name, fn)
  SRP.Export(name, fn)
end
