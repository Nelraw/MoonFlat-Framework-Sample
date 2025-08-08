
local Timestamp = Prototype("Timestamp", nil, {
    __call = function(self, key)
        return key and self:set(key) or self:now();
    end
});

function Timestamp:__new__()
    local new, meta = self:__super__();

    new.stamps = {};
    new:set();

    return new, meta;
end

function Timestamp:now()
    return math.floor(os.time() * 1000);
end

function Timestamp:fetch(key)
    return self.stamps[key or "main"];
end

function Timestamp:set(key, force)
    if not self:fetch(key) or force then
        local stamp = self:now();

        self.stamps[key or "main"] = stamp;

        return stamp;
    end
end

function Timestamp:delete(key)
    if self:fetch(key) then
        self.stamps[key or "main"] = nil;

        return true;
    end
end

function Timestamp:elapsed(key)
    local prev = self.stamps[key or "main"];

    if prev then return self:now() - prev; end
end

function Timestamp:reset(key)
    local stamp = self:fetch(key);

    if stamp then return self:set(key, true); end
end

function Timestamp:diff(y, x)
    if type(y) ~= "string" then
        return;
    end

    y = self:fetch(y);
    x = self:fetch(x);

    return y - x;
end

function Timestamp:hourglass(callback, ...)
    local start = self:now();
    local result = callback(...);
    local stop = self:now();

    return stop - start;
end

function Timestamp:stopwatch(fn, args, iterations)
    local total = 0;

    if not type(fn, "function") then return; end
    remove(fnargs, 1);

    for i = 1, iterations or 50 do
        local start = self:now();

        fn(args);

        local stop = self:now();
        total = total + (stop - start);
    end

    return total / iterations, total; 
end

return Timestamp;