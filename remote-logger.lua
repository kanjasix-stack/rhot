-- Simple Remote Logger for Delta Executor
-- Run this BEFORE your heavy script

warn("=== Remote Logger Starting ===")

-- Store all remote calls
_G.RemoteLog = {}
local logCount = 0

-- Check if hookmetamethod exists
if not hookmetamethod then
    warn("ERROR: Your executor doesn't support hookmetamethod!")
    warn("Try using Simple Spy instead")
    return
end

-- Hook into remote calls
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" or method == "InvokeServer" then
        logCount = logCount + 1

        local remotePath = tostring(self)

        warn("[Remote #" .. logCount .. "] " .. remotePath .. ":" .. method .. "()")

        -- Store in log
        table.insert(_G.RemoteLog, {
            Number = logCount,
            Path = remotePath,
            Method = method,
            Args = args
        })
    end

    return old(self, ...)
end)

warn("=== Remote Logger Active! ===")
warn("Now run your heavy script and use its features")
warn("All remotes will be printed in YELLOW text")
warn("")

-- Function to display all logs
_G.showlogs = function()
    warn("========== CAPTURED REMOTES ==========")
    if #_G.RemoteLog == 0 then
        warn("No remotes captured yet!")
        return
    end

    for i, log in ipairs(_G.RemoteLog) do
        warn("--- Remote #" .. log.Number .. " ---")
        warn("Path: " .. log.Path)
        warn("Method: " .. log.Method)

        -- Print arguments
        if #log.Args > 0 then
            warn("Arguments:")
            for j, arg in ipairs(log.Args) do
                warn("  [" .. j .. "] = " .. tostring(arg))
            end
        else
            warn("Arguments: (none)")
        end
    end
    warn("========== END OF LOG ==========")
    warn("Total remotes captured: " .. #_G.RemoteLog)
end

warn("Commands:")
warn("  showlogs() - Display all captured remotes")
