
local ChatServerMessage = MoonFlat.telegraph:sniff("ChatServerMessage");

ChatServerMessage:callback("whisperNotif", function(self, message)
    if message.channel ~= 9 then return true; end

    local text = "**" .. message.senderName
        .. " a dit : **\n\n"
        .. message.content .. "\n\n \r";

    -- Discord:send("private", text);

    return true;
end);

return ChatServerMessage;