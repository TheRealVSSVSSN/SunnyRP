-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

function LoadUser(identifier, source, new)
        local result = MySQL.Sync.fetchAll("SELECT permission_level, money, identifier, `group` FROM users WHERE identifier = @name", {['@name'] = identifier})

	local group = groups[result[1].group]
	Users[source] = Player(source, result[1].permission_level, result[1].money, result[1].identifier, group)

        TriggerEvent('es:playerLoaded', source, Users[source])

        if settings.defaultSettings.enableRankDecorators then
                TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
        end

        if new then
                TriggerEvent('es:newPlayerLoaded', source, Users[source])
        end
end

function isIdentifierBanned(id)
        local result = MySQL.Sync.fetchAll("SELECT expires, reason, timestamp FROM bans WHERE banned = @name", {['@name'] = id})
        for _,v in ipairs(result) do
                if v.expires > v.timestamp then
                        return true
                end
        end
        return false
end

AddEventHandler('es:getPlayers', function(cb)
        cb(Users)
end)

function hasAccount(identifier)
        local exists = MySQL.Sync.fetchScalar("SELECT 1 FROM users WHERE identifier = @name", {['@name'] = identifier})
        return exists ~= nil
end



function registerUser(identifier, source)
        if not hasAccount(identifier) then
                MySQL.Sync.execute("INSERT INTO users (`identifier`, `permission_level`, `money`, `group`) VALUES (@username, 0, @money, 'user')",
                {['@username'] = identifier, ['@money'] = settings.defaultSettings.startingCash})
                LoadUser(identifier, source, true)
        else
                LoadUser(identifier, source)
        end
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
	if(Users[user])then
		if(Users[user][k])then

                        if(k ~= "money") then
                                Users[user][k] = v
                                MySQL.Sync.execute("UPDATE users SET `"..k.."`=@value WHERE identifier=@identifier", {['@value'] = v, ['@identifier'] = Users[user]['identifier']})
                        end

			if(k == "group")then
				Users[user].group = groups[v]
			end

			cb("Player data edited.", true)
		else
			cb("Column does not exist!", false)
		end
	else
		cb("User could not be found!", false)
	end
end)

AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
        MySQL.Sync.execute("UPDATE users SET `"..k.."`=@value WHERE identifier=@identifier", {['@value'] = v, ['@identifier'] = user})
        cb("Player data edited.", true)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
        local result = MySQL.Sync.fetchAll("SELECT permission_level, money, identifier, `group` FROM users WHERE identifier = @name", {['@name'] = identifier})
        cb(result[1])
end)

AddEventHandler("es:getAllPlayers", function(cb)
        local result = MySQL.Sync.fetchAll("SELECT permission_level, money, identifier, `group` FROM users", {})
        cb(result)
end)

-- Function to update player money every 60 seconds.
local function savePlayerMoney()
	SetTimeout(60000, function()
		TriggerEvent("es:getPlayers", function(users)
			for k,v in pairs(users)do
                                MySQL.Sync.execute("UPDATE users SET `money`=@value WHERE identifier=@identifier", {['@value'] = v.money, ['@identifier'] = v.identifier})
			end
		end)

		savePlayerMoney()
	end)
end

savePlayerMoney()

