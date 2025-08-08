
local native, reader = map, MoonFlat.reader;
local GameMap = Prototype("GameMap");

function GameMap:__new__(id)
    local new, meta = self:__super__();

    new.id = id;

    return new, meta;
end

function GameMap:position()
    if not self._position then
        self._position = {
            x = native:getX(self.id),
            y = native:getY(self.id),
        }
    end

    return self._position;
end

function GameMap:distance(id, raw)
    if not id then return; end

    return raw == true
        and native:GetDistance(self.id, id)
        or native:GetPathDistance(self.id, id);
end

function GameMap:outdoor()
    local d2 = self:d2o();

    return d2 and d2.outdoor;
end

function GameMap:subarea()
    local d2 = self:d2o();

    return d2 and d2.subAreaId;
end

function GameMap:d2o()
    if not self._d2o then
        local parser = reader:getParser("MapPositions");

        self._d2o = parser:object(self.id);
    end

    return self._d2o;
end

return GameMap;