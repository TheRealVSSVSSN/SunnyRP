--[[
    -- Type: Client
    -- Name: es_admin
    -- Use: Handles client-side admin features
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

local states = {
    frozen = false,
    frozenPos = nil
}

RegisterNetEvent('es_admin:spawnVehicle')
AddEventHandler('es_admin:spawnVehicle', function(v)
        local carid = GetHashKey(v)
        local playerPed = PlayerPedId()
        if playerPed ~= 0 then
                RequestModel(carid)
                while not HasModelLoaded(carid) do
                        Wait(0)
                end
                local playerCoords = GetEntityCoords(playerPed)
                local heading = GetEntityHeading(playerPed)
                local veh = CreateVehicle(carid, playerCoords.x, playerCoords.y, playerCoords.z, heading, true, false)
                TaskWarpPedIntoVehicle(playerPed, veh, -1)
                SetEntityInvincible(veh, true)
        end
end)

RegisterNetEvent('es_admin:freezePlayer')
AddEventHandler("es_admin:freezePlayer", function(state)
	local player = PlayerId()

        local ped = PlayerPedId()

	states.frozen = state
        states.frozenPos = GetEntityCoords(ped)

	if not state then
			if not IsEntityVisible(ped) then
					SetEntityVisible(ped, true)
			end

                        if not IsPedInAnyVehicle(ped) then
                                SetEntityCollision(ped, true)
                        end

			FreezeEntityPosition(ped, false)
			--SetCharNeverTargetted(ped, false)
			SetPlayerInvincible(player, false)
	else

                        SetEntityCollision(ped, false)
                        FreezeEntityPosition(ped, true)
			--SetCharNeverTargetted(ped, true)
			SetPlayerInvincible(player, true)
			--RemovePtfxFromPed(ped)

			if not IsPedFatallyInjured(ped) then
					ClearPedTasksImmediately(ped)
			end
	end
end)

RegisterNetEvent('es_admin:teleportUser')
AddEventHandler('es_admin:teleportUser', function(user)
        local pos = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(user))))
        RequestCollisionAtCoord(pos.x, pos.y, pos.z)
        while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                RequestCollisionAtCoord(pos.x, pos.y, pos.z)
                Wait(0)
        end
        SetEntityCoords(PlayerPedId(), pos)
	states.frozenPos = pos
end)

RegisterNetEvent('es_admin:slap')
AddEventHandler('es_admin:slap', function()
        local ped = PlayerPedId()

        ApplyForceToEntity(ped, 1, 9500.0, 3.0, 7100.0, 1.0, 0.0, 0.0, 1, false, true, false, false)
end)

RegisterNetEvent('es_admin:givePosition')
AddEventHandler('es_admin:givePosition', function()
        local pos = GetEntityCoords(PlayerPedId())
        local posString = "{ ['x'] = " .. pos.x .. ", ['y'] = " .. pos.y .. ", ['z'] = " .. pos.z .. " },\n"
        TriggerServerEvent('es_admin:givePos', posString)
        TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, 'Position saved to file.')
end)

RegisterNetEvent('es_admin:kill')
AddEventHandler('es_admin:kill', function()
        SetEntityHealth(PlayerPedId(), 0)
end)

RegisterNetEvent('es_admin:crash')
AddEventHandler('es_admin:crash', function()
	while true do
	end
end)

local noclip = false
local noclip_pos

RegisterNetEvent("es_admin:noclip")
AddEventHandler("es_admin:noclip", function(t)
	local msg = "disabled"
        if not noclip then
                noclip_pos = GetEntityCoords(PlayerPedId())
        end

	noclip = not noclip

	if(noclip)then
		msg = "enabled"
	end

	TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "Noclip has been ^2^*" .. msg)
end)

CreateThread(function()
        while true do
                if states.frozen then
                        ClearPedTasksImmediately(PlayerPedId())
                        SetEntityCoords(PlayerPedId(), states.frozenPos)
                        Wait(10)
                else
                        Wait(500)
                end
        end
end)

local heading = 0

CreateThread(function()
        while true do
                if noclip then
                        SetEntityCoordsNoOffset(PlayerPedId(), noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)

                        if IsControlPressed(1, 34) then
                                heading = heading + 1.5
                                if heading > 360 then
                                        heading = 0
                                end
                                SetEntityHeading(PlayerPedId(), heading)
                        end
                        if IsControlPressed(1, 9) then
                                heading = heading - 1.5
                                if heading < 0 then
                                        heading = 360
                                end
                                SetEntityHeading(PlayerPedId(), heading)
                        end
                        if IsControlPressed(1, 8) then
                                noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.0, 0.0)
                        end
                        if IsControlPressed(1, 32) then
                                noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, -1.0, 0.0)
                        end

                        if IsControlPressed(1, 27) then
                                noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 1.0)
                        end
                        if IsControlPressed(1, 173) then
                                noclip_pos = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, -1.0)
                        end
                        Wait(0)
                else
                        Wait(500)
                end
        end
end)
