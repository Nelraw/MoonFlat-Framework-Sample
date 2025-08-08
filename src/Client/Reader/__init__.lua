
local d2 = d2data;
local File = MoonFlat:import("Utils.File");
local Parser = MoonFlat:import("Client.Reader.Parser");

local Reader = Prototype("Reader");

function Reader:__new__()
    local new, meta = self:__super__();

    new.path = paths.dofus;
    new.parsers = Array();

    new:load(paths.client .. "Reader\\data_parsers\\");
    new:load(paths.script .. "data_parsers\\");

    return new, meta;
end

function Reader:load(path)
    local dir = Module.directory({
        path = path
    });

    for i = 1, #dir do
        local parser = dofile(path .. dir[i]);

        if parser then
            parser = parser:new();

            self.parsers:push(parser);
        end
    end

    return true;
end

function Reader:file(path)
    return File:new(self.path .. path);
end

function Reader:version()
    local file = self:file("VERSION");
    local version = file:open();

    return version:gsub("\n", "");
end

function Reader:getParser(data)
    if type(data) == "string" then
        local name = data;

        data = { name = name };
    end

    local parser = self.parsers:find({ name = data.name });

    if not parser then
        parser = Parser:new(data);

        self.parsers:push(parser);
    end

    return parser;
end

function Reader:get(name, ids)
    local parser = self:getParser(name);

    return parser and parser:objects(ids);
end

function Reader:write(name, data, path)
    local parser = self:getParser(name);

    return parser and parser:write(data, path);
end

return Reader;