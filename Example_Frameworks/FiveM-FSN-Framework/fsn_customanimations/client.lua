--[[
    Type: Table
    Name: animations
    Use: Defines animation data and optional props
    Created: 2025-09-10
    By: VSSVSSN
--]]
local animations = {
    busted = { dict = "random@arrests@busted", anim = "idle_a", flag = 9,
        sequence = {
            { dict = "random@arrests", anim = "idle_2_hands_up", flag = 2, duration = 4000 },
            { dict = "random@arrests", anim = "kneeling_arrest_idle", flag = 2, duration = 500 },
            { dict = "random@arrests@busted", anim = "enter", flag = 2, duration = 1000 },
            { dict = "random@arrests@busted", anim = "idle_a", flag = 9 }
        },
        exit = {
            { dict = "random@arrests@busted", anim = "exit", flag = 2, duration = 3000 },
            { dict = "random@arrests", anim = "kneeling_arrest_get_up", flag = 128, duration = 3000 }
        },
        disable = {140,141,142,21}
    },
    salute   = { dict = "anim@mp_player_intuppersalute", anim = "idle_a", flag = 49 },
    finger   = { dict = "anim@mp_player_intselfiethe_bird", anim = "idle_a", flag = 49 },
    finger2  = { dict = "anim@mp_player_intupperfinger", anim = "idle_a", flag = 49 },
    palm     = { dict = "anim@mp_player_intupperface_palm", anim = "idle_a", flag = 49 },
    notes    = { dict = "missheistdockssetup1clipboard@base", anim = "base", flag = 49,
        props = {
            { model = "prop_notepad_01",  bone = 18905, pos = {0.1, 0.02, 0.05},   rot = {10.0, 0.0, 0.0} },
            { model = "prop_pencil_01",   bone = 58866, pos = {0.12, 0.0, 0.001}, rot = {-150.0, 0.0, 0.0} }
        }
    },
    callphone = { dict = "cellphone@", anim = "cellphone_call_listen_base", flag = 49,
        props = {
            { model = "prop_player_phone_01", bone = 57005, pos = {0.15, 0.02, -0.01}, rot = {105.0, -20.0, 90.0} }
        }
    },
    foldarms2 = { dict = "missfbi_s4mop", anim = "guard_idle_a", flag = 49 },
    umbrella  = { dict = "amb@world_human_drinking@coffee@male@base", anim = "base", flag = 49,
        props = {
            { model = "p_amb_brolly_01", bone = 57005, pos = {0.15, 0.005, -0.02}, rot = {80.0, -20.0, 175.0} }
        }
    },
    brief  = { weapon = 0x88C78EB7 },
    brief2 = { weapon = 0x01B79F17 },
    foldarms = { dict = "oddjobs@assassinate@construction@", anim = "unarmed_fold_arms", flag = 49 },
    damn    = { dict = "gestures@m@standing@casual", anim = "gesture_damn", flag = 120 }
}

local activeProps = {}
local surrendered = false

--[[
    Type: Function
    Name: loadAnimDict
    Use: Requests and waits for an animation dictionary to load
    Created: 2025-09-10
    By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

--[[
    Type: Function
    Name: clearProps
    Use: Detaches and deletes currently attached props
    Created: 2025-09-10
    By: VSSVSSN
--]]
local function clearProps()
    for _, obj in ipairs(activeProps) do
        if DoesEntityExist(obj) then
            DetachEntity(obj, true, true)
            DeleteObject(obj)
        end
    end
    activeProps = {}
end

--[[
    Type: Function
    Name: playAnimation
    Use: Handles animation playback and prop management
    Created: 2025-09-10
    By: VSSVSSN
--]]
local function playAnimation(key)
    local cfg = animations[key]
    if not cfg then
        print("Unknown animation: " .. tostring(key))
        return
    end

    local ped = PlayerPedId()
    if cfg.weapon then
        GiveWeaponToPed(ped, cfg.weapon, 1, false, true)
        return
    end

    -- Busted sequence special case
    if key == 'busted' then
        if surrendered then
            for _, step in ipairs(cfg.exit) do
                loadAnimDict(step.dict)
                TaskPlayAnim(ped, step.dict, step.anim, 8.0, 1.0, step.duration or -1, step.flag or 2, 0, false, false, false)
                Wait(step.duration or 0)
            end
            surrendered = false
        else
            for _, step in ipairs(cfg.sequence) do
                loadAnimDict(step.dict)
                TaskPlayAnim(ped, step.dict, step.anim, 8.0, 1.0, step.duration or -1, step.flag or 2, 0, false, false, false)
                Wait(step.duration or 0)
            end
            surrendered = true
            CreateThread(function()
                while surrendered do
                    Wait(0)
                    if IsEntityPlayingAnim(ped, cfg.dict, cfg.anim, 3) then
                        for _, control in ipairs(cfg.disable or {}) do
                            DisableControlAction(1, control, true)
                        end
                    else
                        surrendered = false
                    end
                end
            end)
        end
        return
    end

    loadAnimDict(cfg.dict)

    if IsEntityPlayingAnim(ped, cfg.dict, cfg.anim, 3) then
        ClearPedTasks(ped)
        clearProps()
    else
        TaskPlayAnim(ped, cfg.dict, cfg.anim, 8.0, 1.0, -1, cfg.flag or 49, 0, false, false, false)
        clearProps()
        if cfg.props then
            local coords = GetEntityCoords(ped)
            for _, info in ipairs(cfg.props) do
                local obj = CreateObject(GetHashKey(info.model), coords.x, coords.y, coords.z + 0.2, true, true, true)
                AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, info.bone), info.pos[1], info.pos[2], info.pos[3], info.rot[1], info.rot[2], info.rot[3], true, true, false, true, 1, true)
                table.insert(activeProps, obj)
            end
        end
    end
end

RegisterCommand('ce', function(_, args)
    local anim = args[1]
    if not anim then
        print('Usage: /ce <animation>')
        return
    end
    playAnimation(anim:lower())
end)

CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/ce', 'Plays a custom animation', {{ name = 'animation', help = 'Animation name' }})
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        TriggerEvent('chat:removeSuggestion', '/ce')
        clearProps()
    end
end)

--[[
    Type: Thread
    Name: ragdollCleanup
    Use: Clears props if the player ragdolls
    Created: 2025-09-10
    By: VSSVSSN
--]]
CreateThread(function()
    while true do
        Wait(500)
        if IsPedRagdoll(PlayerPedId()) then
            clearProps()
        end
    end
end)
