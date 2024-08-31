-- Fungsi untuk memuat dan menjalankan skrip remote
local function loadRemoteScript(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)

    if success then
        local func, loadError = loadstring(response)
        if func then
            local execSuccess, execError = pcall(func)
            if not execSuccess then
                warn("Error executing script from " .. url .. ": " .. execError)
            end
        else
            warn("Error loading script from " .. url .. ": " .. loadError)
        end
    else
        warn("Error fetching script from " .. url .. ": " .. response)
    end
end

-- Memuat semua skrip remote yang dibutuhkan
loadRemoteScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes")
loadRemoteScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes")
loadRemoteScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes")

-- Membuat GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGUI"
screenGui.Parent = playerGui

-- Membuat Frame Utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Active = true
mainFrame.Draggable = true

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Position = UDim2.new(1, -30, 0, 10)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = mainFrame
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
minimizeButton.Position = UDim2.new(0, 10, 0, 10)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20
local isMinimized = false

local function minimizeFrame()
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 500, 0, 300)
        minimizeButton.Text = "-"
        isMinimized = false
    else
        mainFrame.Size = UDim2.new(0, 200, 0, 50)
        minimizeButton.Text = "+"
        isMinimized = true
    end
end

minimizeButton.MouseButton1Click:Connect(minimizeFrame)

-- Tombol Kill Aura
local killAuraButton = Instance.new("TextButton")
killAuraButton.Name = "KillAuraButton"
killAuraButton.Parent = mainFrame
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 60)
killAuraButton.Size = UDim2.new(0, 150, 0, 50)
killAuraButton.Font = Enum.Font.SourceSans
killAuraButton.Text = "Kill Aura V1"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.TextSize = 20

-- Tombol Speed Toggle
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = mainFrame
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.Position = UDim2.new(0.5, -75, 0, 120)
speedButton.Size = UDim2.new(0, 150, 0, 50)
speedButton.Font = Enum.Font.SourceSans
speedButton.Text = "Speed: 16"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20

-- Variabel untuk melacak apakah Kill Aura aktif dan kecepatan
local killAuraEnabled = false
local speedActive = false
local normalSpeed = 16
local fastSpeed = 70

-- Fungsi untuk mengaktifkan Kill Aura
local function activateKillAura()
    local radius = 30

    for _, enemy in pairs(game.Workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            local distance = (player.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance <= radius then
                enemy.Humanoid:TakeDamage(enemy.Humanoid.Health) -- Berikan damage sesuai dengan health maksimum musuh
            end
        end
    end
end

-- Fungsi Toggle Kill Aura
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        killAuraButton.Text = "Kill Aura: ON"
        activateKillAura() -- Panggil fungsi Kill Aura
    else
        killAuraButton.Text = "Kill Aura: OFF"
    end
end

-- Fungsi untuk toggle kecepatan langsung
local function toggleSpeed()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if speedActive then
            humanoid.WalkSpeed = normalSpeed
            speedButton.Text = "Speed: " .. normalSpeed
        else
            humanoid.WalkSpeed = fastSpeed
            speedButton.Text = "Speed: " .. fastSpeed
        end
        speedActive = not speedActive
    end
end

-- Menghubungkan tombol ke fungsi
killAuraButton.MouseButton1Click:Connect(toggleKillAura)
speedButton.MouseButton1Click:Connect(toggleSpeed)
