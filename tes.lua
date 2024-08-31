-- Fungsi untuk memuat skrip remote
local function loadRemoteScripts()
    local remoteScripts = {
        "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes",
        "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes",
        "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes"
    }

    for _, url in ipairs(remoteScripts) do
        local remoteScript, err = game:HttpGet(url)
        if not remoteScript then
            warn("Error fetching remote script from " .. url .. ": " .. err)
            return
        end

        local func, loadError = loadstring(remoteScript)
        if func then
            func()
        else
            warn("Error loading remote script from " .. url .. ": " .. loadError)
            return
        end
    end
end

-- Memuat skrip remote
loadRemoteScripts()

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
killAuraButton.Text = "Kill Aura V1"
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
speedButton.Text = "Speed: 70"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20

-- Variabel untuk melacak apakah Kill Aura aktif
local killAuraEnabled = false

-- Fungsi untuk mengaktifkan Kill Aura
local function activateKillAura()
    print("Kill Aura activated") -- Debug: Pastikan fungsi ini dipanggil
    -- Implementasikan logika Kill Aura di sini
end

-- Fungsi Toggle Kill Aura
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        killAuraButton.Text = "Kill Aura: ON"
        activateKillAura() -- Panggil fungsi Kill Aura
    else
        killAuraButton.Text = "Kill Aura: OFF"
        -- Implementasikan logika untuk menonaktifkan Kill Aura di sini
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
