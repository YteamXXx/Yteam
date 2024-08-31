local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local KillAuraButton = Instance.new("TextButton")
local GodModeButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Active = true
MainFrame.Draggable = true

CloseButton.Parent = MainFrame
CloseButton.Text = "Close"
CloseButton.Size = UDim2.new(0, 50, 0, 25)
CloseButton.Position = UDim2.new(1, -55, 0, 5)

MinimizeButton.Parent = MainFrame
MinimizeButton.Text = "Minimize"
MinimizeButton.Size = UDim2.new(0, 75, 0, 25)
MinimizeButton.Position = UDim2.new(1, -130, 0, 5)

ESPButton.Parent = MainFrame
ESPButton.Text = "Toggle ESP"
ESPButton.Size = UDim2.new(0, 100, 0, 50)
ESPButton.Position = UDim2.new(0.5, -50, 0.5, -100)

SpeedButton.Parent = MainFrame
SpeedButton.Text = "Toggle Speed"
SpeedButton.Size = UDim2.new(0, 100, 0, 50)
SpeedButton.Position = UDim2.new(0.5, -50, 0.5, -50)

KillAuraButton.Parent = MainFrame
KillAuraButton.Text = "Toggle Kill Aura"
KillAuraButton.Size = UDim2.new(0, 100, 0, 50)
KillAuraButton.Position = UDim2.new(0.5, -50, 0.5, 0)

GodModeButton.Parent = MainFrame
GodModeButton.Text = "Toggle God Mode"
GodModeButton.Size = UDim2.new(0, 100, 0, 50)
GodModeButton.Position = UDim2.new(0.5, -50, 0.5, 50)

local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false
local godModeEnabled = false

-- Function to close GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Function to minimize GUI
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Function to toggle ESP
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        -- Add ESP code here
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
        -- Add code to turn off ESP here
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character:FindFirstChildOfClass("Highlight") then
                player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end
end)

-- Function to toggle speed
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "Speed: ON"
        -- Smooth speed adjustment
        local player = game.Players.LocalPlayer
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16 -- Start with normal speed
            for i = 16, 50, 1 do
                humanoid.WalkSpeed = i
                wait(0.05) -- Small delay to smooth the increase
            end
        end
    else
        SpeedButton.Text = "Speed: OFF"
        -- Smooth speed reduction
        local player = game.Players.LocalPlayer
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for i = 50, 16, -1 do
                humanoid.WalkSpeed = i
                wait(0.05) -- Small delay to smooth the decrease
            end
        end
    end
end)

-- Function to toggle Kill Aura
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        KillAuraButton.Text = "Kill Aura: ON"
        -- Start Kill Aura loop
        while killAuraEnabled do
            wait(0.5) -- Short interval for checks
            local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local distance = (humanoidRootPart.Position - playerPos).magnitude
                        if distance < 10 then
                            -- Simulate attack
                            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid.Health = 0 -- Set health to 0 to simulate death
                                -- Optionally: Add a visual effect to simulate death
                                local deathEffect = Instance.new("ParticleEmitter")
                                deathEffect.Parent = player.Character.HumanoidRootPart
                                deathEffect.Texture = "rbxassetid://12345678" -- Replace with a death effect asset
                                deathEffect.Lifetime = NumberRange.new(0.5, 1)
                                deathEffect.Rate = 100
                                wait(0.5) -- Delay to show the effect
                                deathEffect:Destroy() -- Remove the effect after showing
                            end
                        end
                    end
                end
            end
        end
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)

-- Function to toggle God Mode
GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        GodModeButton.Text = "God Mode: ON"
        -- Add God Mode code here
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
    else
        GodModeButton.Text = "God Mode: OFF"
        -- Add code to turn off God Mode here
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
    end
end)

-- Automatically enable Kill Aura when character is added
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    killAuraEnabled = true
    KillAuraButton.Text = "Kill Aura: ON"
    while killAuraEnabled do
        wait(0.5) -- Short interval for checks
        local playerPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local distance = (humanoidRootPart.Position - playerPos).magnitude
                    if distance < 10 then
                        -- Simulate attack
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Health = 0 -- Set health to 0 to simulate death
                            -- Optionally: Add a visual effect to simulate death
                            local deathEffect = Instance.new("ParticleEmitter")
                            deathEffect.Parent = player.Character.HumanoidRootPart
                            deathEffect.Texture = "rbxassetid://12345678" -- Replace with a death effect asset
                            deathEffect.Lifetime = NumberRange.new(0.5, 1)
                            deathEffect.Rate = 100
                            wait(0.5) -- Delay to show the effect
                            deathEffect:Destroy() -- Remove the effect after showing
                        end
                    end
                end
            end
        end
    end
end)
