
local Natives = {};
local vantostring = tostring;

tostring = function(value)
    value = value == nil and "nil" or value;

    return vantostring(value);
end

Natives.tstr = tostring;

setmetatable(table, {
    __call = function(self, fnType)
        if fnType == true then return self.insert, self.unpack; end

        return self.insert, self.remove, self.sort, self.pack, self.unpack;
    end
});

local insert, unpack = table(true);

local setmt = setmetatable;

setmetatable = function(self, mt)
    setmt(self, mt);

    return self, mt;
end

vantype = type;

Natives.type = function(value, count)
    local key = vantype(value);
    if count == nil then return key; end

    local countType = vantype(count);

    if countType == "string" then
        return key == count;
    end

    if countType == "number" then
        local results = {};

        local default = function()
            local defaults = {
                ["string"] = "",
                ["number"] = 0,
                ["boolean"] = false,
                ["table"] = {},
                ["function"] = function() end,
                ["thread"] = { thread = true },
                ["userdata"] = { userdata = true },
            };
    
            return defaults[key];
        end
    
        for i = 1, count do
            results[#results + 1] = default();
        end
    
        return unpack(results);
    end
end

type = Natives.type;

local rg, rs = rawget, rawset;

rawget = function(self, ...)
    local keys, results = { ... }, {};

    if #keys == 0 then return; end
    if #keys == 1 then return rg(self, ...); end

    for _, key in pairs(keys) do
        insert(results, rg(self, v));
    end

    return unpack(results);
end

rawset = function(self, ...)
    local keyvals, results = { ... }, {};

    if #keyvals == 0 then return; end
    if #keyvals == 2 then return rs(self, ...); end

    local key, value = nil, nil;

    for i, keyval in pairs(keyvals) do
        if i % 2 == 0 then
            key = keyval;
        else value = keyval; end

        if key and value then
            rs(self, key, value);

            key, value = nil, nil;
        end
    end

    return unpack(results);
end

return Natives;