local spikes = {}

RegisterNetEvent('police:spikesLocation')
AddEventHandler('police:spikesLocation', function(x, y, z, heading)
    local src = source
    table.insert(spikes, {x = x, y = y, z = z, h = heading, id = src, placed = false, object = nil, watching = false})
    local spikeID = #spikes
    TriggerClientEvent('addSpikes', -1, spikes[spikeID], spikeID)
end)

RegisterNetEvent('police:removespikes')
AddEventHandler('police:removespikes', function(id)
    if spikes[id] then
        table.remove(spikes, id)
    end
    TriggerClientEvent('removeSpikes', -1, id)
end)
