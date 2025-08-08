
local telegraph = MoonFlat.telegraph;

local Shop = Prototype("Shop");
local ShopItem = MoonFlat:import("Game.Market.Shop.ShopItem");

telegraph.sniffer:load(paths.game .. "Market\\Shop\\listeners\\");

function Shop:__new__(marketPlace)
    local new, meta = self:__super__({
        _marketPlace = marketPlace,
        _items = {},
    });

    return new, meta;
end

function Shop:place()
    return self._marketPlace;
end

function Shop:items(objects)
    if not objects then return self._items; end
    local items = {};

    for i = 1, #objects do
        local item = ShopItem:new(objects[i]);
        
        items[#items + 1] = item;
    end
    
    self._items = items;
    return items;
end

function Shop:fetch(id)
    local items, results = self:items(), {};

    for i = 1, #items do
        local item = items[i];

        if item.id == id then
            results[#results + 1] = item;
        end
    end

    return results;
end

function Shop:update(id, price)
    local items = self:fetch(id);
    local store = self:place().store;
    
    local currPrice = store:price(id, true);
    
    for i = 1, #items do
        local item = items[i];
        local lotPrice = currPrice:lotPrice(item.quantity);

        if lotPrice < item.price then
            price = price or lotPrice - 1;

            item:update(price);
        end
    end
end

return Shop;