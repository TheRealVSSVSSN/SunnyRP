local pedState = {}

--[[
    -- Type: Function
    -- Name: updateState
    -- Use: Syncs local ped state with the server
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function updateState()
    local playerId = GetPlayerServerId(PlayerId())
    if pedState[playerId] and next(pedState[playerId]) then
        TriggerServerEvent('fsn_evidence:ped:update', pedState[playerId])
    end
end

RegisterNetEvent('fsn_evidence:ped:update', function(ply, tbl)
    for k, v in pairs(tbl) do
        tbl[k].expire = GetGameTimer() + (v.ttl * 1000)
    end
    pedState[ply] = tbl
end)

RegisterNetEvent('fsn_evidence:ped:addState', function(state, bone, ttl)
    ttl = ttl or 60
    local playerId = GetPlayerServerId(PlayerId())
    pedState[playerId] = pedState[playerId] or {}
    table.insert(pedState[playerId], { state = state, bone = bone, ttl = ttl })
    updateState()
end)

local BodyParts = {
    ['HEAD'] = { label = 'Head', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_HEAD'},
    ['NECK'] = { label = 'Neck', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_NECK'},
    ['SPINE'] = { label = 'Spine', causeLimp = true, isDamaged = false, severity = 0, index = 'BONETAG_SPINE'},
    ['UPPER_BODY'] = { label = 'Upper Body', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_SPINE2'},
    ['LOWER_BODY'] = { label = 'Lower Body', causeLimp = true, isDamaged = false, severity = 0, index = 'BONETAG_SPINE_ROOT'},
    ['LARM'] = { label = 'Left Arm', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_L_UPPERARM'},
    ['LHAND'] = { label = 'Left Hand', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_L_HAND' },
    ['LFINGER'] = { label = 'Left Hand Fingers', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_L_FINGER01'},
    ['LLEG'] = { label = 'Left Leg', causeLimp = true, isDamaged = false, severity = 0, index = 'BONETAG_L_CALF'},
    ['LFOOT'] = { label = 'Left Foot', causeLimp = true, isDamaged = false, severity = 0, index ='BONETAG_L_FOOT'},
    ['RARM'] = { label = 'Right Arm', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_R_UPPERARM' },
    ['RHAND'] = { label = 'Right Hand', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_R_HAND' },
    ['RFINGER'] = { label = 'Right Hand Fingers', causeLimp = false, isDamaged = false, severity = 0, index = 'BONETAG_R_FINGER01' },
    ['RLEG'] = { label = 'Right Leg', causeLimp = true, isDamaged = false, severity = 0, index = 'BONETAG_R_CALF'},
    ['RFOOT'] = { label = 'Right Foot', causeLimp = true, isDamaged = false, severity = 0, index = 'BONETAG_R_FOOT' },
}

RegisterNetEvent('fsn_evidence:ped:updateDamage', function(tbl)
    BodyParts = tbl
end)

local opacity, decreasing = 0, false

CreateThread(function()
    while true do
        Wait(0)
        opacity = decreasing and opacity - 1 or opacity + 1
        if opacity <= 0 then
            decreasing = false
        elseif opacity >= 255 then
            decreasing = true
        end

        local selfId = GetPlayerServerId(PlayerId())
        local selfPed = PlayerPedId()
        local selfCoords = GetEntityCoords(selfPed)

        for plyId, states in pairs(pedState) do
            for key, s in pairs(states) do
                if s.expire and s.expire <= GetGameTimer() then
                    pedState[plyId][key] = nil
                    if not next(pedState[plyId]) then pedState[plyId] = nil end
                    if plyId == selfId then
                        updateState()
                    end
                else
                    local targetPlayer = GetPlayerFromServerId(plyId)
                    local ped = (targetPlayer ~= -1) and GetPlayerPed(targetPlayer) or (plyId == selfId and selfPed)
                    if ped and #(GetEntityCoords(ped) - selfCoords) < 8.0 then
                        local loc = GetWorldPositionOfEntityBone(ped, GetEntityBoneIndexByName(ped, BodyParts[s.bone].index))
                        Util.DrawText3D(loc.x, loc.y, loc.z, s.state, {255,255,255,opacity}, 0.15)
                    end
                end
            end
        end

        if not IsPedInAnyVehicle(selfPed) then
            for _, b in pairs(BodyParts) do
                if b.isDamaged and b.index then
                    local loc = GetWorldPositionOfEntityBone(selfPed, GetEntityBoneIndexByName(selfPed, b.index))
                    local col = {255,255,255,255}
                    if b.severity <= 2 then
                        col = {255,161,54,opacity}
                    else
                        col = {255,0,0,opacity}
                    end
                    Util.DrawText3D(loc.x, loc.y, loc.z, b.label, col, 0.15)
                end
            end
        end
    end
end)

