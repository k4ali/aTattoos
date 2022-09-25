--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

fx_version 'cerulean';
games { 'gta5' };
lua_54 'yes';
use_fxv2_oal 'yes';

author '.revengeback';
version '1.0.0';

files { 'data/*.json' };
shared_scripts { 'common/main.lua', 'config.lua', 'enums/*.lua' };

server_scripts
{
    '@mysql-async/lib/MySQL.lua',
    'server/main.lua',
    'server/modules/*.lua'
};

client_scripts
{
    'client/RageUI/RMenu.lua',
    'client/RageUI/menu/RageUI.lua',
    'client/RageUI/menu/Menu.lua',
    'client/RageUI/menu/MenuController.lua',
    'client/RageUI/components/*.lua',
    'client/RageUI/menu/elements/*.lua',
    'client/RageUI/menu/items/*.lua',
    'client/RageUI/menu/panels/*.lua',
    'client/RageUI/menu/windows/*.lua',
    'client/utils.lua',
    'client/main.lua',
    'client/camera.lua',
    'client/modules/*.lua'
};