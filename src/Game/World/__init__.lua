
local find = Lib.find;

local World = Prototype("World");
local GameMap = MoonFlat:import("Game.World.GameMap");
local City = MoonFlat:import("Game.World.City");

function World:__new__()
    local new, meta = self:__super__();

    new.data, new.cities = {}, {};
    new.cache = {
        maps = Array()
    }

    return new, meta;
end

function World:map(id)
    local found = self:cached("maps", id);

    if not found then
        found = GameMap:new(id);

        self:caching("maps", { found });
    end

    return found;
end

function World:cached(cacheKey, object)
    local cache = self.cache[cacheKey];
    if not object then return cache; end

    local search = object;

    if type(object) == "number" then
        search = { id = object };
    end

    return cache:find(search);
end

function World:caching(cacheKey, data)
    local cache = self.cache[cacheKey];

    for i = 1, #data do
        if not self:cached(cacheKey, data[i]) then
            cache:push(data[i]);
        end
    end

    return cache;
end

function World:city(name)
    name = name or REF_CITY;

    if not self.cities[name] then
        self.cities[name] = City:new(name);
    end

    return self.cities[name];
end

return World;