-- Smok3yyy Hub
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local sg = Instance.new("ScreenGui")
sg.Name = "Smok3yyyHub"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 420, 0, 320)
main.Position = UDim2.new(0.5, -210, 0.5, -160)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Text = "🔥 Smok3yyy Hub"
title.TextColor3 = Color3.fromRGB(255,170,0)
title.Font = Enum.Font.GothamBold
title.TextSize = 26

local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Helper functions
local function createButton(text, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(55,55,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

local function createSlider(name, min, max, default, callback)
    local frame = Instance.new("Frame", main)
    frame.Size = UDim2.new(0.9,0,0,60)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1,0,0,25)
    label.BackgroundTransparency = 1
    label.Text = name.." : "..default
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.6,0,0,25)
    box.Position = UDim2.new(0.2,0,0,30)
    box.Text = tostring(default)
    box.BackgroundColor3 = Color3.fromRGB(70,70,70)
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.ClearTextOnFocus = false

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then
            val = math.clamp(val, min, max)
            box.Text = tostring(val)
            label.Text = name.." : "..val
            callback(val)
        else
            box.Text = tostring(default)
        end
    end)
end

-- FLY SYSTEM
local flying = false
local flyBV, flyBG
local keys = {W=false, A=false, S=false, D=false, Space=false, Shift=false}

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if keys[input.KeyCode.Name] ~= nil then
        keys[input.KeyCode.Name] = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if keys[input.KeyCode.Name] ~= nil then
        keys[input.KeyCode.Name] = false
    end
end)

local function startFly()
    flying = true
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBV.Parent = hrp
    flyBG = Instance.new("BodyGyro")
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
    flyBG.P = 1e4
    flyBG.Parent = hrp
    hum.PlatformStand = true

    RunService.RenderStepped:Connect(function()
        if not flying then return end
        local cam = workspace.CurrentCamera
        flyBG.CFrame = cam.CFrame

        local direction = Vector3.zero
        if keys.W then direction += cam.CFrame.LookVector end
        if keys.S then direction -= cam.CFrame.LookVector end
        if keys.A then direction -= cam.CFrame.RightVector end
        if keys.D then direction += cam.CFrame.RightVector end
        if keys.Space then direction += Vector3.new(0,1,0) end
        if keys.Shift then direction -= Vector3.new(0,1,0) end

        flyBV.Velocity = (direction.Magnitude>0) and direction.Unit*60 or Vector3.zero
    end)
end

local function stopFly()
    flying = false
    hum.PlatformStand = false
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end

createButton("🕊 Toggle Fly", function()
    if flying then stopFly() else startFly() end
end)

-- NOCLIP
local noclip = false
createButton("👻 Toggle Noclip", function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- WalkSpeed & JumpPower sliders
createSlider("WalkSpeed", 8, 500, hum.WalkSpeed, function(v) hum.WalkSpeed = v end)
createSlider("JumpPower", 10, 500, hum.JumpPower, function(v) hum.JumpPower = v end)

-- Toggle UI
createButton("👁 Toggle UI", function()
    sg.Enabled = not sg.Enabled
end)
```

---
