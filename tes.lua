local HttpService = game:GetService("HttpService")
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Fungsi untuk memuat dan menjalankan skrip dari URL
local function fetchScript(url)
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        local func, err = loadstring(response)
        if func then
            return func()
        else
            warn("Failed to load script from URL:", url, "Error:", err)
            return nil
        end
    else
        warn("Failed to fetch script from URL:", url)
        return nil
    end
end

-- Mengambil skrip dari URL
local GetRemotes = fetchScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes")
local RetrieveRemotes = fetchScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes")
local ReturnRemotes = fetchScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes")

-- GUI sederhana
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillAuraGui"
screenGui.Parent = PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, 0)
statusLabel.Text = "Kill Aura: Off"
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
statusLabel.Parent = frame

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(1, 0, 0, 30)
toggleButton.Position = UDim2.new(0, 0, 0, 40)
toggleButton.Text = "Toggle Kill Aura"
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 60, 0, 30)
closeButton.Position = UDim2.new(1, -60, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Variabel untuk status Kill Aura
local killAuraActive = false

-- Fungsi untuk mengaktifkan dan menonaktifkan Kill Aura
local function applyKillAura()
    if killAuraActive then
        -- Implementasi Kill Aura
        local function onPlayerHit(targetPlayer)
            local targetCharacter = targetPlayer.Character
            if targetCharacter then
                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:TakeDamage(humanoid.Health) -- Contoh penerapan kerusakan
                end
            end
        end

        -- Memicu Kill Aura pada semua pemain dalam jangkauan tertentu
        local players = game:GetService("Players"):GetPlayers()
        for _, player in pairs(players) do
            if player ~= game.Players.LocalPlayer then
                onPlayerHit(player)
            end
        end
    end
end

-- Fungsi untuk menangani tombol Toggle Kill Aura
toggleButton.MouseButton1Click:Connect(function()
    killAuraActive = not killAuraActive
    statusLabel.Text = killAuraActive and "Kill Aura: On" or "Kill Aura: Off"
    if killAuraActive then
        -- Jalankan Kill Aura setiap detik
        while killAuraActive do
            applyKillAura()
            wait(1)
        end
    end
end)
