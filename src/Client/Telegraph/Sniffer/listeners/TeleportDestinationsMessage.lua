
local File = MoonFlat:import("Utils.File");
local TeleportDestinationsMessage = MoonFlat.telegraph:sniff("TeleportDestinationsMessage");

local world = MoonFlat.world;

-- TeleportDestinationsMessage:callback("zaapis", function(self, message)
--     local destinations = message.destinations;
--     local file = File:new(paths.data .. "dofus\\parsed\\zaapis.json");

--     local data, area, curr = file:open(), map:currentArea(), map:currentMapId();
--     local insert = table.insert;

--     for i = 1, #destinations do
--         local dest = destinations[i];
--         local gameMap = world:map(dest.mapId);

--         data[#data + 1] = {
--             id = dest.mapId,
--             position = gameMap:position(),
--             area = area
--         }
--     end

--     data[#data + 1] = {
--         id = curr,
--         position = world:map(curr):position(),
--         area = area
--     }

--     print(#data)

--     -- file:write(data);

--     print("written")

--     return true;
-- end);

return TeleportDestinationsMessage;