
local dev = developer;
local Sniffer = Prototype("Sniffer");
local Listener = MoonFlat:import("Client.Telegraph.Sniffer.Listener");

Sniffer.Listener = Listener;

function Sniffer:__new__()
    local new, meta = self:__super__();

    new.listeners = Array();
    new.broken = true;

    return new, meta;
end

function Sniffer:run()
    local dev = developer;

    self:load(paths.client .. "Telegraph\\Sniffer\\listeners\\");
    self:load(paths.script .. "listeners\\");

    self:repair();
    self:ready();
end

function Sniffer:load(path)
    local dir = Module.directory(path);
    
    for i = 1, #dir do
        local name = dir[i]:match("([^\\]+)%.lua$");
        local listener = dofile(path .. dir[i]);
        
        if listener then
            listener.name = name;
            listener.enabled = true;
            
            self:listen(listener);
        end
    end

    self:repair(true);

    return true;
end

function Sniffer:ready()
    -- print("");

    local len = #self.listeners;

    -- print:info("Messages à écouter : " .. len);
    -- print("");

    -- for i = 1, len do
    --     local lst = self.listeners[i];
    --     if lst.enabled then lst:print(); end

    --     print("");
    -- end
end

function Sniffer:listen(data)
    if not data then return; end
    
    data = type(data) == "string"
        and { name = data } or data;
    
    if not data.name then return; end
    
    data.enabled = data.enabled ~= nil
        and data.enabled or true;

    local instaciated = Prototype
        .__instanceOf__(data, "Listener");

    local listener = not instaciated
        and Listener:new(data)
        or data;

    self:register(listener);
    self.listeners:single(listener);

    return listener;
end

function Sniffer:repair(force)
    if self.broken or force then
        for i = 1, #self.listeners do
            local listener = self.listeners[i];

            if listener.enabled then
                self:register(listener.name);
            end
        end

        self.broken = false;
    end
end

function Sniffer:receive(message)
    self:repair();

    local name = dev:typeOf(message);
    local listener = self:fetch(name);

    return (not listener or not listener.enabled and nil)
        or listener.receive(listener, message);
end

function Sniffer:register(name)
    if type(name) ~= "string" then
        name = name.name;
    end

    if not dev:isMessageRegistred(name) then
        local receiver = function(message)
            return self:receive(message);
        end;

        dev:registerMessage(name, receiver);
        return true;
    end
end

function Sniffer:unregister(name)
    if type(name) ~= "string" then
        name = name.name;
    end

    if dev:isMessageRegistred(name) then
        dev:unRegisterMessage(name);

        return true;
    end
end

function Sniffer:fetch(name)
    return self.listeners:find({ name = name });
end

function Sniffer:names()
    local names = {};

    for i = 1, #self.listeners do
        local listener = self.listeners[i];

        if listener.enabled then
            names[#names + 1] = listener.name;
        end
    end

    return names;
end

function Sniffer:toggle(name, enabled)
    local listener = self:fetch(name);
    if listener then listener.enabled = enabled; end

    return listener.enabled;
end

function Sniffer:wait(names, timeout, fail, step)
    if not names or type(names) == "number" then
        timeout = names or 500;

        names = "ClientYouAreDrunkMessage";
    end

    if type(names) == "string" then
        names = { names };
    end

    if type(fail) == "string" then
        names[#names + 1] = fail;
    end

    timeout = timeout or 1000;
    step = step or (timeout > 10 and 10 or timeout);

    local args, unp = {
        names, timeout, false, step
    }, unpack;

    local result = dev:suspendScriptUntilMultiplePackets(unp(args));

    if result == "False" then return fail; end
    return result;
end

function Sniffer:await(names, timeout, step)
    local result = self:wait(names, timeout, nil, step);

    return result == nil
        and self:await(names, timeout, false, step)
        or result;
end

function Sniffer:once(name, timeout, callback)
    if type(timeout) == "function" then
        callback = timeout;

        timeout = 50;
    end

    local result = self:await(name, timeout);

    if result == name then
        return callback
            and callback(self, name) or true;
    end
end

-- result = dev:suspendScriptUntilMultiplePackets(names, timeout, false, 500);


return Sniffer;