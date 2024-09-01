local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- GUI setup
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "MainGUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 300, 0, 300)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BorderSizePixel = 0

local speedSlider = Instance.new("TextBox", mainFrame)
speedSlider.Size = UDim2.new(0, 180, 0, 20)
speedSlider.Position = UDim2.new(0.5, -90, 0.5, -50)
speedSlider.Text = "16"
speedSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.TextColor3 = Color3.fromRGB(0, 0, 0)

local speedLabel = Instance.new("TextLabel", mainFrame)
speedLabel.Size = UDim2.new(0, 200, 0, 20)
speedLabel.Position = UDim2.new(0.5, -100, 0, 20)
speedLabel.Text = "Speed: 16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

local espButton = Instance.new("TextButton", mainFrame)
espButton.Size = UDim2.new(0, 150, 0, 50)
espButton.Position = UDim2.new(0.5, -75, 0, 90)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.Text = "ESP Toggle"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 20

local killAuraButton = Instance.new("TextButton", mainFrame)
killAuraButton.Size = UDim2.new(0, 150, 0, 50)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 150)
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Text = "Kill Aura V1"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.TextSize = 20

-- Variables
local espEnabled = false
local killAuraActive = false

-- Function to set walking speed
local function setWalkSpeed(speed)
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

-- Speed Slider Functionality
speedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local walkSpeed = tonumber(speedSlider.Text)
        if walkSpeed and walkSpeed >= 16 and walkSpeed <= 100 then
            setWalkSpeed(walkSpeed)
            speedLabel.Text = "Speed: " .. walkSpeed
        else
            speedSlider.Text = tostring(humanoid.WalkSpeed)
        end
    end
end)

-- ESP Functionality
local function updateESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoidRootPart = player.Character.HumanoidRootPart
            local espLabel = player.Character:FindFirstChild("ESPLabel")
            if espEnabled then
                if not espLabel then
                    espLabel = Instance.new("BillboardGui", player.Character)
                    espLabel.Name = "ESPLabel"
                    espLabel.Size = UDim2.new(0, 200, 0, 50)
                    espLabel.StudsOffset = Vector3.new(0, 3, 0)
                    espLabel.AlwaysOnTop = true
                    local textLabel = Instance.new("TextLabel", espLabel)
                    textLabel.Size = UDim2.new(1, 0, 1, 0)
                    textLabel.BackgroundTransparency = 1
                    textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    textLabel.TextStrokeTransparency = 0.5
                end
                local espLabel = player.Character:FindFirstChild("ESPLabel")
                espLabel.TextLabel.Text = player.Name .. "\nHealth: " .. (player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health or "N/A")
            elseif espLabel then
                espLabel:Destroy()
            end
        end
    end
end

-- Update ESP periodically
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Kill Aura Functionality
local function activateKillAura()
    local function getHighestDamageMeleeWeapon()
        local bestWeapon = nil
        local maxDamage = 0
        for _, item in pairs(localPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and item:FindFirstChild("meleeDamage") then
                local damage = item.meleeDamage.Value
                if damage > maxDamage then
                    maxDamage = damage
                    bestWeapon = item
                end
            end
        end
        return bestWeapon
    end

    local function attackNearbyEnemies()
        local weapon = getHighestDamageMeleeWeapon()
        if weapon then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (player.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
                    if distance < 20 then  -- Adjust the radius as needed
                        weapon.Parent = localPlayer.Backpack
                        weapon:Activate()
                    end
                end
            end
        end
    end

    while killAuraActive do
        attackNearbyEnemies()
        wait(1)
    end
end

-- Button Connections
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP On" or "ESP Off"
end)

killAuraButton.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    killAuraButton.Text = killAuraActive and "Kill Aura On" or "Kill Aura Off"
    if killAuraActive then
        activateKillAura()
    end
end)

-- Fly Functionality
local function flyToTarget(target)
    local targetPosition = target.Character.HumanoidRootPart.Position
    while (targetPosition - character.HumanoidRootPart.Position).magnitude > 5 do
        character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
        wait(0.1)
    end
end

-- Example usage of flyToTarget (find the nearest enemy and fly to it)
local function flyToNearestEnemy()
    local nearestEnemy = nil
    local shortestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                nearestEnemy = player
            end
        end
    end

    if nearestEnemy then
        flyToTarget(nearestEnemy)
    end
end

-- Example usage: Call flyToNearestEnemy() to fly to the nearest enemy
-- You can bind this function to a button or call it periodically
