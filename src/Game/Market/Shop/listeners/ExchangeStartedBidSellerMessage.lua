
local telegraph = MoonFlat.telegraph;
local ExchangeStartedBidSellerMessage = telegraph:sniff("ExchangeStartedBidSellerMessage");

ExchangeStartedBidSellerMessage:callback("items", function(self, message)
    local market = MoonFlat.market;
    local curr = market:current(message.sellerDescriptor, "sell");
    
    curr.shop:items(message.objecttsInfos);

    return true;
end, -10);

return ExchangeStartedBidSellerMessage;