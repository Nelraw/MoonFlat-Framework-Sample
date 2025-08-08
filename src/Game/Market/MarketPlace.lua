
local telegraph = MoonFlat.telegraph;
local MarketPlace = Prototype("MarketPlace");

local Shop = MoonFlat:import("Game.Market.Shop");
local Store = MoonFlat:import("Game.Market.Store");

function MarketPlace:__new__(category, types)
    local new, meta = self:__super__({
        category = category,
        types = types,
        searched = Array(),
    });

    new.shop = Shop:new(new);
    new.store = Store:new(new);

    return new, meta;
end

function MarketPlace:open(mode)
    local data = {
        sell = { id = 5, packet = "ExchangeStartedBidSellerMessage" },
        buy = { id = 6, packet = "ExchangeStartedBidBuyerMessage" },
    };

    data = data[mode];

    telegraph:send("NpcGenericActionRequestMessage", {
        npcId = -1,
        npcActionId = data.id,
        npcMapId = map:currentMapId(),
    });

    local awaited = telegraph:wait(data.packet, 1000);

    return self;
end

function MarketPlace:buy()
    return self:open("buy");
end

function MarketPlace:sell()
    return self:open("sell");
end

function MarketPlace:close()
    global:leaveDialog();

    self.opened = false;
    self.mode = nil;

    return true;
end

function MarketPlace:follow(id)
    if not self.opened then return; end

    local index = self.searched:indexOf(id);

    if index then
        self:unfollow(id);

        self.searched:remove(index);
    end

    if #self.searched >= 3 then
        local first = self.searched:shift();

        self:unfollow(first);
    end

    self.searched:push(id);

    telegraph:send("ExchangeBidHouseSearchMessage", {
        objectGID = id,
        follow = true
    });

    if self.mode == "sell" then
        telegraph:send("ExchangeBidHousePriceMessage", {
            objectGID = id,
        });
    end
end

function MarketPlace:unfollow(id)
    if not self.opened then return; end

    return telegraph:send("ExchangeBidHouseSearchMessage", {
        objectGID = id,
        follow = false
    });
end

return MarketPlace;