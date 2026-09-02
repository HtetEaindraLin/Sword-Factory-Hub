-- Ascend Or Fall / Aura Ascension Mobile Script
-- Includes Auto Rebirth and Safe Anti-Fall / Position Lock (Godmode alternative)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("AscendFallHub") then
    player.PlayerGui.AscendFallHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendFallHub"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 210)
MainFrame.Position = UDim2.new(0.5, -130, 0.3, -105)
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
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Text = "Ascend Or Fall Hub"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Auto Rebirth Toggle
local RebirthBtn = Instance.new("TextButton")
RebirthBtn.Size = UDim2.new(0.85, 0, 0, 35)
RebirthBtn.Position = UDim2.new(0.075, 0, 0.23, 0)
RebirthBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
RebirthBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RebirthBtn.TextSize, RebirthBtn.Font = 12, Enum.Font.GothamBold
RebirthBtn.Text = "Auto Rebirth: OFF"
RebirthBtn.Parent = MainFrame

local RBurner = Instance.new("UICorner")
RBurner.CornerRadius = UDim.new(0, 8)
RBurner.Parent = RebirthBtn

-- Godmode / Safe Fall Toggle (Locks position when falling to prevent death/resets)
local GodBtn = Instance.new("TextButton")
GodBtn.Size = UDim2.new(0.85, 0, 0, 35)
GodBtn.Position = UDim2.new(0.075, 0, 0.45, 0)
GodBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
GodBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
GodBtn.TextSize, GodBtn.Font = 12, Enum.Font.GothamBold
GodBtn.Text = "Anti-Fall / Godmode: OFF"
GodBtn.Parent = MainFrame

local GBurner = Instance.new("UICorner")
GBurner.CornerRadius = UDim.new(0, 8)
GBurner.Parent = GodBtn

-- Save Position Button
local SavePosBtn = Instance.new("TextButton")
SavePosBtn.Size = UDim2.new(0.85, 0, 0, 30)
SavePosBtn.Position = UDim2.new(0.075, 0, 0.67, 0)
SavePosBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
SavePosBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SavePosBtn.TextSize, SavePosBtn.Font = 11, Enum.Font.GothamBold
SavePosBtn.Text = "Set Safe Platform Position"
SavePosBtn.Parent = MainFrame

local SBBurner = Instance.new("UICorner")
SBBurner.CornerRadius = UDim.new(0, 8)
SBBurner.Parent = SavePosBtn

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, 0, 0, 25)
Status.Position = UDim2.new(0, 0, 0.84, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(160, 160, 160)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Idle"
Status.Parent = MainFrame

local autoRebirthActive = false
local godmodeActive = false
local savedPosition = nil

-- Save current platform coordinate
SavePosBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        Status.Text = "Status: Safe position saved!"
    end
end)

-- Rebirth Loop
RebirthBtn.MouseButton1Click:Connect(function()
    autoRebirthActive = not autoRebirthActive
    if autoRebirthActive then
        RebirthBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        RebirthBtn.Text = "Auto Rebirth: ON"
    else
        RebirthBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        RebirthBtn.Text = "Auto Rebirth: OFF"
    end

    task.spawn(function()
        while autoRebirthActive do
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

-- Anti-Fall / Godmode Loop (Teleports back up if you drop or fail)
GodBtn.MouseButton1Click:Connect(function()
    godmodeActive = not godmodeActive
    if godmodeActive then
        GodBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        GodBtn.Text = "Anti-Fall / Godmode: ON"
    else
        GodBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        GodBtn.Text = "Anti-Fall / Godmode: OFF"
    end

    task.spawn(function()
        while godmodeActive do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    -- If no saved position, auto-capture current ground
                    if not savedPosition then
                        savedPosition = char.HumanoidRootPart.CFrame
                    end
                    
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid and humanoid.Health <= 0 then
                        task.wait(1) -- wait for respawn
                    end
                    
                    -- If player falls below map bounds, teleport back to safety
                    if char.HumanoidRootPart.Position.Y < (savedPosition.Y - 35) then
                        char.HumanoidRootPart.CFrame = savedPosition
                        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0,0,0)
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end)
