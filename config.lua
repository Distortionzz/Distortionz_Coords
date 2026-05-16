Config = {}

Config.Debug = false

Config.ResourceName   = 'distortionz_coords'
Config.CurrentVersion = '1.1.4'

-- ─── Version checker ────────────────────────────────────────────────
Config.VersionCheck = {
    enabled      = true,
    url          = 'https://raw.githubusercontent.com/Distortionzz/Distortionz_Coords/main/version.json',
    checkOnStart = true,
}

-- ─── Notify integration ─────────────────────────────────────────────
Config.Notify = {
    title                 = 'Coords',
    useDistortionzNotify  = true,
}

-- ─── Tool ───────────────────────────────────────────────────────────
Config.Tool = {
    command   = 'coords',     -- /coords still toggles the laser too
    -- Default key to toggle the laser on/off. Rebindable in FiveM
    -- Settings → Key Bindings → "Toggle coords laser". '' = no key.
    keybind   = 'F7',

    -- Optional ace gate. false = anyone. e.g. 'command.coords' and grant
    -- it to your dev/admin group.
    ace       = false,

    rayDist   = 100.0,        -- max laser distance (m)
    decimals  = 2,            -- coord rounding in the copy string

    copyKey   = 38,           -- control id to copy (38 = E)
    copyMode  = 'vec4',       -- 'vec4' | 'vec3' — what the copy key grabs

    laserColor = { r = 255, g = 30, b = 42 },   -- Distortionz red
}
