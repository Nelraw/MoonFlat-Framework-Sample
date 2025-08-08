
local telegraph = MoonFlat.telegraph;

local packet = "ExchangeTypesItemsExchangerDescriptionForUserMessage";
local ExchangeTypesItemsExchangerDescriptionForUserMessage = telegraph:sniff(packet);

ExchangeTypesItemsExchangerDescriptionForUserMessage:callback("price", function(self, message)
    local curr = MoonFlat.market:current();

    print(curr.category);
    curr.store:addItem(message);

    print("added")

    return true;
end, -10);

return ExchangeTypesItemsExchangerDescriptionForUserMessage;