
return function(self, rawdata)
    local effect = {
        actionId = rawdata.actionId,
        value = rawdata.value,
    };

    return effect;
end