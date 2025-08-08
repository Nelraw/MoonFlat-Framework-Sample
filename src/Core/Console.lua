

local Console = {
    tags = {
        [""] = "";
        error = "[ Erreur ] - ",
        success = "[ Succès ] - ",
        info = "[ Info ] - ",
        selling = "[ Vente ] - ",
        dev = "[ Dev ] - ",
        marge = " - ",
    }
};

local has = function(tab, value)
    for k, v in pairs(tab) do
        if v == value then
            return v;
        end
    end
end

local message = function(str, marge)
    marge = marge or 0;
    str = tostring(str == nil and "nil" or str);

    for i = 1, marge do str = " " .. str end
    return str;
end

local __call = function(self, msg, tag, marge)
    if type(msg or "nil") == "table" then
        return self:table(msg)
    end

    if type(msg or "nil") == "string" and #msg == 0 then
        return self:void();
    end

    msg = message(msg, marge);

    return self:basic(msg, tag, marge);
end

function Console:new(ctrl)
    local new = {
        ctrl = ctrl,
        _glb = nil,
    };

    setmetatable(new, {
        __index = self,
        __call = __call 
    });

    return new;
end

Console.__call = function(self, msg, tag, marge)
    msg = message(msg, marge);

    return self:basic(msg, tag, marge);
end

function Console:tag(key)
    return self.tags[key] or self.tags[""];
end

function Console:glb()
    if not self._glb then
        self._glb = self.ctrl
            and self.ctrl.glb or global;
    end

    return self._glb;
end

function Console:basic(msg, tag, marge)
    msg = message(msg, marge);
    self:glb():printMessage(self:tag(tag) .. msg);

    return self, msg;
end

function Console:green(msg, tag, marge)
    msg = message(msg, marge);
    self:glb():printSuccess(self:tag(tag) .. msg);

    return self, msg;
end

function Console:red(msg, tag, marge)
    msg = message(msg, marge);
    self:glb():printError(self:tag(tag) .. msg);

    return self, msg;
end

function Console:color(msg, color, tag, marge)
    color = color or "#343434";

    msg = message(msg, marge);
    self:glb():printColor(color, self:tag(tag) .. msg);

    return self, msg;
end

function Console:void(count)
    count = count or 1;
    if type(count) == "string" then count = 1 end
    
    for i = 1, count do
        self:color("", "#343434");
    end

    return self;
end

function Console:success(msg, marge)
    return self, self:green(msg, "success", marge);
end

function Console:error(msg, marge)
    return self, self:red(msg, "error", marge);
end

function Console:info(msg, marge)
    return self, self:basic(msg, "info", marge);
end

function Console:table(tab, depth)
    depth = depth or 0;

    if depth == 0 then self:void(); end

    local err = function(t)
        if t == nil then return self:error("Nil value"); end

        if type(tab) ~= "table" and depth == 0 then
            self:error("Not a table");
        end
    end

    if err(tab) then return; end

    local len = (function()
        local i = 0;
        for _ in pairs(tab) do i = i + 1; end
        return i;
    end)();

    if len == 0 and depth == 0 then
        return self:error("Table length is null");
    end

    for key, value in pairs(tab) do
        local margin, bl = "", {
            "__index",
        }

        for _ = 1, depth do margin = margin .. "  " end

        if value == nil then
            self(margin .. tostring(key) .. " = nil")
        elseif type(value) ~= "table" then
            self(margin .. tostring(key) .. " = " .. tostring(value) .. " (" .. type(value) .. ")")
        else
            if not has(bl, key) then
                if type(key) == "string" and key:startsWith("_") and not key:startsWith("__") then
                    local rawkey = key:sub(2, #key);
        
                    self(margin .. rawkey .. " = [ circular ]");
                else
                    self(margin .. tostring(key) .. " = " .. tostring(value) .. " (" .. type(value) .. ")")
                    
                    self:table(value, depth + 1)
                end
            end
        end
    end

    if depth == 0 then self:void(); end
    return self, tab;
end

function Console:lines()
    return self:glb():consoleLines();
end

function Console:clear()
    return self:glb():clearConsole();
end

return Console;
