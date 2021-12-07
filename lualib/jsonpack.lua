local json = require("json")

local M = {}

function M.pack(data)
    local buff = json.encode(data)
    local len = 2 + 2 + #buff
    return string.pack(">Hs2", len, buff)
end

function M.unpack(buff)
    -- string.unpack(">s2s2")
    -- 2字节表示路由长度 + 路由名称 2字节表示消息体长度 + 消息体
    return json.decode(buff)
end

return M
