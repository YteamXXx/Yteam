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
    shotHitAi = interactions:WaitForChild("shotHitAi"),
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
