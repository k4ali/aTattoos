--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

local ESX;

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj)
    ESX = obj;
end)

aTattoos.utils = {}

---@public
---@param data table
---@param callback function
function aTattoos.utils:createMenu(data, callback)
    if (data.menu) then
        data.menu.Closed = function ()
            aTattoos.playerVars.menuOpened = false;
        end
    end

    if (aTattoos.playerVars.menuOpened) then
        aTattoos.playerVars.menuOpened = false;
        RageUI.CloseAll() Wait(50.0);
        return;
    end

    Wait(100.0);
    aTattoos.playerVars.menuOpened = true;
    CreateThread(function ()
        RageUI.Visible(data.menu, true);
        
        while (aTattoos.playerVars.menuOpened) do
            if (callback) then
                callback();
            end

            Wait(1.0);
        end

        aTattoos.playerVars.menuOpened = false;
        aTattoos.playerVars.actualShop = nil;
        FreezeEntityPosition(PlayerPedId(), false);
        aTattoos.utils:resetSkin();
        aTattoos.camera:EndCam();
    end)
end

---@public
function aTattoos.utils:setPlayerNaked()
    local nakedSexe = aTattoos.config.nakedStateClothes.male;
    local authorizedModels = {
        [-1667301416] = true,
        [1885233650] = true,
    };

    if (not authorizedModels[GetEntityModel(PlayerPedId())]) then
        return;
    end
    
    TriggerEvent('::{korioz#0110}::skinchanger:getSkin', function (playerSkin)
        if (playerSkin['sex'] == 1) then
            nakedSexe = aTattoos.config.nakedStateClothes.female;
        end

        TriggerEvent('::{korioz#0110}::skinchanger:loadClothes', playerSkin, nakedSexe);
    end)
end

---@public
function aTattoos.utils:resetSkin(removeDecorations)
    if (removeDecorations) then
        ClearPedDecorations(PlayerPedId())
    end
    
    ESX.TriggerServerCallback('::{korioz#0110}::esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('::{korioz#0110}::skinchanger:loadSkin', (skin or {  }));
    end)
end