
local String = {};

String.split = function(str, sep, rawSep)
    local result = {};

    if not sep then
        sep = ".";
        rawSep = true;
    end
    if sep == "%s" then
        rawSep = nil;
    end

    local rawSep = rawSep and sep or "([^" .. sep .. "]+)";
    local insert = table.insert;

    for match in str:gmatch(rawSep) do
        result[#result + 1] = match;
    end

    return result;
end

String.startsWith = function(str, search)
    return str:sub(1, #search) == search;
end

String.endsWith = function(str, search)
    local len = #str;
    local searchLen = #search;

    return str:sub(len - searchLen + 1, len) == search;
end

return String;