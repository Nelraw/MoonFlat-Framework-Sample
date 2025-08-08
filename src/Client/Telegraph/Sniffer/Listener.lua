
local Listener = Prototype("Listener");

function Listener:__new__(data)
    if type(data) == "string" then
        data = { name = data };
    end

    if type(data.callstack) == "function" or data.callback then
        local callback = {
            name = "main",
            fn = data.callstack or data.callback,
            prio = -10^4,
            enabled = true,
        };

        data.callstack = { callback };
    end

    data.callstack = Array(data.callstack);

    local new, meta = self:__super__();

    new.data = {};
    new.name = data.name;
    new.callstack = data.callstack;
    new.prio = data.prio or 0;
    new.enabled = data.enabled ~= nil
        and data.enabled or true;

    return new, meta;
end

function Listener:receive(message)
    self.message = self.parse
        and self:parse(message) or message;

    local result = self:exec(self.message);

    return result;
end

function Listener:callback(name, fn, prio, enabled, erase)
    local found, index = self.callstack:find({ name = name });

    if found then
        if not erase then return; end

        self.callstack:remove(index);
    end

    if fn and type(fn) == "function" then
        self.callstack:push({
            fn = fn,
            name = name,
            prio = prio or 0,
            enabled = enabled == nil
                and true or enabled,
        });

        self.callstack:sort(function(x, y)
            return x.prio < y.prio;
        end);
    
        return self;
    end
end

function Listener:toggle(name, enabled)
    local callback = self.callstack:find({ name = name });
    if not callback then return; end

    callback.enabled = enabled;
    return callback.enabled;
end

function Listener:lull()
    for i = 1, #self.callstack do
        local callback = self.callstack[i];

        callback.enabled = false;
    end

    return true;
end

function Listener:exec(message)
    local result = nil;
    
    for i = 1, #self.callstack do
        local callback = self.callstack[i];
        
        if callback and callback.enabled then
            result = callback.fn(self, message);

            if result == nil then return result; end
        end
    end

    return result;
end

function Listener:registered()
    return developer:isMessageRegistred(self.name);
end

function Listener:print()
    if VERBOSE < 2 then return; end

    print:success("Message : " .. self.name);
    print:info(" Actif : " .. tostring(self.enabled and "Oui" or "Non"));
    print:info(" En écoute : " .. tostring(self:registered() and "Oui" or "Non"));
    print:info(" Callbacks : " .. tostring(#self.callstack));

    for i = 1, #self.callstack do
        local callback = self.callstack[i];

        if callback.enabled then
            print:info("  [ " .. callback.name .. " ]");
        end
    end
end

return Listener;