local skynet = require("skynet")
require("globalfunc")

local M = {
    conf = {
        gate = nil,
        watchdog = nil
    },
    -- 可以使用的代理 key表示agentid，value任意值
    agentpool = {},
    -- 已经使用的代理
    freeagents = {},
    -- 总的数量
    count = 0
}

function M.new_agent()
    local a = skynet.newservice("agent")
    M.agentpool[a] = true
    table.insert(M.freeagents, a)
    skynet.call(a, "lua", "init", M.conf)
    M.count = M.count + 1
    return a
end

function M.precreate_agetns(count)
    count = count or 500
    for _ = 1, count do
        M.new_agent()
    end
end

function M.pop()
    if not M.freeagents or #M.freeagents == 0 then
        M.new_agent()
    end
    return table.pop(M.freeagents)
end

function M.set_free(agentid)
    table.insert(M.freeagents, agentid)
end

return M
