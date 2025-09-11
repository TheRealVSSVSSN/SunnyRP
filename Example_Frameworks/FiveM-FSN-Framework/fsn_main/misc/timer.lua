-- Investigate viability of https://runtime.fivem.net/doc/natives/#_0x9CD27B0045628463
local fsn_time = 0

CreateThread(function()
    while true do
        Wait(1000)
        fsn_time = fsn_time + 1
    end
end)

function fsn_GetTime()
    return fsn_time
end