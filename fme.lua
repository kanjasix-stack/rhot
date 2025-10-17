-- Fish Game - Lite Version
-- Created with Fluent UI Library

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Rhot",
    SubTitle = "Lite Version",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, set this to false if you want
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Minimize with Left Ctrl
})

-- We'll add tabs and features later
print("Rhot loaded successfully!")

-- Keep the UI running
game:GetService("RunService").Heartbeat:Wait()
