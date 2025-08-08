
local Parser = MoonFlat:import("Client.Reader.Parser");
local ItemTypesParser = Parser:extend("ItemTypesParser");

function ItemTypesParser:parse(data)
    local categoryNames = {
        "equipment", "consumable",
        "resource", "misc",
        "buff", "skin"
    }

    if data.categoryId then
        local index = data.categoryId + 1;

        data.categoryName = categoryNames[index];
    end

    return data;
end

return ItemTypesParser;