
local telegraph = MoonFlat.telegraph;

local Bot = Prototype("Bot");
local Inventory = MoonFlat:import("Game.Bot.Inventory");

function Bot:__new__()
    local new, meta = self:__super__();

    new.inventory = Inventory:new(new);

    return new, meta;
end

function Bot:npc(id, mode, dialogs)
    if dialogs then
        mode = mode or 3;
        npc:npc(id, mode);

        for i = 1, #dialogs do
            global:delay(50);

            npc:reply(dialogs[i]);
        end

        return true;
    end
end

return Bot;