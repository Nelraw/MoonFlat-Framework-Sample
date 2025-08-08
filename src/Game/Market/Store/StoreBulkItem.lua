
local StoreItem = MoonFlat:import("Game.Market.Store.StoreItem");
local StoreBulkItem = StoreItem:extend("StoreBulkItem");

function StoreBulkItem:__new__(message)
    local new, meta = self:__super__(message);
    
    return new, meta;
end

return StoreBulkItem;