local emitters = {
  "se_walk_radio_d_picked",
}

CreateThread(function()
  for _, emitter in ipairs(emitters) do
    SetStaticEmitterEnabled(emitter, false)
  end
end)

CreateThread(function()
  RequestIpl("gabz_import_milo_")

  local interiorId = GetInteriorAtCoords(941.00840000, -972.66450000, 39.14678000)

  if IsValidInterior(interiorId) then
    --EnableInteriorProp(interiorId, "basic_style_set")
    --EnableInteriorProp(interiorId, "urban_style_set")
    EnableInteriorProp(interiorId, "branded_style_set")
    EnableInteriorProp(interiorId, "car_floor_hatch")

    RefreshInterior(interiorId)
  end
end)

