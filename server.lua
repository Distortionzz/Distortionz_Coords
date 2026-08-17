-- =====================================================================
--  Distortionz Coords - Server
--  Only consulted when Config.Tool.ace is set (optional restriction).
-- =====================================================================

lib.callback.register('distortionz_coords:server:canUse', function(source)
    if not Config.Tool.ace then return true end
    return IsPlayerAceAllowed(source, Config.Tool.ace) == true
end)

CreateThread(function()
    Wait(1000)
    print(('^5[%s]^7 ^2v%s loaded — keybind=%s ace=%s^7'):format(
        Config.ResourceName,
        Config.CurrentVersion,
        Config.Tool.keybind ~= '' and Config.Tool.keybind or 'none',
        tostring(Config.Tool.ace)
    ))
end)
