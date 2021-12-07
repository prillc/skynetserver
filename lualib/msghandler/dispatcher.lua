local skynet = require("skynet")
local M = {
    _handlers = {}
}

function M.register(name, handler)
    assert(not M._handlers[name], string.format("Duplicate register handler: %s", name))
    M._handlers[name] = handler
end

function M.dispatch(name, ...)
    local f = assert(M._handlers[name], string.format("Unregister handler: %s", name))
    return f(...)
end

skynet.init(
    function()
        local files = {"auth"}
        for _, file in ipairs(files) do
            for handlername, handler in pairs(require("msghandler." .. file)) do
                M.register(file .. "." .. handlername, handler)
            end
        end
    end
)

return M
