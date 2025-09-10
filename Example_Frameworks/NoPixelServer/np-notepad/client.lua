--[[
    -- Type: Client Script
    -- Name: np-notepad/client.lua
    -- Use: Handles client-side notepad interactions and rendering
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]

local guiEnabled = false
local serverNotes = {}
local Controlkey = { ["generalUse"] = {38, "E"}, ["generalUseSecondaryWorld"] = {23, "F"} }

--[[
    -- Type: Function
    -- Name: setGui
    -- Use: Toggles the notepad UI in read or write mode
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function setGui(state, text)
    SetPlayerControl(PlayerId(), state and 0 or 1, 0)
    guiEnabled = state
    SetNuiFocus(state, state)

    if state then
        local msg = { openSection = text and "openNotepadRead" or "openNotepad" }
        if text then msg.TextRead = text end
        SendNUIMessage(msg)
        TriggerEvent("notepad")
    else
        ClearPedTasks(PlayerPedId())
        SendNUIMessage({ openSection = "close" })
    end
end

local function openGui()
    setGui(true)
end

local function openGuiRead(text)
    setGui(true, text)
end

local function closeGui()
    setGui(false)
end

RegisterNUICallback('close', function(_, cb)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('drop', function(data, cb)
    closeGui()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('server:newNote', data.noteText, coords.x, coords.y, coords.z)
    cb('ok')
end)

local function DrawText3Ds(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextCentre(true)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
        local factor = string.len(text) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

CreateThread(function()
    while true do
        Wait(1)

        if #serverNotes == 0 then
            Wait(1000)
        else
            local plyLoc = GetEntityCoords(PlayerPedId())
            local closestNoteDistance = 900.0
            local closestNoteId = 0

            for i = 1, #serverNotes do
                local note = serverNotes[i]
                local distance = #(plyLoc - vector3(note.x, note.y, note.z))

                if distance < 10.0 then
                    DrawMarker(27, note.x, note.y, note.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 2.0, 255, 255, 150, 75, 0, 0, 2, 0, 0, 0, 0)
                end

                if distance < closestNoteDistance then
                    closestNoteDistance = distance
                    closestNoteId = i
                end
            end

            if closestNoteDistance > 100.0 then
                Wait(math.ceil(closestNoteDistance * 10))
            end

            local note = serverNotes[closestNoteId]
            if note then
                local distance = #(plyLoc - vector3(note.x, note.y, note.z))
                if distance < 2.0 then
                    DrawMarker(27, note.x, note.y, note.z - 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 2.0, 255, 255, 155, 75, 0, 0, 2, 0, 0, 0, 0)
                    DrawText3Ds(note.x, note.y, note.z - 0.4, "~g~" .. Controlkey["generalUse"][2] .. "~s~ to read,~g~" .. Controlkey["generalUseSecondaryWorld"][2] .. "~s~ to destroy")

                    if IsControlJustReleased(0, Controlkey["generalUse"][1]) then
                        openGuiRead(note.text)
                    end
                    if IsControlJustReleased(0, Controlkey["generalUseSecondaryWorld"][1]) then
                        TriggerServerEvent('server:destroyNote', closestNoteId)
                    end
                end
            elseif closestNoteId ~= 0 then
                table.remove(serverNotes, closestNoteId)
            end
        end
    end
end)

RegisterNetEvent('Notepad:close')
AddEventHandler('Notepad:close', function()
    closeGui()
end)

RegisterNetEvent('client:updateNotes')
AddEventHandler('client:updateNotes', function(serverNotesPassed)
    serverNotes = serverNotesPassed
end)

RegisterNetEvent('client:updateNotesAdd')
AddEventHandler('client:updateNotesAdd', function(newNote)
    serverNotes[#serverNotes + 1] = newNote
end)

RegisterNetEvent('client:updateNotesRemove')
AddEventHandler('client:updateNotesRemove', function(id)
    table.remove(serverNotes, id)
end)

RegisterNetEvent('Notepad:open')
AddEventHandler('Notepad:open', function()
    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if GetPedInVehicleSeat(veh, -1) ~= PlayerPedId() then
        openGui()
    end
end)

CreateThread(function()
    Wait(200)
    TriggerServerEvent('server:requestNotes')
end)
