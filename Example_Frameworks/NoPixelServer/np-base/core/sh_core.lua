NPX.Core = NPX.Core or {}

--[[
    -- Type: Function
    -- Name: ConsoleLog
    -- Use: Logs formatted messages to the server console
    -- Created: 2024-04-??
    -- By: VSSVSSN
--]]
function NPX.Core:ConsoleLog(msg, mod)
    if not msg then return end
    mod = mod or "No Module"
    print(('[NPX LOG - %s] %s'):format(mod, msg))
end

RegisterNetEvent('np-base:consoleLog')
AddEventHandler('np-base:consoleLog', function(msg, mod)
    NPX.Core:ConsoleLog(msg, mod)
end)

--[[
    -- Type: Function
    -- Name: getModule
    -- Use: Retrieves a module from the NPX table
    -- Created: 2024-04-??
    -- By: VSSVSSN
--]]
function getModule(module)
    if not NPX[module] then
        print("Warning: '" .. tostring(module) .. "' module doesn't exist")
        return false
    end
    return NPX[module]
end

--[[
    -- Type: Function
    -- Name: addModule
    -- Use: Adds or overrides a module in the NPX table
    -- Created: 2024-04-??
    -- By: VSSVSSN
--]]
function addModule(module, tbl)
    if NPX[module] then
        print("Warning: '" .. tostring(module) .. "' module is being overridden")
    end
    NPX[module] = tbl
end

NPX.Core.ExportsReady = false

--[[
    -- Type: Function
    -- Name: WaitForExports
    -- Use: Signals when np-base exports become available
    -- Created: 2024-04-??
    -- By: VSSVSSN
--]]
function NPX.Core:WaitForExports()
    CreateThread(function()
        while true do
            Wait(0)
            if exports and exports['np-base'] then
                TriggerEvent('np-base:exportsReady')
                NPX.Core.ExportsReady = true
                break
            end
        end
    end)
end

NPX.Core:WaitForExports()