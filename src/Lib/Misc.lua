
local Misc = {};

Misc.switch = function(operator, cases)
    cases = cases or {};

    if type(operator) == "function" then
        operator = operator();
    end

    local booleans = { true, false, nil };

    for i = 1, #booleans do
        if operator == booleans[i] then
            local bool = booleans[i];
            bool = bool == nil and "nil" or bool;

            operator = tostring(bool);
            break;
        end
    end

    return cases[operator or "default"];
end

Misc.rndm = function(first, second)
    first = first or 0
    second = second or 10^10

    return math.random(first, second)
end

Misc.tmpFile = function(code, callback)
    local path = os.tmpname() .. ".lua";
end

Misc.directory = function(path, ext)
    return global:getAllFilesNameInDirectory(path, ext);
end

Misc.request = function(method, url, data)
    local dev, unp = developer, table.unpack;

    local req = function()
        local headers = {
            { "Content-Type" },
            { "application/json" },
        };
    
        return method == "GET"
            and dev:getRequest(url, unp(headers))
            or dev:postRequest(url, data, unp(headers));
    end

    local status, result = pcall(req);

    if status then
        local  err = "System.Net.Http.HttpRequestException";
        
        if result:find(err) then
            global:printError("[ Erreur ] - Échec de la requête.");
            local info = "[ Info ] - " .. method:upper()
                .. " - " .. url;

            global:printMessage(info);
            if data then print(data); end

            return false;
        end;

        if #result > 0 then
            return Json and Json.decode(result);
        end
    end
end

Misc.instanceOf = function(object, name)
    return Prototype.__instanceOf__(object, name);
end

Misc.date = function()
    local date = os.date("*t");
    local days = {
        "Sunday", "Monday", "Tuesday", "Wednesday",
        "Thursday", "Friday", "Saturday"
    }

    date.wday = days[date.wday]:lower();

    return {
        day = date.day,
        month = date.month,
        year = date.year,
        hour = date.hour,
        minutes = date.min,
        seconds = date.sec,
        weekday = date.wday
    }
end

Misc.timestamp = function()
    return MoonFlat:import("Utils.Timestamp"):now();
end

Misc.thousand = function(value)
    local s = string.format("%d", math.floor(value))
	local pos = string.len(s) % 3
	if pos == 0 then 
        pos = 3
    end
    
	return string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos+1), "(...)", ".%1")
end

return Misc;