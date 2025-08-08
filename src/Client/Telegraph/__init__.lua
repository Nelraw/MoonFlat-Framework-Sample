
local dev = developer;
local Telegraph = Prototype("Telegraph");

function Telegraph:__new__()
    local new, meta = self:__super__();
    
    local Sniffer = MoonFlat:import("Client.Telegraph.Sniffer");
    local Writer = MoonFlat:import("Client.Telegraph.Writer");
    
    new.sniffer = Sniffer:new();
    new.writer = Writer:new();

    return new, meta;
end

function Telegraph:run()
    self.sniffer:run();
    
    self.writer:run();
end

function Telegraph:sniff(data)
    self.sniffer.broken = true;
    
    return self.sniffer:listen(data);
end

function Telegraph:write(draftType, data)
    return self.writer:draft(draftType, data);
end

function Telegraph:send(draftType, data)
    local message = nil;

    if type(draftType) == "table" then
        if Lib.instanceOf(draftType, "Draft") then
            message = draftType;
        end
    end

    if not message then
        message = self:write(draftType, data);
    end

    if message then
        developer:sendMessage(message);

        return message;
    end
end

function Telegraph:question(draft, listener)
    
end

function Telegraph:unsniff(name, fnName)
    local sniffer = self.sniffer;

    if not fnName then
        return sniffer:toggle(name, false);
    end

    local listener = sniffer.listeners[name];

    if listener then
        return listener:toggle(fnName, false);
    end
end

function Telegraph:wait(...)
    return self.sniffer:wait(...);
end

function Telegraph:await(...)
    return self.sniffer:await(...);
end

function Telegraph:once(...)
    return self.sniffer:once(...);
end

return Telegraph;


