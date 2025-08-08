

local Prototype = dofile(PATH .. "src\\Core\\Prototype.lua");
local Module = Prototype("Module");

local split = function(str, sep, rawSep)
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

function Module:__new__(path)
    local new, meta = self:__super__();

    new.path = path;
    new.modules = {};

    return new, meta;
end

function Module:load()
    return dofile(self:main());
end

function Module:main()
    local dir = self:directory();

    if dir then return self.path .. "__init__.lua"; end
    return self.path;
end

function Module:directory(name)
    if type(self) == "string" then
        return global:getAllFilesNameInDirectory(self);
    end

    local len = #self.path;
    
    if self.path:sub(len - 3, len) == ".lua" then
        return;
    end

    local result = {};
    local dir = global:getAllFilesNameInDirectory(self.path);

    for i = 1, #dir do
        local file = dir[i];

        if not file:find("__init__.lua") then
            result[#result + 1] = file;
        end
    end

    if not name then return result; end

    for i = 1, #result do
        if result[i]:sub(1, #name) == name then
            return result[i];
        end
    end
end

function Module:import(path)
    path = path:gsub("%.", "\\");
    
    local found = self:find(path);
    if found then return found; end
    
    local splitted = split(path, "\\");
    local tab, name = self.modules, splitted[#splitted];

    for i = 1, #splitted do
        if not tab[splitted[i]] then
            tab[splitted[i]] = {};
        end
        
        if i == #splitted then break; end
        tab = tab[splitted[i]];
    end
    
    local filePath = self.path .. path .. ".lua";
    
    if not global:fileExists(filePath) then
        path = path .. "\\__init__";
    end
    
    local module = dofile(self.path .. path .. ".lua");

    if module then
        tab[name] = module;
    end

    return module;
end

function Module:find(path)
    local splitted = split(path, "\\");
    local tab = self.modules;
    
    for i = 1, #splitted do
        if not tab[splitted[i]] then
            return;
        end
        
        tab = tab[splitted[i]];
    end

    return tab;
end

return Module;