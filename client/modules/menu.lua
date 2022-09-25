--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

---@private
local callbackReceived = true;

---@public
---@return boolean, number?
function playerHaveTattoo(collection, name)
    for id, tattoo in pairs(aTattoos.playerVars.ownedTattoos) do
        if (tattoo.collection == collection and tattoo.name == name) then
            return true, id;
        end
    end
    return false;
end

---@public
---@param collection string
---@param hashName string
function PreviewTattoo(collection, hashName)
    local ped = PlayerPedId();
    local haveTattoo, _ = playerHaveTattoo(collection, hashName)
    
    ClearPedDecorations(ped);
    if (not haveTattoo) then
        ApplyPedOverlay(ped, GetHashKey(collection), GetHashKey(hashName))
    end
    
    if (#aTattoos.playerVars.ownedTattoos > 0) then
        for _, tattoo in pairs(aTattoos.playerVars.ownedTattoos) do
            ApplyPedOverlay(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
    end
end

---@public
---@param collection string
---@param hashName string
function ApplyTattoo(collection, hashName)
    local ped = PlayerPedId();

    if (#aTattoos.playerVars.ownedTattoos > 0) then
        for _, tattoo in pairs(aTattoos.playerVars.ownedTattoos) do
            if (tattoo.collection ~= collection and tattoo.name ~= hashName) then
                ApplyPedOverlay(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
            end
        end
    end

    ApplyPedOverlay(ped, GetHashKey(collection), GetHashKey(hashName));
    table.insert(aTattoos.playerVars.ownedTattoos, { collection = collection, name = hashName })
end

---@public
---@param collection string
---@param hashName string
function RemoveTattoo(collection, hashName)
    local ped = PlayerPedId();
    local haveTattoo, id = playerHaveTattoo(collection, hashName)
    ClearPedDecorationsLeaveScars(ped)

    if (haveTattoo) then
        table.remove(aTattoos.playerVars.ownedTattoos, id);
    end

    if (#aTattoos.playerVars.ownedTattoos > 0) then
        for _, tattoo in pairs(aTattoos.playerVars.ownedTattoos) do
            if (tattoo.collection ~= collection and tattoo.name ~= hashName) then
                ApplyPedOverlay(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
            end
        end
    end
end

---@public
function cleanPreviewTattoos()
    local ped = PlayerPedId();
    ClearPedDecorationsLeaveScars(ped)

    if (#aTattoos.playerVars.ownedTattoos > 0) then
        for _, tattoo in pairs(aTattoos.playerVars.ownedTattoos) do
            ApplyPedOverlay(ped, GetHashKey(tattoo.collection), GetHashKey(tattoo.name))
        end
    end
end

---@public
function TattooShopMenu()
    local model = GetEntityModel(PlayerPedId());

    local main = RageUI.CreateMenu('', (TATTOO_SHOPS[aTattoos.playerVars.actualShop].label or 'Tattoo Shop'));
    local subs = {};
    for index, cat in pairs(TATTOO_CATEGORY) do
        subs[cat.label] = RageUI.CreateSubMenu(main, '', cat.label);
        subs[cat.label].Closed = function()
            cleanPreviewTattoos();
            aTattoos.camera:setCamValues({ zoom = 0.0, offset = 0.0 });
        end

        if (TATTOO_SHOPS[aTattoos.playerVars.actualShop]) then
            subs[cat.label]:SetSpriteBanner(aTattoos.config.headersDictionnary, ('txt_header_%s'):format(TATTOO_SHOPS[aTattoos.playerVars.actualShop].headerTxt));
        end
    end

    if (TATTOO_SHOPS[aTattoos.playerVars.actualShop]) then
        main:SetSpriteBanner(aTattoos.config.headersDictionnary, ('txt_header_%s'):format(TATTOO_SHOPS[aTattoos.playerVars.actualShop].headerTxt));
    end

    aTattoos.utils:setPlayerNaked();
    aTattoos.camera:StartCam();

    aTattoos.utils:createMenu({ menu = main }, function ()
        RageUI.IsVisible(main, function ()
            for _,category in pairs(TATTOO_CATEGORY) do
                RageUI.Button(category.label, nil, { RightLabel = "→" }, true, {
                    onSelected = function()
                        aTattoos.playerVars.actualCat = category.label;
                        aTattoos.camera:setCamValues({ zoom = ZONES_CAM_SETTINGS[category.zone].zoom, offset = ZONES_CAM_SETTINGS[category.zone].height });
                    end
                }, (subs[category.label] or nil));
            end
        end);

        for key, sub in pairs(subs) do
            RageUI.IsVisible(sub, function()
                if (aTattoos.playerVars.actualCat == key) then
                    if (TATTOO_CATEGORY[key]) then
                        for _, tattoo in pairs(TATTOO_CATEGORY[key].cat) do
                            ---@enum Gender
                            local Gender_sort = {
                                [1885233650] = tattoo.HashNameMale,
                                [-1667301416] = tattoo.HashNameFemale
                            }

                            if (Gender_sort[model] and Gender_sort[model] ~= "") then
                                local price = (math.floor(tattoo.Price / aTattoos.config.priceDemultiplier) or 1000);

                                RageUI.Button(aTattoos:getTattooLabel(tattoo.Name), nil, aTattoos:getBtnStyle({ name = Gender_sort[model], collection = tattoo.Collection }, price), callbackReceived, {
                                    onSelected = function()
                                        local haveTattoo, id = playerHaveTattoo(tattoo.Collection, Gender_sort[model])
                                        callbackReceived = false;

                                        if (not haveTattoo) then
                                            aTattoos:buyTattoo({
                                                collection = tattoo.Collection,
                                                name = Gender_sort[model]
                                            }, tonumber(price), function (response)
                                                callbackReceived = true;

                                                if (response) then
                                                    ApplyTattoo(tattoo.Collection, Gender_sort[model]);
                                                end
                                            end)
                                        else
                                            aTattoos:buyRemoval(id, function (response)
                                                callbackReceived = true;

                                                if (response) then
                                                    RemoveTattoo(tattoo.Collection, Gender_sort[model])
                                                end
                                            end)
                                        end
                                    end,
    
                                    onActive = function ()
                                        Gender_sort = {
                                            [1885233650] = tattoo.HashNameMale,
                                            [-1667301416] = tattoo.HashNameFemale
                                        }

                                        local haveTattoo, id = playerHaveTattoo(tattoo.Collection, Gender_sort[model])
                                        if (haveTattoo) then
                                            RageUI.Info('Retirer tatouage~s~', { ('Prix: ~r~%s $'):format(math.floor(aTattoos.config.removingPrice)) }, { '' })
                                        end

                                        PreviewTattoo(tattoo.Collection, Gender_sort[model]);
                                    end,
                                })
                            end
                        end
                    end
                end
            end)
        end

        aTattoos.camera:setPlayerControls();
    end)
end