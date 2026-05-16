-- =====================================================================
--  Distortionz Coords - Server
--  Only consulted when Config.Tool.ace is set (optional restriction).
-- =====================================================================

lib.callback.register('distortionz_coords:server:canUse', function(source)
    if not Config.Tool.ace then return true end
    return IsPlayerAceAllowed(source, Config.Tool.ace) == true
end)
