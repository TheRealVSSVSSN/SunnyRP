--[[
    -- Type: Script
    -- Name: client.lua
    -- Use: Displays player server IDs above heads when the scoreboard key is held.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]

local hiddenPlayers = {}
local disPlayerNames = 50
local headBone = 0x796e

local controlKey = {
    generalScoreboard = {303, "U"}
}

--[[
    -- Type: Function
    -- Name: doesPlayerExist
    -- Use: Checks if a player with the given server ID is active.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function doesPlayerExist(serverId)
    local player = GetPlayerFromServerId(serverId)
    return player ~= -1 and NetworkIsPlayerActive(player)
end

--[[
    -- Type: Function
    -- Name: drawText3D
    -- Use: Renders 3D text at the specified world coordinates.
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function drawText3D(x, y, z, text, color)
    local col = { r = 255, g = 255, b = 255, a = 255 }
    if color then
        col.r = color[1] or col.r
        col.g = color[2] or col.g
        col.b = color[3] or col.b
        col.a = color[4] or col.a
    end

    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px, py, pz) - vector3(x, y, z))
    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(col.r, col.g, col.b, col.a)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

RegisterNetEvent("hud:HidePlayer")
AddEventHandler("hud:HidePlayer", function(player, toggle)
    if type(player) == "table" then
        for serverId, _ in pairs(player) do
            if doesPlayerExist(serverId) then
                hiddenPlayers[GetPlayerFromServerId(serverId)] = serverId
            end
        end
        return
    end

    if doesPlayerExist(player) then
        local id = GetPlayerFromServerId(player)
        if toggle then
            hiddenPlayers[id] = player
        else
            hiddenPlayers[id] = nil
        end
    end
end)

RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(tbl)
    controlKey.generalScoreboard = tbl.generalScoreboard
end)

CreateThread(function()
    while true do
        if IsControlPressed(0, controlKey.generalScoreboard[1]) then
            for _, id in ipairs(GetActivePlayers()) do
                N_0x31698aa80e0223f8(id)
            end

            local playerPed = PlayerPedId()
            local myCoords = GetPedBoneCoords(playerPed, headBone)

            for _, id in ipairs(GetActivePlayers()) do
                local ped = GetPlayerPed(id)
                local serverId = GetPlayerServerId(id)

                if ped == playerPed then
                    drawText3D(myCoords.x, myCoords.y, myCoords.z + 0.5, (' %s '):format(serverId), {152, 251, 152, 255})
                else
                    local pedCoords = GetPedBoneCoords(ped, headBone)
                    local distance = #(myCoords - pedCoords)

                    if distance < disPlayerNames and not hiddenPlayers[id] then
                        local canSee = HasEntityClearLosToEntity(playerPed, ped, 17)
                        local isHidden = IsPedDucking(ped) or IsPedDoingDriveby(ped) or IsPedInCover(ped, true) or (GetPedStealthMovement(ped) == 1)
                        if not isHidden and canSee then
                            local color = NetworkIsPlayerTalking(id) and {22, 55, 155, 255} or {255, 255, 255, 255}
                            drawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 0.5, (' %s '):format(serverId), color)
                        end
                    end
                end
            end

            Wait(0)
        else
            Wait(1000)
        end
    end
end)

