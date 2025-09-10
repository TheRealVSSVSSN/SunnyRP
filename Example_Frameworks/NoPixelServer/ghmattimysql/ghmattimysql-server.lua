local function safeParameters(parameters)
  return parameters or {}
end

local function awaitSql(cb)
  local p = promise.new()
  cb(p)
  return Citizen.Await(p)
end

exports('executeSync', function(query, parameters)
  return awaitSql(function(p)
    exports.ghmattimysql:execute(query, safeParameters(parameters), function(result)
      p:resolve(result)
    end, GetInvokingResource())
  end)
end)

exports('scalarSync', function(query, parameters)
  return awaitSql(function(p)
    exports.ghmattimysql:scalar(query, safeParameters(parameters), function(result)
      p:resolve(result)
    end, GetInvokingResource())
  end)
end)

exports('transactionSync', function(queries, parameters)
  return awaitSql(function(p)
    exports.ghmattimysql:transaction(queries, safeParameters(parameters), function(result)
      p:resolve(result)
    end, GetInvokingResource())
  end)
end)

exports('storeSync', function(query)
  return awaitSql(function(p)
    exports.ghmattimysql:store(query, function(result)
      p:resolve(result)
    end, GetInvokingResource())
  end)
end)
