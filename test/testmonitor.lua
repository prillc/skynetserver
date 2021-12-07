local skynet = require "skynet"
require("skynet.manager")

local CMD = {}
function CMD.ping()
    return "ping"
end

skynet.start(
    function()
        print("...main...")
        -- local monitor = skynet.monitor("simplemonitor")
        -- skynet.call(monitor, "lua", "WATCH", skynet.self())
        skynet.dispatch(
            "lua",
            function(_, address, cmd, ...)
                print("add", _, address, cmd, ...)
                skynet.ret(skynet.pack(CMD[cmd](...)))
            end
        )
    end
)
