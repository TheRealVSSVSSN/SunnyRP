local guiEnabled = false

DecorRegister("bikeRental:rented", 3)

local bikeRentalCoords = {
  {label = "Occupation/Elgin Garage Booth", coords = vector3(278.7927, -346.3935, 44.91988)},
  {label = "Beach/Pier Bike Rental", coords = vector3(-1223.59, -1496.72, 4.36)}
}

Citizen.CreateThread(function()
  for _, v in ipairs(bikeRentalCoords) do
    v.blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
    SetBlipSprite(v.blip, 226)
    SetBlipColour(v.blip, 4)
    SetBlipScale(v.blip, 0.6)
    SetBlipAsShortRange(v.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Bike Rental")
    EndTextCommandSetBlipName(v.blip)
  end

  while true do
    local wait = 1000
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    for _, v in ipairs(bikeRentalCoords) do
      local dist = #(pos - v.coords)
      if dist <= 2.0 then
        wait = 0
        if not IsPedInAnyVehicle(ped, false) then
          Util.DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.3, '~r~[E] ~w~Bike Rentals', {255,255,255,255}, 0.25)
          if IsControlJustReleased(0, 38) then
            EnableGui(true)
          end
        else
          local veh = GetVehiclePedIsIn(ped, false)
          if DecorGetInt(veh, "bikeRental:rented") == 1 then
            Util.DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.3, '~r~[E] ~w~Return Bike', {255,255,255,255}, 0.25)
            if IsControlJustReleased(0, 38) then
              deleteCar()
              TriggerEvent('fsn_notify:displayNotification', 'Rented Bike Returned', 'centerLeft', 4000, 'success')
            end
          else
            Util.DrawText3D(v.coords.x, v.coords.y, v.coords.z + 0.3, 'Not on a Rented Bike', {255,255,255,255}, 0.25)
          end
        end
      end
    end
    Citizen.Wait(wait)
  end
end)

local function spawnCar(model)
  local modelHash = GetHashKey(model)

  RequestModel(modelHash)
  while not HasModelLoaded(modelHash) do
    Citizen.Wait(0)
  end

  local ped = PlayerPedId()
  local x, y, z = table.unpack(GetEntityCoords(ped, false))
  local vehicle = CreateVehicle(modelHash, x, y, z + 1.0, GetEntityHeading(ped), true, false)
  SetEntityAsMissionEntity(vehicle, true, true)
  SetPedIntoVehicle(ped, vehicle, -1)
  DecorSetInt(vehicle, "bikeRental:rented", 1)
  SetModelAsNoLongerNeeded(modelHash)
end

local function deleteCar()
  local veh = GetVehiclePedIsIn(PlayerPedId(), false)
  if DecorGetInt(veh, "bikeRental:rented") == 1 then
    SetEntityAsMissionEntity(veh, true, true)
    DeleteVehicle(veh)
  else
    print("Not a rented bike.")
  end
end

local function EnableGui(enable)
  SetNuiFocus(enable, enable)
  guiEnabled = enable
  SendNUIMessage({
    type = "enableui",
    enable = enable
  })
end

RegisterNUICallback('escape', function(_, cb)
  EnableGui(false)
  cb('ok')
end)

RegisterNUICallback('rentBike', function(data, cb)
  if exports["fsn_main"]:fsn_GetWallet() >= tonumber(data.price) then
    TriggerEvent('fsn_bank:change:walletMinus', data.price)
    TriggerEvent('fsn_notify:displayNotification', 'Bike Rented!', 'centerLeft', 4000, 'success')
    spawnCar(data.model)
    EnableGui(false)
    cb('ok')
  else
    TriggerEvent('fsn_notify:displayNotification', 'Not enough money.', 'centerLeft', 4000, 'error')
  end
end)

Citizen.CreateThread(function()
  while true do
    if guiEnabled then
      DisableControlAction(0, 1, true)
      DisableControlAction(0, 2, true)
      DisableControlAction(0, 142, true)
      DisableControlAction(0, 106, true)

      if IsDisabledControlJustReleased(0, 142) then
        SendNUIMessage({type = "click"})
      end
    end
    Citizen.Wait(0)
  end
end)
