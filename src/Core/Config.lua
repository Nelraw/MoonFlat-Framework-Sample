
local Config = Module:extend("Config");

function Config:__new__()
    local path = global:getCurrentScriptDirectory();
    local new, meta = self:__super__(path .. "\\config\\");

    local main = new:import("Main");
    
    for k, v in pairs(main) do
        MoonFlat.modules[k] = v;
    end

    meta.__call = function(self, path)
        return self:import(path);
    end

    return new, meta;
end

return Config;
