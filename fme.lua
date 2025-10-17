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

-- Make window draggable without moving camera
task.wait(0.5) -- Wait for UI to fully load

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local gui = game:GetService("CoreGui"):FindFirstChild("Fluent") or Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Fluent")

if gui then
    local frame = gui:FindFirstChildWhichIsA("Frame", true)
    if frame then
        frame.Draggable = true
        frame.Active = true

        -- Block mouse input from affecting the game when hovering over GUI
        local isHovering = false

        frame.MouseEnter:Connect(function()
            isHovering = true
        end)

        frame.MouseLeave:Connect(function()
            isHovering = false
        end)

        -- Prevent camera from moving when GUI is being interacted with
        RunService.RenderStepped:Connect(function()
            if isHovering then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end)
    end
end

-- Create Main Tab
local MainTab = Window:AddTab({
    Title = "Main",
    Icon = "home"
})

-- Fishing Section
local FishingSection = MainTab:AddSection("Fishing")

-- Auto Fishing Variables
local AutoFishingLoop

local AutoFishingToggle = MainTab:AddToggle("AutoFishing", {
    Title = "Auto Fishing",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFishing = Value
        print("Auto Fishing:", Value)

        if Value then
            print("Auto Fishing enabled!")

            -- Start auto fishing loop
            AutoFishingLoop = task.spawn(function()
                while getgenv().AutoFishing do
                    -- Step 1: Equip fishing rod from hotbar slot 1
                    local equipArgs = {[1] = 1}
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RE/EquipToolFromHotbar"):FireServer(unpack(equipArgs))

                    task.wait(0.5) -- Wait a bit for rod to equip

                    -- Step 2: Cast the fishing rod with charge power
                    local castArgs = {[1] = 1756863567.2171}
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RF/ChargeFishingRod"):InvokeServer(unpack(castArgs))

                    task.wait(0.3) -- Wait before completing

                    -- Step 3: Complete fishing (catch the fish)
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RE/FishingCompleted"):FireServer()

                    task.wait(0.5) -- Wait before next cycle
                end
            end)
        else
            print("Auto Fishing disabled!")
            getgenv().AutoFishing = false

            -- Stop the loop
            if AutoFishingLoop then
                task.cancel(AutoFishingLoop)
                AutoFishingLoop = nil
            end
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
