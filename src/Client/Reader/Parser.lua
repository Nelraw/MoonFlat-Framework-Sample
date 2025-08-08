
local d2, File = d2data, MoonFlat:import("Utils.File");

local Parser = Prototype("Parser", {
    textKeys = { "nameId" }
});

function Parser:__new__(data)
    data = data or {};

    local new, meta = self:__super__();

    new.cache = Array();

    new.name = data.name or meta.__name:gsub("Parser", "");
    new.textKeys = data.textKeys;
    
    new.datapath = paths.data .. "dofus\\raw\\"
        .. new.name .. ".json";
    
    new.basepath = global:getCurrentDirectory()
        .. new.name .. ".json";
    
    return new, meta;
end

function Parser:parse(data)
    return data;
end

function Parser:write(data, path)
    path = path or self.datapath;

    if data == true then data = self:objects(); end
    if data == nil then data = self:rawdata(); end

    local file = File:new(path);
    local version = MoonFlat.reader:version();

    local written = file:write({
        name = self.name,
        time = Lib.date(),
        version = version,
        data = data,
    });

    return written;
end

function Parser:texts(data)
    if type(self.textKeys) == "string" then
        self.textKeys = { self.textKeys };
    end

    for k, v in pairs(self.textKeys) do
        if data[v] then
            local fieldKey = v:sub(1, -3);

            data[fieldKey] = d2:text(data[v]);
        end
    end

    return data;
end

function Parser:object(id)
    local found = self:cached(id);
    if found then return found; end

    local object = d2:objectFromD2O(self.name, id);

    if object and object.Fields then
        object = self:texts(object.Fields);

        return object and self:parse(object);
    end
end

function Parser:objects(...)
    local ids = type(...) ~= "table"
        and { ... } or ...;

    local objects = {};

    if #ids == 0 then
        local all = d2:allObjectsFromD2O(self.name);

        for i = 1, #all do
            local object = self:texts(all[i].Fields);

            objects[i] = self:parse(object);
        end
    else
        for i = 1, #ids do
            objects[i] = self:object(ids[i]);
        end
    end

    self:caching(objects);

    return objects;
end

function Parser:cached(object)
    if not object then return self.cache; end
    local search = object;

    if type(object) == "number" then
        search = { id = object };
    end

    return self.cache:find(search);
end

function Parser:caching(data)
    for i = 1, #data do
        if not self:cached(data[i]) then
            self.cache:push(data[i]);
        end
    end

    return self.cache;
end

function Parser:rawdata()
    local result = {};
    local data = d2:allObjectsFromD2O(self.name);

    for i = 1, #data do
        result[i] = self:texts(data[i].Fields);
    end

    return result;
end

return Parser;