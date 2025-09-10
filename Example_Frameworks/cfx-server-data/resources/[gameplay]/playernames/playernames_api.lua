--[[
    -- Type: Module
    -- Name: playernames_api
    -- Use: Provides shared utilities to manage player name tags
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]

local playerConfig = {}

--[[
    -- Type: Function
    -- Name: createTriggerFunction
    -- Use: Builds server/client aware triggers for updating player tags
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function createTriggerFunction(key)
    return function(id, ...)
        if not IsDuplicityVersion() then
            TriggerEvent('playernames:configure', GetPlayerServerId(id), key, ...)
            return
        end

        if not playerConfig[id] then
            playerConfig[id] = {}
        end

        playerConfig[id][key] = table.pack(...)

        TriggerClientEvent('playernames:configure', -1, id, key, ...)
    end
end

if IsDuplicityVersion() then
    --[[
        -- Type: Function
        -- Name: reconfigure
        -- Use: Sends stored player configuration back to a joining client
        -- Created: 2024-02-14
        -- By: VSSVSSN
    --]]
    function reconfigure(src)
        for id, data in pairs(playerConfig) do
            for key, args in pairs(data) do
                TriggerClientEvent('playernames:configure', src, id, key, table.unpack(args))
            end
        end
    end

    AddEventHandler('playerDropped', function()
        playerConfig[source] = nil
    end)
end

setComponentColor = createTriggerFunction('setc')
setComponentAlpha = createTriggerFunction('seta')
setComponentVisibility = createTriggerFunction('tglc')
setWantedLevel = createTriggerFunction('setw')
setHealthBarColor = createTriggerFunction('sehc')
setNameTemplate = createTriggerFunction('tpl')
setName = createTriggerFunction('name')

if not io then
    io = { write = nil, open = nil }
end

local resourceName = GetCurrentResourceName()
local templateCode = LoadResourceFile(resourceName, 'template/template.lua')
assert(templateCode, 'playernames template missing')
local template = load(templateCode, '@template.lua')()

--[[
    -- Type: Function
    -- Name: formatPlayerNameTag
    -- Use: Renders a player name using a template string
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
function formatPlayerNameTag(i, templateStr)
    local originalPrint = template.print
    local str = ''

    template.print = function(txt)
        str = str .. txt
    end

    local context = {
        name = GetPlayerName(i),
        i = i,
        global = _G
    }

    context.id = IsDuplicityVersion() and i or GetPlayerServerId(i)

    TriggerEvent('playernames:extendContext', i, function(k, v)
        context[k] = v
    end)

    template.render(templateStr, context, nil, true)

    template.print = originalPrint

    return str
end
