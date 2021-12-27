local json = require "json"
local processer = {}

function processer.decode(msg)
    return json.decode(msg)
end

function processer.encode(data)
    local buff = json.encode(data)
    return string.pack(">Hs2", #buff, buff)
end

return processer
