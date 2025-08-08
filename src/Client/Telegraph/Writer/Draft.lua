
local dev = developer;
local Draft = Prototype("Draft", {
    model = {}
});

function Draft:__new__()
    local new, meta = self:__super__();

    new.type = meta.__name;
    
    return new, meta;
end

function Draft:parse(data)
    return data;
end

function Draft:create(data)
    data = self:parse(data);

    local draft = dev:createMessage(self.type);
    local writer = MoonFlat.telegraph.writer;

    for k, v in pairs(data) do
        local value = v;
        local modelType = self.model[k];

        if modelType and modelType:find("^[A-Z]") == 1 then
            value = writer:draft(modelType, v);
        end

        draft[k] = value;
    end

    return self:check(draft) and draft or nil;
end

function Draft:check(data)
    local model = self.model;
    if not model then return true; end

    for k, v in pairs(model) do
        local value = data[k];
        if value == nil then return; end

        local checkType = type(value);
        
        if v:find("^[A-Z]") == 1 then
            if v:endsWith("List") then
                if #value > 0 then
                    checkType = dev:typeOf(value[1]);

                    v = v:sub(1, -5);
                end
            else
                checkType = dev:typeOf(value);
            end
        end

        if checkType ~= v then return; end
    end

    return true;
end

function Draft:list(data)
    local result = {};

    for i = 1, #data do
        result[i] = self:create(data[i]);
    end

    return result;
end

return Draft;
