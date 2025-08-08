
local Module = dofile(PATH .. "src\\Core\\Module.lua");

MoonFlat = Module:extend("MoonFlat");

function MoonFlat:__new__()
    local src = PATH .. "src\\";
    local new, meta = self:__super__(src);

    return new:__init__(), meta;
end

function MoonFlat:__init__()
    self:core();
    self:client();
    self:game();

    return self;
end

function MoonFlat:file(path)
    local File = self:import("Utils.File");

    return File:new(path);
end

function MoonFlat:core()
    local modules = self.modules;
    
    _G.MoonFlat = self;
    setmetatable(_G, { __index = modules });
    
    modules.Module = Module;
    modules.Prototype = Module:__proto__();

    modules.paths = {
        core = self.path .. "Core\\",
        data = PATH .. "data\\",
        lib = self.path .. "Lib\\",
        utils = self.path .. "Utils\\",
        game = self.path .. "Game\\",
        client = self.path .. "Client\\",
        script = global:getCurrentScriptDirectory() .. "\\src\\",
        dofus = os.getenv("LOCALAPPDATA") .. "\\Ankama\\Dofus\\"
    };

    self:import("Lib");
    self:import("Utils.Timestamp");
    self:import("Utils.Json");
    self:import("Utils.File");

    self.modules.Array = self:import("Utils.Array");

    print = self:import("Core.Console"):new();

    self.config = self:import("Core.Config"):new();
    
    self.ankabot = self:import("Client.AnkaBot")
        :__instance__();

    self.reader = self:import("Client.Reader")
        :__instance__();

    if CLEAR then print:clear(); end

    return self;
end

function MoonFlat:client()
    local Telegraph = self:import("Client.Telegraph");
    self.telegraph = Telegraph:new();

    return self;
end

function MoonFlat:game()
    self:import("Game.Bot");

    self.world = self:import("Game.World")
        :__instance__();

    self.market = self:import("Game.Market")
        :__instance__();

    return self;
end

function MoonFlat:bot()
    return self.botProto:__instance__();
end

MoonFlat = MoonFlat:__instance__();

function messagesRegistering()
    print("");
    print:info("Running telegraph...");

    MoonFlat.telegraph:run();

    print:success("Telegraph is running.");
    print("");
end


function MoonFlat:move(callback)
    -- print:table(self);
end


return MoonFlat;
