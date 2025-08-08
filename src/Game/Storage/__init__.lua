
local inv = inventory;
local StorageItem = MoonFlat:import("Game.Storage.StorageItem");

local Storage = Prototype("Storage", {
    itemProto = StorageItem
});

function Storage:__new__(rawItems)
    local new, meta = self:__super__();

    new.rawItems = rawItems;
    new.lastContent = Array();
    
    return new, meta;
end

function Storage:item(data)
    local item = self.itemProto:new(data);

    return item:parse();
end

function Storage:parse(rawItems, forceUpdate)
    local result = {};
    local content = rawItems or self.rawItems;
    
    for i = 1, #content do
        local item = content[i];
        local found = self:fetch(-item.objecttUID);
        
        if found and not forceUpdate then
            found:parse(item);
            
            result[i] = found;
        else
            result[i] = self:item(item);
        end
    end

    self.lastContent = Array(result);

    return result;
end

function Storage:fetch(fetcher, many)
    if type(fetcher) == "number" then
        local id = math.abs(fetcher);
        local key = fetcher > 0 and "id" or "uid";

        fetcher = function(item)
            return item[key] == id;
        end
    end

    if type(fetcher) == "string" then
        local name = fetcher:lower();

        if name:find("%%") then
            name = name:gsub("%%", "");

            fetcher = function(item)
                return item:name():lower():find(name);
            end
        else
            fetcher = function(item)
                return item:name():lower() == name;
            end
        end
    end

    local content = self.lastContent;

    return many == true
        and content:filter(fetcher)
        or content:find(fetcher);
end

function Storage:content(rawItems, forceUpdate)
    return self:parse(rawItems, forceUpdate);
end

return Storage;