local TestHandler = {}

function TestHandler.ping()
    return {
        a = "ping",
        d = {
            msg = "pong",
            timestmap = os.time()
        }
    }
end

function TestHandler.t()
    return {
        a = "t",
        d = {
            timestmap = os.time()
        }
    }
end

return TestHandler
