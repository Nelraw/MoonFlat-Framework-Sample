
local Discord = Prototype("Discord");

function Discord:__new__()
    local new, meta = self:__super__({
        baseHook = "https://discord.com/api/webhooks",
    });

    new.hooks = CONFIG.DISCORD_WEBHOOKS;
    return new, meta;
end

function Discord:send(hook, text)
    hook = self.hooks[hook];

    if not hook then return; end 
    local url = self.baseHook .. "/" .. hook;

    data = Json.encode({
        content = text,
    });

    return request("POST", url, data);
end

return Discord;