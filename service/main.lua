local skynet = require "skynet"
local sharetable = require("skynet.sharetable")
require("skynet.manager")
require("globalfunc")

skynet.start(
    function()
        print("...main...")
        skynet.uniqueservice("debug_console", 8001)
        -- 登录服务器
        local loginservice = skynet.uniqueservice("login")

        local watchdog = skynet.newservice("watchdog")
        skynet.call(
            watchdog,
            "lua",
            "start",
            {
                port = 6666,
                nodelay = true,
                loginservice = loginservice
            }
        )
    end
)
