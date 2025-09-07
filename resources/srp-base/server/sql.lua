SRP = SRP or {}
SRP.SQL = { memory = { accounts = {}, characters = {} } }

AddEventHandler('onResourceStart', function(res)
  if res ~= GetCurrentResourceName() then return end
  if GetResourceState('ghmattimysql') == 'started' then
    SRP.SQL.db = exports['ghmattimysql']
    SRP.SQL.db:execute('CREATE TABLE IF NOT EXISTS srp_accounts (id VARCHAR(64) PRIMARY KEY)')
    SRP.SQL.db:execute('CREATE TABLE IF NOT EXISTS srp_characters (id VARCHAR(64) PRIMARY KEY, account_id VARCHAR(64), first_name VARCHAR(50), last_name VARCHAR(50))')
  end
end)

--[[
    -- Type: Function
    -- Name: SRP.SQL.fetchAll
    -- Use: Run a SELECT query during failover
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.SQL.fetchAll(query, params, cb)
  if SRP.SQL.db and SRP.Failover.active() then
    SRP.SQL.db:execute(query, params, function(result)
      if cb then cb(result) end
    end)
  else
    if cb then cb({}) end
    return {}
  end
end

--[[
    -- Type: Function
    -- Name: SRP.SQL.execute
    -- Use: Run a mutation query during failover
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.SQL.execute(query, params, cb)
  if SRP.SQL.db and SRP.Failover.active() then
    SRP.SQL.db:execute(query, params, function(result)
      if cb then cb(result) end
    end)
  else
    if cb then cb(0) end
    return 0
  end
end
