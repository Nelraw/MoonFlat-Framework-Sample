
local Array = Prototype("Array");

Array:__meta__().__call = function(self, tab)
    return Array:new(tab);
end

function Array:__new__(tab)
    local new, meta = self:__super__();
    new.value = tab or {};

    meta.__len = function()
        return #new.value;
    end

    meta.__index = function(_, key)
        if type(key) == "string" then
            local got = rawget(new, key);
            if got then return got; end

            return Array[key];
        end

        return new.value[key];
    end

    meta.__newindex = function(_, key, value)
        new.value[key] = value;
    end

    return new, meta;
end

local function search(data)
    local callback = nil;

    if type(data) == "table" then
        callback = function(object, index)
            local count, result = 0, 0;

            if type(object) == "table" then
                for k, v in pairs(data) do
                    if type(k) == "number" then break; end

                    count = count + 1;

                    if object[k] and object[k] == v then
                        result = result + 1;
                    end
                end
            end

            return result == count;
        end
    elseif type(data) ~= "function" then
        local value = data;

        callback = function(v, k)
            return v == value;
        end
    end

    return callback or data;
end

function Array:find(callback)
    callback = search(callback);

    for i = 1, #self.value do
        local result = callback(self.value[i], i, self.value);

        if result then return self.value[i], i; end
    end
end

function Array:filter(callback)
    local result = {};
    callback = search(callback);

    for i = 1, #self.value do
        if callback(self.value[i], i, self.value) then
            result[#result + 1] = self.value[i];
        end
    end

    return Array:new(result);
end

function Array:indexOf(data)
    local _, index = self:find(data);

    return index;
end

function Array:concat(tab)
    for i = 1, #tab do
        self.value[#self.value + 1] = tab[i];
    end

    return self;
end

function Array:sort(callback)
    local sort = table.sort;

    sort(self.value, callback);
    return self;
end

function Array:push(data, i)
    local index = i or (#self.value + 1);

    self.value[index] = data;
    
    return data;
end

function Array:single(data)
    for i = 1, #self.value do
        if self.value[i] == data then
            return;
        end
    end

    return self:push(data);
end

function Array:remove(search)
    local remove = table.remove;

    if type(search) ~= "number" then
        search = self:indexOf(search);
    end

    if search then
        remove(self.value, search);

        return self;
    end
end

function Array:pop()
    local len = #self.value;
    local last = self.value[len];

    self:remove(len)

    return last;
end

function Array:shift()
    local first = self.value[1];

    self:remove(1);
    return first;
end

return Array;