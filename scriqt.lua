-- Ascend / Aura Ascension Mobile GUI
-- Optimized UI for mobile executors (Delta, Codex, Arceus X, etc.)

local success, err = pcall(function()
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer

    -- Remove existing GUI if re-executing
    if player.PlayerGui:FindFirstChild("AscendMobileGui") then
        player.PlayerGui.AscendMobileGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AscendMobileGui"
    ScreenGui.Parent = player.PlayerGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 280, 0, 190)
    MainFrame.Position = UDim2.new(0.5, -140, 0.4, -95)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.Text = "Ascend Mobile Hub"
    Title.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = Title

    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.85, 0, 0, 45)
    ToggleBtn.Position = UDim2.new(0.075, 0, 0.32, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 14
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Text = "Auto Rebirth: OFF"
    ToggleBtn.Parent = MainFrame

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = ToggleBtn

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 30)
    StatusLabel.Position = UDim2.new(0, 0, 0.72, 0)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 12
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Text = "Status: Idle"
    StatusLabel.Parent = MainFrame

    local toggleState = false

    ToggleBtn.MouseButton1Click:Connect(function()
        toggleState = not toggleState
        if toggleState then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            ToggleBtn.Text = "Auto Rebirth: ON"
            StatusLabel.Text = "Status: Running..."
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            ToggleBtn.Text = "Auto Rebirth: OFF"
            StatusLabel.Text = "Status: Stopped"
        end

        task.spawn(function()
            while toggleState do
                pcall(function()
                    -- Generic remote firing approach based on common network structures
                    for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                        if remote:IsA("RemoteEvent") and (remote.Name:lower():find("rebirth") or remote.Name:lower():find("ascend")) then
                            remote:FireServer()
                        elseif remote:IsA("RemoteFunction") and (remote.Name:lower():find("rebirth") or remote.Name:lower():find("ascend")) then
                            remote:InvokeServer()
                        end
                    end
                end)
                task.wait(1.5)
            end
        end)
    end)
end)

if not success then
    warn("Script execution error: " .. tostring(err))
end
