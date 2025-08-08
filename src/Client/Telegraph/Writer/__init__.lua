
local dev, find = developer, Lib.find;
local Writer = Prototype("Writer");
local Draft = MoonFlat:import("Client.Telegraph.Writer.Draft");

function Writer:__new__()
    local new, meta = self:__super__();

    new.drafts = Array();

    return new, meta;
end

function Writer:run()
    local dev = developer;

    self:load(paths.client .. "Telegraph\\Writer\\drafts\\");
    self:load(paths.script .. "drafts\\");

    self:ready();
end

function Writer:load(path)
    local dir = Module.directory({ path = path });
    
    for i = 1, #dir do
        local name = dir[i]:match("([^\\]+)%.lua$");
        local draft = dofile(path .. dir[i]);
        
        if draft then
            draft = draft:new();

            self.drafts:push(draft);
        end
    end

    return true;
end

function Writer:draft(draftType, data)
    local list = nil;

    if draftType:endsWith("List") then
        list = true;

        draftType = draftType:sub(1, -5);
    end

    local draft = self.drafts:find({
        type = draftType
    });

    if draft then
        if list then
            return draft:list(data);
        end
        
        return draft:create(data);
    end

    return self:default(draftType, data);
end

function Writer:default(draftType, data)
    local msg = dev:createMessage(draftType);

    if msg then
        for k, v in pairs(data) do msg[k] = v; end

        return msg;
    end
end

function Writer:ready()
    return self;
end

return Writer;