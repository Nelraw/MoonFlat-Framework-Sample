
print("x")
local StoreItem = MoonFlat:import("Game.Market.Store.StoreItem");
print("y")
print(StoreItem)
local StoreSingleItem = StoreItem:extend("StoreSingleItem");
print("z")

function StoreSingleItem:__new__(message)
    local new, meta = self:__super__(message);

    return new, meta;
end

return StoreSingleItem;