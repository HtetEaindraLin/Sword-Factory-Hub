-- Ascend Or Fall - Dedicated Auto Rebirth Script
-- Focused exclusively on firing the auto-rebirth remote loop for maximum reliability on mobile executors.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("AscendPureRebirthGui") then
    player.PlayerGui.AscendPureRebirthGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendPureRebirthGui"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 120)
MainFrame.Position = UDim2.new(0.5, -120, 0.3, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize, Title.Font = 12, Enum.Font.GothamBold
Title.Text = "Auto Rebirth Only"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local RebirthBtn = Instance.new("TextButton")
RebirthBtn.Size = UDim2.new(0.85, 0, 0, 45)
RebirthBtn.Position = UDim2.new(0.075, 0, 0.40, 0)
RebirthBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
RebirthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthBtn.TextSize, RebirthBtn.Font = 13, Enum.Font.GothamBold
RebirthBtn.Text = "Auto Rebirth: OFF"
RebirthBtn.Parent = MainFrame

local RCorner = Instance.new("UICorner")
RCorner.CornerRadius = UDim.new(0, 8)
RCorner.Parent = RebirthBtn

local autoRebirth = false

RebirthBtn.MouseButton1Click:Connect(function()
    autoRebirth = not autoRebirth
    RebirthBtn.BackgroundColor3 = autoRebirth and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    RebirthBtn.Text = "Auto Rebirth: " .. (autoRebirth and "ON" or "OFF")

    task.spawn(function()
        while autoRebirth do
            pcall(function()
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:lower():find("rebirth") then
                        if v:IsA("RemoteEvent") then 
                            v:FireServer() 
                        else 
                            v:InvokeServer() 
                        end
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end)
