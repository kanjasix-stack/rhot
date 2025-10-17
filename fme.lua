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

-- Fluent UI handles dragging automatically, no additional code needed

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
                -- Step 1: Equip fishing rod ONCE at the start
                local equipArgs = {[1] = 1}
                game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RE/EquipToolFromHotbar"):FireServer(unpack(equipArgs))
                print("Fishing rod equipped!")

                task.wait(1) -- Wait for rod to equip

                local lastChargeTime = 0

                while getgenv().AutoFishing do
                    local currentTime = tick()

                    -- Step 2: Cast/Charge the fishing rod every 3 seconds
                    if currentTime - lastChargeTime >= 3 then
                        local castArgs = {[1] = 1756863567.2171}
                        game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RF/ChargeFishingRod"):InvokeServer(unpack(castArgs))
                        lastChargeTime = currentTime
                        print("Fishing rod charged!")
                    end

                    -- Step 3: Complete fishing continuously (loop)
                    game:GetService("ReplicatedStorage").Packages._Index:FindFirstChild("sleitnick_net@0.2.0").net:FindFirstChild("RE/FishingCompleted"):FireServer()

                    task.wait(0.1) -- Small wait to prevent spam
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
