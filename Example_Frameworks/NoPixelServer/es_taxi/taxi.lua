local onJob = 0
local player = PlayerId()

local mypaytaxi = 0
local playerPed = PlayerPedId()
local location = GetEntityCoords(playerPed, 0)
local isSignedIn = false

-- predefined vehicle spawn locations at taxi depot
local spawnLocations = {
    {x = 154.875, y = -746.979, z = 32.748, a = 338.417},
    {x = 151.623, y = -746.979, z = 32.748, a = 338.417},
    {x = 147.846, y = -746.979, z = 32.748, a = 338.417},
    {x = 140.757, y = -743.993, z = 32.748, a = 338.417},
    {x = 137.141, y = -742.611, z = 32.748, a = 338.417},
    {x = 134.904, y = -732.704, z = 33.133, a = 244.824},
}

--[[
    -- Type: Function
    -- Name: getSpawnLoc
    -- Use: Returns the first free spawn location for a taxi at the depot
    -- Created: 2024-06-04
    -- By: VSSVSSN
--]]
function getSpawnLoc()
    for _, loc in ipairs(spawnLocations) do
        local vehicle = GetClosestVehicle(loc.x, loc.y, loc.z, 3.0, 0, 70)
        if not DoesEntityExist(vehicle) then
            return loc
        end
    end
    return nil
end

local lastSpawn
local isTaxi = false
local isNews = false

-- passenger pickup locations around the map
local customerLocations = {
    { 293.476,-590.163,42.7371},
    { 253.404,-375.86,44.0819},
    { 120.808,-300.416,45.1399},
    { -38.4132,-381.576,38.3456},
    { -107.442,-614.377,35.6703},
    { -252.292,-856.474,30.5626},
    { -236.138,-988.382,28.7749},
    { -276.989,-1061.18,25.6853},
    { -576.451,-998.989,21.785},
    { -602.798,-952.63,21.6353},
    { -790.653,-961.855,14.8932},
    { -912.588,-864.756,15.0057},
    { -1069.77,-792.513,18.8075},
    { -1306.94,-854.085,15.0959},
    { -1468.51,-681.363,26.178},
    { -1380.89,-452.7,34.0843},
    { -1326.35,-394.81,36.0632},
    { -1383.68,-269.985,42.4878},
    { -1679.61,-457.339,39.4048},
    { -1812.45,-416.917,43.6734},
    { -2043.64,-268.291,22.9927},
    { -2186.45,-421.595,12.6776},
    { -1862.08,-586.528,11.1747},
    { -1859.5,-617.563,10.8788},
    { -1634.95,-988.302,12.6241},
    { -1283.99,-1154.16,5.30998},
    { -1126.47,-1338.08,4.63434},
    { -867.907,-1159.67,5.00795},
    { -847.55,-1141.38,6.27591},
    { -722.625,-1144.6,10.2176},
    { -575.503,-318.446,34.5273},
    { -592.309,-224.853,36.1209},
    { -559.594,-162.873,37.7547},
    { -534.992,-65.6695,40.634},
    { -758.234,-36.6906,37.2911},
    { -1375.88,20.9516,53.2255},
    { -1320.25,-128.018,48.097},
    { -1285.71,294.287,64.4619},
    { -1245.67,386.533,75.0908},
    { -760.355,285.015,85.0667},
    { -626.786,254.146,81.0964},
    { -563.609,267.962,82.5116},
    { -486.806,271.977,82.8187},
    { 88.295,250.867,108.188},
    { 234.087,344.678,105.018},
    { 434.963,96.707,99.1713},
    { 482.617,-142.533,58.1936},
    { 762.651,-786.55,25.8915},
    { 809.06,-1290.8,25.7946},
    { 490.819,-1751.37,28.0987},
    { 432.351,-1856.11,27.0352},
    { 164.348,-1734.54,28.8982},
    { -57.6909,-1501.4,31.1084},
    { 52.2241,-1566.65,29.006},
    { 310.222,-1376.76,31.4442},
    { 181.967,-1332.79,28.8773},
    { -74.6091,-1100.64,25.738},
    { -887.045,-2187.46,8.13248},
    { -749.584,-2296.59,12.4627},
    { -1064.83,-2560.66,19.6811},
    { -1033.44,-2730.24,19.6868},
    { -1018.67,-2732,13.2687},
    { 797.354,-174.423,72.708},
    { 508.156,-117.908,60.78},
    { 159.458,-27.555,67.38},
    { -36.382,-106.912,56.982},
    { -355.801,-270.404,33.011},
    { -831.196,-76.871,37.323},
    { -1038.707,-214.593,37.437},
    { 1918.448,3691.41,32.261},
    { 1820.217,3697.115,33.493},
    { 1619.323,3827.162,34.482},
    { 1418.628,3602.243,34.511},
    { 1944.858,3856.252,31.741},
    { 2285.278,3839.444,34.023},
    { 2760.945,3387.813,55.659},
    { 1952.819,2627.731,45.368},
    { 1051.414,474.833,93.653},
    { 866.393,17.635,78.654},
    { 318.985,167.41,103.335},
    { 88.836,254.054,108.236},
    { -44.852,70.414,72.437},
    { -115.496,84.333,70.792},
    { -384.806,226.868,83.548},
    { -578.669,139.085,61.337},
    { -651.334,-584.879,34.116},
    { -571.847,-1195.648,17.869},
    { -1513.271,-670.039,28.362},
    { -1297.484,-654.913,26.123},
    { -1645.546,144.571,61.664},
    { -1160.618,744.418,154.571},
    { -798.09,831.699,204.351},
}

RegisterNetEvent("np-jobmanager:playerBecameJob")
AddEventHandler("np-jobmanager:playerBecameJob", function(job)
	remBlips()
	StopJob(1)
	
	if job == "taxi" then
		isSignedIn = true
		isTaxi = true
		isNews = false
	elseif job == "news" then
		isTaxi = false
		isNews = true
	else
		isSignedIn = false
		isTaxi = false
		isNews = false
		onJob = 0
	end
end)




local jobs = {peds = {}, flag = {}, blip = {}, cars = {}, coords = {cx = {}, cy = {}, cz = {}}}

function StartJob(jobid)
        if jobid == 1 then -- taxi
                showLoadingPromt("Loading taxi mission", 2000, 3)
                for i, loc in ipairs(customerLocations) do
                        jobs.coords.cx[i], jobs.coords.cy[i], jobs.coords.cz[i] = loc[1], loc[2], loc[3]
                end

                jobs.cars[1] = GetVehiclePedIsUsing(PlayerPedId())
                jobs.flag[1] = 0
                jobs.flag[2] = 259 + GetRandomIntInRange(1, 61)
                Wait(2000)
                DrawTxtTaxi("Head to the Taxi Rank and wait for a customer.", 10000)
                onJob = jobid
        end
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawTxtTaxi(x - width/2, y - height/2 + 0.005)
end
local counter = 0
function DrawTxtTaxi(text, showtime)

	TriggerEvent("DoLongHudText",text,69)
    Wait(1000)
end

function showLoadingPromt(showText, showTime, showType)
	CreateThread(function()
		Wait(0)
		N_0xaba17d7ce615adbf("STRING") -- set type
		AddTextComponentString(showText) -- sets the text
		N_0xbd12f8228410d9b4(showType) -- show promt (types = 3)
		Wait(showTime) -- show time
		N_0x10d373323e5b9c0d() -- remove promt
	end)
end

function StopJob(jobid)
	if jobid == 1 then
		if DoesEntityExist(jobs.peds[1]) then
			local pedb = GetBlipFromEntity(jobs.peds[1])
			if pedb ~= nil and DoesBlipExist(pedb) then
				SetBlipSprite(pedb, 2)
				SetBlipDisplay(pedb, 3)
			end
			ClearPedTasksImmediately(jobs.peds[1])
			if DoesEntityExist(jobs.cars[1]) and IsVehicleDriveable(jobs.cars[1], 0) then
				if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
					TaskLeaveVehicle(jobs.peds[1], jobs.cars[1], 256)
				end
			end
			Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
		end
		if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
			remBlips()
		end
		onJob = 0
		jobs.cars[1] = nil
		jobs.peds[1] = nil
		jobs.flag[1] = nil
		jobs.flag[2] = nil
	end
end
local paymenttaxilolhehe = 0
CreateThread(function()
	while true do
		Wait(0)
		if onJob == 0 and isSignedIn then
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if IsVehicleModel(GetVehiclePedIsUsing(PlayerPedId()), GetHashKey("taxi", _r)) then
					TriggerEvent("DoLongHudText","Type /phone to check for any active Job Alerts!",1)

					StartJob(1)
				end
			end
		elseif onJob == 1 then
			if DoesEntityExist(jobs.cars[1]) and IsVehicleDriveable(jobs.cars[1], 0) then
				local taxidst = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(jobs.cars[1]))
				if IsPedSittingInVehicle(PlayerPedId(), jobs.cars[1]) or taxidst < 10.0 then
					if DoesEntityExist(jobs.peds[1]) then
						if IsPedFatallyInjured(jobs.peds[1]) then
							Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
							local pedb = GetBlipFromEntity(jobs.peds[1])
							if pedb ~= nil and DoesBlipExist(pedb) then
								SetBlipSprite(pedb, 2)
								SetBlipDisplay(pedb, 3)
							end
							jobs.peds[1] = nil
							jobs.flag[1] = 0
							jobs.flag[2] = 60+GetRandomIntInRange(1, 61)
							if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
								remBlips()
							end
							DrawTxtTaxi("The client is dead. Maybe that should be reported to the police?", 5000)
						else
							if jobs.flag[1] == 1 and jobs.flag[2] > 0 then
								Wait(1000)
								jobs.flag[2] = jobs.flag[2]-1
								if jobs.flag[2] == 0 then
									local pedb = GetBlipFromEntity(jobs.peds[1])
									if pedb ~= nil and DoesBlipExist(pedb) then
										SetBlipSprite(pedb, 2)
										SetBlipDisplay(pedb, 3)
									end
									ClearPedTasksImmediately(jobs.peds[1])
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
									jobs.peds[1] = nil
									DrawTxtTaxi("The client got tired of waiting. Find another one.", 5000)
									jobs.flag[1] = 0
									jobs.flag[2] = 60+GetRandomIntInRange(1, 61)
								else
									if IsPedSittingInVehicle(PlayerPedId(), jobs.cars[1]) then
										if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(jobs.peds[1])) < 25.0001 and GetEntitySpeed(jobs.cars[1]) < 5.0 then
											local offs = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsUsing(PlayerPedId()), 1.5, 0.0, 0.0)
											local offs2 = GetOffsetFromEntityInWorldCoords(GetVehiclePedIsUsing(PlayerPedId()), -1.5, 0.0, 0.0)
											if #(vector3(offs['x'], offs['y'], offs['z']) - GetEntityCoords(jobs.peds[1])) < #(vector3(offs2['x'], offs2['y'], offs2['z']) - GetEntityCoords(jobs.peds[1])) then
												TaskEnterVehicle(jobs.peds[1], jobs.cars[1], -1, 2, 2.0001, 1)
											else
												TaskEnterVehicle(jobs.peds[1], jobs.cars[1], -1, 1, 2.0001, 1)
											end
											jobs.flag[1] = 2
											jobs.flag[2] = 30
										end
									end
								end
							end
							if jobs.flag[1] == 2 and jobs.flag[2] > 0 then
								Wait(1000)
								jobs.flag[2] = jobs.flag[2]-1
								if jobs.flag[2] == 0 then
									local pedb = GetBlipFromEntity(jobs.peds[1])
									if pedb ~= nil and DoesBlipExist(pedb) then
										SetBlipSprite(pedb, 2)
										SetBlipDisplay(pedb, 3)
									end
									ClearPedTasksImmediately(jobs.peds[1])
									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))
									jobs.peds[1] = nil
									DrawTxtTaxi("The client is not going with you. Find another one.", 5000)
									jobs.flag[1] = 0
									jobs.flag[2] = 60+GetRandomIntInRange(1, 61)
								else
									if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
										local pedb = GetBlipFromEntity(jobs.peds[1])
										playerPed = PlayerPedId()
										location = GetEntityCoords(playerPed, 0)

										if pedb ~= nil and DoesBlipExist(pedb) then
											SetBlipSprite(pedb, 2)
											SetBlipDisplay(pedb, 3)
										end
										jobs.flag[1] = 3
										jobs.flag[2] = GetRandomIntInRange(1, 62)
										local street = table.pack(GetStreetNameAtCoord(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]]))
										
										paymenttaxilolhehe = CalculateTravelDistanceBetweenPoints(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]],GetEntityCoords(PlayerPedId()))
            


										if street[2] ~= 0 and street[2] ~= nil then
											local streetname = string.format("Take me to %s, nearby %s", GetStreetNameFromHashKey(street[1]),GetStreetNameFromHashKey(street[2]))
											DrawTxtTaxi(streetname, 5000)
										else
											local streetname = string.format("Take me to the %s", GetStreetNameFromHashKey(street[1]))
											DrawTxtTaxi(streetname, 5000)
										end
										jobs.blip[1] = AddBlipForCoord(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]])
										AddTextComponentString(GetStreetNameFromHashKey(street[1]))
										N_0x80ead8e2e1d5d52e(jobs.blip[1])
										SetBlipRoute(jobs.blip[1], 1)
									end
								end
							end
							if jobs.flag[1] == 3 then

								if #(GetEntityCoords(PlayerPedId()) - vector3(jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]])) > 4.0001 then

									DrawMarker(27, jobs.coords.cx[jobs.flag[2]],jobs.coords.cy[jobs.flag[2]],jobs.coords.cz[jobs.flag[2]]-1.0001, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 2.0, 178, 236, 93, 155, 0, 0, 2, 0, 0, 0, 0)

								else

									if jobs.blip[1] ~= nil and DoesBlipExist(jobs.blip[1]) then
										remBlips()
									end

									DrawTxtTaxi("Park the Taxi, they are ready to pay you.", 5000)

									local counter = 60000
									while GetEntitySpeed(jobs.cars[1]) > 1.0 and counter > 0 do
										Wait(1)
										counter = counter - 1
									end

									Wait(1000)

									if DoesEntityExist(jobs.cars[1]) then
										if IsPedSittingInVehicle(jobs.peds[1], jobs.cars[1]) then
											TaskLeaveVehicle(jobs.peds[1], jobs.cars[1], 256)
										end
									end

									Citizen.InvokeNative(0xB736A491E64A32CF,Citizen.PointerValueIntInitialized(jobs.peds[1]))

									jobs.peds[1] = nil

									Wait(2000)

	              				    DrawTxtTaxi("You have delivered the client!", 5000)

									mypaytaxi = math.ceil((paymenttaxilolhehe / 12))

									if mypaytaxi > 150 then
										mypaytaxi = 150
									end
									
									if mypaytaxi == nil or mypaytaxi < 30 then
						              mypaytaxi = 30
						            end


									local util = exports["np-base"]:getModule("Util")
	    
									TriggerServerEvent("server:givepayJob", "Taxi Service", math.random(30,mypaytaxi))

									Wait(2000)

									DrawTxtTaxi("Head to the Taxi Rank and wait for a customer.", 10000)
									jobs.flag[1] = 0
									jobs.flag[2] = 59+GetRandomIntInRange(1, 61)

								end
							end
						end
					else
						local pickable = false
						local dst = #(vector3( -12.72, -143.3, 56.26) - GetEntityCoords(PlayerPedId())) 
						if dst < 20.0 then
							pickable = true
							Wait(2000)
						else
							Wait(2000)
						end
						if isSignedIn and GetRandomIntInRange(0,100) > 61 and pickable then			
							local pos = GetEntityCoords(PlayerPedId())
							local randX = GetRandomIntInRange(15, 35)
							local randY = GetRandomIntInRange(15, 35)
							local rped = GetPedNow()
							if DoesEntityExist(rped) then
	
								jobs.peds[1] = rped
								jobs.flag[1] = 1
								jobs.flag[2] = 19+GetRandomIntInRange(1, 21)
								ClearPedTasksImmediately(jobs.peds[1])
								SetBlockingOfNonTemporaryEvents(jobs.peds[1], 1)
								
								HailTaxi(jobs.peds[1])
								DrawTxtTaxi("A customer is nearby waving for a taxi - go get them!", 5000)
								local lblip = AddBlipForEntity(jobs.peds[1])
								SetBlipAsFriendly(lblip, 1)
								SetBlipColour(lblip, 2)
								SetBlipCategory(lblip, 3)
							else
								jobs.flag[1] = 0
								jobs.flag[2] = 59+GetRandomIntInRange(1, 90)
								if math.random(100) > 70 then
									TriggerServerEvent("server:givepayJob", "Taxi Service", math.random(1,5))
								end
							end
						end
					end
				else
					if #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(jobs.cars[1])) > 30.0001 then
						StopJob(1)
					end
				end
			else
				StopJob(1)
				DrawTxtTaxi("The taxi is destroyed.", 5000)
			end
		else
			Wait(1000)
		end
	end
end)



function canPedBeUsed(ped)

    if ped == nil then
        return false
    end

    if ped == PlayerPedId() then
        return false
    end

    if GetEntityHealth(ped) < GetEntityMaxHealth(ped) then
      return false
    end

    if IsPedInAnyVehicle(ped, false) then
    	return false
    end


    if `mp_f_deadhooker` == GetEntityModel(ped) then
      return false
    end

    local curcoords = GetEntityCoords(PlayerPedId())
    local startcoords = GetEntityCoords(ped)

    if #(curcoords - startcoords) < 6.0 then
      return false
    end    

    if not DoesEntityExist(ped) then
        return false
    end

    if IsPedAPlayer(ped) then
        return false
    end

    if IsPedFatallyInjured(ped) then
        return false
    end
    
    if IsPedArmed(ped, 7) then
        return false
    end

    if IsPedInMeleeCombat(ped) then
        return false
    end

    if IsPedShooting(ped) then
        return false
    end

    if IsPedDucking(ped) then
        return false
    end

    if IsPedBeingJacked(ped) then
        return false
    end

    if IsPedSwimming(ped) then
        return false
    end

    if IsPedJumpingOutOfVehicle(ped) or IsPedBeingJacked(ped) then
        return false
    end

    local pedType = GetPedType(ped)
    if pedType == 6 or pedType == 27 or pedType == 29 or pedType == 28 then
        return false
    end

    return true
end

function GetPedNow()

    local basedistance = 25.0
    local playerped = PlayerPedId()
    local playerCoords = GetEntityCoords(playerped)
    local handle, ped = FindFirstPed()
    local success
    local rped = nil
    local distanceFrom
    repeat
        local pos = GetEntityCoords(ped)
        local distance = #(playerCoords - pos)
        if canPedBeUsed(ped) and distance < basedistance and distance > 2.0 then
            distanceFrom = distance
            rped = ped
        end
        success, ped = FindNextPed(handle)
    until not success

    EndFindPed(handle)

    return rped
end

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Wait( 5 )
    end
end


function remBlips()
	for i = 1, #jobs.blip do
		SetBlipRoute(jobs.blip[i],0)
		Citizen.InvokeNative(0x86A652570E5F25DD,Citizen.PointerValueIntInitialized(jobs.blip[i]))
		jobs.blip[i] = nil

	end
end

function HailTaxi(lPed)
	TaskTurnPedToFaceEntity(lPed, PlayerPedId(), 1.0)
	Wait(1000)
	local dic = "taxi_hail"
	local anim = "hail_taxi"
	loadAnimDict( dic ) 
	TaskPlayAnim(lPed, dic, anim, 1.0, 1.0, -1, 16, 1, 0, 0, 0 )
end