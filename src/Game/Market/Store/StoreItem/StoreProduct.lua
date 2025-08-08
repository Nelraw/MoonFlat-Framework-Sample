
local StoreProduct = Prototype("StoreProduct");

function StoreProduct:__new__(storeItem, rawdata)
    local new, meta = self:__super__({
        _item = storeItem,
    });

    new.uid = rawdata.objecttUID;
    new.prices = Array(rawdata.prices);
    new:effects(rawdata.effects);

    return new, meta;
end

function StoreProduct:effects(rawEffects)
    if not self._effects and rawEffects then
        self._effects = Array();
        
        for i = 1, #rawEffects do
            local effect = rawEffects[i];
            local parsed = self._item:parseEffect(effect);

            if parsed then self._effects:push(parsed); end
        end
    end

    return self._effects;
end

function StoreProduct:average()
    local prices = self.prices;
    local total, count = 0, 0;

    for i = 1, #prices do
        local price = prices[i];

        count = count + 1;
        total = total + (price / self:lot(i));

        local skip = self.category == "equipment"
            or self.category == "skin";

        if skip then break; end
    end

    return math.floor(total / count);
end

function StoreProduct:lowest()
    local prices = self.prices;
    local lowest = {
        value = prices[1],
        index = 1,
    };

    for i = 1, #prices do
        local price = prices[i];
        local skip = self.category == "equipment"
            or self.category == "skin";

        if skip then return price; end

        local unitPrice = price / self:lot(i);

        if unitPrice < lowest.value then
            lowest.value = unitPrice;
            lowest.index = i;
        end
    end

    lowest.lot = self:lot(lowest.index);
    return lowest;
end

function StoreProduct:lot(index, reverse)
    local lots = { 1, 10, 100 };
    if reverse then
        for i = 1, #lots do
            if lots[i] == index then
                return i;
            end
        end
    end

    return lots[index or 1];
end

function StoreProduct:lotPrice(lot)
    local index = self:lot(lot, true);

    return self.prices[index];
end

return StoreProduct;