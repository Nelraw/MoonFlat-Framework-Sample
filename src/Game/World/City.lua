
local City = Prototype("City");

function City:__new__(name)
    local new, meta = self:__super__();

    new.name = name

    local path = paths.data .. "dofus\\parsed\\cities.json";
    local cities = MoonFlat:file(path);
    cities = cities:open();

    new.data = Array(cities):find({
        name = name
    });

    return new, meta;
end

function City:zaap()
    return self.data.zaap;
end

return City;