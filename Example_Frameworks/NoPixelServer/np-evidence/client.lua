--[[
    -- Type: Client
    -- Name: np-evidence client
    -- Use: Handles evidence creation, caching, display and pickup on the client
    -- Created: 2024-02-29
    -- By: VSSVSSN
--]]

local ped = PlayerPedId()
local coords = GetEntityCoords(ped)
local inVehicle = IsPedInAnyVehicle(ped, false)

CreateThread(function()
    while true do
        ped = PlayerPedId()
        coords = GetEntityCoords(ped)
        inVehicle = IsPedInAnyVehicle(ped, false)
        Wait(500)
    end
end)

-- evidence containers
local drops = {}
local scannedEvidence = {}

-- temporary cache for nearby evidence to reduce work every frame
local cachedEvidence = {}
local cacheActive = false

local currentInformation = 0
local triggered = false
local currentWeather = 'SUNNY'
local overrideWeather = false

-- helpers ---------------------------------------------------------------

local function cameraForwardVec()
    local rot = (math.pi / 180.0) * GetGameplayCamRot(2)
    return vector3(-math.sin(rot.z) * math.abs(math.cos(rot.x)),
                   math.cos(rot.z) * math.abs(math.cos(rot.x)),
                   math.sin(rot.x))
end

local function raycast(dist)
    local start = GetGameplayCamCoord()
    local target = start + (cameraForwardVec() * dist)
    local ray = StartShapeTestRay(start, target, -1, ped, 1)
    local _, hit, hitPos, _, entity = GetShapeTestResult(ray)
    return hit == 1, hitPos, entity
end

local function waterTest()
    local hit = TestVerticalProbeAgainstAllWater(coords.x, coords.y, coords.z, 0, 1.0)
    return hit
end

local function generateId(pos)
    return string.format('%.2f-%.2f-%.2f', pos.x, pos.y, pos.z)
end

local function drawText3D(x, y, z, text)
    local onScreen,_x,_y = World3dToScreen2d(x, y, z)
    if not onScreen then return end
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 245)
    SetTextOutline(true)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

local function addEvidence(id, data)
    drops[id] = data
    TriggerEvent('PoolingEvidence')
end

-- pooling ---------------------------------------------------------------

local pooling = false

local function sendPooling()
    TriggerServerEvent('evidence:pooled', drops)
    drops = {}
end

RegisterNetEvent('PoolingEvidence', function()
    if pooling then return end
    pooling = true
    local counter = 5
    while counter > 0 do
        counter = counter - 1
        Wait(1000)
    end
    pooling = false
    if next(drops) then
        sendPooling()
    end
end)

-- event handlers -------------------------------------------------------

RegisterNetEvent('evidence:bulletInformation', function(info)
    currentInformation = info
end)

RegisterNetEvent('kWeatherSync', function(info)
    currentWeather = info
end)

RegisterNetEvent('inside:weather', function(info)
    overrideWeather = info
end)

RegisterNetEvent('evidence:pooled', function(data)
    for k, v in pairs(data) do
        scannedEvidence[k] = v
    end
end)

RegisterNetEvent('evidence:remove:done', function(id)
    scannedEvidence[id] = nil
end)

RegisterNetEvent('evidence:clear:done', function(ids)
    for i = 1, #ids do
        scannedEvidence[ids[i]] = nil
    end
end)

RegisterNetEvent('evidence:clear', function()
    local deleteIds = {}
    for k, v in pairs(scannedEvidence) do
        if #(coords - vector3(v.x, v.y, v.z)) < 10.0 then
            deleteIds[#deleteIds+1] = k
        end
    end
    if #deleteIds > 0 then
        TriggerServerEvent('evidence:clear', deleteIds)
    end
end)

RegisterNetEvent('evidence:bleeding', function()
    if inVehicle or waterTest() then return end
    local cid = exports['isPed']:isPed('cid')
    local raining = overrideWeather or currentWeather == 'RAIN'
    local pos = vector3(coords.x, coords.y, coords.z - 0.7)
    local id = generateId(pos)
    addEvidence(id, {
        x = pos.x,
        y = pos.y,
        z = pos.z,
        deactivated = false,
        meta = {
            evidenceType = 'blood',
            identifier = 'DNA-' .. cid,
            other = 'Partial Human DNA',
            raining = raining
        }
    })
end)

RegisterNetEvent('evidence:trigger', function()
    if triggered then return end
    triggered = true
    local counter = 5
    while counter > 0 do
        Wait(1000)
        if not IsPedUsingScenario(ped, 'WORLD_HUMAN_PAPARAZZI') then
            counter = counter - 1
        end
    end
    triggered = false
end)

-- caching nearby evidence ----------------------------------------------

RegisterNetEvent('CacheEvidence', function()
    cachedEvidence = {}
    cacheActive = true
    for k, v in pairs(scannedEvidence) do
        if #(coords - vector3(v.x, v.y, v.z)) < 80.0 then
            cachedEvidence[k] = v
        end
    end
    Wait(5000)
    cacheActive = false
end)

-- evidence display and pickup -----------------------------------------

local function drawEvidence(id, data)
    local pos = vector3(data.x, data.y, data.z)
    local dist = #(coords - pos)
    if dist > 20.0 then return end

    local text = data.meta.other .. ' | ' .. (data.meta.identifier or '')

    if data.meta.evidenceType == 'blood' then
        DrawMarker(28, pos.x, pos.y, pos.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.1,0.1,0.1, 202,22,22,141, false,false,2,false,nil,nil,false)
        drawText3D(pos.x, pos.y, pos.z + 0.5, text)
    elseif data.meta.evidenceType == 'casing' then
        DrawMarker(25, pos.x, pos.y, pos.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.1,0.1,0.1, 252,255,1,141, false,false,2,false,nil,nil,false)
        drawText3D(pos.x, pos.y, pos.z + 0.25, text)
    elseif data.meta.evidenceType == 'projectile' then
        DrawMarker(41, pos.x, pos.y, pos.z + 0.2, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.1,0.1,0.1, 13,245,1,231, false,false,2,false,nil,nil,false)
        drawText3D(pos.x, pos.y, pos.z + 0.5, text)
    elseif data.meta.evidenceType == 'glass' then
        DrawMarker(23, pos.x, pos.y, pos.z + 0.2, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.1,0.1,0.1, 13,10,0,191, false,false,2,false,nil,nil,false)
        drawText3D(pos.x, pos.y, pos.z + 0.5, text)
    elseif data.meta.evidenceType == 'vehiclefragment' then
        local c = data.meta.identifier
        DrawMarker(36, pos.x, pos.y, pos.z + 0.2, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.1,0.1,0.1, c.r or 255, c.g or 255, c.b or 255, 255, false,false,2,false,nil,nil,false)
        drawText3D(pos.x, pos.y, pos.z + 0.5, data.meta.other)
    else
        DrawMarker(21, pos.x, pos.y, pos.z, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.1,0.1,0.1, 222,255,51,91, false,false,2,false,nil,nil,false)
        drawText3D(pos.x, pos.y, pos.z + 0.5, text)
    end

    return dist
end

CreateThread(function()
    while true do
        Wait(1)
        if GetSelectedPedWeapon(ped) == GetHashKey('WEAPON_FLASHLIGHT') or triggered then
            if not cacheActive then
                TriggerEvent('CacheEvidence')
            end

            local closest, minDist = nil, 70.0
            for id, data in pairs(cachedEvidence) do
                local dist = drawEvidence(id, data) or 100.0
                if dist < minDist then
                    minDist = dist
                    closest = id
                end
            end

            if IsControlJustReleased(0, 38) and closest and minDist < 2.0 then
                local job = exports['isPed']:isPed('myjob')
                local finished = exports['np-taskbar']:taskBar(3000, 'Picking Up Item', 'What?', true)
                if finished == 100 and job == 'police' then
                    local info = scannedEvidence[closest]
                    TriggerServerEvent('evidence:removal', closest)
                    PickUpItem(info.meta.identifier, info.meta.evidenceType, info.meta.other, 'evidence')
                    Wait(3000)
                end
            end

            if minDist == 70.0 then
                Wait(700)
            end
        else
            Wait(1000)
        end
    end
end)

-- evidence creation ----------------------------------------------------

CreateThread(function()
    while true do
        Wait(1)
        if not IsPedArmed(ped, 7) then
            Wait(1000)
        elseif not waterTest() and IsPedShooting(ped) then
            local offsetX = math.random(-20,20) / 10
            local offsetY = math.random(-20,20) / 10
            local pos = GetOffsetFromEntityInWorldCoords(ped, offsetX, offsetY, -0.7)
            if inVehicle then pos = vector3(pos.x, pos.y, pos.z + 0.7) end
            local uid = generateId(pos)

            local hit, hitPos, entity = raycast(150.0)
            if hit and hitPos then
                if IsEntityAVehicle(entity) and math.random(4) > 1 then
                    local r, g, b = GetVehicleColor(entity)
                    if r ~= 0 or g ~= 0 or b ~= 0 then
                        addEvidence(uid .. '-p', {
                            x = hitPos.x,
                            y = hitPos.y,
                            z = hitPos.z,
                            deactivated = false,
                            meta = {
                                evidenceType = 'vehiclefragment',
                                identifier = { r = r, g = g, b = b },
                                other = ('(r:%d, g:%d, b:%d) Colored Vehicle Fragment'):format(r, g, b)
                            }
                        })
                    end
                elseif hitPos.x ~= 0.0 or hitPos.y ~= 0.0 then
                    addEvidence(uid .. '-p', {
                        x = hitPos.x,
                        y = hitPos.y,
                        z = hitPos.z,
                        deactivated = false,
                        meta = {
                            evidenceType = 'projectile',
                            identifier = currentInformation,
                            other = GetSelectedPedWeapon(ped),
                            casingClass = GetWeapontypeGroup(GetSelectedPedWeapon(ped))
                        }
                    })
                end
            end

            addEvidence(uid, {
                x = pos.x,
                y = pos.y,
                z = pos.z,
                deactivated = false,
                meta = {
                    evidenceType = 'casing',
                    identifier = currentInformation,
                    other = GetSelectedPedWeapon(ped),
                    casingClass = GetWeapontypeGroup(GetSelectedPedWeapon(ped))
                }
            })
            Wait(100)
        end
    end
end)

-- pickup ---------------------------------------------------------------

function PickUpItem(id, eType, other, item)
    local information = {
        identifier = id,
        eType = eType,
        other = other
    }
    TriggerEvent('player:receiveItem', item, 1, true, information)
end
