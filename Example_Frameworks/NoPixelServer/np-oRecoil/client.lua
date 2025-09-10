
local stresslevel = 0
local firstPersonActive = false
local movFwd = true
local ctrlStage = 0
local crouchCam = 0
local fixprone = false
local myWep = 0
local runningMovement = false
local timelimit = 0
local isHolding = false
local isFlying = false
local incrouch = true
local handCuffed = false
local handCuffedWalking = false

local isDead = false
local beingDragged, dragging = false, false

local function RecoilFactor(stress, stance)
    stance = stance or 0
    if stance == 3 then
        stance = 1
    end

    local sendFactor = math.max((math.ceil(stress) / 1000) - stance, 0)
    TriggerEvent("recoil:updateposition", sendFactor)
end

RegisterNetEvent("client:updateStress")
AddEventHandler("client:updateStress", function(newStress)
    stresslevel = newStress
    if stresslevel <= 0 then
        RevertToStressMultiplier()
    end
end)

RegisterNetEvent('pd:deathcheck')
AddEventHandler('pd:deathcheck', function()
    if not isDead then
        isDead = true
    else
        beingDragged = false
        dragging = false
        isDead = false
    end
end)

function crouchMovement()
    RequestAnimSet("move_ped_crouched")
    while not HasAnimSetLoaded("move_ped_crouched") do
        Wait(0)
    end

    SetPedMovementClipset(PlayerPedId(), "move_ped_crouched",1.0)    
    SetPedWeaponMovementClipset(PlayerPedId(), "move_ped_crouched",1.0)
    SetPedStrafeClipset(PlayerPedId(), "move_ped_crouched_strafing",1.0)

end



Controlkey = {["movementCrouch"] = {73,"X"},["movementCrawl"] = {20,"Z"}} 
RegisterNetEvent('event:control:update')
AddEventHandler('event:control:update', function(table)
    Controlkey["movementCrouch"] = table["movementCrouch"]
    Controlkey["movementCrawl"] = table["movementCrawl"]
end)


RegisterNetEvent("fuckthis")
AddEventHandler("fuckthis", function()
    while firstPersonActive do
        Wait(1)
        local crouchpos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.127, -0.29, 0.801)
        if not DoesCamExist(crouchCam) then
            crouchCam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
            SetCamCoord(crouchCam, crouchpos)
            SetCamRot(crouchCam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
            SetCamActive(crouchCam, true)
            RenderScriptCams(true, false, 0, true, true)
            SetCamCoord(crouchCam, crouchpos)
            SetCamFov(crouchCam, 60.0)
        end

        SetCamCoord(crouchCam, crouchpos)
        SetCamRot(crouchCam, GetGameplayCamRelativePitch(), 0.0, GetEntityHeading(PlayerPedId()) + GetGameplayCamRelativeHeading())
        if IsControlJustReleased(0, 25) then
            firstPersonActive = false
        end
    end

    if DoesCamExist(crouchCam) then
        RenderScriptCams(false, false, 0, 1, 0)
        DestroyCam(crouchCam, false)
    end
end)

RegisterNetEvent("fixprone")
AddEventHandler("fixprone", function()
    if ctrlStage == 2 then
        fixprone = true
    end
end)


function doCrouchIn()
    crouchMovement()
end
RegisterNetEvent("proneMovement")
AddEventHandler("proneMovement",function()
    if runningMovement then
        return
    end
    runningMovement = true

    if ((IsControlPressed(1,32)) and not movFwd) or (fixprone and (IsControlPressed(1,32))) then -- W
        fixprone = false
        movFwd = true
        SetPedMoveAnimsBlendOut(PlayerPedId())
        local pronepos = GetEntityCoords(PlayerPedId())
        TaskPlayAnimAdvanced(PlayerPedId(), "move_crawl", "onfront_fwd", pronepos["x"], pronepos["y"], pronepos["z"] + 0.1, 0.0, 0.0, GetEntityHeading(PlayerPedId()), 100.0, 0.4, 1.0, 7, 2.0, 1, 1)
        Wait(500)
    elseif ( not (IsControlPressed(1,32)) and movFwd) or (fixprone and not (IsControlPressed(1,32))) then -- W
        fixprone = false
        curWep = GetSelectedPedWeapon(PlayerPedId())
        myWep =  GetSelectedPedWeapon(PlayerPedId())
        local pronepos = GetEntityCoords(PlayerPedId())
        TaskPlayAnimAdvanced(PlayerPedId(), "move_crawl", "onfront_fwd", pronepos["x"], pronepos["y"], pronepos["z"] + 0.1, 0.0, 0.0, GetEntityHeading(PlayerPedId()), 100.0, 0.4, 1.0, 6, 2.0, 1, 1)
        Wait(500)
        movFwd = false
    end     
    runningMovement = false

end)


CreateThread(function()

    local Triggered1 = false
    local Triggered2 = false
    
    while true do

        if ctrlStage == 3 then

            if IsControlJustPressed(2,23) then -- F
                firstPersonActive = false
                ctrlStage = 0
                TriggerEvent("AnimSet:Set")
                jumpDisabled = false
                SetPedStealthMovement(PlayerPedId(),0,0)
                RecoilFactor(stresslevel,0)             
            else
                if not Triggered3 then
                    ClearPedTasks(PlayerPedId())
                    Triggered1 = false  
                    Triggered2 = false
                    Triggered3 = true
                    crouchMovement()

                else
                    if IsControlJustReleased(1, Controlkey["movementCrouch"][1]) then -- X
                        SetPedStealthMovement(PlayerPedId(),true,"")
                        firstPersonActive = false
                        ctrlStage = 0

                        TriggerEvent("AnimSet:Set")

                        Wait(100)
                        ClearPedTasks(PlayerPedId())

                        jumpDisabled = false
                        
                        RecoilFactor(stresslevel,0)
                        Wait(500)
                        SetPedStealthMovement(PlayerPedId(),false,"")
                        Triggered3 = false

                    else
                        if GetEntitySpeed(PlayerPedId()) > 1.0 and not incrouch then
                            incrouch = true
                            SetPedWeaponMovementClipset(PlayerPedId(), "move_ped_crouched",1.0)
                            SetPedStrafeClipset(PlayerPedId(), "move_ped_crouched_strafing",1.0)
                        elseif incrouch and GetEntitySpeed(PlayerPedId()) < 1.0 and (GetFollowPedCamViewMode() == 4 or GetFollowVehicleCamViewMode() == 4) then
        
                            incrouch = false
                            ResetPedWeaponMovementClipset(PlayerPedId())
                            ResetPedStrafeClipset(PlayerPedId())
                        end     
                    end         
                end
            end
        end




        if timelimit > 0 then
            timelimit = timelimit - 1
        end

        if IsControlJustPressed(0, 142) or IsDisabledControlJustPressed(0, 142) then
            if ctrlStage == 2 then
                ctrlStage = 3
            end
        end
        
        if IsControlJustReleased(1, Controlkey["movementCrouch"][1]) and not isFlying and not isHolding and not IsPedSittingInAnyVehicle(PlayerPedId()) and not (handCuffed or handCuffedWalking or isDead) then
            ctrlStage = 3
            if GetPedStealthMovement(PlayerPedId()) then
                SetPedStealthMovement(PlayerPedId(),0,0)
            end
            RecoilFactor(stresslevel,ctrlStage)
            firstPersonActive = false
        end

        if IsPedJacking(PlayerPedId()) or IsPedInMeleeCombat(PlayerPedId()) or IsControlJustReleased(1,22) or IsPedRagdoll(PlayerPedId()) or handCuffed or handCuffedWalking or isDead or IsPedSittingInAnyVehicle(PlayerPedId()) then
            if ctrlStage ~= 0 then
                ClearPedTasks(PlayerPedId())
                firstPersonActive = false
                ctrlStage = 0
                TriggerEvent("AnimSet:Set")
                jumpDisabled = false
                SetPedStealthMovement(PlayerPedId(),0,0)
                RecoilFactor(stresslevel,0)
                Triggered1 = false
                Triggered2 = false
                Triggered3 = false
            end
        end

        --TaskPlayAnim(PlayerPedId(), "move_crawl", "onfront_fwd", GetEntityCoords(PlayerPedId()), 1.0, 1.0, 999, 16, 1.0, 2, 2, 2);
    --  TASK_PLAY_ANIM_ADVANCED(Ped ped, char* animDict, char* animName, float posX, float posY, float posZ, float rotX, float rotY, float rotZ, float speed, float speedMultiplier, int duration, Any flag, float animTime, Any p14, Any p15);
        --TaskPlayAnimAdvanced(ped, animDict, animName, posX, posY, posZ, rotX, rotY, rotZ, speed, speedMultiplier, duration, flag, animTime, p14, p15)
        --TaskPlayAnimAdvanced(PlayerPedId(), "move_crawl", "onfront_fwd", GetEntityCoords(PlayerPedId()), 0.0, 0.0, GetEntityHeading(PlayerPedId()), 1.0, 1.0, -1, 47, 1.0, 0, 0)

        --TaskPlayAnimAdvanced(PlayerPedId(), "move_crawl", "onfront_fwd", GetEntityCoords(PlayerPedId()), 0.0, 0.0, GetEntityHeading(PlayerPedId()), 1.0, 1.0, -1, 1, 1.0, 0, 0)

        --TaskPlayAnim(ped, animDictionary, animationName, speed, speedMultiplier, duration, flag, playbackRate, lockX, lockY, lockZ)
        Wait(1)

        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            Wait(1000)
        end

    end
--  DeleteEntity(proneball)
end)


RegisterNetEvent('police:currentHandCuffedState')
AddEventHandler('police:currentHandCuffedState', function(handCuffedSent,WalkingSent)
    handCuffed = handCuffedSent
    handCuffedWalking = WalkingSent
end)

RegisterNetEvent('news:HoldingState')
AddEventHandler('news:HoldingState', function(state)
    isHolding = state
end)

RegisterNetEvent("admin:isFlying")
AddEventHandler("admin:isFlying", function(state)
    isFlying = state
end)


CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        if IsPedArmed(playerPed, 6) then
            if IsPedDoingDriveby(playerPed) then
                if GetFollowPedCamViewMode() == 0 or GetFollowVehicleCamViewMode() == 0 then
                    SetPlayerCanDoDriveBy(PlayerId(),false)
                    SetFollowPedCamViewMode(4)
                    SetFollowVehicleCamViewMode(4)
                    Wait(50)
                    SetPlayerCanDoDriveBy(PlayerId(),true)
                end
            else
                DisableControlAction(0,36,true)
                if GetPedStealthMovement(playerPed) == 1 then
                    SetPedStealthMovement(playerPed,0)
                end
            end
        end
        Wait(1)
    end
end)

