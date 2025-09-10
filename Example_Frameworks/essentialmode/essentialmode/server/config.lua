--[[
    -- Type: Config
    -- Name: ServerConfig
    -- Use: Shared state and default settings for EssentialMode
    -- Created: 09/10/2025
    -- By: VSSVSSN
--]]

Users = Users or {}
commands = commands or {}
settings = settings or {
    defaultSettings = {
        banReason = 'You are currently banned. Please go to: insertsite.com/bans',
        pvpEnabled = false,
        permissionDenied = false,
        debugInformation = false,
        startingCash = 0,
        enableRankDecorators = false
    },
    sessionSettings = {}
}

