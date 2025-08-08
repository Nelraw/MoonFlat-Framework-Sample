
local telegraph = MoonFlat.telegraph;

local GameItem = MoonFlat:import("Game.GameItem");
local ShopItem = GameItem:extend("ShopItem");

function ShopItem:__new__(rawdata)
    local new, meta = self:__super__(rawdata);
    
    return new:parsing(), meta;
end

function ShopItem:parsing(rawdata)
    rawdata = rawdata or self.rawdata;

    self.price = rawdata.objecttPrice;
    self.expiration = rawdata.unsoldDelay;
    self.quantity = rawdata.quantity;

    local effects = {};

    for i = 1, #rawdata.effects do
        local effect = rawdata.effects[i];

        effects[#effects + 1] = self:parseEffect(effect);
    end

    self.effects = effects;
    return self;
end

function ShopItem:update(price)
    telegraph:send("ExchangeObjectModifyPricedMessage", {
        objecttUID = self.uid,
        quantity = self.quantity,
        price = price,
    });

    telegraph:wait("ExchangeBidHouseInListUpdatedMessage");
    self.price = price;

    return self.price;
end

return ShopItem;