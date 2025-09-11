local FSN = {}
_G.FSN = FSN

local current_players = {}
local moneystore = {}

AddEventHandler('fsn:getFsnObject', function(cb)
    cb(FSN)
end)

AddEventHandler('fsn_main:updateCharacters', function(charTbl)
    current_players = charTbl or {}
end)

AddEventHandler('fsn_main:updateMoneyStore', function(moneyTbl)
    moneystore = moneyTbl or {}
end)

AddEventHandler('playerDropped', function()
    local playerId = source
    for k, v in pairs(current_players) do
        if v.ply_id == playerId then
            current_players[k] = nil
            break
        end
    end
end)

FSN.GetPlayerFromId = function(playerId)
    for _, ply in pairs(current_players) do
        if ply.ply_id == playerId then
            return ply
        end
    end
    return nil
end

-- Legacy util helpers
local Util = {}
_G.Util = Util

function Util.SplitString(inputstr, sep)
    sep = sep or "%s"
    local t = {}
    local i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function Util.GetSteamID(src)
    local id = GetPlayerIdentifiers(src)[1]
    if not id or not string.find(id, 'steam') then
        DropPlayer(src, 'ERR: Steam does not seem to be running')
    end
    return id
end

function Util.MakeString(length)
    if length < 1 then return nil end
    local str = ""
    for _ = 1, length do
        str = str .. math.random(32, 126)
    end
    return str
end

return FSN
