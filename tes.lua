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

-- Tombol Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = mainFrame
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.Position = UDim2.new(0, 460, 0, 0)
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Font = Enum.Font.SourceSans
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20

-- Tombol Close
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.Position = UDim2.new(0, 460, 0, 40)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Font = Enum.Font.SourceSans
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20

-- Tombol Kill Aura
local killAuraButton = Instance.new("TextButton")
killAuraButton.Name = "KillAuraButton"
killAuraButton.Parent = mainFrame
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 20)
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
speedButton.Position = UDim2.new(0.5, -75, 0, 80)
speedButton.Size = UDim2.new(0, 150, 0, 50)
speedButton.Font = Enum.Font.SourceSans
speedButton.Text = "Speed: 16"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20

-- Variabel untuk melacak apakah Kill Aura aktif
local killAuraEnabled = false

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

-- Fungsi untuk toggle kecepatan
local function toggleSpeed()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed == 70 then
            humanoid.WalkSpeed = 16
            speedButton.Text = "Speed: 16"
        else
            humanoid.WalkSpeed = 70
            speedButton.Text = "Speed: 70"
        end
    end
end

-- Fungsi untuk minimize frame
local function minimizeFrame()
    mainFrame.Visible = not mainFrame.Visible
end

-- Fungsi untuk close frame
local function closeFrame()
    mainFrame:Destroy()
end

-- Menghubungkan tombol ke fungsi
killAuraButton.MouseButton1Click:Connect(toggleKillAura)
speedButton.MouseButton1Click:Connect(toggleSpeed)
minimizeButton.MouseButton1Click:Connect(minimizeFrame)
closeButton.MouseButton1Click:Connect(closeFrame)

-- Mengatur kecepatan menggunakan RunService
local RunService = game:GetService("RunService")
local speed = 16

RunService.RenderStepped:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed ~= speed then
            humanoid.WalkSpeed = speed
        end
    end
end)
