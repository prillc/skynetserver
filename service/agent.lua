local skynet = require "skynet"
local socket = require("skynet.socket")
local json = require "json"
local handlerdispathcer = require("msghandler.dispatcher")
local watchdog
local gate
local agentstate = {
    -- 文件句柄
    fd = nil,
    uid = nil
}

skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
    unpack = function(msg, sz)
        return json.decode(skynet.tostring(msg, sz))
    end,
    dispatch = function(fd, _, data)
        assert(fd == agentstate.fd) -- You can use fd to reply message
        skynet.ignoreret() -- session is fd, don't call skynet.ret
        data.fd = fd
        data.agent = skynet.self()
        dump(data, "AGENT REQUEST: ")
        local ret = handlerdispathcer.dispatch(data.a, data)
        if ret then
            local buff = json.encode(ret)
            socket.write(fd, string.pack(">Hs2", #buff, buff))
        end
    end
}

local CMD = {}
function CMD.init(conf)
    watchdog = conf.watchdog
    gate = conf.gate
end

function CMD.init_state(fd, uid)
    agentstate.fd = fd
    agentstate.uid = uid
end

function CMD.clear_state()
    skynet.error(string.format("Cleart agent state, fd=%d, uid=%s.", agentstate.fd, agentstate.uid))
    agentstate.fd = nil
    agentstate.uid = nil
end

skynet.start(
    function()
        skynet.dispatch(
            "lua",
            function(_, address, cmd, ...)
                skynet.ret(skynet.pack(CMD[cmd](...)))
            end
        )
    end
)
