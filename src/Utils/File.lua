
local Json = MoonFlat:import("Utils.Json");
local File = Prototype("File");

function File:__new__(path)
    local new, meta = self:__super__();
    
    new.path = path;
    new.json = path:endsWith(".json");

    return new, meta;
end

function File:exist()
    local glb = global;

    return glb:fileExists(self.path);
end

function File:error(mode, msg)
    local modeStr = mode == "r"
        and "File opening error"
        or "File writing error"

    print:red("");
    print:error(modeStr .. ":");
    print:error(self.path);
    print:error(msg);
    print:red("");
end

function File:open()
    local status, result = pcall(function()
        local path = self.path;
        local file = io.open(path, "r");
        
        local content = file:read("*a");
        file:close();

        return self.json
            and Json.decode(content)
            or content;
    end);

    if status == false then
        return self:error("r", result);
    end

    return result;
end

function File:write(data)
    local mode = "w";

    local status, result = pcall(function()
        local path = self.path;
        local file = io.open(path, "w");

        if Lib.instanceOf(data, "Array") then
            data = data.value;
        end

        data = self.json
            and Json.encode(data)
            or data;

        file:write(data);
        file:close();
    end);

    return not status
        and self:error("w", result)
        or true;
end

function File:load()
    if not self.path:endsWith(".lua") then
        return;
    end

    return dofile(self.path);
end

-- MoonFlat.openFile = function(path)
--     local status, result = pcall(function()
--         if global:fileExists(path) then
--             local file = io.open(path, "r");
            
--             if file then
--                 local content = file:read("*a");
--                 file:close();

--                 return path:find(".json")
--                     and Json.decode(content) or content;
--             end
--         end
--     end);

--     return status == true and result;
-- end

-- MoonFlat.writeFile = function(path, data)
--     local status, result = pcall(function()
--         local file = io.open(path, "w");
        
--         data = path:find(".json")
--             and Json.encode(data) or data;

--         file:write(data);
--         file:close();

--         return true;
--     end)

--     return status == true and result or status, result;
-- end

-- MoonFlat.updateFile = function(callback, path)
--     if type(callback) ~= "function" then
--         return;
--     end	

--     local data = MoonFlat.openFile(path);

--     if type(data) == "string" then
--         data = callback(data);

--         if type(data) == "string" then
--             local written = MoonFlat.writeFile(path, data);

--             return written;
--         end
--     end
-- end
    
return File;