
local Draft = MoonFlat:import("Client.Telegraph.Writer.Draft");
local ObjectItemQuantity = Draft:extend("ObjectItemQuantity", {
    model = {
        objecttUID = "number",
        quantity = "number",
    }
});

function ObjectItemQuantity:parse(data)
    return {
        objecttUID = data.objecttUID,
        quantity = data.quantity,
    }
end

return ObjectItemQuantity;