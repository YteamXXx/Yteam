-- Fungsi untuk memuat dan menjalankan skrip remote dari URL
local function loadRemoteScript(url)
    local success, response = pcall(function() return game:HttpGet(url) end)
    if success then
        local func, loadError = loadstring(response)
        if func then
            func()
        else
            warn("Error loading script from " .. url .. ": " .. loadError)
        end
    else
        warn("Failed to get script from " .. url .. ": " .. response)
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

-- Tombol Kill Aura
local killAuraButton = Instance.new("TextButton")
killAuraButton.Name = "KillAuraButton"
killAuraButton.Parent = screenGui
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 20)
killAuraButton.Size = UDim2.new(0, 150, 0, 50)
killAuraButton.Font = Enum.Font.SourceSans
killAuraButton.Text = "Kill Aura: OFF"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.TextSize = 20

-- Tombol Speed Toggle
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = screenGui
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
    -- Set radius Kill Aura
    local radius = 30 

    -- Temukan semua musuh dalam radius
    for _, enemy in pairs(game.Workspace:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") then
            local distance = (player.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
            if distance <= radius then
                -- Hapus musuh atau berikan damage yang besar untuk memastikan mereka mati
                enemy.Humanoid:TakeDamage(enemy.Humanoid.MaxHealth) -- Berikan damage sesuai dengan health maksimum musuh
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
        -- Implementasikan logika untuk menonaktifkan Kill Aura di sini (jika diperlukan)
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

-- Menghubungkan tombol ke fungsi
killAuraButton.MouseButton1Click:Connect(toggleKillAura)
speedButton.MouseButton1Click:Connect(toggleSpeed)
