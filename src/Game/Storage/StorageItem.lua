
local GameItem = MoonFlat:import("Game.GameItem");
local StorageItem = GameItem:extend("StorageItem");

function StorageItem:__new__(rawdata)
    local new, meta = self:__super__(rawdata);

    return new, meta;
end

return StorageItem;