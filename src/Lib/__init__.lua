
local Lib = Prototype("Lib");

function Lib:__new__()
    local new, meta = self:__super__();
    local dir = Module.directory({ path = paths.lib });

    for i = 1, #dir do
        local file = dir[i];
        local name = file:sub(1, #file - 4);
        local fns = dofile(paths.lib .. file);

        local tab = name ~= "String"
            and new or string;

        for k, v in pairs(fns) do
            tab[k] = v;
        end
    end

    return new, meta;
end

return Lib:__instance__();