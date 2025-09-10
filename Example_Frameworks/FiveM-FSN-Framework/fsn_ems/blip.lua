local blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},

     {title="Care Center", colour=4, id=80, x = -254.430, y = 6320.478, z = 37.617}
  }
      
CreateThread(function()
    for _, info in pairs(blips) do
        local blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(blip, info.id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, info.colour)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(blip)
    end
end)

