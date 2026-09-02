-- Ascend Game - Targeted Rebirth & Ascend Mobile Script
-- Works on Delta, Arceus X, Codex, and other mobile executors.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("AscendTargetedGui") then
    player.PlayerGui.AscendTargetedGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendTargetedGui"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 180)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Text = "Ascend Auto Rebirth Hub"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Rebirth Toggle Button
local RebirthBtn = Instance.new("TextButton")
RebirthBtn.Size = UDim2.new(0.85, 0, 0, 35)
RebirthBtn.Position = UDim2.new(0.075, 0, 0.28, 0)
RebirthBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
RebirthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthBtn.TextSize, RebirthBtn.Font = 12, Enum.Font.GothamBold
RebirthBtn.Text = "Auto Rebirth: OFF"
RebirthBtn.Parent = MainFrame

local RBurner = Instance.new("UICorner")
RBurner.CornerRadius = UDim.new(0, 8)
RBurner.Parent = RebirthBtn

-- Ascend Toggle Button
local AscendBtn = Instance.new("TextButton")
AscendBtn.Size = UDim2.new(0.85, 0, 0, 35)
AscendBtn.Position = UDim2.new(0.075, 0, 0.53, 0)
AscendBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
AscendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AscendBtn.TextSize, AscendBtn.Font = 12, Enum.Font.GothamBold
AscendBtn.Text = "Auto Ascender: OFF"
AscendBtn.Parent = MainFrame

local ABurner = Instance.new("UICorner")
ABurner.CornerRadius = UDim.new(0, 8)
ABurner.Parent = AscendBtn

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.78, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(170, 170, 170)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Idle"
Status.Parent = MainFrame

local autoRebirthRunning = false
local autoAscendRunning = false

-- Helper function to find and trigger remotes explicitly matching keywords
local function triggerRemote(keyword)
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:find(keyword) then
                pcall(function()
                    if v:IsA("RemoteEvent") then
                        v:FireServer()
                    elseif v:IsA("RemoteFunction") then
                        v:InvokeServer()
                    end
                end)
            end
        end
    end
end

RebirthBtn.MouseButton1Click:Connect(function()
    autoRebirthRunning = not autoRebirthRunning
    if autoRebirthRunning then
        RebirthBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        RebirthBtn.Text = "Auto Rebirth: ON"
        Status.Text = "Status: Auto Rebirth active"
    else
        RebirthBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        RebirthBtn.Text = "Auto Rebirth: OFF"
        Status.Text = "Status: Idle"
    end

    task.spawn(function()
        while autoRebirthRunning do
            triggerRemote("rebirth")
            task.wait(0.2)
        end
    end)
end)

AscendBtn.MouseButton1Click:Connect(function()
    autoAscendRunning = not autoAscendRunning
    if autoAscendRunning then
        AscendBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        AscendBtn.Text = "Auto Ascender: ON"
        Status.Text = "Status: Auto Ascender active"
    else
        AscendBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        AscendBtn.Text = "Auto Ascender: OFF"
        Status.Text = "Status: Idle"
    end

    task.spawn(function()
        while autoAscendRunning do
            triggerRemote("ascend")
            triggerRemote("cycle")
            task.wait(0.5)
        end
    end)
end)
