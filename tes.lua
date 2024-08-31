local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local KillAuraButton = Instance.new("TextButton")
local GodModeButton = Instance.new("TextButton")

-- Parent GUI to CoreGui
ScreenGui.Parent = game.CoreGui

-- Main Frame Setup
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Active = true
MainFrame.Draggable = true

-- Close Button
CloseButton.Parent = MainFrame
CloseButton.Text = "Close"
CloseButton.Size = UDim2.new(0, 50, 0, 25)
CloseButton.Position = UDim2.new(1, -55, 0, 5)

-- Minimize Button
MinimizeButton.Parent = MainFrame
MinimizeButton.Text = "Minimize"
MinimizeButton.Size = UDim2.new(0, 75, 0, 25)
MinimizeButton.Position = UDim2.new(1, -130, 0, 5)

-- ESP Button
ESPButton.Parent = MainFrame
ESPButton.Text = "Toggle ESP"
ESPButton.Size = UDim2.new(0, 100, 0, 50)
ESPButton.Position = UDim2.new(0.5, -50, 0.5, -100)

-- Speed Boost Button
SpeedButton.Parent = MainFrame
SpeedButton.Text = "Toggle Speed"
SpeedButton.Size = UDim2.new(0, 100, 0, 50)
SpeedButton.Position = UDim2.new(0.5, -50, 0.5, -50)

-- Kill Aura Button
KillAuraButton.Parent = MainFrame
KillAuraButton.Text = "Toggle Kill Aura"
KillAuraButton.Size = UDim2.new(0, 100, 0, 50)
KillAuraButton.Position = UDim2.new(0.5, -50, 0.5, 0)

-- God Mode Button
GodModeButton.Parent = MainFrame
GodModeButton.Text = "Toggle God Mode"
GodModeButton.Size = UDim2.new(0, 100, 0, 50)
GodModeButton.Position = UDim2.new(0.5, -50, 0.5, 50)

-- Close GUI Function
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize GUI Function
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- ESP Functionality
local espEnabled = false

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        -- Enable ESP
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        ESPButton.Text = "ESP: OFF"
        -- Disable ESP
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character:FindFirstChildOfClass("Highlight") then
                player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end
end)

-- Speed Boost Functionality
local speedEnabled = false
local originalSpeed = 16
local boostedSpeed = 50

SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "Speed: ON"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = boostedSpeed
    else
        SpeedButton.Text = "Speed: OFF"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = originalSpeed
    end
end)

-- Kill Aura Functionality (with real damage)
local killAuraEnabled = false
local attackDistance = 10
local damageAmount = 50

KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        KillAuraButton.Text = "Kill Aura: ON"
        while killAuraEnabled do
            wait(0.1) -- Attack interval every 0.1 seconds
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance < attackDistance then
                        player.Character.Humanoid:TakeDamage(damageAmount)
                    end
                end
            end
        end
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)

-- God Mode Functionality
local godModeEnabled = false

GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        GodModeButton.Text = "God Mode: ON"
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
    else
        GodModeButton.Text = "God Mode: OFF"
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
    end
end)
