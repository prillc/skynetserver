local skynet = require "skynet"
local sharetable = require("skynet.sharetable")
local json = require("json")

local path = "static_data/"
local CMD = {}

function CMD.loadfile()
    for _, name in ipairs({"test.lua"}) do
        print("loadfile: " .. name)
        sharetable.loadfile(path .. name)
        dump(sharetable.query(path .. name))
    end
end

function CMD.query(fielname)
    return sharetable.query(path .. fielname)
end

skynet.start(function()
    skynet.dispatch("lua", function(_, address, cmd, ...)
        local f = CMD[cmd]
        print(address, cmd, ..., f)
        if f then
            skynet.ret(skynet.pack(json.encode(f(...))))
        end
    end)
    CMD.loadfile()
end)
