-- Simple Remote Logger for Delta Executor
-- Run this BEFORE your heavy script

print("=== Remote Logger Starting ===")

-- Store all remote calls
getgenv().RemoteLog = {}
local logCount = 0

-- Hook into remote calls
local old
old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" or method == "InvokeServer" then
        logCount = logCount + 1

        local remotePath = self:GetFullName()

        print(string.format("[Remote #%d] %s:%s()", logCount, remotePath, method))

        -- Store in log
        table.insert(getgenv().RemoteLog, {
            Number = logCount,
            Path = remotePath,
            Method = method,
            Args = args,
            Time = os.time()
        })
    end

    return old(self, ...)
end))

print("=== Remote Logger Active! ===")
print("Now run your heavy script and use its features")
print("Type 'showlogs()' to see all captured remotes")
print("")

-- Function to display all logs
getgenv().showlogs = function()
    print("\n========== CAPTURED REMOTES ==========")
    if #getgenv().RemoteLog == 0 then
        print("No remotes captured yet!")
        return
    end

    for i, log in ipairs(getgenv().RemoteLog) do
        print(string.format("\n--- Remote #%d ---", log.Number))
        print("Path: " .. log.Path)
        print("Method: " .. log.Method)

        -- Print arguments
        if #log.Args > 0 then
            print("Arguments:")
            for j, arg in ipairs(log.Args) do
                print(string.format("  [%d] = %s", j, tostring(arg)))
            end
        else
            print("Arguments: (none)")
        end
    end
    print("\n========== END OF LOG ==========")
    print(string.format("Total remotes captured: %d", #getgenv().RemoteLog))
end

-- Function to copy all logs as Lua code
getgenv().copylogs = function()
    local output = "-- Captured Remote Calls\n\n"

    for i, log in ipairs(getgenv().RemoteLog) do
        output = output .. string.format("-- Remote #%d\n", log.Number)

        if log.Method == "FireServer" then
            output = output .. string.format('game:GetService("ReplicatedStorage").%s:FireServer(', log.Path:split("ReplicatedStorage.")[2] or log.Path)
        else
            output = output .. string.format('game:GetService("ReplicatedStorage").%s:InvokeServer(', log.Path:split("ReplicatedStorage.")[2] or log.Path)
        end

        -- Add args
        for j, arg in ipairs(log.Args) do
            if type(arg) == "string" then
                output = output .. string.format('"%s"', arg)
            else
                output = output .. tostring(arg)
            end
            if j < #log.Args then
                output = output .. ", "
            end
        end

        output = output .. ")\n\n"
    end

    if setclipboard then
        setclipboard(output)
        print("✓ All logs copied to clipboard!")
    else
        print(output)
    end
end

print("Commands:")
print("  showlogs() - Display all captured remotes")
print("  copylogs() - Copy all remotes as Lua code")
