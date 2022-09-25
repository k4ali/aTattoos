--[[
    This file is a part of aTattoos.
    Credits: .akisora (zRevenge - revengeback).
    Copyright (c) 2022 - All rights reserved;
]]

local angleZisSet = false;
aTattoos.camera = {}
aTattoos.camera.cam, aTattoos.camera.angleY, aTattoos.camera.angleZ, aTattoos.camera.supOffset, aTattoos.camera.supZoom = nil, 0.0, 0.0, 0.0, 0.0;

---@public
function aTattoos.camera:setPlayerControls()
    if (aTattoos.camera.cam) then
        if (not angleZisSet) then
            aTattoos.camera.angleZ = (GetEntityHeading(PlayerPedId()) - 265.0);
            angleZisSet = true;
        end
        
        self:ProcessCamControls()
    end
    
    if (aTattoos.playerVars.actualShop ~= nil) then
        DisableControlAction(2, 30, true)
        DisableControlAction(2, 31, true)
        DisableControlAction(2, 32, true)
        DisableControlAction(2, 33, true)
        DisableControlAction(2, 34, true)
        DisableControlAction(2, 35, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 24, true)
        DisableControlAction(0, 25, true)
        DisableControlAction(0, 47, true)
        DisableControlAction(0, 58, true)
        DisableControlAction(0, 263, true)
        DisableControlAction(0, 264, true)
        DisableControlAction(0, 257, true)
        DisableControlAction(0, 140, true)
        DisableControlAction(0, 141, true)
        DisableControlAction(0, 142, true)
        DisableControlAction(0, 143, true)
        DisableControlAction(0, 75, true)
        DisableControlAction(27, 75, true)
        DisableControlAction(0, 60, true)
    end
end

---@public
---@param data table
function aTattoos.camera:setCamValues(data)
    if (data.zoom) then
        aTattoos.camera.supZoom = data.zoom

        if (data.zoom ~= aTattoos.camera.supZoom) then
            aTattoos.camera.supZoom = data.zoom
        end
    end

    if (data.offset) then
        aTattoos.camera.supOffset = data.offset

        if (data.offset ~= aTattoos.camera.supOffset) then
            aTattoos.camera.supOffset = data.offset
        end
    end
end

function aTattoos.camera:StartCam()
    ClearFocus()

    local playerPed = PlayerPedId()

    aTattoos.camera.cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", (GetEntityCoords(playerPed) + vector3(0.0, 0.0, 0.3)), 0, 0, 0)
    SetCamActive(aTattoos.camera.cam, true)
    RenderScriptCams(true, true, 550, true, false)
end

function aTattoos.camera:EndCam()
    ClearFocus()
    
    local playerPed = PlayerPedId()
    RenderScriptCams(false, true, 500, true, false)
    DestroyCam(aTattoos.camera.cam, false)
    
    aTattoos.camera.cam = nil;
    angleZisSet = false;
end

function aTattoos.camera:ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    -- disable 1st person as the 1st person camera can cause some glitches
    DisableFirstPersonCamThisFrame()
    
    -- calculate new position
    local newPos = self:ProcessNewPosition()

    -- focus cam area
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    
    SetCamCoord(aTattoos.camera.cam, newPos.x, newPos.y, newPos.z + aTattoos.camera.supOffset)
    SetCamFov(aTattoos.camera.cam, 80.0 - aTattoos.camera.supZoom)
    
    -- set rotation
    PointCamAtCoord(aTattoos.camera.cam, playerCoords.x, playerCoords.y, playerCoords.z + aTattoos.camera.supOffset)
end

function aTattoos.camera:ProcessNewPosition()
    local mouseX = 0.0;
    
    mouseX = GetDisabledControlNormal(1, 1) * 8.0
        
    aTattoos.camera.angleZ = (aTattoos.camera.angleZ - mouseX);

    local pCoords = GetEntityCoords(PlayerPedId())
    
    local behindCam = {
        x = pCoords.x + ((Cos(aTattoos.camera.angleZ) * Cos(aTattoos.camera.angleY)) + (Cos(aTattoos.camera.angleY) * Cos(aTattoos.camera.angleZ))) / 2 * (1.5 + 0.5),
        y = pCoords.y + ((Sin(aTattoos.camera.angleZ) * Cos(aTattoos.camera.angleY)) + (Cos(aTattoos.camera.angleY) * Sin(aTattoos.camera.angleZ))) / 2 * (1.5 + 0.5),
        z = pCoords.z + ((Sin(aTattoos.camera.angleY))) * (1.5 + 0.5)
    }

    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    local maxRadius = 1.5

    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 1.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end
    
    local offset = {
        x = ((Cos(aTattoos.camera.angleZ) * Cos(aTattoos.camera.angleY)) + (Cos(aTattoos.camera.angleY) * Cos(aTattoos.camera.angleZ))) / 2 * maxRadius,
        y = ((Sin(aTattoos.camera.angleZ) * Cos(aTattoos.camera.angleY)) + (Cos(aTattoos.camera.angleY) * Sin(aTattoos.camera.angleZ))) / 2 * maxRadius,
        z = ((Sin(aTattoos.camera.angleY))) * maxRadius
    }
    
    local camPos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }

    return (camPos);
end