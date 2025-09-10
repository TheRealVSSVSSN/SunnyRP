--[[
    -- Type: Client Script
    -- Name: fsn_emotecontrol walk types
    -- Use: Applies walking styles and exposes events for other resources.
    -- Created: 2023-11-19
    -- By: VSSVSSN
--]]

local walkSets = {
    Hurry       = "move_m@hurry@a",
    Business    = "move_m@business@a",
    Brave       = "move_m@brave",
    Tipsy       = "move_m@drunk@slightlydrunk",
    Injured     = "move_m@injured",
    ToughGuy    = "move_m@tough_guy@",
    Sassy       = "move_m@sassy",
    Sad         = "move_m@sad@a",
    Posh        = "move_m@posh@",
    Alien       = "move_m@alien",
    NonChalant  = "move_m@non_chalant",
    Hobo        = "move_m@hobo@a",
    Money       = "move_m@money",
    Swagger     = "move_m@swagger",
    Joy         = "move_m@joy",
    Moon        = "move_m@powerwalk",
    Shady       = "move_m@shadyped@a",
}

local function setWalkStyle(clipset)
    if not clipset then
        ResetPedMovementClipset(PlayerPedId(), 0.0)
        return
    end
    RequestAnimSet(clipset)
    while not HasAnimSetLoaded(clipset) do
        Citizen.Wait(0)
    end
    SetPedMovementClipset(PlayerPedId(), clipset, true)
    TriggerServerEvent("police:setAnimData", clipset)
end

for name, clip in pairs(walkSets) do
    RegisterNetEvent('AnimSet:' .. name)
    AddEventHandler('AnimSet:' .. name, function()
        setWalkStyle(clip)
    end)
end

RegisterNetEvent('AnimSet:Reset')
AddEventHandler('AnimSet:Reset', function()
    setWalkStyle(nil)
end)

RegisterCommand('walk', function(_, args)
    local style = args[1] and walkSets[args[1]] or nil
    setWalkStyle(style)
end, false)

