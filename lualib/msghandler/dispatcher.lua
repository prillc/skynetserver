local skynet = require("skynet")

local Dispacther = {
    _handlers = {}
}

function Dispacther.register(name, handler)
    assert(not Dispacther._handlers[name], string.format("Duplicate register handler: %s", name))
    Dispacther._handlers[name] = handler
end

function Dispacther.dispatch(name, ...)
    local f = assert(Dispacther._handlers[name], string.format("Unregister handler: %s", name))
    return f(...)
end

skynet.init(
    function()
        local files = {"test"}
        for _, file in ipairs(files) do
            for handlername, handler in pairs(require("msghandler." .. file)) do
                Dispacther.register(file .. "." .. handlername, handler)
            end
        end
    end
)

return Dispacther
