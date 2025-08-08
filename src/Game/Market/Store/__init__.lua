
local telegraph = MoonFlat.telegraph;

local Store = Prototype("Store");

local StoreSingleItem = MoonFlat:import("Game.Market.Store.StoreSingleItem");
local StoreBulkItem = MoonFlat:import("Game.Market.Store.StoreBulkItem");

telegraph.sniffer:load(paths.game .. "Market\\Store\\listeners\\");

function Store:__new__(marketPlace)
    local new, meta = self:__super__({
        _marketPlace = marketPlace,
        items = Array(),
    });

    return new, meta;
end

function Store:place()
    return self._marketPlace;
end

function Store:fetchItem(search, many)
    if type(search) == "number" then
        search = { id = search };
    end

    return many and self.items:filter(search)
        or self.items:find(search);
end

function Store:addItem(message)
    print("adding item")
    
    local id = message.objectGID;

    print("fetching")
    local found = self:fetchItem(id);

    if not found then
        print("not found")

        print("StoreBulkItem: ")
        print(StoreBulkItem)
        print("category fn : ")
        print(tostring(StoreBulkItem.category))
        local category = StoreBulkItem.category({ id = id });
        print("category:");
        print(category)

        local builder = category.name == "equipment"
            and StoreBulkItem or StoreSingleItem;

        print("building")
        found = builder.new(builder, message);
        print("built")
        
        self.items:push(found);
        print("pushed")
    else
        print("found")
        found.products = Array();
        
        print("add products")
        found:addManyProducts(message.itemTypeDescriptions);
        print("products added")
    end

    return found;
end

function Store:search(id)
    local packet = "ExchangeTypesItemsExchanger"
        .. "DescriptionForUserMessage";

    self:place():follow(id);
    telegraph:wait(packet);

    return self:priceOf(id);
end

function Store:priceOf(id, update)
    if update then return self:search(id); end

    local found = self:fetchItem(id);
    return found or self:priceOf(id, true);
end

return Store;