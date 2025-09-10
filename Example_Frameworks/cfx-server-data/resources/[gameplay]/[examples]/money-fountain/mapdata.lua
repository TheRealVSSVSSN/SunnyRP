-- define the money fountain list (SHARED SCRIPT)
moneyFountains = {}

-- index to know what to remove
local fountainIdx = 1

--[[
    -- Type: Function
    -- Name: getMapDirectives
    -- Use: Registers money fountain directive for map parsing
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
AddEventHandler('getMapDirectives', function(add)
    add('money_fountain', function(state, name)
        return function(data)
            local coords = data[1]
            local amount = data.amount or 100

            local idx = fountainIdx
            fountainIdx = fountainIdx + 1

            moneyFountains[idx] = {
                id = name,
                coords = coords,
                amount = amount
            }

            state.add('idx', idx)
        end
    end, function(state)
        moneyFountains[state.idx] = nil
    end)
end)
