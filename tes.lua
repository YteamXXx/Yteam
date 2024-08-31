local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

-- Skrip untuk kill aura dengan teleportasi
local killAuraActive = false
local function killAura()
    if killAuraActive then
        local closestPlayer = nil
        local shortestDistance = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    closestPlayer = player
                    shortestDistance = distance
                end
            end
        end

        if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame
            closestPlayer.Character.Humanoid.Health = 0
        end
    end
end

RunService.Heartbeat:Connect(killAura)

-- GUI untuk kill aura dan lari cepat dengan tombol minimize dan close
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local MinimizeButton = Instance.new("TextButton")
local CloseButton = Instance.new("TextButton")
local KillAuraButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local MinimizedFrame = Instance.new("Frame")
local MinimizedLabel = Instance.new("TextLabel")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

Frame.Size = UDim2.new(0, 200, 0, 150)
Frame.Position = UDim2.new(0.5, -100, 0.5, -75)
Frame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

MinimizeButton.Size = UDim2.new(0, 50, 0, 50)
MinimizeButton.Position = UDim2.new(0, 0, 0, 0)
MinimizeButton.Text = "-"
MinimizeButton.Parent = Frame

CloseButton.Size = UDim2.new(0, 50, 0, 50)
CloseButton.Position = UDim2.new(0, 50, 0, 0)
CloseButton.Text = "X"
CloseButton.Parent = Frame

KillAuraButton.Size = UDim2.new(0, 100, 0, 50)
KillAuraButton.Position = UDim2.new(0, 0, 0, 50)
KillAuraButton.Text = "Kill Aura"
KillAuraButton.Parent = Frame

SpeedButton.Size = UDim2.new(0, 100, 0, 50)
SpeedButton.Position = UDim2.new(0, 0, 0, 100)
SpeedButton.Text = "Run Fast"
SpeedButton.Parent = Frame

MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
MinimizedFrame.Position = UDim2.new(0.5, -25, 0, 0)
MinimizedFrame.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
MinimizedFrame.Visible = false
MinimizedFrame.Parent = ScreenGui

MinimizedLabel.Size = UDim2.new(1, 0, 1, 0)
MinimizedLabel.Text = "YTeam"
MinimizedLabel.TextColor3 = Color3.new(1, 1, 1)
MinimizedLabel.BackgroundTransparency = 1
MinimizedLabel.Parent = MinimizedFrame

KillAuraButton.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    KillAuraButton.Text = killAuraActive and "Kill Aura: ON" or "Kill Aura: OFF"
end)

SpeedButton.MouseButton1Click:Connect(function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    killAuraActive = false
    LocalPlayer.Character.Humanoid.WalkSpeed = 16
end)

MinimizeButton.MouseButton1Click:Connect(function()
    Frame.Visible = false
    MinimizedFrame.Visible = true
end)

MinimizedFrame.MouseButton1Click:Connect(function()
    Frame.Visible = true
    MinimizedFrame.Visible = false
end)

-- Anti-ban dan deteksi
local function antiBan()
    local originalWalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
    local originalJumpPower = LocalPlayer.Character.Humanoid.JumpPower

    RunService.Heartbeat:Connect(function()
        if LocalPlayer.Character.Humanoid.WalkSpeed > 50 then
            LocalPlayer.Character.Humanoid.WalkSpeed = originalWalkSpeed
        end
        if LocalPlayer.Character.Humanoid.JumpPower > 50 then
            LocalPlayer.Character.Humanoid.JumpPower = originalJumpPower
        end
    end)
end

antiBan()
