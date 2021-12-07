local M = {}

function M.login(uid)
    if uid == 1 then
        return {
            name = "zhangsan",
            level = 1,
            exp = 123
        }
    end
    return nil
end

function M.ping()
    return "pong"
end

return M
