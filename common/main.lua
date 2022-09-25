--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

local aTattoos = {};
aTattoos.loadedTattoos = {
    zone_head = {},
    zone_leftarm = {},
    zone_rightarm = {},
    zone_torso = {},
    zone_leftleg = {},
    zone_rightleg = {},
};

---@enum tattoosZones_storage
local tattoosZones_storage = {
    ["ZONE_HEAD"] = aTattoos.loadedTattoos.zone_head,
    ["ZONE_LEFT_ARM"] = aTattoos.loadedTattoos.zone_leftarm,
    ["ZONE_RIGHT_ARM"] = aTattoos.loadedTattoos.zone_rightarm,
    ["ZONE_TORSO"] = aTattoos.loadedTattoos.zone_torso,
    ["ZONE_LEFT_LEG"] = aTattoos.loadedTattoos.zone_leftleg,
    ["ZONE_RIGHT_LEG"] = aTattoos.loadedTattoos.zone_rightleg,
};

---@public
---@param cb function
function aTattoos:loadTattoos(cb)
    local data = 2;
    for i = 1, data do
        local f = json.decode(LoadResourceFile(GetCurrentResourceName(), ('data/overlays_%i.json'):format(i)));
        if (f) then
            for _, tattoo in pairs(f) do
                if (tattoo.Zone) then
                    if (tattoosZones_storage[tattoo.Zone]) then
                        table.insert(tattoosZones_storage[tattoo.Zone], tattoo);
                    end
                end
            end
        end
    end
   
    cb(aTattoos.loadedTattoos);
end

---@public
---@param digits number
---@return string
function aTattoos:groupDigits(digits)
    local left, num, right = string.match(digits, "^([^%d]*%d)(%d*)(.-)$")
    return (tostring(left .. (num:reverse():gsub("(%d%d%d)", "%1 "):reverse()) .. right))
end

---@public
---@param query
---@param sortFunction
---@return table
function aTattoos:sortKeys(query, sortFunction)
    local keys, len = {}, 0
    for k, _ in pairs(query) do
        len = len + 1;
        keys[len] = k;
    end

    table.sort(keys, sortFunction)
    return keys;
end
  

_G.aTattoos = aTattoos;