-- LocalScript: Auto Hit Setup and Functionality
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer.PlayerGui

-- Remote Setup
local interactions = ReplicatedStorage:WaitForChild("remoteInterface"):WaitForChild("interactions")

-- Menetapkan remotes tanpa duplikasi
getgenv().remotes = {
    meleePlayer = interactions:WaitForChild("meleePlayer"),
}

-- Setup GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "AutoHitGUI"

-- Main GUI Frame
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 200, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true

-- Minimal GUI Frame
local minimalFrame = Instance.new("Frame", gui)
minimalFrame.Size = UDim2.new(0, 50, 0, 50)
minimalFrame.Position = UDim2.new(0.5, -25, 0, 10)
minimalFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
minimalFrame.Visible = false

local minimalIcon = Instance.new("TextLabel", minimalFrame)
minimalIcon.Size = UDim2.new(1, 0, 1, 0)
minimalIcon.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
minimalIcon.Text = "A"
minimalIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
minimalIcon.TextSize = 20
minimalIcon.TextStrokeTransparency = 0.5
minimalIcon.TextWrapped = true

-- Buttons for Main GUI
local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Auto Hit"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextWrapped = true

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20

local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20

local autoHitButton = Instance.new("TextButton", mainFrame)
autoHitButton.Size = UDim2.new(1, -20, 0, 50)
autoHitButton.Position = UDim2.new(0, 10, 0, 40)
autoHitButton.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
autoHitButton.Text = "Enable Auto Hit"
autoHitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
autoHitButton.TextSize = 20

-- State Management
local autoHitEnabled = false
local attackRadius = 50
local damage = 60

-- Fungsi Auto Hit
local function autoHit()
    local playerPos = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character.HumanoidRootPart.Position
    if not playerPos then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local enemyPos = player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position
            if enemyPos and (enemyPos - playerPos).Magnitude < attackRadius then
                -- Mengirim perintah hit ke remote
                getgenv().remotes.meleePlayer:FireServer("hit", player.Character.Humanoid, damage)
            end
        end
    end
end

-- Event Handlers
autoHitButton.MouseButton1Click:Connect(function()
    autoHitEnabled = not autoHitEnabled
    if autoHitEnabled then
        autoHitButton.Text = "Disable Auto Hit"
    else
        autoHitButton.Text = "Enable Auto Hit"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        mainFrame.Visible = false
        minimalFrame.Visible = true
    else
        mainFrame.Visible = true
        minimalFrame.Visible = false
    end
end)

minimalFrame.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    minimalFrame.Visible = false
end)

-- Loop untuk menjalankan Auto Hit
RunService.RenderStepped:Connect(function()
    if autoHitEnabled then
        autoHit()
    end
end)
