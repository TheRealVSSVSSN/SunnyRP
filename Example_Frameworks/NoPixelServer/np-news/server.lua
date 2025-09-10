--[[
    -- Type: Event
    -- Name: NewsStandCheckFinish
    -- Use: Forwards news strings back to requesting client.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNetEvent('NewsStandCheckFinish', function(newsOne, newsTwo)
    local src = source
    TriggerClientEvent('NewsStandCheckFinish', src, newsOne, newsTwo or '')
end)
