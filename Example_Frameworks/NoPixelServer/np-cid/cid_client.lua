--[[
    -- Type: Client
    -- Name: cid_client.lua
    -- Use: Handles CID creation UI logic on the client side
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]

local isGuiOpen = false
local isCreating = false

--[[
    -- Type: Function
    -- Name: openGui
    -- Use: Displays the CID creation interface
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
function openGui()
    isGuiOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ openPhone = true })
end

--[[
    -- Type: Function
    -- Name: closeGui
    -- Use: Closes the CID creation interface
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
function closeGui()
    isCreating = false
    isGuiOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ openPhone = false })
end

--[[
    -- Type: Function
    -- Name: startCidCreation
    -- Use: Opens the UI and monitors player state until completion
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
local function startCidCreation()
    openGui()
    isCreating = true
    while isCreating do
        Wait(400)
        if exports["isPed"]:isPed("dead") then
            closeGui()
        end
    end
end

-- NUI Callback Methods
RegisterNUICallback('close', function(_, cb)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('create', function(data, cb)
    closeGui()
    TriggerServerEvent("np-cid:createID", data.first, data.last, data.job, data.sex, data.dob)
    cb('ok')
end)

RegisterNUICallback('error', function(data, cb)
    TriggerEvent("DoLongHudText", data.message, 2)
    cb('ok')
end)

--[[
    -- Type: Thread
    -- Name: proximityThread
    -- Use: Monitors player proximity to the creation marker
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
Citizen.CreateThread(function()
    while true do
        local sleep = 2000
        if exports["isPed"]:isPed("myjob") == "police" then
            local dist = #(vector3(2063.89,2990.74,-67.7) - GetEntityCoords(PlayerPedId()))
            if dist < 8 then
                sleep = 0
                DrawMarker(27,2063.89,2990.74,-68.5,0.0,0.0,0.0,0.0,0.0,0.0,0.69,0.69,0.3,100,255,255,60,0,0,2,0,0,0,0)
                DrawText3D(2063.89,2990.74,-67.8,"[E] to create ID.")
                if dist < 2 and IsControlJustPressed(0,38) then
                    openGui()
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('event:control:cid')
AddEventHandler('event:control:cid', function()
    if isGuiOpen then
        closeGui()
    else
        startCidCreation()
    end
end)

--[[
    -- Type: Function
    -- Name: DrawText3D
    -- Use: Renders 3D text at given world coordinates
    -- Created: 2024-09-10
    -- By: VSSVSSN
--]]
function DrawText3D(x,y,z, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist) * 2
    local fov = (1/GetGameplayCamFov()) * 100
    scale = scale * fov

    if onScreen then
        SetTextScale(0.3,0.3)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255,255,255,255)
        SetTextDropshadow(0,0,0,0,55)
        SetTextEdge(2,0,0,0,150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
