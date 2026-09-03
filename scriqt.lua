-- Ascend Or Fall / Aura Ascension Hub (Auto Rebirth, Auto Infinity Aura/Upgrades, & Anti-Fall)
-- Updated with Auto Upgrade and Auto Step features

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

if player.PlayerGui:FindFirstChild("AscendFallFullHub") then
    player.PlayerGui.AscendFallFullHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendFallFullHub"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 275)
MainFrame.Position = UDim2.new(0.5, -130, 0.25, -135)
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
Title.Text = "Ascend Or Fall - Ultimate Hub"
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Helper creator for toggle buttons
local function createButton(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 32)
    btn.Position = UDim2.new(0.075, 0, posY, 0)
    btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize, btn.Font = 11, Enum.Font.GothamBold
    btn.Text = name .. ": OFF"
    btn.Parent = MainFrame
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    return btn
end

local RebirthBtn = createButton("Auto Rebirth", 0.17)
local UpgradeBtn = createButton("Auto Upgrade Aura/Stats", 0.31)
local StepBtn = createButton("Auto Step / Climb", 0.45)
local GodBtn = createButton("Anti-Fall / Godmode", 0.59)

-- Save Position Button
local SavePosBtn = Instance.new("TextButton")
SavePosBtn.Size = UDim2.new(0.85, 0, 0, 28)
SavePosBtn.Position = UDim2.new(0.075, 0, 0.73, 0)
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
Status.Position = UDim2.new(0, 0, 0.88, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(160, 160, 160)
Status.TextSize = 11
Status.Font = Enum.Font.Gotham
Status.Text = "Status: Idle"
Status.Parent = MainFrame

local states = {
    rebirth = false,
    upgrade = false,
    step = false,
    godmode = false
}
local savedPosition = nil

SavePosBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPosition = char.HumanoidRootPart.CFrame
        Status.Text = "Status: Safe position saved!"
    end
end)

-- Generic Remote Trigger Helper
local function triggerByKeyword(keyword)
    for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local name = v.Name:lower()
            if name:find(keyword) then
                pcall(function()
                    if v:IsA("RemoteEvent") then v:FireServer() else v:InvokeServer() end
                end)
            end
        end
    end
end

-- 1. Auto Rebirth
RebirthBtn.MouseButton1Click:Connect(function()
    states.rebirth = not states.rebirth
    RebirthBtn.BackgroundColor3 = states.rebirth and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    RebirthBtn.Text = "Auto Rebirth: " .. (states.rebirth and "ON" or "OFF")
    
    task.spawn(function()
        while states.rebirth do
            pcall(function() triggerByKeyword("rebirth") end)
            task.wait(0.3)
        end
    end)
end)

-- 2. Auto Upgrade (Targets infinity aura upgrades / stat increases)
UpgradeBtn.MouseButton1Click:Connect(function()
    states.upgrade = not states.upgrade
    UpgradeBtn.BackgroundColor3 = states.upgrade and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    UpgradeBtn.Text = "Auto Upgrade Aura/Stats: " .. (states.upgrade and "ON" or "OFF")
    
    task.spawn(function()
        while states.upgrade do
            pcall(function()
                triggerByKeyword("upgrade")
                triggerByKeyword("buy")
                triggerByKeyword("aura")
            end)
            task.wait(0.5)
        end
    end)
end)

-- 3. Auto Step / Climb (Simulates regular tower steps or jumping forward)
StepBtn.MouseButton1Click:Connect(function()
    states.step = not states.step
    StepBtn.BackgroundColor3 = states.step and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    StepBtn.Text = "Auto Step / Climb: " .. (states.step and "ON" or "OFF")
    
    task.spawn(function()
        while states.step do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid:Move(Vector3.new(0, 0, -1), true)
                    char.Humanoid.Jump = true
                end
            end)
            task.wait(0.2)
        end
    end)
end)

-- 4. Anti-Fall / Godmode
GodBtn.MouseButton1Click:Connect(function()
    states.godmode = not states.godmode
    GodBtn.BackgroundColor3 = states.godmode and Color3.fromRGB(40, 180, 40) or Color3.fromRGB(180, 40, 40)
    GodBtn.Text = "Anti-Fall / Godmode: " .. (states.godmode and "ON" or "OFF")
    
    task.spawn(function()
        while states.godmode do
            pcall(function()
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    if not savedPosition then
                        savedPosition = char.HumanoidRootPart.CFrame
                    end
                    if char.HumanoidRootPart.Position.Y < (savedPosition.Y - 35) then
                        char.HumanoidRootPart.CFrame = savedPosition
                        char.HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
            task.wait(0.2)
        end
    end)
end)

-- Prevent AFK Kick
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)
