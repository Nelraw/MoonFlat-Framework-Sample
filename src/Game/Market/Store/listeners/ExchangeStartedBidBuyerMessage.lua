
local telegraph = MoonFlat.telegraph;
local ExchangeStartedBidBuyerMessage = telegraph:sniff("ExchangeStartedBidBuyerMessage");

ExchangeStartedBidBuyerMessage:callback("current", function(self, message)
    local curr = MoonFlat.market:current(message.buyerDescriptor, "buy");

    return true;
end, -10);

return ExchangeStartedBidBuyerMessage;