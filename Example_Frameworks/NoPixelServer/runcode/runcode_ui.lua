local openData
local resourceName = GetCurrentResourceName()
local baseUrl = ('http://%s/%s/'):format(GetCurrentServerEndpoint(), resourceName)

RegisterNetEvent('runcode:openUi')

--[[
    -- Type: Event
    -- Name: runcode:openUi
    -- Use: Opens the NUI editor with privilege options.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('runcode:openUi', function(options)
    openData = {
        type = 'open',
        options = options,
        url = baseUrl,
        res = resourceName,
    }

    SendNUIMessage(json.encode(openData))
end)

--[[
    -- Type: Callback
    -- Name: getOpenData
    -- Use: Supplies cached UI initialization data to NUI.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('getOpenData', function(args, cb)
    cb(openData)
end)

--[[
    -- Type: Callback
    -- Name: doOk
    -- Use: Enables NUI focus after confirmation.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('doOk', function(args, cb)
    SendNUIMessage(json.encode({
        type = 'ok'
    }))

    SetNuiFocus(true, true)

    cb('ok')
end)

--[[
    -- Type: Callback
    -- Name: doClose
    -- Use: Closes the NUI editor and removes focus.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('doClose', function(args, cb)
    SendNUIMessage(json.encode({
        type = 'close'
    }))

    SetNuiFocus(false, false)

    cb('ok')
end)

local rcCbs = {}
local id = 1

--[[
    -- Type: Callback
    -- Name: runCodeInBand
    -- Use: Sends code to server for execution and awaits result.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
RegisterNUICallback('runCodeInBand', function(args, cb)
    id = id + 1
    rcCbs[id] = cb
    TriggerServerEvent('runcode:runInBand', id, args)
end)

RegisterNetEvent('runcode:inBandResult')

--[[
    -- Type: Event
    -- Name: runcode:inBandResult
    -- Use: Receives execution results from the server.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('runcode:inBandResult', function(id, result)
    if rcCbs[id] then
        local cb = rcCbs[id]
        rcCbs[id] = nil
        cb(result)
    end
end)

--[[
    -- Type: Event
    -- Name: onResourceStop
    -- Use: Removes NUI focus when resource stops.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
AddEventHandler('onResourceStop', function(resource)
    if resource == resourceName then
        SetNuiFocus(false, false)
    end
end)
