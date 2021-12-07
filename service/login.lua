local skynet = require "skynet"
local authhandler = require("msghandler.auth")

local CMD = {}
function CMD.login(source, fd, uid)
    local userdata = authhandler.login(uid)
    if not userdata then
        print("登录失败")
    else
        print("登录成功")
        skynet.call(source, "lua", "login_success", fd, uid)
    end
end

skynet.start(
    function()
        skynet.dispatch(
            "lua",
            function(_, address, cmd, ...)
                skynet.ret(skynet.pack(CMD[cmd](address, ...)))
            end
        )
    end
)
