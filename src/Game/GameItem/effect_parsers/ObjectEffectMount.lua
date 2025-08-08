
return function(self, rawdata)
    local effect = {
        id = rawdata.id,
        expirationDate = rawdata.expirationDate,
        model = rawdata.model,
        name = rawdata.name,
        owner = rawdata.owner,
        level = rawdata.level,
        sex = rawdata.sex,
        isRideable = rawdata.isRideable,
        isFeconded = rawdata.isFeconded,
        isFecondationReady = rawdata.isFecondationReady,
        reproductionCount = rawdata.reproductionCount,
        reproductionCountMax = rawdata.reproductionCountMax,
        capacities = rawdata.capacities,
        actionId = rawdata.actionId,
    }

    local subEffects = {};

    for i = 1, #rawdata.effects do
        local subEffect = rawdata.effects[i];

        subEffects[#subEffects + 1] = self:parseEffect(subEffect);
    end

    effect.effects = subEffects;
    return effect;
end