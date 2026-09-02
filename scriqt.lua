-- Direct UI Automation Script for Ascend (Mobile-Friendly)
-- This script hooks directly into the ReplicatedStorage packages or triggers standard touch inputs if remote names are encrypted.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Clean up previous UI
if player.PlayerGui:FindFirstChild("AscendBypassGui") then
    player.PlayerGui.AscendBypassGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AscendBypassGui"
ScreenGui.Parent = player.PlayerGui
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 220, 0, 120)
Frame.Position = UDim2.new(0.5, -110, 0.4, -60)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.Active = true
Frame.Draggable = true

local Corner = Instance.new("UICorner", Frame)
Corner.CornerRadius = UDim.new(0, 10)

local Button = Instance.new("TextButton", Frame)
Button.Size = UDim2.new(0.85, 0, 0, 50)
Button.Position = UDim2.new(0.075, 0, 0.25, 0)
Button.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.TextSize = 14
Button.Font = Enum.Font.GothamBold
Button.Text = "Force Rebirth: OFF"

local BtnCorner = Instance.new("UICorner", Button)
BtnCorner.CornerRadius = UDim.new(0, 8)

local active = false

Button.MouseButton1Click:Connect(function()
    active = not active
    if active then
        Button.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
        Button.Text = "Force Rebirth: ON"
    else
        Button.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        Button.Text = "Force Rebirth: OFF"
    end

    task.spawn(function()
        while active do
            pcall(function()
                -- Iterates over all packages/modules in ReplicatedStorage to find any active Knit/Remote functions related to currency/rebirth
                for _, descendant in ipairs(ReplicatedStorage:GetDescendants()) do
                    if descendant:IsA("RemoteEvent") then
                        local n = descendant.Name:lower()
                        if n:Contains("rebirth") or n:Contains("ascend") or n:Contains("aura") then
                            descendant:FireServer()
                        end
                    elseif descendant:IsA("RemoteFunction") then
                        local n = descendant.Name:lower()
                        if n:Contains("rebirth") or n:Contains("ascend") or n:Contains("aura") then
                            descendant:InvokeServer()
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)
