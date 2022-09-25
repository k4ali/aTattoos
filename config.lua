--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

---@type table
aTattoos.config = {
    headersDictionnary = 'headers',
    priceDemultiplier = 9.0,
    removingPrice = 1000,

    blipSettings = {
        sprite = 75,
        color = 1,
        size = 0.5,
    },
    
    markerSettings = {
        type = 1,
        size = { x = 1.7, y = 1.7, z = 0.75 },
        color = { 255, 255, 255, 50 }
    },

    shops = {
        {
            type = 1,
            position = vector3(1324.09, -1652.65, 52.28),
            skinCfg = {
                heading = 77.77
            }
        },
        {
            type = 2,
            position = vector3(322.14, 181.93, 103.59),
            skinCfg = {
                heading = 208.8
            }
        },
        {
            type = 5,
            position = vector3(-1152.93, -1426.12, 4.95),
            skinCfg = {
                heading = 81.57
            }
        },
        {
            type = 3,
            position = vector3(-3171.24, 1075.52, 20.83),
            skinCfg = {
                heading = 284.97
            }
        },
        {
            type = 4,
            position = vector3(1864.33, 3747.86, 33.03),
            skinCfg = {
                heading = 3.35
            }
        },
        {
            type = 4,
            position = vector3(-294.02, 6199.74, 31.49),
            skinCfg = {
                heading = 207.19
            }
        },
    },

    nakedStateClothes = {
        male = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 18, ['pants_2'] = 0,
            ['shoes_1'] = 34, ['shoes_2'] = 0,
            ['helmet_1'] = -1,
            ['glasses_1'] = 0,
            ['chain_1'] = 0
        },
        
        female = {
            ['tshirt_1'] = 15, ['tshirt_2'] = 0,
            ['torso_1'] = 15, ['torso_2'] = 0,
            ['arms'] = 15,
            ['pants_1'] = 17, ['pants_2'] = 1,
            ['shoes_1'] = 35, ['shoes_2'] = 0,
            ['helmet_1'] = -1,
            ['glasses_1'] = 5,
            ['chain_1'] = 0
        },
    }
}