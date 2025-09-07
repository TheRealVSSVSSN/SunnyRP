SRP = SRP or {}
SRP.Modules = SRP.Modules or {}
SRP.Modules.Base = {}

local accounts = {}

--[[
    -- Type: Function
    -- Name: getAccount
    -- Use: Retrieve or init account cache
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
local function getAccount(id)
  if not accounts[id] then accounts[id] = { seq = 1, characters = {}, selected = nil } end
  return accounts[id]
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersList
    -- Use: List characters for an account
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersList(accountId)
  return getAccount(accountId).characters
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersCreate
    -- Use: Create a new character
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersCreate(accountId, data, idem)
  local acc = getAccount(accountId)
  local char = { id = tostring(acc.seq), firstName = data.firstName, lastName = data.lastName }
  acc.seq = acc.seq + 1
  acc.characters[#acc.characters + 1] = char
  if SRP.Failover.active() then
    SRP.SQL.execute('INSERT INTO srp_characters (id, account_id, first_name, last_name) VALUES (@id,@acc,@fn,@ln)', { ['@id'] = char.id, ['@acc'] = accountId, ['@fn'] = data.firstName, ['@ln'] = data.lastName })
    SRP.Failover.enqueue(function()
      local env = {
        id = idem,
        type = 'srp.base.characters.create',
        source = 'srp-base',
        subject = accountId,
        time = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        specversion = '1.0',
        data = { accountId = accountId, data = data }
      }
      local url = ('http://127.0.0.1:%s/internal/srp/rpc'):format(GetConvar('srp_node_port', '4000'))
      local res = SRP.Http.post(url, env)
      return res.status == 200
    end)
  end
  return char
end

--[[
    -- Type: Function
    -- Name: SRP.Modules.Base.charactersSelect
    -- Use: Select a character for an account
    -- Created: 2025-02-14
    -- By: VSSVSSN
--]]
function SRP.Modules.Base.charactersSelect(accountId, characterId)
  local acc = getAccount(accountId)
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
function SRP.Modules.Base.charactersDelete(accountId, characterId)
  local acc = getAccount(accountId)
  for i, c in ipairs(acc.characters) do
    if c.id == characterId then
      table.remove(acc.characters, i)
      if SRP.Failover.active() then
        SRP.SQL.execute('DELETE FROM srp_characters WHERE id=@id', { ['@id'] = characterId })
        SRP.Failover.enqueue(function()
          local env = {
            id = 'evt_' .. characterId,
            type = 'srp.base.characters.delete',
            source = 'srp-base',
            subject = accountId,
            time = os.date('!%Y-%m-%dT%H:%M:%SZ'),
            specversion = '1.0',
            data = { accountId = accountId, characterId = characterId }
          }
          local url = ('http://127.0.0.1:%s/internal/srp/rpc'):format(GetConvar('srp_node_port', '4000'))
          local res = SRP.Http.post(url, env)
          return res.status == 200
        end)
      end
      return true
    end
  end
  return false
end
