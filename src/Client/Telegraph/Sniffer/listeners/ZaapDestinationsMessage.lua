
local find = Lib.find;
local ZaapDestinationsMessage = MoonFlat.telegraph:sniff("ZaapDestinationsMessage");

local world = MoonFlat.world;

ZaapDestinationsMessage:callback("known", function(self, message)
    local destinations = message.destinations;
    world.knownZaaps = world.knownZaaps or {};

    local known = world.knownZaaps;

    for i = 1, #destinations do
        local mapId = destinations[i].mapId;
        local found = find(known, function(v, k)
            return v == mapId;
        end);

        if not found then known[#known + 1] = mapId; end
    end

    return true;
end);

return ZaapDestinationsMessage;