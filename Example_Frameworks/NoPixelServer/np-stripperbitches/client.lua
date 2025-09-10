--[[
    -- Type: Function
    -- Name: loadAnimDict
    -- Use: Requests and loads an animation dictionary into memory before use
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

--[[
    -- Type: Function
    -- Name: playAnim
    -- Use: Plays an animation on the given ped and waits for completion
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function playAnim(ped, dict, anim, flag)
    loadAnimDict(dict)
    TaskPlayAnim(ped, dict, anim, 1.0, -1.0, -1, flag or 0, 1.0, false, false, false)
    local duration = GetAnimDuration(dict, anim)
    Wait(math.floor(duration * 1000))
    RemoveAnimDict(dict)
end

--[[
    -- Type: Function
    -- Name: stripDance1
    -- Use: Handles the first lap dance animation sequence
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function stripDance1()
    local ped = PlayerPedId()
    ClearPedSecondaryTask(ped)
    playAnim(ped, "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", "ld_girl_a_song_a_p1_f")
    playAnim(ped, "mini@strip_club@lap_dance@ld_girl_a_song_a_p2", "ld_girl_a_song_a_p2_f")
    playAnim(ped, "mini@strip_club@lap_dance@ld_girl_a_exit", "ld_girl_a_exit_f")
end

--[[
    -- Type: Function
    -- Name: stripDance2
    -- Use: Handles the second lap dance animation sequence
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function stripDance2()
    local ped = PlayerPedId()
    ClearPedSecondaryTask(ped)
    playAnim(ped, "mini@strip_club@lap_dance_2g@ld_2g_p1", "ld_2g_p1_s1")
    playAnim(ped, "mini@strip_club@lap_dance_2g@ld_2g_p2", "ld_2g_p2_s1")
    playAnim(ped, "mini@strip_club@lap_dance@ld_girl_a_exit", "ld_girl_a_exit_f")
end

--[[
    -- Type: Function
    -- Name: poleDance
    -- Use: Handles the pole dance animation sequence
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function poleDance()
    local ped = PlayerPedId()
    ClearPedSecondaryTask(ped)
    playAnim(ped, "mini@strip_club@pole_dance@pole_enter", "pd_enter")
    playAnim(ped, "mini@strip_club@pole_dance@pole_dance1", "pd_dance_01")
    playAnim(ped, "mini@strip_club@pole_dance@pole_dance2", "pd_dance_02")
    playAnim(ped, "mini@strip_club@pole_dance@pole_dance3", "pd_dance_03")
end

--[[
    -- Type: Function
    -- Name: privDance
    -- Use: Handles the private dance animation sequence
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function privDance()
    local ped = PlayerPedId()
    ClearPedSecondaryTask(ped)
    SetEntityCollision(ped, false, false)
    playAnim(ped, "mini@strip_club@private_dance@part1", "priv_dance_p1")
    playAnim(ped, "mini@strip_club@private_dance@part2", "priv_dance_p2")
    playAnim(ped, "mini@strip_club@private_dance@part3", "priv_dance_p3")
    SetEntityCollision(ped, true, true)
end

--[[
    -- Type: Function
    -- Name: attachToPole
    -- Use: Aligns the player to the pole using a temporary chair object
    -- Created: 2025-09-10
    -- By: VSSVSSN
--]]
local function attachToPole()
    local ped = PlayerPedId()
    local chair = CreateObject(GetHashKey("prop_chair_01a"), 112.59926422119, -1286.5965087891, 28.45867729187, true, false, false)
    SetEntityHeading(chair, GetEntityHeading(ped) + 180.0)
    SetEntityCollision(chair, false, false)
    SetEntityCoords(chair, 112.59926422119, -1286.5965087891, 28.45867729187)
    AttachEntityToEntity(ped, chair, 20, 0.0, 0.0, 1.0, 180.0, 180.0, 0.0, false, false, false, false, 1, true)
    DeleteObject(chair)
end

RegisterNetEvent("attachtopole")
AddEventHandler("attachtopole", attachToPole)

RegisterNetEvent("stripper:dance")
AddEventHandler("stripper:dance", stripDance1)

RegisterNetEvent("stripper:dance2")
AddEventHandler("stripper:dance2", stripDance2)

RegisterNetEvent("stripper:dance3")
AddEventHandler("stripper:dance3", poleDance)

RegisterNetEvent("stripper:dance4")
AddEventHandler("stripper:dance4", privDance)
