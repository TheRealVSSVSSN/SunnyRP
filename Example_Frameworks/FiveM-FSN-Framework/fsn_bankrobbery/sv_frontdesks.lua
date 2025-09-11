--[[ 
    -- Type: Server Script
    -- Name: sv_frontdesks.lua
    -- Use: Manages front desk hacking states and payouts
    -- Created: 2024-04-XX
    -- By: VSSVSSN
--]]

local desks = {}

local function resetDesks()
    desks = {
        ["Hawick Ave"] = {
            door = { mdl = -1184592117, x = 309.730, y = -280.239, z = 54.438, locked = true },
            keyboards = {
                [1] = { payout = math.random(500,1000), robspot = {x=311.0596, y=-279.4685, z=54.1646, h=341.7767}, x = 311.296, y = -278.917, z = 54.380, robbed = false },
                [2] = { payout = math.random(500,1000), robspot = {x=312.5282, y=-279.9909, z=54.1647, h=334.2443}, x = 312.679, y = -279.417, z = 54.380, robbed = false },
                [3] = { payout = math.random(500,1000), robspot = {x=314.0113, y=-280.5226, z=54.1647, h=338.1339}, x = 314.118, y = -279.945, z = 54.380, robbed = false },
                [4] = { payout = math.random(500,1000), robspot = {x=315.2654, y=-281.0484, z=54.1647, h=335.2930}, x = 315.42, y = -280.437, z = 54.380, robbed = false }
            }
        },
        ["Legion Sq"] = {
            door = { mdl = -1184592117, x = 145.399, y = -1041.872, z = 29.641, locked = true },
            keyboards = {
                [1] = { payout = math.random(500,1000), robspot = {x=146.7293, y=-1041.1541, z=29.3679, h=340.0969}, x = 146.966, y = -1040.550, z = 29.584, robbed = 'hacked' },
                [2] = { payout = math.random(500,1000), robspot = {x=148.1930, y=-1041.6196, z=29.3680, h=338.7307}, x = 148.349, y = -1041.051, z = 29.584, robbed = 'nothacked' },
                [3] = { payout = math.random(500,1000), robspot = {x=149.5933, y=-1042.1168, z=29.3680, h=347.9455}, x = 149.788, y = -1041.79, z = 29.584, robbed = 'nothacked' },
                [4] = { payout = math.random(500,1000), robspot = {x=150.8287, y=-1042.5831, z=29.3680, h=343.7143}, x = 151.093, y = -1042.072, z = 29.584, robbed = 'nothacked' }
            }
        }
    }
end

resetDesks()

RegisterNetEvent('fsn_bankrobbery:desks:doorUnlock')
AddEventHandler('fsn_bankrobbery:desks:doorUnlock', function(bank)
    if desks[bank] then
        desks[bank].door.locked = false
        TriggerClientEvent('fsn_bankrobbery:desks:receive', -1, desks)
    end
end)

RegisterNetEvent('fsn_bankrobbery:desks:request')
AddEventHandler('fsn_bankrobbery:desks:request', function()
    TriggerClientEvent('fsn_bankrobbery:desks:receive', source, desks)
end)

RegisterNetEvent('fsn_bankrobbery:desks:startHack')
AddEventHandler('fsn_bankrobbery:desks:startHack', function(bank, board)
    local comp = desks[bank] and desks[bank].keyboards[board]
    if comp then
        comp.robbed = 'hacking'
        TriggerClientEvent('fsn_bankrobbery:desks:receive', -1, desks)
    end
end)

RegisterNetEvent('fsn_bankrobbery:desks:endHack')
AddEventHandler('fsn_bankrobbery:desks:endHack', function(bank, board, state)
    local comp = desks[bank] and desks[bank].keyboards[board]
    if not comp then return end

    if state then
        comp.robbed = 'hacked'
        TriggerClientEvent('fsn_bank:change:bankAdd', source, comp.payout)
        TriggerClientEvent('mythic_notify:client:SendAlert', source, {type='success', text='You hacked the device and wired $'..comp.payout..' to your account.'})
    else
        if comp.robbed == 'hackfailed' then
            comp.robbed = 'hacked'
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type='error', text='You failed the retry of the computer hacking.'})
        else
            comp.robbed = 'hackfailed'
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type='error', text='You failed to hack the device!'})
            TriggerClientEvent('mythic_notify:client:SendAlert', source, {type='inform', text='You can retry the hacking if you have the right device.'})
        end
    end

    TriggerClientEvent('fsn_bankrobbery:desks:receive', -1, desks)
end)

CreateThread(function()
    while true do
        Wait(900000)
        resetDesks()
        TriggerClientEvent('fsn_bankrobbery:desks:receive', -1, desks)
    end
end)
