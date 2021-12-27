function dump(value, desciption, nesting)
    if type(nesting) ~= "number" then
        nesting = 10
    end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = '"' .. v .. '"'
        end
        return tostring(v)
    end

    -- local traceback = string.split(debug.traceback("", 2), "\n")
    -- result[#result+1] = "dump from: " .. string.trim(traceback[3])

    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if type(value) ~= "table" then
            result[#result + 1] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result + 1] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result + 1] = string.format("%s%s = *MAX NESTING*", indent, tostring(desciption))
            else
                result[#result + 1] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent .. "    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then
                        keylen = vkl
                    end
                    values[k] = v
                end
                table.sort(
                    keys,
                    function(a, b)
                        if type(a) == "number" and type(b) == "number" then
                            return a < b
                        else
                            return tostring(a) < tostring(b)
                        end
                    end
                )
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result + 1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)
    print(table.concat(result, "\n"))
end

-- 闭包函数，指定的函数第一个参数固定
function handler(obj, f)
    return function(...)
        return f(obj, ...)
    end
end

function table.pop(tb)
    if not tb or #tb == 0 then
        return nil
    end
    local length = #tb
    local r = tb[length]
    tb[length] = nil
    return r
end

function string.isempty(s)
    if not s or s == "" then
        return true
    end
    return false
end

function class(classname, super)
    local superType = type(super)
    local cls

    if superType ~= "function" and superType ~= "table" then
        superType = nil
        super = nil
    end

    if super then
        cls = {}
        setmetatable(cls, {__index = super})
        cls.super = super
    else
        cls = {
            ctor = function()
            end
        }
    end

    cls.__cname = classname
    cls.__index = cls

    function cls.new(...)
        local instance = setmetatable({}, cls)
        instance.class = cls
        instance:ctor(...)
        return instance
    end

    return cls
end
