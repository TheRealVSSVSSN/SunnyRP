--[[ 
    -- Type: Server
    -- Name: np-rehab server
    -- Use: Provides commands to manage player rehabilitation
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]

--[[ 
    -- Type: Command
    -- Name: rehab
    -- Use: Places or removes a player from rehab
    -- Created: 2024-05-31
    -- By: VSSVSSN
--]]
RegisterCommand('rehab', function(source, args)
    local src = source
    local user = exports["np-base"]:getModule("Player"):GetUser(src)
    if not user then return end

    local job = user:getVar("job")
    if job ~= 'therapist' and job ~= 'doctor' then return end

    local target = tonumber(args[1])
    if not target or not GetPlayerName(target) then
        TriggerClientEvent("DoLongHudText", src, 'There are no player with this ID.', 2)
        return
    end

    local inRehab = args[2] and args[2]:lower() == 'true'
    TriggerClientEvent("beginJailRehab", target, inRehab)
end, false)

