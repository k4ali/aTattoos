--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]
---@enum tattooCategory

TATTOO_CATEGORY = {
    ["Tête"] = {
        label = 'Tête',
        zone = 'ZONE_HEAD',
        cat = aTattoos.loadedTattoos.zone_head
    },
    ["Torse"] = {
        label = 'Torse',
        zone = 'ZONE_TORSO',
        cat = aTattoos.loadedTattoos.zone_torso
    },
    ["Bras gauche"] = {
        label = 'Bras gauche',
        zone = 'ZONE_LEFT_ARM',
        cat = aTattoos.loadedTattoos.zone_leftarm
    },
    ["Bras droit"] = {
        label = 'Bras droit',
        zone = 'ZONE_RIGHT_ARM',
        cat = aTattoos.loadedTattoos.zone_rightarm
    },
    ["Jambe gauche"] = {
        label = 'Jambe gauche',
        zone = 'ZONE_LEFT_LEG',
        cat = aTattoos.loadedTattoos.zone_leftleg
    },
    ["Jambe droit"] = {
        label = 'Jambe droit',
        zone = 'ZONE_RIGHT_LEG',
        cat = aTattoos.loadedTattoos.zone_rightleg
    },
}