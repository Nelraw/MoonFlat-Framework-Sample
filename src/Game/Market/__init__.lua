
local Market = Prototype("Market");
local MarketPlace = MoonFlat:import("Game.Market.MarketPlace");

function Market:__new__()
    local new, meta = self:__super__({
        places = {},
    });

    print("x")
    local file = MoonFlat:file(paths.data .. "dofus\\parsed\\marketTypes.json");
    print("y")
    local marketData = file:open();
    print("z")

    for i = 1, #marketData do
        local data = marketData[i];
        local place = MarketPlace:new(data.category, data.types);

        new.places[#new.places + 1] = place;
    end

    return new, meta;
end

function Market:place(search)
    if type(search) == "number" then
        for i = 1, #self.places do
            local bidhouse = self.places[i];

            local found = Lib.find(bidhouse.types, function(itemType)
                return itemType == search;
            end);

            if found then return bidhouse; end
        end
    end

    if type(search) == "string" then
        for i = 1, #self.places do
            local bidhouse = self.places[i];

            if bidhouse.category == search then
                return bidhouse;
            end
        end
    end
end

function Market:current(descriptor, mode)
    if not descriptor then return self._current; end

    for i = 1, #descriptor.types do
        local curr = self:place(descriptor.types[i]);

        if curr then
            curr.opened = true;
            curr.mode = mode;

            self._current = curr;

            break;
        end
    end

    return self._current;
end

return Market;