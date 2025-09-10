local BlipHandlers = {}

--[[
    -- Type: Thread
    -- Name: sessionInit
    -- Use: Waits for network session before initializing decor
    -- Created: 2024-09-08
    -- By: VSSVSSN
--]]
CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(0)
    end

    DecorRegister("EmergencyType", 3)
    DecorSetInt(PlayerPedId(), "EmergencyType", 0)
end)

--[[
	Emergency Type Decor:
		1 = police
		2 = ems
]]

function IsDOC(pCallSign)
    if pCallSign then
        local sign = string.sub(pCallSign, 1, 1)
        return sign == '7'
    else
        return false
    end
end

function GetBlipSettings(pJobId, pCallSign)
    local settings = {
        short = true,
        sprite = 1,
        category = 7
    }

    if pJobId == 'police' then
        settings.color = 3
        settings.heading = true
        settings.text = ('Officer | %s'):format(pCallSign)
    elseif pJobId == 'doc' then
        settings.color = 2
        settings.heading = true
        settings.text = ('DOC | %s'):format(pCallSign)
    elseif pJobId == 'ems' then
        settings.color = 23
        settings.heading = true
        settings.text = ('Paramedic | %s'):format(pCallSign)
    else
        return false
    end

    return settings
end

function CreateBlipHandler(pServerId, pJob, pCallSign)
    local serverId = pServerId
    local callsign = pCallSign
    local job = pJob

    if job == 'police' and IsDOC(callsign) then
        job = 'doc'
    end

    local settings = GetBlipSettings(job, callsign)

    if not settings then
        return
    end

    local handler = EntityBlip:new('player', serverId, settings)
    handler:enable(true)

    BlipHandlers[serverId] = handler
end

function DeleteBlipHandler(pServerId)
    BlipHandlers[pServerId]:disable()
    BlipHandlers[pServerId] = nil
end

RegisterNetEvent('e-blips:setHandlers')
AddEventHandler('e-blips:setHandlers', function(pHandlers)
	for _, pData in pairs(pHandlers) do
		if pData then
			CreateBlipHandler(pData.netId, pData.job, pData.callsign)
		end
	end
end)

RegisterNetEvent('e-blips:deleteHandlers')
AddEventHandler('e-blips:deleteHandlers', function()
	for serverId, pData in pairs(BlipHandlers) do
		if pData then
			DeleteBlipHandler(serverId)
		end
	end

	BlipHandlers = {}
end)

RegisterNetEvent('e-blips:addHandler')
AddEventHandler('e-blips:addHandler', function(pData)
    if pData then
        CreateBlipHandler(pData.netId, pData.job, pData.callsign)
    end
end)

RegisterNetEvent('e-blips:removeHandler')
AddEventHandler('e-blips:removeHandler', function(pServerId)
    if BlipHandlers[pServerId] then
        DeleteBlipHandler(pServerId)
    end
end)

--[[
    -- Type: Function
    -- Name: updateEmergencyDecor
    -- Use: Sets decor based on player's job
    -- Created: 2024-09-08
    -- By: VSSVSSN
--]]
local function updateEmergencyDecor(job)
    local decorType = 0
    if job == 'police' then
        decorType = 1
    elseif job == 'ems' then
        decorType = 2
    end

    DecorSetInt(PlayerPedId(), "EmergencyType", decorType)
end

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job, name, notify)
    updateEmergencyDecor(job)

    TriggerServerEvent('e-blips:updateBlips', GetPlayerServerId(PlayerId()), job, name)
end)

RegisterNetEvent("e-blips:updateAfterPedChange")
AddEventHandler("e-blips:updateAfterPedChange", function(job)
    updateEmergencyDecor(job)

    TriggerServerEvent('e-blips:updateBlips', GetPlayerServerId(PlayerId()), job)
end)

RegisterNetEvent('np:infinity:player:coords')
AddEventHandler('np:infinity:player:coords', function (pCoords)
    for serverId, handler in pairs(BlipHandlers) do
        if handler and handler.mode == 'coords' and pCoords[serverId] then
            handler:onUpdateCoords(pCoords[serverId])

            if handler:entityExistLocally() then
                handler:onModeChange('entity')
            end
        end
    end
end)

RegisterNetEvent('onPlayerJoining')
AddEventHandler('onPlayerJoining', function(player)
    if BlipHandlers[player] then
        BlipHandlers[player].inScope = true
        Wait(1000)
        if BlipHandlers[player].inScope then
            BlipHandlers[player]:onModeChange('entity')
        end
    end
end)

RegisterNetEvent('onPlayerDropped')
AddEventHandler('onPlayerDropped', function(player)
    if BlipHandlers[player] then
        BlipHandlers[player].inScope = false
        BlipHandlers[player]:onModeChange('coords')
    end
end)


--[[
    -- Type: Function
    -- Name: refreshDecor
    -- Use: Refreshes decor when player ped changes
    -- Created: 2024-09-08
    -- By: VSSVSSN
--]]
local function refreshDecor()
    local decorType = 0

    TriggerEvent("nowIsCop", function(isCop)
        TriggerEvent("nowIsEMS", function(isMedic)
            decorType = isCop and 1 or 0
            decorType = (decorType == 0 and isMedic) and 2 or decorType
            DecorSetInt(PlayerPedId(), "EmergencyType", decorType)
        end)
    end)
end

CreateThread(function()
    while true do
        Wait(2000)
        if not DecorExistOn(PlayerPedId(), "EmergencyType") then
            refreshDecor() -- Decors don't stick with players when their ped changes.
        end
    end
end)
