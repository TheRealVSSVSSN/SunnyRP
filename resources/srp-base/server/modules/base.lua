SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.Base = {}

local memory = SRP.SQL.memory

--[[
    -- Type: Function
    -- Name: nodeUrl
    -- Use: Build Node service URL
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function nodeUrl(path)
  local port = GetConvar('srp_node_port', '4000')
  return ('http://127.0.0.1:%s%s'):format(port, path)
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersList
    -- Use: List characters for an account
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersList(accountId)
  if not SRP.Failover.active() then
    local res = SRP.Http.get(nodeUrl(('/v1/accounts/%s/characters'):format(accountId)))
    if res.status == 200 then
      local body = json.decode(res.body or '{}')
      return body.characters or {}
    end
  end
  local acc = memory.accounts[accountId]
  return acc and acc.characters or {}
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersCreate
    -- Use: Create a character with failover support
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersCreate(accountId, data, idKey)
  if not SRP.Failover.active() then
    local res = SRP.Http.post(nodeUrl(('/v1/accounts/%s/characters'):format(accountId)), data, { ['Idempotency-Key'] = idKey })
    if res.status == 201 then
      return json.decode(res.body or '{}')
    end
  end
  local acc = memory.accounts[accountId] or { characters = {}, seq = 1, selected = nil }
  local id = tostring(acc.seq)
  acc.seq = acc.seq + 1
  local char = { id = id, firstName = data.firstName, lastName = data.lastName }
  acc.characters[#acc.characters + 1] = char
  memory.accounts[accountId] = acc
  SRP.SQL.execute('INSERT INTO srp_characters (id, account_id, first_name, last_name) VALUES (@id, @acc, @fn, @ln)', {
    ['@id'] = id,
    ['@acc'] = accountId,
    ['@fn'] = data.firstName,
    ['@ln'] = data.lastName
  })
  SRP.Failover.enqueue(function()
    local r = SRP.Http.post(nodeUrl(('/v1/accounts/%s/characters'):format(accountId)), data, { ['Idempotency-Key'] = idKey })
    return r.status >= 200 and r.status < 300
  end)
  return char
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersSelect
    -- Use: Select an existing character
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersSelect(accountId, characterId, idKey)
  if not SRP.Failover.active() then
    local res = SRP.Http.post(nodeUrl(('/v1/accounts/%s/characters/%s/select'):format(accountId, characterId)), {}, { ['Idempotency-Key'] = idKey })
    if res.status == 200 then
      return json.decode(res.body or '{}')
    end
  end
  local acc = memory.accounts[accountId]
  if not acc then return nil end
  for _, c in ipairs(acc.characters) do
    if c.id == characterId then
      acc.selected = characterId
      return c
    end
  end
  return nil
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersDelete
    -- Use: Delete a character
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersDelete(accountId, characterId, idKey)
  if not SRP.Failover.active() then
    local res = SRP.Http.requestExSync({ url = nodeUrl(('/v1/accounts/%s/characters/%s'):format(accountId, characterId)), method = 'DELETE', headers = { ['Idempotency-Key'] = idKey } })
    if res.status == 204 then return true end
  end
  local acc = memory.accounts[accountId]
  if not acc then return false end
  for i, c in ipairs(acc.characters) do
    if c.id == characterId then
      table.remove(acc.characters, i)
      if acc.selected == characterId then acc.selected = nil end
      SRP.SQL.execute('DELETE FROM srp_characters WHERE id=@id', { ['@id'] = characterId })
      SRP.Failover.enqueue(function()
        local r = SRP.Http.requestExSync({ url = nodeUrl(('/v1/accounts/%s/characters/%s'):format(accountId, characterId)), method = 'DELETE', headers = { ['Idempotency-Key'] = idKey } })
        return r.status == 204
      end)
      return true
    end
  end
  return false
end
