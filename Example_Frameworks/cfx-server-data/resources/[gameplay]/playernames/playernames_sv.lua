--[[
    -- Type: Script
    -- Name: playernames_sv
    -- Use: Synchronizes player name templates and tags on the server
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]

local curTemplate
local curTags = {}
local activePlayers = {}

--[[
    -- Type: Function
    -- Name: detectUpdates
    -- Use: Refreshes tag templates and updates client tags
    -- Created: 2024-02-14
    -- By: VSSVSSN
--]]
local function detectUpdates()
    local template = GetConvar('playerNames_template', '[{{id}}] {{name}}')

    if curTemplate ~= template then
        setNameTemplate(-1, template)
        curTemplate = template
    end

    template = GetConvar('playerNames_svTemplate', '[{{id}}] {{name}}')

    for id in pairs(activePlayers) do
        local newTag = formatPlayerNameTag(id, template)
        if newTag ~= curTags[id] then
            setName(id, newTag)
            curTags[id] = newTag
        end
    end

    for id in pairs(curTags) do
        if not activePlayers[id] then
            curTags[id] = nil
        end
    end
end

AddEventHandler('playerDropped', function()
    curTags[source] = nil
    activePlayers[source] = nil
end)

RegisterNetEvent('playernames:init')
AddEventHandler('playernames:init', function()
    reconfigure(source)
    activePlayers[source] = true
end)

CreateThread(function()
    while true do
        Wait(500)
        detectUpdates()
    end
end)

