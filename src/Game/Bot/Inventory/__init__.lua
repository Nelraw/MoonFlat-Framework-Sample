
local inv = inventory;

local Storage = MoonFlat:import("Game.Storage");
local InventoryItem = MoonFlat:import("Game.Bot.Inventory.InventoryItem")

local Inventory = Storage:extend("Inventory", {
    itemProto = InventoryItem
});

function Inventory:__new__()
    local new, meta = self:__super__();

    new:content();

    return new, meta;
end

function Inventory:content(forceUpdate)
    local rawItems = inv:inventoryContent();

    return self:parse(rawItems, forceUpdate);
end

return Inventory;