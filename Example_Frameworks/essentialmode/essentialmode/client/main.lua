-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

CreateThread(function()
        while not NetworkIsSessionStarted() do
                Wait(0)
        end
        TriggerServerEvent('es:firstJoinProper')
end)

local loaded = false
local cashy = 0
local oldPos

CreateThread(function()
        while true do
                Wait(1000)
                local pos = GetEntityCoords(PlayerPedId())

                if not oldPos or oldPos.x ~= pos.x or oldPos.y ~= pos.y or oldPos.z ~= pos.z then
                        TriggerServerEvent('es:updatePositions', pos.x, pos.y, pos.z)

                        if loaded then
                                SendNUIMessage({
                                        setmoney = true,
                                        money = cashy
                                })
                                loaded = false
                        end
                        oldPos = pos
                end
        end
end)

local myDecorators = {}

RegisterNetEvent("es:setPlayerDecorator")
AddEventHandler("es:setPlayerDecorator", function(key, value, doNow)
	myDecorators[key] = value
	DecorRegister(key, 3)

	if(doNow)then
                DecorSetInt(PlayerPedId(), key, value)
	end
end)

AddEventHandler("playerSpawned", function()
        for k,v in pairs(myDecorators)do
                DecorSetInt(PlayerPedId(), k, v)
        end
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(e)
	SendNUIMessage({
		setmoney = true,
		money = e
	})
end)

RegisterNetEvent("es:addedMoney")
AddEventHandler("es:addedMoney", function(m)
	SendNUIMessage({
		addcash = true,
		money = m
	})

end)

RegisterNetEvent("es:removedMoney")
AddEventHandler("es:removedMoney", function(m)
	SendNUIMessage({
		removecash = true,
		money = m
	})
end)

RegisterNetEvent("es:setMoneyDisplay")
AddEventHandler("es:setMoneyDisplay", function(val)
	SendNUIMessage({
		setDisplay = true,
		display = val
	})
end)

RegisterNetEvent("es:enablePvp")
AddEventHandler("es:enablePvp", function()
        SetCanAttackFriendly(PlayerPedId(), true, true)
        NetworkSetFriendlyFireOption(true)
end)

