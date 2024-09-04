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
        warn("Failed to fetch script from URL:", url, "Error:", response)
        return nil
    end
end

-- Mengambil skrip dari URL
local GetRemotes = fetchScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes")
local RetrieveRemotes = fetchScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes")
local ReturnRemotes = fetchScript("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes")

-- Memeriksa apakah skrip berhasil dimuat
if not GetRemotes or not RetrieveRemotes or not ReturnRemotes then
    warn("One or more scripts failed to load.")
    return
end

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
local remoteFunctions = {}

-- Fungsi untuk mengaktifkan dan menonaktifkan Kill Aura
local function applyKillAura()
    if not killAuraActive then return end

    -- Fungsi untuk memicu kerusakan pada target
    local function hitTarget(target)
        if target and target:FindFirstChildOfClass("Humanoid") then
            local humanoid = target:FindFirstChildOfClass("Humanoid")
            humanoid:TakeDamage(humanoid.Health)  -- Contoh penerapan kerusakan
        end
    end

    -- Mengambil semua pemain dan menerapkan Kill Aura pada mereka
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local character = player.Character
            if character then
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        hitTarget(character)
                    end
                end
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
