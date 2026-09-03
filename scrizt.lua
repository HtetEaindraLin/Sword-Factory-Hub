-- ============================================================
--  ASCEND OR FALL HUB — Ultra-Clean Roblox Script
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Clean up existing GUI
pcall(function()
    if CoreGui:FindFirstChild("SimpleAOFHub") then
        CoreGui.SimpleAOFHub:Destroy()
    end
    if player.PlayerGui:FindFirstChild("SimpleAOFHub") then
        player.PlayerGui.SimpleAOFHub:Destroy()
    end
end)

-- Variables
local autoClimb = false
local infJump = false
local noClip = false

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleAOFHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Floating Toggle Button (To open/close menu)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0.35, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.TextColor3 = Color3.fromRGB(138, 43, 226)
ToggleButton.Text = "🌌"
ToggleButton.TextSize = 22
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local btnCorner = Instance.new("UICorner", ToggleButton)
btnCorner.CornerRadius = UDim.new(1, 0)
local btnStroke = Instance.new("UIStroke", ToggleButton)
btnStroke.Color = Color3.fromRGB(138, 43, 226)
btnStroke.Thickness = 2

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local frameCorner = Instance.new("UICorner", MainFrame)
frameCorner.CornerRadius = UDim.new(0, 8)
local frameStroke = Instance.new("UIStroke", MainFrame)
frameStroke.Color = Color3.fromRGB(50, 50, 65)
frameStroke.Thickness = 1

-- Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Text = "  🌌 Ascend Or Fall Hub"
TitleBar.TextSize = 12
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.Parent = MainFrame

local titleCorner = Instance.new("UICorner", TitleBar)
titleCorner.CornerRadius = UDim.new(0, 8)

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 35, 0, 35)
CloseButton.Position = UDim2.new(1, -35, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.TextColor3 = Color3.fromRGB(200, 60, 60)
CloseButton.Text = "X"
CloseButton.TextSize = 12
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Parent = TitleBar

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Toggle Menu Visibility
ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Content Container
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(1, -16, 1, -45)
ContentContainer.Position = UDim2.new(0, 8, 0, 40)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.ScrollBarThickness = 2
ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentContainer.Parent = MainFrame

local UIList = Instance.new("UIListLayout", ContentContainer)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

-- Helper to create buttons/toggles
local function createButtonToggle(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.TextColor3 = Color3.fromRGB(220, 220, 225)
    btn.Text = "  " .. text .. ": [ OFF ]"
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = ContentContainer
    
    local c = Instance.new("UICorner", btn)
    c.CornerRadius = UDim.new(0, 6)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.Text = "  " .. text .. ": [ ON ]"
            btn.TextColor3 = Color3.fromRGB(87, 242, 135)
        else
            btn.Text = "  " .. text .. ": [ OFF ]"
            btn.TextColor3 = Color3.fromRGB(220, 220, 225)
        end
        callback(active)
    end)
end

-- Add Features
createButtonToggle("Auto Climb / Jump", function(state)
    autoClimb = state
end)

createButtonToggle("Infinite Jump", function(state)
    infJump = state
end)

createButtonToggle("NoClip", function(state)
    noClip = state
end)

-- Logic Loops
task.spawn(function()
    while true do
        task.wait(0.2)
        if autoClimb then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJump then
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if noClip then
        pcall(function()
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)

print("Ascend Or Fall Hub Loaded Successfully!")
