-- Fish Game - Lite Version
-- Created with Fluent UI Library

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Rhot",
    SubTitle = "Lite Version",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- Set to false for better performance and compatibility
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl -- Minimize with Left Ctrl
})

-- Make window draggable
local gui = game:GetService("CoreGui"):FindFirstChild("Fluent") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Fluent")
if gui then
    local frame = gui:FindFirstChildWhichIsA("Frame", true)
    if frame then
        frame.Draggable = true
        frame.Active = true
    end
end

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

-- Infinite Jump Connection
local InfiniteJumpConnection

local InfiniteJumpToggle = MainTab:AddToggle("InfiniteJump", {
    Title = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        getgenv().InfiniteJump = Value
        print("Infinite Jump:", Value)

        -- Infinite Jump code
        if Value then
            -- Disconnect old connection if exists
            if InfiniteJumpConnection then
                InfiniteJumpConnection:Disconnect()
            end

            -- Create new connection
            InfiniteJumpConnection = game:GetService("UserInputService").JumpRequest:Connect(function()
                if getgenv().InfiniteJump then
                    local character = game.Players.LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                        end
                    end
                end
            end)
            print("Infinite Jump activated!")
        else
            -- Disconnect when disabled
            if InfiniteJumpConnection then
                InfiniteJumpConnection:Disconnect()
                InfiniteJumpConnection = nil
            end
            print("Infinite Jump deactivated!")
        end
    end
})

print("Rhot loaded successfully!")
