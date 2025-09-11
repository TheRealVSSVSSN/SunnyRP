local last_health = 0

CreateThread(function()
        while true do Wait(0)
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                        local cur_health = GetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId(), false))
			if cur_health < last_health then
				local difference = last_health - cur_health
                                if difference > 40 and IsPointOnRoad(GetEntityCoords(PlayerPedId()), GetVehiclePedIsIn(PlayerPedId(), false)) then
                                        local pos = GetEntityCoords(PlayerPedId())
					local coords = {
					 x = pos.x,
					 y = pos.y,
					 z = pos.z
				   }
				   TriggerServerEvent('fsn_police:dispatch', coords, 16)
				end
			end
                        last_health = GetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId(), false))
		end
	end
end)
