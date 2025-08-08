
local AnkaBot = Prototype("AnkaBot");

function AnkaBot:__new__()
    local new, meta = self:__super__();
    
    new.manager = new:manager("Bot");
    
    return new, meta;
end

function AnkaBot:manager(name)
    local akb, ctrl = ankabotController, nil;

    local finder = function(acc)
        local alias = acc:getAlias();

        return alias:find(name .. "Manager");
    end

    local found = self:loaded(finder);

    ctrl = #found >= 1 
        and found[1] or akb:loadControllerAccount();

    if ctrl then
        local glb = ctrl.global;

        glb:editAlias(name .. "Manager");

        return ctrl;
    end
end

function AnkaBot:searcher(data)
    local callback = data;

    return type(callback) == "function"
        and callback
        or function(str) return str == callback; end
end

function AnkaBot:registered(data)
    local akb, results = ankabotController, {};
    local search = self:searcher(data);

    local aliases = akb:getAliasAllRegistredAccounts();
    local usernames = akb:getUsernameAllRegistredAccounts();

    for i, alias in ipairs(aliases) do
        if search(alias, aliases, self) then
            results[#results + 1] = {
                alias = alias,
                username = usernames[i],
            }
        end
    end

    return results;
end

function AnkaBot:loaded(data)
    local akb, results = ankabotController, {};
    local search = self:searcher(data);

    local accounts = akb:getLoadedAccounts();

    for i, acc in ipairs(accounts) do
        if search(acc, accounts, self) then
            results[#results + 1] = acc;
        end
    end

    return results;
end

function AnkaBot:unload(data)
    local akb, results = ankabotController, {};
    local search = self:searcher(data);

    local accounts = akb:getLoadedAccounts();
    
    for i, acc in ipairs(accounts) do
        if search(acc, accounts, self) then
            results[#results + 1] = acc;
            
            local alias = acc:getAlias();
            akb:unloadAccountByAlias(alias);
        end
    end

    return results;
end

return AnkaBot;