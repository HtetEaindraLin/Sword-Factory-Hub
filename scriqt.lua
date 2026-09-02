-- Ascend / Ascender Mobile Script (Targeted for the actual game UI / Ascender mechanic)
-- Make sure you are at the point where you can ascend/progress cycles.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("AscendFixedGui") then
    player.PlayerGui.AscendFixedGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendFixedGui"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 160)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, -80)
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
Title.Text = "Ascender Auto Hub"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.35, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize, ToggleBtn.Font = 13, Enum.Font.GothamBold
ToggleBtn.Text = "Auto Ascender: OFF"
ToggleBtn.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleBtn

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.75, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(170, 170, 170)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Idle"
Status.Parent = MainFrame

local running = false

ToggleBtn.MouseButton1Click:Connect(function()
    running = not running
    if running then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        ToggleBtn.Text = "Auto Ascender: ON"
        Status.Text = "Status: Scanning remotes..."
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleBtn.Text = "Auto Ascender: OFF"
        Status.Text = "Status: Stopped"
    end

    task.spawn(function()
        while running do
            pcall(function()
                -- Deep scan for any remote related to Ascend, Cycle, or Rank upgrade
                for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                        local name = v.Name:lower()
                        if name:find("ascend") or name:find("cycle") or name:find("rank") or name:find("upgrade") then
                            if v:IsA("RemoteEvent") then
                                v:FireServer()
                            elseif v:IsA("RemoteFunction") then
                                v:InvokeServer()
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)
