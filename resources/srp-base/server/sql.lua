--[[
    -- Type: Module
    -- Name: sql
    -- Use: Failover persistence via GHMattiMySQL or memory
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local SRP = SRP or require('resources/srp-base/shared/srp.lua')
local hasMySQL = GetResourceState('ghmattimysql') == 'started'
local memory = {
    accounts = {},
    characters = {}
}

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    if hasMySQL and SRP.Failover.active() then
        exports['ghmattimysql']:execute([[CREATE TABLE IF NOT EXISTS accounts(id INT PRIMARY KEY AUTO_INCREMENT, name VARCHAR(64));]])
        exports['ghmattimysql']:execute([[CREATE TABLE IF NOT EXISTS characters(id INT PRIMARY KEY AUTO_INCREMENT, account_id INT, first_name VARCHAR(50), last_name VARCHAR(50));]])
    end
end)

SRP.SQL = {}

SRP.SQL.fetchAll = function(query, params)
    if not hasMySQL or not SRP.Failover.active() then
        return memory[query] or {}
    end
    local p = promise.new()
    exports['ghmattimysql']:execute(query, params or {}, function(result) p:resolve(result) end)
    return Citizen.Await(p)
end

SRP.SQL.execute = function(query, params)
    if not hasMySQL or not SRP.Failover.active() then
        return true
    end
    local p = promise.new()
    exports['ghmattimysql']:execute(query, params or {}, function(result) p:resolve(result) end)
    return Citizen.Await(p)
end

return SRP.SQL
