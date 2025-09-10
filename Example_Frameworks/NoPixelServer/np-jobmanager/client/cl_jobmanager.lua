--[[
    -- Type: Client Script
    -- Name: cl_jobmanager.lua
    -- Use: Handles client-side job updates and notifications
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local function handleSpecialMessages(job, name)
    if name == "Entertainer" then
        TriggerEvent('DoLongHudText', "College DJ and Comedy Club pay per person around you", 1)
    elseif name == "Broadcaster" then
        TriggerEvent('DoLongHudText', "(RadioButton + LeftCtrl for radio toggle)", 3)
        TriggerEvent('DoLongHudText', "Broadcast from this room and give out the vibes to los santos on 1982.9", 1)
    elseif job == "news" then
        TriggerEvent('DoLongHudText', "'H' to use item, F1 change item. (/light r g b)", 1)
    elseif job == "driving instructor" then
        TriggerEvent('DoLongHudText', "'/driving' to access driving instructor systems", 1)
    elseif job == "towtruck" then
        TriggerEvent('DoLongHudText', "Use /tow to tow cars to your truck.", 1)
    end
end

RegisterNetEvent("np-jobmanager:playerBecameJob", function(job, name, notify)
    local localPlayer = exports["np-base"]:getModule("LocalPlayer")
    localPlayer:setVar("job", job)

    if notify ~= false then
        TriggerEvent("DoLongHudText", job ~= "unemployed" and "New Job: " .. tostring(name) or "You're now unemployed", 1)
    end

    handleSpecialMessages(job, name)

    if job == "unemployed" then
        local ped = PlayerPedId()
        SetPedRelationshipGroupDefaultHash(ped, GetHashKey("PLAYER"))
        SetPoliceIgnorePlayer(ped, false)
        TriggerEvent("ResetRadioChannel")
    elseif job == "trucker" then
        TriggerServerEvent("TokoVoip:addPlayerToRadio", 4, GetPlayerServerId(PlayerId()))
    elseif job == "towtruck" then
        TriggerServerEvent("TokoVoip:addPlayerToRadio", 3, GetPlayerServerId(PlayerId()))
    end

    TriggerServerEvent("np-items:updateID", job, exports["isPed"]:retreiveBusinesses())
end)

RegisterNetEvent("np-base:characterLoaded", function()
    local localPlayer = exports["np-base"]:getModule("LocalPlayer")
    localPlayer:setVar("job", "unemployed")
end)

RegisterNetEvent("np-base:exportsReady", function()
    exports["np-base"]:addModule("JobManager", NPX.Jobs)
end)

