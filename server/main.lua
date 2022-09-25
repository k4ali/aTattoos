--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

local ESX;
TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) 
    ESX = obj;
end)

RegisterNetEvent('aTattoos:player:requestTattoos');
AddEventHandler('aTattoos:player:requestTattoos', function()
    local _source = source;
    local fetchQuery = "SELECT tattoos FROM `users` WHERE identifier = @identifier";

    local identifier = GetPlayerIdentifier(_source, 1);
    MySQL.Async.fetchScalar(fetchQuery, { ['@identifier'] = identifier }, function(result)
        TriggerClientEvent('aTattoos:player:requestTattoos', _source, (json.decode(result) or {}))
    end)
end)

ESX.RegisterServerCallback('aTattoos:player:manageTattoo', function(source, cb, addState, price, tattoo, playerTattoos, shopId)
    local player = ESX.GetPlayerFromId(source);
    local playerTattoos = (playerTattoos or {});
    local query = "UPDATE `users` SET `tattoos` = @tattoos WHERE identifier = @identifier";

    local strings = {
        [true] = ("~g~Merci pour votre achat chez (%s)"):format(TATTOO_SHOPS[shopId].label),
        [false] = "~y~Vous avez retiré(e) un tattouage"
    };

    if (not player) then
        return;
    end

    if (player.getAccount('cash').money >= price) then
        player.removeAccountMoney('cash', price);

        if (addState) then
            table.insert(playerTattoos, tattoo);
        else
            table.remove(playerTattoos, tattoo);
        end

        MySQL.Sync.execute(query, {
            ['@identifier'] = player.identifier,
            ['@tattoos'] = json.encode(playerTattoos)
        })

        TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, strings[addState]);
        cb(true);
    else
        TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~r~Pas assez d'argent")
        cb(false);
    end
end)