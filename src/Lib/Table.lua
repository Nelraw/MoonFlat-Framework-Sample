
local Table = {};

Table.has = function(tab, value)
    for k, v in pairs(tab) do
        if v == value then
            return v, k;
        end
    end
end

Table.find = function(tab, callback, key)
    if type(callback) ~= "function" then
        local value = callback;

        callback = function(v, k)
            if type(v) == "table" then
                return key ~= nil
                    and v[key] == value
                    or v == value;
            end

            return key ~= nil and
                (k == key and v == value)
                or v == value;
        end
    end

    for k, v in pairs(tab) do
        local result = callback(v, k, tab);

        if result then return v, k; end
    end
end

Table.filter = function(tab, callback, key)
    local result = {};

    if type(callback) ~= "function" then
        local value = callback;

        callback = function(v, k)
            return key ~= nil and
                (k == key and v == value)
                or v == value;
        end
    end

    for k, v in pairs(tab) do
        if callback(v, k, tab) then
            result[#result + 1] = v;
        end
    end

    return result;
end

Table.fetch = function(tab, search, many)
    local function resolve(obj, callback)
        return many and Table.filter(obj, callback)
            or Table.find(obj, callback);
    end

    if type(search) ~= "table" then
        return resolve(tab, search);
    else
        local callback = function(obj)
            local i, j = 0, 0;

            for k, v in pairs(search) do
                i = i + 1;
                
                if obj[k] == v then j = j + 1; end
            end
    
            return i == j;
        end

        return resolve(tab, callback);
    end
end

Table.merge = function(x, y)
    x, y = x or {}, y or {};

    for k, v in pairs(y) do x[k] = y[k]; end
    return x;
end

Table.address = function(tab)
    local str = tostring(tab);

    return str:sub(8, str:len());
end

table.type = function(tab)
    local result = nil;

    for k, v in pairs(tab) do
        result = type(k) == "number"
            and "array"
            or "object";

        break;
    end

    return result == nil
        and "table" or result;
end

return Table;