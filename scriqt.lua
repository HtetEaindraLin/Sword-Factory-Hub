-- Ascend Or Fall - Auto Rebirth & Auto Farm Aura Script
-- Works on mobile executors (Delta, Arceus X, Codex, etc.)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("AscendBasicHub") then
    player.PlayerGui.AscendBasicHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendBasicHub"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize, Title.Font = 13, Enum.Font.GothamBold
Title.Text = "Auto Rebirth & Aura Farm"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Button 1: Auto Rebirth Toggle
local RebirthBtn = Instance.new("TextButton")
RebirthBtn.Size = UDim2.new(0.85, 0, 0, 38)
RebirthBtn.Position = UDim2.new(0.075, 0, 0.30, 0)
RebirthBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
RebirthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthBtn.TextSize, RebirthBtn.Font = 12, Enum.Font.GothamBold
RebirthBtn.Text = "Auto Rebirth: OFF"
RebirthBtn.Parent = MainFrame

local RCorner = Instance.new("UICorner")
RCorner.CornerRadius = UDim.new(0, 8)
RCorner.Parent = RebirthBtn

-- Button 2: Auto Farm Aura / Step Toggle
local FarmBtn = Instance.new("TextButton")
FarmBtn.Size = UDim2.new(0.85, 0, 0, 38)
FarmBtn.Position = UDim2.new(0.075, 0, 0.58, 0)
FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.TextSize, FarmBtn.Font = 12, Enum.Font.GothamBold
FarmBtn.Text = "Auto Farm Aura: OFF"
FarmBtn.Parent = MainFrame

local FCorner = Instance.new("UICorner")
FCorner.CornerRadius = UDim.new(0, 8)
FCorner.Parent = FarmBtn

local autoRebirth = false
local autoFarm = false

-- Helper to fire rebirth remotes safely
RebirthBtn.MouseButton1Click:Connect(function()
    autoRebirth = not autoRebirth
    RebirthBtn.BackgroundColor3 = autoRebirth and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    RebirthBtn.Text = "Auto Rebirth: " .. (autoRebirth and "ON" or "OFF")

    task.spawn(function()
        while autoRebirth do
            pcall(function()
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:lower():find("rebirth") then
                        if v:IsA("RemoteEvent") then v:FireServer() else v:InvokeServer() end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

-- Helper to simulate stepping/climbing for aura gains
FarmBtn.MouseButton1Click:Connect(function()
    autoFarm = not autoFarm
    FarmBtn.BackgroundColor3 = autoFarm and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    FarmBtn.Text = "Auto Farm Aura: " .. (autoFarm and "ON" or "OFF")

    task.spawn(function()
        while autoFarm do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    -- Simulates forward movement and jumping on steps to accumulate aura
                    char.Humanoid:Move(Vector3.new(0, 0, -1), true)
                    char.Humanoid.Jump = true
                end
            end)
            task.wait(0.25)
        end
    end)
end)
