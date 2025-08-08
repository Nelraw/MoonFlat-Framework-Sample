
local Prototype = {
    __name__ = "Prototype",
};

setmetatable(Prototype, {
    __name = "Prototype",
    __proto = Prototype,
    __call = function(self, ...)
        return self:extend(...);
    end
});

function Prototype:__new__()
    local new, meta = new or {}, meta or {};

    meta.__index = self;
    meta.__name = self.__name__;

    setmetatable(new, meta);

    return new, meta;
end

function Prototype:__super__(...)
    local mt = getmetatable(self);
    if not mt then return new, meta; end

    local new, meta = {}, {};
    
    if mt and mt.__proto then
        local proto = mt.__proto;

        new, meta = proto:__new__(...);

        meta.__proto = self;
        meta.__index = self;

        meta.__name = mt.__name;
    end

    return new, meta;
end

function Prototype:__proto__()
    local mt = getmetatable(self);

    return mt and mt.__proto;
end

function Prototype:__instanceOf__(eq)
    if not self.__name__ then return false; end
    if self.__name__ == eq then return true; end

    return Prototype.__instanceOf__(self:__proto__(), eq);
end

function Prototype:__meta__(key)
    local mt = getmetatable(self);
    if not key then return mt; end

    return mt and mt["__" .. key]; 
end

function Prototype:__instance__(...)
    if not self.instance then
        self.instance = self:new(...);
    end

    return self.instance;
end

function Prototype:new(...)
    local new, meta = self:__new__(...);

    meta.__name = self.__name__;
    meta.__proto = self;
    meta.__object = new;

    meta.__index = meta.__index or self;

    return new, meta;
end

function Prototype:extend(name, builder, meta)
    builder, meta = builder or {}, meta or {};
    
    meta.__name = name;
    meta.__proto = self;
    meta.__index = meta.__index or self;

    builder.__name__ = name;
    setmetatable(builder, meta);

    return builder, meta;
end

return Prototype;