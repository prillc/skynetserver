root = "./skynet/"
--  启动多少个工作线程。通常不要将它配置超过你实际拥有的 CPU 核心数
thread = 8
-- 决定了 skynet 内建的 skynet_error 这个 C API 将信息输出到什么文件中。如果 logger 配置为 nil ，将输出到标准输出。你可以配置一个文件名来将信息记录在特定文件中
logger = nil
-- 可以是 1-255 间的任意整数。一个 skynet 网络最多支持 255 个节点。每个节点有必须有一个唯一的编号
harbor = 0
-- 这是 bootstrap 最后一个环节将启动的 lua 服务，也就是你定制的 skynet 节点的主程序。默认为 main ，即启动 main.lua 这个脚本。这个 lua 服务的路径由下面的 luaservice 指定
start = "main" -- main script
-- skynet 启动的第一个服务以及其启动参数。默认配置为 snlua bootstrap ，即启动一个名为 bootstrap 的 lua 服务。通常指的是 service/bootstrap.lua 这段代码
bootstrap = "snlua bootstrap"

-- 用 C 编写的服务模块的位置，通常指 cservice 下那些 .so 文件。如果你的系统的动态库不是以 .so 为后缀，需要做相应的修改。这个路径可以配置多项，以 ; 分割
cpath = root .. "cservice/?.so;"
-- lua 服务代码所在的位置。可以配置多项，以 ; 分割
luaservice = root .. "service/?.lua;" .. root .. "examples/?.lua;"
-- luaservice = root .. "service/?.lua;"
lualoader = root .. "lualib/loader.lua"
preload = "./lualib/preload.lua"
lua_cpath = root .. "luaclib/?.so;"
lua_path = root .. "lualib/?.lua;" .. root .. "lualib/?/init.lua"
-- snax = root .. "examples/?.lua;" .. root .. "test/?.lua"

luaservice = "./service/?.lua;./service/?/main.lua;" .. luaservice
lua_path = "./lualib/?.lua;" .. lua_path
lua_cpath = "./luaclib/?.so;./luaclib/?.so;" .. lua_cpath
