local Pool = class("Pool")

function Pool:ctor(poolfactory, size)
    size = size or 10
    assert(type(poolfactory) == "function", "Pool factory function required!")
    assert(size > 0, "Invalid pool size, >= 1 required!")
    -- 工厂
    self.poolfactory = poolfactory
    -- 可以使用的代理 key表示agentid，value任意值
    self._pool = {}
    -- 总的数量
    self.count = 0

    -- 初始化池子
    self:_init_pool(size)
end

function Pool:_newmember()
    local member = self.poolfactory()
    self.count = self.count + 1
    return member
end

function Pool:_init_pool(size)
    for i = 1, size, 1 do
        table.insert(self._pool, self:_newmember())
    end
end

function Pool:get()
    local member
    if #self._pool > 0 then
        member = table.pop(self._pool)
    else
        member = self._newmember()
    end
    return member
end

function Pool:set(member)
    -- 回收一个对象
    table.insert(self._pool, member)
end

function Pool:clear()
end

return Pool
