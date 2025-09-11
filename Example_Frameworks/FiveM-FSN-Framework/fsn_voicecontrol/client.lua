--[[
    -- Type: Function
    -- Name: drawTxt
    -- Use: Draws text on the player's HUD
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function drawTxt(x, y, width, height, scale, text, r, g, b, a)
    SetTextFont(4)
    SetTextProportional(false)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x - width / 2, y - height / 2 + 0.005)
end

local UI = {
    x = 0.0,
    y = -0.001
}

--[[
    -- Type: Variable
    -- Name: voiceModes
    -- Use: Holds available voice modes and their ranges
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local voiceModes = {
    { label = 'WHISPERING', distance = 1.5 },
    { label = 'NORMAL',     distance = 5.0 },
    { label = 'SHOUT',      distance = 12.0 }
}
local currentMode = 2

--[[
    -- Type: Function
    -- Name: applyProximity
    -- Use: Applies voice proximity based on current mode
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function applyProximity()
    local dist = voiceModes[currentMode].distance
    MumbleSetAudioInputDistance(dist)
    MumbleSetAudioOutputDistance(dist)
end

--[[
    -- Type: Command
    -- Name: fsn_cyclevoice
    -- Use: Cycles through voice proximity modes
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterCommand('fsn_cyclevoice', function()
    currentMode = currentMode % #voiceModes + 1
    applyProximity()
end, false)
RegisterKeyMapping('fsn_cyclevoice', 'Cycle voice range', 'keyboard', 'Z')

CreateThread(function()
    applyProximity()
    while true do
        Wait(0)
        local voice = voiceModes[currentMode]
        local colour = NetworkIsPlayerTalking(PlayerId()) and { 66, 220, 244, 255 } or { 255, 255, 255, 255 }
        drawTxt(UI.x + 0.517, UI.y + 1.434, 1.0, 1.0, 0.4, voice.label, table.unpack(colour))
    end
end)

--[[ Phone call management ]]--
local onPhone = false
local callWith = 0
local voiceChannel = 0
local holding = false
local selfHolding = false

CreateThread(function()
    while true do
        Wait(0)
        if onPhone then
            local text
            if selfHolding then
                text = ('Call: %s#%s // ~r~HOLD~w~\n~INPUT_DETONATE~: end'):format(callWith, voiceChannel)
                if IsControlJustPressed(0, 47) then -- G
                    TriggerServerEvent('fsn_voicecontrol:call:end', callWith)
                end
            elseif holding then
                text = ('Call: %s#%s // ~o~HOLD~w~\n~INPUT_PICKUP~: unhold\n~INPUT_DETONATE~: end'):format(callWith, voiceChannel)
                if IsControlJustPressed(0, 38) then -- E
                    TriggerServerEvent('fsn_voicecontrol:call:unhold', callWith)
                elseif IsControlJustPressed(0, 47) then
                    TriggerServerEvent('fsn_voicecontrol:call:end', callWith)
                end
            else
                text = ('Call: %s#%s // ~g~ACTIVE~w~\n~INPUT_PICKUP~: hold\n~INPUT_DETONATE~: end'):format(callWith, voiceChannel)
                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent('fsn_voicecontrol:call:hold', callWith)
                elseif IsControlJustPressed(0, 47) then
                    TriggerServerEvent('fsn_voicecontrol:call:end', callWith)
                end
            end
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(text)
            EndTextCommandDisplayHelp(0, false, true, -1)
        end
    end
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:start
    -- Use: Activates voice channel for a call
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_voicecontrol:call:start')
AddEventHandler('fsn_voicecontrol:call:start', function(channel)
    onPhone = true
    voiceChannel = channel
    NetworkSetVoiceChannel(channel)
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:end
    -- Use: Ends the current phone call and restores proximity voice
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_voicecontrol:call:end')
AddEventHandler('fsn_voicecontrol:call:end', function()
    onPhone = false
    holding = false
    selfHolding = false
    callWith = 0
    voiceChannel = 0
    NetworkClearVoiceChannel()
    applyProximity()
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:hold
    -- Use: Handles placing a call on hold
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_voicecontrol:call:hold')
AddEventHandler('fsn_voicecontrol:call:hold', function(iPlacedHold)
    if iPlacedHold then
        selfHolding = true
        NetworkClearVoiceChannel()
    else
        holding = true
    end
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:unhold
    -- Use: Resumes a held call
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_voicecontrol:call:unhold')
AddEventHandler('fsn_voicecontrol:call:unhold', function()
    selfHolding = false
    holding = false
    if voiceChannel ~= 0 then
        NetworkSetVoiceChannel(voiceChannel)
    end
end)

--[[
    -- Type: Event Handler
    -- Name: fsn_voicecontrol:call:ring
    -- Use: Handles incoming call prompts
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
RegisterNetEvent('fsn_voicecontrol:call:ring')
AddEventHandler('fsn_voicecontrol:call:ring', function(callFrom)
    callWith = callFrom
    local ringing = true
    CreateThread(function()
        local timeout = GetGameTimer() + 15000
        while ringing and GetGameTimer() < timeout do
            Wait(0)
            BeginTextCommandDisplayHelp('STRING')
            AddTextComponentSubstringPlayerName(('Incoming call from %s\n~INPUT_PICKUP~ answer\n~INPUT_DETONATE~ decline'):format(callFrom))
            EndTextCommandDisplayHelp(0, false, true, -1)
            if IsControlJustPressed(0, 38) then
                TriggerServerEvent('fsn_voicecontrol:call:answer', callFrom)
                ringing = false
            elseif IsControlJustPressed(0, 47) then
                TriggerServerEvent('fsn_voicecontrol:call:decline', callFrom)
                ringing = false
            end
        end
        if ringing then
            TriggerServerEvent('fsn_voicecontrol:call:decline', callFrom)
        end
    end)
    CreateThread(function()
        while ringing do
            TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 3, 'fsn_phonecall.ogg', 0.4)
            Wait(2500)
        end
    end)
end)

