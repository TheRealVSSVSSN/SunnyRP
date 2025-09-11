function SplitString(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function print_table(node)
    -- to make output beautiful
    local function tab(amt)
        local str = ""
        for i=1,amt do
            str = str .. "\t"
        end
        return str
    end

    local cache, stack, output = {},{},{}
    local depth = 1
    local output_str = "{\n"

    while true do
        local size = 0
        for k,v in pairs(node) do
            size = size + 1
        end

        local cur_index = 1
        for k,v in pairs(node) do
            if (cache[node] == nil) or (cur_index >= cache[node]) then

                if (string.find(output_str,"}",output_str:len())) then
                    output_str = output_str .. ",\n"
                elseif not (string.find(output_str,"\n",output_str:len())) then
                    output_str = output_str .. "\n"
                end

                -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
                table.insert(output,output_str)
                output_str = ""

                local key
                if (type(k) == "number" or type(k) == "boolean") then
                    key = "["..tostring(k).."]"
                else
                    key = "['"..tostring(k).."']"
                end

                if (type(v) == "number" or type(v) == "boolean") then
                    output_str = output_str .. tab(depth) .. key .. " = "..tostring(v)
                elseif (type(v) == "table") then
                    output_str = output_str .. tab(depth) .. key .. " = {\n"
                    table.insert(stack,node)
                    table.insert(stack,v)
                    cache[node] = cur_index+1
                    break
                else
                    output_str = output_str .. tab(depth) .. key .. " = '"..tostring(v).."'"
                end

                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                else
                    output_str = output_str .. ","
                end
            else
                -- close the table
                if (cur_index == size) then
                    output_str = output_str .. "\n" .. tab(depth-1) .. "}"
                end
            end

            cur_index = cur_index + 1
        end

        if (size == 0) then
            output_str = output_str .. "\n" .. tab(depth-1) .. "}"
        end

        if (#stack > 0) then
            node = stack[#stack]
            stack[#stack] = nil
            depth = cache[node] == nil and depth + 1 or depth - 1
        else
            break
        end
    end

    -- This is necessary for working with HUGE tables otherwise we run out of memory using concat on huge strings
    table.insert(output,output_str)
    output_str = table.concat(output)

    print(output_str)
end

function checkBan(source, setKickReason)
        local src = source
        updateIdentifiers(src)
        for _, identifier in pairs(GetPlayerIdentifiers(src)) do
                local check = MySQL.query.await('SELECT * FROM fsn_bans WHERE ban_identifier = @identifier', {
                        ['@identifier'] = identifier
                })
                if check[1] then
                        if check[1].ban_expire >= os.time() or check[1].ban_expire == -1 then
                                local reason
                                if check[1].ban_expire == -1 then
                                        print((':fsn_main: (sv_bans.lua) - Player(%s) is PERM banned, Identifier(%s) - dropping player.'):format(src, identifier))
                                        reason = ':FSN: You are banned from Fusion Roleplay. \n\nBanID: '..check[1].ban_id..'\nReason: '..check[1].ban_reason..'\nExpires: Never\n\nAppeal this ban @ fsn.life/forums\n\n'
                                else
                                        print((':fsn_main: (sv_bans.lua) - Player(%s) is banned until Date(%s), Identifier(%s) - dropping player.'):format(src, check[1].ban_expire, identifier))
                                        reason = ':FSN: You are banned from Fusion Roleplay. \n\nBanID: '..check[1].ban_id..'\nReason: '..check[1].ban_reason..'\nExpires: '..check[1].ban_expire..'\n\nAppeal this ban @ fsn.life/forums\n\n'
                                end
                                DropPlayer(src, reason)
                                if setKickReason then
                                        setKickReason(reason)
                                end
                                CancelEvent()
                        end
                end
        end
end

function updateIdentifiers(src)
	
        local steamid = GetPlayerIdentifiers(src)[1]
        if not steamid then
                print('trying to update identifiers for player('..src..') failed')
                return
        else
                print(':fsn_main: (sv_bans.lua) Updating identifiers for Player('..src..') with SteamID('..steamid..')')
        end
        local sql = MySQL.query.await('SELECT * FROM fsn_users WHERE steamid = @steamid', {
                ['@steamid'] = steamid
        })
        if sql[1] then
                local myIdentifiers = sql[1].identifiers
                if myIdentifiers then
                        myIdentifiers = json.decode(myIdentifiers)
                else
                        myIdentifiers = {}
                end
                for _, v in pairs(GetPlayerIdentifiers(src)) do
                        local split = SplitString(v, ':')
                        local iType = split[1]
                        myIdentifiers[iType] = myIdentifiers[iType] or {}
                        local exists = false
                        for _, value in pairs(myIdentifiers[iType]) do
                                if value == v then
                                        exists = true
                                        break
                                end
                        end
                        if not exists then
                                table.insert(myIdentifiers[iType], v)
                        end
                end
                local update = json.encode(myIdentifiers)
                MySQL.update.await('UPDATE fsn_users SET identifiers = @ids WHERE user_id = @id', {
                        ['@ids'] = update,
                        ['@id'] = sql[1].user_id
                })
        end

end

--AddEventHandler("playerConnecting", checkBan)
