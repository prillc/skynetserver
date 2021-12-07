local skynet = require "skynet"
local socket = require "skynet.socket"
local agentmgr = require "agentmgr"
local json = require "json"
require("globalfunc")

local CMD = {}
local SOCKET = {}
-- 网关服务
local gate
-- 登录服务器
local loginservice
-- 已经认证的fds
local authed_fds = {}

function close_agent(fd)
    local a = authed_fds[fd]
    if not a then
        return
    end
    skynet.call(a, "lua", "clear_state")
    agentmgr.set_free(a)
end

function SOCKET.open(fd, addr)
    skynet.error("New client from : " .. addr)
    skynet.call(gate, "lua", "accept", fd)
end

function SOCKET.close(fd)
    print("socket close", fd)
end

function SOCKET.error(fd, msg)
    print("socket error", fd, msg)
end

function SOCKET.warning(fd, size)
    -- size K bytes havn't send out in fd
    print("socket warning", fd, size)
end

function SOCKET.data(fd, msg)
    skynet.error(string.format("recv data, fd: %d, msg: %d", fd, #msg))
    -- watchdog做一个数据的认证
    local data = json.decode(msg)
    dump(data, "REQUEST:")
    if not authed_fds[fd] and data.a ~= "auth.login" then
        skynet.error("unauthed fd: ", fd)
        skynet.call(gate, "lua", "kick", fd)
        return
    end
    skynet.call(loginservice, "lua", "login", fd, data.d.uid)
end

function CMD.start(conf)
    loginservice = conf.loginservice
    skynet.call(gate, "lua", "open", conf)
end

function CMD.close(fd)
    close_agent(fd)
end

function CMD.login_success(fd, uid)
    skynet.error("login success", fd, uid)
    local a = agentmgr.pop()
    authed_fds[fd] = uid
    skynet.call(a, "lua", "init_state", fd, uid)
    -- 交给agent处理消息
    skynet.call(gate, "lua", "forward", fd, nil, a)
end

skynet.start(
    function()
        skynet.dispatch(
            "lua",
            function(session, source, cmd, subcmd, ...)
                if cmd == "socket" then
                    -- socket api don't need return
                    local f = SOCKET[subcmd]
                    f(...)
                else
                    local f = assert(CMD[cmd])
                    skynet.ret(skynet.pack(f(subcmd, ...)))
                end
            end
        )

        gate = skynet.newservice("gate")
        -- 预加载一些agent
        agentmgr.conf = {
            watchdog = skynet.self(),
            gate = gate
        }
        agentmgr.precreate_agetns(10)
    end
)
