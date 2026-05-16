-- =====================================================================
--  Distortionz Coords - Client
--  /coords toggles a camera laser. Point at anything to read its live
--  coords; press the copy key to copy vec4/vec3 to clipboard.
-- =====================================================================

local active = false

local function DebugPrint(message)
    if Config.Debug then
        print(('[%s:client] %s'):format(Config.ResourceName, message))
    end
end

-- ─── Notify wrapper ─────────────────────────────────────────────────

local function Notify(message, status, duration)
    status   = status or 'info'
    duration = duration or 4000

    if Config.Notify.useDistortionzNotify and GetResourceState('distortionz_notify') == 'started' then
        local ok = pcall(function()
            exports['distortionz_notify']:Notify(message, status, duration)
        end)
        if ok then return end
        ok = pcall(function()
            exports['distortionz_notify']:Send(message, status, duration)
        end)
        if ok then return end
        ok = pcall(function()
            TriggerEvent('distortionz_notify:client:notify', message, status, duration)
        end)
        if ok then return end
    end

    lib.notify({
        title       = Config.Notify.title,
        description = message,
        type        = status,
        duration    = duration,
    })
end

-- ─── Helpers ────────────────────────────────────────────────────────

local function RotationToDirection(rot)
    local rx, rz = math.rad(rot.x), math.rad(rot.z)
    local cosrx  = math.abs(math.cos(rx))
    return vec3(-math.sin(rz) * cosrx, math.cos(rz) * cosrx, math.sin(rx))
end

local function Round(n, d)
    local m = 10 ^ (d or 2)
    return math.floor(n * m + 0.5) / m
end


local function CastRay()
    local cam = GetGameplayCamCoord()
    local dir = RotationToDirection(GetGameplayCamRot(2))
    local dest = cam + dir * Config.Tool.rayDist
    local handle = StartExpensiveSynchronousShapeTestLosProbe(
        cam.x, cam.y, cam.z, dest.x, dest.y, dest.z, -1, PlayerPedId(), 7)
    local _, hit, endCoords, _, entity = GetShapeTestResult(handle)
    if hit == 1 then
        return endCoords, entity
    end
    return dest, 0
end

local function EntityLabel(entity)
    -- GetEntityModel hard-crashes the game on shapetest map handles, so
    -- it is deliberately NOT used here. Type + heading only.
    if not entity or entity == 0 or not DoesEntityExist(entity) then return nil end
    local kind = 'Object'
    if IsEntityAPed(entity) then
        kind = IsPedAPlayer(entity) and 'Player' or 'Ped'
    elseif IsEntityAVehicle(entity) then
        kind = 'Vehicle'
    end
    return ('%s · heading %.1f'):format(kind, GetEntityHeading(entity))
end

-- ─── Loop ───────────────────────────────────────────────────────────

local function buildString(coords, heading, mode)
    local d = Config.Tool.decimals
    if mode == 'vec3' then
        return ('vec3(%s, %s, %s)'):format(Round(coords.x, d), Round(coords.y, d), Round(coords.z, d))
    end
    return ('vec4(%s, %s, %s, %s)'):format(
        Round(coords.x, d), Round(coords.y, d), Round(coords.z, d), Round(heading, 2))
end

-- If the laser hit an entity, report THAT object's coords + heading.
-- Otherwise fall back to the world surface point + the player's heading.
local function ResolveTarget(hitPos, entity)
    if entity and entity ~= 0 and DoesEntityExist(entity) then
        return GetEntityCoords(entity), GetEntityHeading(entity), true
    end
    return hitPos, GetEntityHeading(PlayerPedId()), false
end

CreateThread(function()
    local lc = Config.Tool.laserColor
    local lastPush = 0
    while true do
        if active then
            local hitPos, entity = CastRay()
            local cam = GetGameplayCamCoord()
            local tgt, hd, isEnt = ResolveTarget(hitPos, entity)

            -- Laser/marker stay on the aim point (visual feedback);
            -- the readout/copy use the resolved target (object if hit).
            DrawLine(cam.x, cam.y, cam.z, hitPos.x, hitPos.y, hitPos.z, lc.r, lc.g, lc.b, 200)
            DrawMarker(28, hitPos.x, hitPos.y, hitPos.z, 0, 0, 0, 0, 0, 0,
                0.12, 0.12, 0.12, lc.r, lc.g, lc.b, 160, false, false, 2, false)

            if IsControlJustPressed(0, Config.Tool.copyKey) then
                local str = buildString(tgt, hd, Config.Tool.copyMode)
                pcall(function() lib.setClipboard(str) end)
                print(('[%s] %s'):format(Config.ResourceName, str))
                print(('[%s] %s'):format(Config.ResourceName, buildString(tgt, hd, 'vec3')))
                Notify('Copied: ' .. str, 'success', 3000)
                SendNUIMessage({ action = 'flash' })
            end

            -- Throttled NUI push (world draws stay per-frame above).
            local now = GetGameTimer()
            if now - lastPush >= 80 then
                lastPush = now
                SendNUIMessage({
                    action   = 'update',
                    version  = Config.CurrentVersion,
                    x        = tgt.x,
                    y        = tgt.y,
                    z        = tgt.z,
                    vec4     = ('vec4(%.2f, %.2f, %.2f, %.1f)'):format(tgt.x, tgt.y, tgt.z, hd),
                    entity   = isEnt and (EntityLabel(entity) .. ' — object coords')
                                       or '(world surface)',
                    copyMode = Config.Tool.copyMode,
                    cmd      = Config.Tool.command,
                })
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

-- ─── Toggle ─────────────────────────────────────────────────────────

local function Toggle()
    if Config.Tool.ace then
        local allowed = lib.callback.await('distortionz_coords:server:canUse', false)
        if not allowed then
            Notify('You are not allowed to use this.', 'error', 4000)
            return
        end
    end
    active = not active
    if active then
        SendNUIMessage({ action = 'show', version = Config.CurrentVersion })
    else
        SendNUIMessage({ action = 'hide' })
    end
    Notify(active and 'Laser ON — point at something. [E] to copy.'
        or 'Laser OFF.', active and 'info' or 'inform', 3000)
end

RegisterCommand(Config.Tool.command, Toggle, false)

if Config.Tool.keybind and Config.Tool.keybind ~= '' then
    RegisterKeyMapping(Config.Tool.command, 'Toggle coords laser', 'keyboard', Config.Tool.keybind)
end

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        active = false
        SendNUIMessage({ action = 'hide' })
    end
end)
