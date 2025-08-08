
local inv = inventory;
local StorageItem = MoonFlat:import("Game.Storage.StorageItem");
local InventoryItem = StorageItem:extend("InventoryItem");

function InventoryItem:__new__(rawdata)
    local new, meta = self:__super__(rawdata);

    new.quantity = new.rawdata.quantity;
    new.position = new.rawdata.position;

    return new, meta;
end

function InventoryItem:use(qty)
    qty = qty or 1;

    return qty == 1
        and inv:useItem(self.id, qty)
        or inv:useMultipleItem(self.id, qty);
end

return InventoryItem;