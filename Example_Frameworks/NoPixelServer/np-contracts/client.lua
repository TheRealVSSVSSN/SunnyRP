--[[
    -- Type: Client Script
    -- Name: np-contracts client
    -- Use: Handles contract UI interactions in the client
    -- Created: 2024-01-21
    -- By: VSSVSSN
--]]

local guiEnabled, hasOpened = false, false
local listedContracts, viewIndex = {}, 0
local acceptingContract = false

local Controlkey = { generalUse = {38, "E"}, generalUseSecondaryWorld = {23, "F"} }
RegisterNetEvent('event:control:update', function(tbl)
    Controlkey.generalUse = tbl.generalUse
    Controlkey.generalUseSecondaryWorld = tbl.generalUseSecondaryWorld
end)

local function sendMessage(data)
    SendNUIMessage(data)
end

local function openGui(section)
    SetPlayerControl(PlayerId(), false, 0)
    guiEnabled = true
    SetNuiFocus(true, true)
    sendMessage({ openSection = section })
    TriggerEvent('notepad')
    if section == 'openContracts' and not hasOpened then
        listedContracts = {}
        hasOpened = true
    end
end

local function openContractsGui()
    openGui('openContracts')
end

local function openContractCreatorGui()
    openGui('openContractStart')
end

local function closeGui()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
    SetNuiFocus(false, false)
    sendMessage({ openSection = 'close' })
    guiEnabled = false
    SetPlayerControl(PlayerId(), true, 0)
end

-- NUI callbacks
RegisterNUICallback('giveID', function(data, cb)
    closeGui()
    TriggerServerEvent('server:contractsend', data.target, data.conamount, data.coninformation)
    cb('ok')
end)

RegisterNUICallback('previousID', function(_, cb)
    TriggerEvent('ContractsList', listedContracts, viewIndex - 1)
    cb('ok')
end)

RegisterNUICallback('nextID', function(_, cb)
    TriggerEvent('ContractsList', listedContracts, viewIndex + 1)
    cb('ok')
end)

RegisterNUICallback('payID', function(_, cb)
    local currentTax = exports['np-votesystem']:getTax()
    TriggerServerEvent('contract:paycontract', false, listedContracts[viewIndex].ContractID, currentTax)
    closeGui()
    cb('ok')
end)

RegisterNUICallback('close', function(_, cb)
    closeGui()
    cb('ok')
end)

local function openDummyContract(price, strg)
    SetNuiFocus(false, false)
    sendMessage({ openSection = 'openContractDummy', price = price, strg = strg })
end

local function drawText3D(text)
    local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.0))
    local _, _x, _y = World3dToScreen2d(x, y, z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = 60 / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent('contract:requestaccept', function(price, strg, src)
    if acceptingContract then return end
    acceptingContract = true
    openDummyContract(price, strg)

    CreateThread(function()
        while acceptingContract do
            Wait(0)
            drawText3D(('CONTRACT: [%s] to accept, [%s] to deny.'):format(Controlkey.generalUse[2], Controlkey.generalUseSecondaryWorld[2]))
            if IsControlJustReleased(0, Controlkey.generalUse[1]) then
                TriggerServerEvent('contract:accept', price, strg, src, true)
                acceptingContract = false
                closeGui()
            elseif IsControlJustReleased(0, Controlkey.generalUseSecondaryWorld[1]) then
                TriggerServerEvent('contract:accept', price, strg, src, false)
                acceptingContract = false
                closeGui()
            end
        end
    end)
end)

RegisterNetEvent('contracts:close', function()
    closeGui()
end)

RegisterNetEvent('startcontract', function()
    openContractCreatorGui()
end)

RegisterNetEvent('ContractsList', function(contracts, viewnumber)
    if #contracts == 0 then return end
    viewIndex = viewnumber
    closeGui()
    Wait(10)
    openContractsGui()
    listedContracts = contracts

    if viewIndex > #listedContracts then
        viewIndex = 1
    elseif viewIndex < 1 then
        viewIndex = #listedContracts
    end

    local contract = listedContracts[viewIndex]
    local contractID = ('<h3>Contract Identification Number</h3> <br><h1>%s</h1>'):format(contract.ContractID)
    local contractAmount = ('<h3>Contract Amount Payable</h3> <br><h1> $%s USD</h1>'):format(contract.amount)
    local contractInfo = ('<h3>Signed Contract Agreement</h3> <br>%s'):format(contract.Info)
    sendMessage({ openSection = 'contractUpdate', NUIcontractID = contractID, NUIcontractAmount = contractAmount, NUIcontractInfo = contractInfo })
end)

