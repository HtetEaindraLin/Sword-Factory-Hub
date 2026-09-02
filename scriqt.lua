-- Ascend UI Injector / Universal Rebirth Clicker
local success, result = pcall(function()
    local vim = game:GetService("VirtualInputManager")
    local players = game:GetService("Players")
    local lp = players.LocalPlayer

    -- Create a simple floating button to manually pulse clicks at your character/screen center
    local gui = Instance.new("ScreenGui", lp.PlayerGui)
    gui.Name = "BypassClicker"
    
    local btn = Instance.new("TextButton", gui)
    btn.Size = UDim2.new(0, 150, 0, 50)
    btn.Position = UDim2.new(0.5, -75, 0.1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    btn.Text = "Spam Click: OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.Text = "Spam Click: ON"
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        else
            btn.Text = "Spam Click: OFF"
            btn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        end
        
        task.spawn(function()
            while active do
                pcall(function()
                    -- Simulates tapping the center of the screen where UI buttons usually open
                    vim:SendMouseButtonEvent(300, 300, 0, true, game, 0)
                    task.wait(0.05)
                    vim:SendMouseButtonEvent(300, 300, 0, false, game, 0)
                end)
                task.wait(0.2)
            end
        end)
    end)
end)

if not success then
    warn("Executor compatibility issue: " .. tostring(result))
end
