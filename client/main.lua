--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

local ESX;
aTattoos.clientVars = {
    loaded = false,
};

aTattoos.playerVars = {
    actualShop = nil,
    actualCat = nil,
    menuOpened = false,
    previewTattoo = nil,
    ownedTattoos = {}
};

RegisterNetEvent('aTattoos:root:loadTattoos');
AddEventHandler('aTattoos:root:loadTattoos', function(list)
    aTattoos.loadedTattoos = list;
end)

RegisterNetEvent('aTattoos:player:requestTattoos');
AddEventHandler('aTattoos:player:requestTattoos', function(list)
    aTattoos.playerVars.ownedTattoos = list;
    aTattoos.clientVars.loaded = true;
end)

AddEventHandler('skinchanger:modelLoaded', function()
    local ped = PlayerPedId();

    while (not aTattoos.clientVars.loaded) do
        Wait(0);
    end
    
    if (#aTattoos.playerVars.ownedTattoos > 0) then
        for _, tattoo in pairs(aTattoos.playerVars.ownedTattoos) do
            ApplyPedOverlay(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
    end
end)

CreateThread(function()
    local interval = 1200;
    local markerCfg = aTattoos.config.markerSettings;

    aTattoos:loadTattoos(function(_)
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj;

            aTattoos:loadBlips()
        end)
    end)

    TriggerServerEvent('aTattoos:player:requestTattoos');
    while (not aTattoos.clientVars.loaded) do
        Wait(0);
    end

    while (ESX ~= nil) do
        local playerPed = PlayerPedId();
        local playerPos = GetEntityCoords(playerPed);
        if (not IsModelAPed(GetEntityModel(playerPed))) then
            goto skip;
        end
        
        if (aTattoos.playerVars.menuOpened) then
            goto skip;
        end
        
        for _, shop in pairs(aTattoos.config.shops) do
            local distance = #(playerPos - shop.position);
            if (distance < 9.5) then
                interval = 1.0;

                if (distance < 7.0) then
                    DrawMarker(markerCfg.type, (shop.position + vector3(0.0, 0.0, -0.95)), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, markerCfg.size.x, markerCfg.size.y, markerCfg.size.z, markerCfg.color[1] or 255, markerCfg.color[2] or 255, markerCfg.color[3] or 255, markerCfg.color[4] or 0.0);
                
                    if (distance < 0.8) then
                        ESX.ShowHelpNotification("~BLIP_TATTOO~ Appuyez sur ~INPUT_CONTEXT~ pour ouvrir");

                        if (IsControlJustPressed(0, 38)) then
                            aTattoos:openShop(shop, shop.type);
                        end
                    end
                end
            end
        end

        ::skip::
        Wait(interval);
    end
end)

---@public
---@param langName string
---@return string
function aTattoos:getTattooLabel(langName)
    local label = GetLabelText(langName);
    if (label ~= "NULL") then
        return label;
    end
    return ('Sans nom')
end

---@public
function aTattoos:loadBlips()
    for _, value in pairs(aTattoos.config.shops) do
        local b = AddBlipForCoord(value.position);
        SetBlipSprite(b, aTattoos.config.blipSettings.sprite);
        SetBlipColour(b, aTattoos.config.blipSettings.color);
        SetBlipScale(b, aTattoos.config.blipSettings.size);
        SetBlipAsShortRange(b, true);
        BeginTextCommandSetBlipName("STRING");
        AddTextComponentString(aTattoos:getTattooLabel("BLIP_TATTOO"));
        EndTextCommandSetBlipName(b);
    end
end

---@public
---@param shopId number
function aTattoos:openShop(settings, shopId)
    self.playerVars.actualShop = shopId;
    SetEntityHeading(PlayerPedId(), settings.skinCfg.heading);
    TattooShopMenu()
end

---@public
---@param tattoo table
---@param price number
---@return table
function aTattoos:getBtnStyle(tattoo, price)
    if (not playerHaveTattoo(tattoo.collection, tattoo.name)) then
        return { RightLabel = ('~g~%s $'):format(self:groupDigits(price)) };
    end
    return { RightBadge = RageUI.BadgeStyle.Tattoo };
end

---@public
---@param tattoo table
---@param price number
---@param callback function
function aTattoos:buyTattoo(tattoo, price, callback)
    ESX.TriggerServerCallback('aTattoos:player:manageTattoo', function(response)
        callback(response);
    end, true, price, tattoo, aTattoos.playerVars.ownedTattoos, aTattoos.playerVars.actualShop)
end

---@public
---@param tattoo table
---@param callback function
function aTattoos:buyRemoval(tattoo, callback)
    ESX.TriggerServerCallback('aTattoos:player:manageTattoo', function(response)
        callback(response);
    end, false, aTattoos.config.removingPrice, tattoo, aTattoos.playerVars.ownedTattoos, aTattoos.playerVars.actualShop)
end
