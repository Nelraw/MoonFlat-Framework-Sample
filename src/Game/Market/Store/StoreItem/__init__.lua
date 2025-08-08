

local GameItem = MoonFlat:import("Game.GameItem");
local StoreItem = GameItem:extend("StoreItem");

local StoreProduct = MoonFlat:import("Game.Market.Store.StoreItem.StoreProduct");

function StoreItem:__new__(message)
    message = message or {};
    
    local new, meta = self:__super__(message.objectGID);

    new.products = Array();
    new:addManyProducts(message.itemTypeDescriptions);

    return new, meta;
end

function StoreItem:addProduct(data)
    if type(data) == "userdata" then
        local product = StoreProduct:new(self, data);
        
        self.products:push(product);

        return product;
    end
end

function StoreItem:addManyProducts(descriptions)
    for i = 1, #data do
        self:addProduct(data[i]);
    end

    return self;
end

function StoreItem:getProduct(search, many)
    if type(search) == "number" then
        search, many = { uid = search }, nil;
    end

    return many and self.products:filter(search)
        or self.products:find(search);
end

return StoreItem;