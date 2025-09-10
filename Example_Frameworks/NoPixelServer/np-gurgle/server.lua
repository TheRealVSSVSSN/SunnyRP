--[[
    -- Type: Server Script
    -- Name: server.lua
    -- Use: Manages website submissions and retrieval for Gurgle
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local websites = {}
local price = 500

--[[
    -- Type: Function
    -- Name: sanitize
    -- Use: Removes unsafe characters from user input
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function sanitize(text)
    return (tostring(text or ""):gsub("[^%w%s%-_]", ""))
end

--[[
    -- Type: Function
    -- Name: loadWebsites
    -- Use: Loads all websites from the database
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
local function loadWebsites(cb)
    exports.ghmattimysql:execute('SELECT name, keywords, description FROM websites', {}, function(result)
        websites = {}
        for _, row in ipairs(result or {}) do
            websites[#websites+1] = {
                Title = row.name,
                Keywords = row.keywords,
                Description = row.description
            }
        end
        if cb then cb(websites) end
    end)
end

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    loadWebsites()
end)

--[[
    -- Type: Event
    -- Name: website:new
    -- Use: Inserts a new website and charges the player
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
RegisterNetEvent('website:new')
AddEventHandler('website:new', function(title, keywords, description)
    local src = source
    local user = exports['np-base']:getModule('Player'):GetUser(src)
    local char = user:getCurrentCharacter()
    local cid = char.id

    title = sanitize(title)
    keywords = sanitize(keywords)
    description = sanitize(description)

    if #title == 0 or #keywords == 0 or #description == 0 then
        TriggerClientEvent('DoShortHudText', src, 'Invalid website data', 2)
        return
    end

    if tonumber(user:getCash()) >= price then
        user:removeMoney(price)
        exports.ghmattimysql:execute('INSERT INTO websites (owner, name, keywords, description) VALUES (@owner, @name, @keywords, @description)', {
            ['owner'] = cid,
            ['name'] = title,
            ['keywords'] = keywords,
            ['description'] = description
        }, function()
            websites[#websites+1] = { Title = title, Keywords = keywords, Description = description }
            TriggerClientEvent('websites:updateClient', -1, websites)
        end)
    else
        TriggerClientEvent('DoShortHudText', src, 'You need $' .. price .. ' + Tax.', 2)
    end
end)

--[[
    -- Type: Event
    -- Name: websitesList
    -- Use: Sends the website list to the requesting client
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]
RegisterNetEvent('websitesList')
AddEventHandler('websitesList', function()
    local src = source
    loadWebsites(function(data)
        TriggerClientEvent('websites:updateClient', src, data)
    end)
end)
