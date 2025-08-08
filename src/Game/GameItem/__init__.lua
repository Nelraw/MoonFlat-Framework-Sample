

local inv = inventory;
local GameItem = Prototype("GameItem");

local reader = MoonFlat.reader;
reader:load(paths.game .. "GameItem\\data_parsers\\");

local types = reader:getParser("ItemTypes");

function GameItem:__new__(rawdata)
    if type(rawdata) == "number" then
        rawdata = { objecttGID = rawdata };
    end
    
    local new, meta = self:__super__();

    new.rawdata = rawdata;

    return new, meta;
end

function GameItem:parse(raw)
    raw = raw or self.rawdata;
    if not raw then return self; end
    
    self.id = self.id or raw.objecttGID;
    self.uid = raw.objecttUID;

    return self;
end

function GameItem:name()
    if not self._name then
        self._name = inv:itemNameId(self.id);
    end

    return self._name;
end

function GameItem:weight()
    if not self._weight then
        self._weight = inv:itemWeight(self.id);
    end

    return self._weight;
end

function GameItem:level()
    if not self._level then
        self._level = inv:getLevel(self.id);
    end

    return self._level;
end

function GameItem:type()
    if not self._type then
        self._type = {
            id = inv:getTypeId(self.id),
            name = inv:getTypeName(self.id),
        };
    end

    return self._type;
end

function GameItem:category()
    if not self._category then
        local typeId = inv:getTypeId(self.id);
        local d2o = types:object(typeId);

        if d2o then
            self._category = {
                id = d2o.categoryId,
                name = d2o.categoryName,
            }
        end
    end

    return self._category;
end

function GameItem:print(verbose)
    local str = " " .. self.name .. " x " .. self.quantity;

    if verbose then
        str = str .. " - [ " .. self:__meta__("name")
            .. " - " .. self.id
            .. " - " .. self.uid .. " ] "
    end

    print:info(str);
end

function GameItem:d2o()
    if not self._d2o then
        self._d2o = reader:get("Items", self.id);
    end

    return self._d2o;
end

function GameItem:recipe()
    if self._recipe == nil then
        self._recipe = reader:get("Recipes", self.id);

        if not self._recipe then self._recipe = false; end
    end

    return self._recipe;
end

function GameItem:parseEffect(rawEffect)
    if not self.effectParsers then
        self.effectParsers = {};

        path = paths.game .. "GameItem\\effect_parsers\\";
        local dir = Module.directory({ path = path });

        for i = 1, #dir do
            local name = dir[i]:match("([^\\]+)%.lua$");
            local parser = dofile(path .. dir[i]);

            if parser then
                self.effectParsers[name] = parser;
            end
        end
    end

    local dataType = developer:typeOf(rawEffect);
    local parser = self.effectParsers[dataType];

    if parser then
        return parser(self, rawEffect);
    end
end

return GameItem;