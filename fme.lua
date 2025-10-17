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

-- Create Main Tab
local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "home"
})

-- Fishing Section
local FishingSection = MainTab:AddSection("Fishing")

local AutoFishingToggle = MainTab:AddToggle("AutoFishing", {
    Title = "Auto Fishing",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFishing = Value
        print("Auto Fishing:", Value)

        -- Add your auto fishing code here later
        if Value then
            print("Auto Fishing enabled!")
        else
            print("Auto Fishing disabled!")
        end
    end
})

-- Player Section
local PlayerSection = MainTab:AddSection("Player")

local InfiniteJumpToggle = MainTab:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
        print("Infinite Jump:", Value)

        -- Infinite Jump code
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if getgenv().InfiniteJump then
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        end
    end
})

print("Rhot loaded successfully!")
