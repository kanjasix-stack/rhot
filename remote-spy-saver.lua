-- Remote Spy with Auto-Save to File
-- This will save ALL remote calls to a file you can read later

warn("=== Remote Spy File Saver Starting ===")

-- Check if writefile is supported
if not writefile then
    warn("ERROR: Your executor doesn't support writefile!")
    warn("Delta should support this, but if not, try another method")
    return
end

-- Check if hookmetamethod is supported
if not hookmetamethod then
    warn("ERROR: Your executor doesn't support hookmetamethod!")
    return
end

-- Create log storage
local allLogs = {}
local logCount = 0
local fileName = "RemoteSpyLogs.txt"

-- Clear old file
writefile(fileName, "=== REMOTE SPY LOGS ===\n")
writefile(fileName, "Started at: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")

warn("File created: " .. fileName)
warn("All remotes will be saved automatically!")

-- Hook remote calls
local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" or method == "InvokeServer" then
        logCount = logCount + 1

        local remotePath = tostring(self)
        local remoteFullPath = self:GetFullName()

        -- Build log entry
        local logEntry = string.format("\n========== Remote #%d ==========\n", logCount)
        logEntry = logEntry .. "Path: " .. remoteFullPath .. "\n"
        logEntry = logEntry .. "Method: " .. method .. "\n"

        -- Log arguments
        if #args > 0 then
            logEntry = logEntry .. "Arguments:\n"
            for i, arg in ipairs(args) do
                local argType = type(arg)
                local argValue = tostring(arg)

                if argType == "string" then
                    logEntry = logEntry .. string.format('  [%d] = "%s" (string)\n', i, argValue)
                elseif argType == "number" then
                    logEntry = logEntry .. string.format('  [%d] = %s (number)\n', i, argValue)
                elseif argType == "boolean" then
                    logEntry = logEntry .. string.format('  [%d] = %s (boolean)\n', i, argValue)
                else
                    logEntry = logEntry .. string.format('  [%d] = %s (%s)\n', i, argValue, argType)
                end
            end
        else
            logEntry = logEntry .. "Arguments: (none)\n"
        end

        -- Generate ready-to-use code
        logEntry = logEntry .. "\n-- Ready to use code:\n"
        logEntry = logEntry .. remoteFullPath .. ":" .. method .. "("

        if #args > 0 then
            for i, arg in ipairs(args) do
                if type(arg) == "string" then
                    logEntry = logEntry .. string.format('"%s"', arg)
                else
                    logEntry = logEntry .. tostring(arg)
                end
                if i < #args then
                    logEntry = logEntry .. ", "
                end
            end
        end

        logEntry = logEntry .. ")\n"

        -- Save to file
        appendfile(fileName, logEntry)

        -- Also print to console (yellow text)
        warn(string.format("[Remote #%d] %s:%s()", logCount, remotePath, method))
    end

    return old(self, ...)
end)

warn("=== Remote Spy Active! ===")
warn("✓ All remotes are being saved to: " .. fileName)
warn("✓ Use your heavy script now")
warn("✓ When done, check workspace folder for the file")
warn("")

-- Function to show file location
_G.showfile = function()
    warn("File saved at: " .. fileName)
    warn("Total remotes captured: " .. logCount)
    warn("Check your executor's workspace folder!")
end

-- Auto-save summary every 10 seconds
task.spawn(function()
    while true do
        task.wait(10)
        if logCount > 0 then
            local summary = string.format("\n[Auto-Save] Total remotes captured so far: %d\n", logCount)
            appendfile(fileName, summary)
        end
    end
end)

warn("Commands available:")
warn("  showfile() - Show file location and count")
