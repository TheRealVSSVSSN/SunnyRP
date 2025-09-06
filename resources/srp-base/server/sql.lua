--[[
    -- Type: Module
    -- Name: SQL Wrapper
    -- Use: Handles persistence during failover
    -- Created: 2024-06-02
    -- By: VSSVSSN
--]]

SRP.SQL = {}
local hasMysql = GetResourceState('ghmattimysql') == 'started'

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    if not hasMysql then return end
    exports['ghmattimysql']:execute([[CREATE TABLE IF NOT EXISTS srp_accounts (id VARCHAR(64) PRIMARY KEY)]] , {})
    exports['ghmattimysql']:execute([[CREATE TABLE IF NOT EXISTS srp_characters (id VARCHAR(64) PRIMARY KEY, account_id VARCHAR(64), name VARCHAR(255))]] , {})
    exports['ghmattimysql']:execute([[CREATE TABLE IF NOT EXISTS srp_coords (account_id VARCHAR(64), x DOUBLE, y DOUBLE, z DOUBLE, PRIMARY KEY(account_id))]] , {})
    exports['ghmattimysql']:execute([[CREATE TABLE IF NOT EXISTS srp_sessions (id VARCHAR(64) PRIMARY KEY, account_id VARCHAR(64), character_id VARCHAR(64))]] , {})
end)

local function execSync(query, params)
    if not hasMysql then return 0 end
    local p = promise.new()
    exports['ghmattimysql']:execute(query, params or {}, function(affected)
        p:resolve(affected or 0)
    end)
    return Citizen.Await(p)
end

local function fetchSync(query, params)
    if not hasMysql then return {} end
    local p = promise.new()
    exports['ghmattimysql']:execute(query, params or {}, function(result)
        p:resolve(result or {})
    end)
    return Citizen.Await(p)
end

function SRP.SQL.execute(query, params)
    if not SRP.Failover.active() then return 0 end
    return execSync(query, params)
end

function SRP.SQL.fetchAll(query, params)
    if not SRP.Failover.active() then return {} end
    return fetchSync(query, params)
end
