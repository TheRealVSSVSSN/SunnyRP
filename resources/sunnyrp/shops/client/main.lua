-- resources/sunnyrp/shops/client/main.lua

RegisterNetEvent('srp:shops:catalog', function(data)
  -- Minimal printout; wire to NUI later
  if not data or not data.items then return end
  print(('Catalog for %s:'):format(data.business.slug))
  for _, it in ipairs(data.items) do
    print(('- %s: $%0.2f %s'):format(it.item_code, it.price_cents/100.0, it.stock_qty and ('(stock '..it.stock_qty..')') or '(∞)'))
  end
end)

RegisterNetEvent('srp:shops:receipt', function(r)
  -- toast-like feedback; replace with NUI as needed
  BeginTextCommandThefeedPost("STRING")
  AddTextComponentSubstringPlayerName(("~g~Receipt~s~ %s: $%0.2f (tax $%0.2f)"):format(r.business.slug, (r.totals.total_cents or 0)/100.0, (r.totals.tax_cents or 0)/100.0))
  EndTextCommandThefeedPostTicker(false, false)
end)