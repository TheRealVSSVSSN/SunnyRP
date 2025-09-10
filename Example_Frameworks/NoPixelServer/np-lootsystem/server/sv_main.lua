--[[
    -- Type: Utility
    -- Name: np-lootsystem Server Logic
    -- Use: Handles loot distribution for various loot containers
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]

math.randomseed(GetGameTimer())

--[[
    -- Type: Function
    -- Name: giveItem
    -- Use: Sends an item to the player through the `player:receiveItem` event
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local function giveItem(src, item, count)
    TriggerClientEvent('player:receiveItem', src, item, count)
end

--[[
    -- Type: Function
    -- Name: processHouseRobbery
    -- Use: Gives default reward and rolls additional loot based on weighted chances
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local function processHouseRobbery(src)
    giveItem(src, 'rolexwatch', math.random(1, 2))

    local roll = math.random(100)
    local cumulative = 0
    local drops = {
        { chance = 1,  item = 'monalisa',         min = 1,   max = 1   },
        { chance = 9,  item = 'decrypterenzo',    min = 1,   max = 2   },
        { chance = 10, item = 'rollcash',         min = 100, max = 100 },
        { chance = 25, item = 'anime',            min = 1,   max = 1   },
        { chance = 5,  item = 'burialmask',       min = 1,   max = 1   },
        { chance = 20, item = 'stoleniphone',     min = 1,   max = 1   },
        { chance = 30, item = 'stolencasiowatch', min = 1,   max = 1   },
    }

    for _, entry in ipairs(drops) do
        cumulative = cumulative + entry.chance
        if roll <= cumulative then
            giveItem(src, entry.item, math.random(entry.min, entry.max))
            break
        end
    end
end

--[[
    -- Type: Function
    -- Name: processBankbox
    -- Use: Rewards the player with various cash items and valuables
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local function processBankbox(src)
    giveItem(src, 'cashroll',    math.random(1, 10))
    giveItem(src, 'cashstack',   math.random(1, 10))
    giveItem(src, 'Gruppe6Card', math.random(1, 10))
    giveItem(src, 'valuablegoods', math.random(1, 10))
end

--[[
    -- Type: Function
    -- Name: processSecureBriefcase
    -- Use: Gives one of two rare hashes when opened
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local function processSecureBriefcase(src)
    local options = { '-879347409', '-1746263880' }
    giveItem(src, options[math.random(#options)], 1)
end

--[[
    -- Type: Function
    -- Name: processChopChop
    -- Use: Gives recyclable materials with a chance for PIX1
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local function processChopChop(src)
    giveItem(src, 'recyclablematerial', math.random(5, 15))
    if math.random(10) == 10 then
        giveItem(src, 'pix1', math.random(1, 3))
    end
end

--[[
    -- Type: Function
    -- Name: processChopChopRare
    -- Use: Gives more recyclable materials with a chance for PIX2
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local function processChopChopRare(src)
    giveItem(src, 'recyclablematerial', math.random(7, 20))
    if math.random(20) == 20 then
        giveItem(src, 'pix2', math.random(1, 3))
    end
end

--[[
    -- Type: Table
    -- Name: lootHandlers
    -- Use: Maps loot types to their processing functions
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
local lootHandlers = {
    houserobbery = processHouseRobbery,
    Bankbox = processBankbox,
    Securebriefcase = processSecureBriefcase,
    chopchop = processChopChop,
    chopchoprare = processChopChopRare,
}

--[[
    -- Type: Event Handler
    -- Name: loot:useItem
    -- Use: Routes the loot request to the appropriate handler
    -- Created: 10/09/2025
    -- By: VSSVSSN
--]]
RegisterNetEvent('loot:useItem', function(lootType)
    if type(lootType) ~= 'string' then return end

    local src = source
    local handler = lootHandlers[lootType]

    if handler then
        handler(src)
    else
        print(('Unknown loot type requested: %s'):format(lootType))
    end
end)

