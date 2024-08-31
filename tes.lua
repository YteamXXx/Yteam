-- Mengakses ReplicatedStorage dan interactions
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local interactions = ReplicatedStorage:WaitForChild("remoteInterface"):WaitForChild("interactions")
local inventory = ReplicatedStorage:WaitForChild("remoteInterface"):WaitForChild("inventory")

-- Menetapkan remotes tanpa duplikasi
getgenv().remotes = {
    meleeAI = interactions:WaitForChild("meleeAI"),
    take = inventory:WaitForChild("take"),
    pickupItem = inventory:WaitForChild("pickupItem"),
    plant = interactions:WaitForChild("plant"),
    harvest = interactions:WaitForChild("harvest"),
    eat = interactions:WaitForChild("eat"),
    build = interactions:WaitForChild("build"),
    deleteStructure = interactions:WaitForChild("deleteStructure"),
    shotHitPlayer = interactions:WaitForChild("shotHitPlayer"),
    objectHit = interactions:WaitForChild("objectHit"),
    hitStructure = interactions:WaitForChild("hitStructure"),
    shotStructure = interactions:WaitForChild("shotStructure"),
    chop = interactions:WaitForChild("chop"),
    buyRebirthPerk = interactions:WaitForChild("buyRebirthPerk"),
    mine = interactions:WaitForChild("mine"),
    meleeAl = interactions:WaitForChild("meleeAl"),
    meleePlayer = interactions:WaitForChild("meleePlayer"),
    rebirth = interactions:WaitForChild("rebirth"),
    removePath = interactions:WaitForChild("removePath"),
    itemAlInterraction = interactions:WaitForChild("itemAlInterraction")
}

-- Menetapkan nama-nama GUI sesuai dengan urutan
for i, v in pairs(game.Players.LocalPlayer.PlayerGui.client.client:GetChildren()) do
    if i == 2 then
        v.Name = "meleePlayer"
    elseif i == 4 then
        v.Name = "chop"
    elseif i == 5 then
        v.Name = "mine"
    elseif i == 6 then
        v.Name = "hitStructure"
    end
end

-- Fungsi tambahan
function getFunctionName(Function)
    return debug.getinfo and debug.getinfo(Function).name or debug.info and debug.info(Function, "n")
end

function shallowClone(Table)
    local newTable = {}
    if not Table then
        return
    end
    for i, v in pairs(Table) do
        newTable[i] = v
    end
    return newTable
end

function getFiOneConstants(Function)
    local upvalues = debug.getupvalues(Function)
    local upvalue = upvalues[1]
    if type(upvalue) == "table" then
        local consts = rawget(upvalue, "const")
        if type(consts) == "table" then
            return consts, upvalues
        end
    end
end

function findInFiOne(Table, Type)
    for i, v in pairs(Table) do
        if type(v) == "table" then
            local value = rawget(v, "value")
            if type(value) == Type and (value:IsA("RemoteEvent") or value:IsA("RemoteFunction")) then
                return value
            end
            for _, v2 in pairs(v) do
                if type(v2) == "table" then
                    local value = rawget(v2, "value")
                    if typeof(value) == Type and (value:IsA("RemoteEvent") or value:IsA("RemoteFunction")) then
                        return value
                    end
                end
            end
        end
    end
end

-- Memeriksa dan mengatur fungsi-fungsi GC
for i, v in pairs(getgc(true)) do
    if type(v) == "table" then
        for _, v2 in pairs(v) do
            if type(v2) == "function" then
                local consts, upvalues = getFiOneConstants(v2)
                if consts and (table.find(consts, "FireServer") or table.find(consts, "InvokeServer")) then
                    local remote = findInFiOne(upvalues, "Instance")
                    if remote then
                        local shallowTable = shallowClone(v)
                        shallowTable.FireServer = v2
                        table.remove(shallowTable, table.find(shallowTable, v2))
                        getgenv().remotes[tostring(remote)] = shallowTable
                    end
                end
            end
        end
    end

    if type(v) == "function" and getFunctionName(v) == "on_lua_error" then
        hookfunction(v, function() end)
    end
end

-- GUI
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)

-- Speed Slider
local speedFrame = Instance.new("Frame", gui)
speedFrame.Size = UDim2.new(0, 200, 0, 100)
speedFrame.Position = UDim2.new(0.5, -100, 0, 0)
speedFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local speedSlider = Instance.new("Slider", speedFrame)
speedSlider.Size = UDim2.new(0, 180, 0, 20)
speedSlider.Position = UDim2.new(0.5, -90, 0.5, -10)
speedSlider.Min = 16
speedSlider.Max = 100
speedSlider.Value = 16

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0, 200, 0, 20)
speedLabel.Position = UDim2.new(0.5, -100, 0, 20)
speedLabel.Text = "Speed: " .. speedSlider.Value
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

speedSlider.Changed:Connect(function()
    local walkSpeed = speedSlider.Value
    player.Character.Humanoid.WalkSpeed = walkSpeed
    speedLabel.Text = "Speed: " .. walkSpeed
end)

-- ESP Button
local espButton = Instance.new("TextButton", gui)
espButton.Size = UDim2.new(0, 150, 0, 50)
espButton.Position = UDim2.new(0.5, -75, 0, 110)
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.Text = "ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local espEnabled = false
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "ESP Enabled" or "ESP"
    -- Update ESP logic here
    if espEnabled then
        -- Menampilkan ESP untuk semua pemain
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player then
                local espLabel = Instance.new("BillboardGui", v.Character)
                espLabel.Size = UDim2.new(0, 200, 0, 50)
                espLabel.StudsOffset = Vector3.new(0, 3, 0)
                
                local nameLabel = Instance.new("TextLabel", espLabel)
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = v.Name
                nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                nameLabel.TextStrokeTransparency = 0.5

                local healthLabel = Instance.new("TextLabel", espLabel)
                healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
                healthLabel.BackgroundTransparency = 1
                healthLabel.Text = "Health: " .. (v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health or "N/A")
                healthLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                healthLabel.TextStrokeTransparency = 0.5
            end
        end
    else
        -- Menyembunyikan ESP dari semua pemain
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= player then
                local espLabel = v.Character:FindFirstChildOfClass("BillboardGui")
                if espLabel then
                    espLabel:Destroy()
                end
            end
        end
    end
end)

-- Kill Aura Button
local killAuraButton = Instance.new("TextButton", gui)
killAuraButton.Size = UDim2.new(0, 150, 0, 50)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 170)
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Text = "Kill Aura V1"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local function getHighestDamageWeapon()
    -- Mengambil data senjata dari remote
    local response = game:HttpGet("https://raw.githubusercontent.com/YteamXXx/Yteam/main/GetItems.lua")
    local items = loadstring(response)()
    local highestDamage = 0
    local bestWeapon = nil

    for _, item in pairs(items) do
        if item.itemType == "MELEE_WEAPON" and item.itemStats.meleeDamage > highestDamage then
            highestDamage = item.itemStats.meleeDamage
            bestWeapon = item
        end
    end

    return bestWeapon
end

local function activateKillAura()
    local bestWeapon = getHighestDamageWeapon()
    if not bestWeapon then
        warn("No melee weapons found.")
        return
    end

    local weaponId = bestWeapon.id
    local range = 10  -- Radius serangan
    local playerPosition = player.Character.HumanoidRootPart.Position

    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local targetPosition = v.Character.HumanoidRootPart.Position
            local distance = (targetPosition - playerPosition).magnitude
            if distance <= range then
                -- Menggunakan senjata untuk menyerang
                for _ = 1, 2 do  -- 2 kali serangan
                    getgenv().remotes.meleeAI:FireServer(weaponId, v.Character.HumanoidRootPart.Position)
                end
            end
        end
    end
end

killAuraButton.MouseButton1Click:Connect(function()
    activateKillAura()
end)
