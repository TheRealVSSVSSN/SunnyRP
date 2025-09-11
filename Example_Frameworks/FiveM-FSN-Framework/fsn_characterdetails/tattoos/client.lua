--[[ 
    -- Type: Module
    -- Name: Tattoo Client
    -- Use: Handles tattoo shop interactions and preview camera
    -- Created: 2024-04-22
    -- By: VSSVSSN
--]]

local choosingTattoo = false
local currentCategory = 1
local currentTattoo = 1
local tattooCamera
local previousTattoos = {}

RegisterNetEvent('fsn_characterdetails:recievetattoos')
AddEventHandler('fsn_characterdetails:recievetattoos', function(data)
    previousTattoos = data or {}
end)

CreateThread(function()
    for _, store in ipairs(Config.TattooLocations) do
        local blip = AddBlipForCoord(store.X, store.Y, store.Z)
        SetBlipSprite(blip, 75)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString('InKed uP')
        EndTextCommandSetBlipName(blip)
    end

    while true do
        Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, coords in ipairs(Config.TattooLocations) do
            local distance = #(playerCoords - vector3(coords.X, coords.Y, coords.Z))
            if distance < 10.0 then
                DrawMarker(1, coords.X, coords.Y, coords.Z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.001, 1.0001, 0.4001, 0, 155, 255, 175, false, false, 0, false)
                if distance < 1.0 then
                    SetTextComponentFormat('STRING')
                    AddTextComponentString('Press ~INPUT_PICKUP~ to get a ~y~tattoo')
                    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                    if IsControlJustPressed(0, 38) then
                        ToggleActionMenu()
                        previewTattoo()
                    end
                end
            end
        end
    end
end)

local function applyTattoos()
    ClearPedDecorations(PlayerPedId())
    for _, hash in ipairs(previousTattoos) do
        local category = GetTattooCategory(hash)
        if category then
            ApplyPedOverlay(PlayerPedId(), GetHashKey(category), GetHashKey(hash))
        end
    end
end

function ExitTattooStore()
    choosingTattoo = false
end

function NextCategory()
    currentCategory = currentCategory + 1
    if currentCategory > #Config.TattooCategories then
        currentCategory = 1
    end
    currentTattoo = 1
    previewTattoo()
end

function BackCategory()
    currentCategory = currentCategory - 1
    if currentCategory < 1 then
        currentCategory = #Config.TattooCategories
    end
    currentTattoo = 1
    previewTattoo()
end

function NextTattoo()
    local list = Config.TattooList[Config.TattooCategories[currentCategory].Value]
    currentTattoo = currentTattoo + 1
    if currentTattoo > #list then
        currentTattoo = 1
    end
    previewTattoo()
end

function PreviousTattoo()
    local list = Config.TattooList[Config.TattooCategories[currentCategory].Value]
    currentTattoo = currentTattoo - 1
    if currentTattoo < 1 then
        currentTattoo = #list
    end
    previewTattoo()
end

function PurchaseTattoo()
    local hash = Config.TattooList[Config.TattooCategories[currentCategory].Value][currentTattoo].NameHash
    table.insert(previousTattoos, hash)
    TriggerEvent('fsn_main:saveCharacter')
end

function previewTattoo()
    choosingTattoo = true

    local playerPed = PlayerPedId()
    SetEntityHeading(playerPed, 297.7296)
    applyTattoos()

    if not DoesCamExist(tattooCamera) then
        tattooCamera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        SetCamActive(tattooCamera, true)
        RenderScriptCams(true, false, 0, true, true)
    end

    FreezeEntityPosition(playerPed, true)

    local coords = GetEntityCoords(playerPed)
    local data = Config.TattooList[Config.TattooCategories[currentCategory].Value][currentTattoo]

    SetCamCoord(tattooCamera, coords.x + data.AddedX, coords.y + data.AddedY, coords.z + data.AddedZ)
    SetCamRot(tattooCamera, 0.0, 0.0, data.RotZ)

    ApplyPedOverlay(playerPed, GetHashKey(Config.TattooCategories[currentCategory].Value), GetHashKey(data.NameHash))

    while choosingTattoo do
        Wait(0)
    end

    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(tattooCamera, true)
    FreezeEntityPosition(playerPed, false)
    applyTattoos()
end

function GetPreviousTattoos()
    return previousTattoos
end

function GetTattooCategory(tattooHash)
    for category, tattoos in pairs(Config.TattooList) do
        for _, info in ipairs(tattoos) do
            if info.NameHash == tattooHash then
                return category
            end
        end
    end
    return nil
end
