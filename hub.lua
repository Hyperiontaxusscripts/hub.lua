-- Smok3yyy Hub (Rebuilt)

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

local function GetChar()
    return Player.Character or Player.CharacterAdded:Wait()
end

local function GetHum()
    return GetChar():WaitForChild("Humanoid")
end

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "Smok3yyyHub"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 320)
main.Position = UDim2.new(0.5,-250,0.5,-160)
main.BackgroundColor3 = Color3.fromRGB(18,18,18)
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)

-- Title
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "Smok3yyy Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.new(1,1,1)

-- Tabs
local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0,120,1,-40)
tabs.Position = UDim2.new(0,0,0,40)
tabs.BackgroundColor3 = Color3.fromRGB(25,25,25)

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,-120,1,-40)
content.Position = UDim2.new(0,120,0,40)
content.BackgroundTransparency = 1

-- Pages
local mainPage = Instance.new("Frame", content)
mainPage.Size = UDim2.new(1,0,1,0)
mainPage.BackgroundTransparency = 1

local uiPage = Instance.new("Frame", content)
uiPage.Size = UDim2.new(1,0,1,0)
uiPage.Visible = false
uiPage.BackgroundTransparency = 1

-- Toggle key
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
    end
end)

-- Helpers
local function Button(parent,text,callback)
    local b = Instance.new("TextButton",parent)
    b.Size = UDim2.new(1,-20,0,35)
    b.Position = UDim2.new(0,10,0,0)
    b.BackgroundColor3 = Color3.fromRGB(35,35,35)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextColor3 = Color3.new(1,1,1)
    b.TextSize = 14
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,6)

    b.MouseButton1Click:Connect(function()
        TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
        task.wait(0.15)
        TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3 = Color3.fromRGB(35,35,35)}):Play()
        callback()
    end)

    return b
end

local function TextBox(parent,placeholder,default)
    local box = Instance.new("TextBox",parent)
    box.Size = UDim2.new(1,-20,0,35)
    box.Position = UDim2.new(0,10,0,0)
    box.BackgroundColor3 = Color3.fromRGB(30,30,30)
    box.PlaceholderText = placeholder
    box.Text = tostring(default or "")
    box.TextColor3 = Color3.new(1,1,1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    Instance.new("UICorner",box).CornerRadius = UDim.new(0,6)
    return box
end

-- Tab buttons
Button(tabs,"Main",function()
    mainPage.Visible = true
    uiPage.Visible = false
end)

Button(tabs,"UI",function()
    mainPage.Visible = false
    uiPage.Visible = true
end)

---------------------------------------------------
-- FEATURES
---------------------------------------------------

local hum = GetHum()

Player.CharacterAdded:Connect(function()
    task.wait(1)
    hum = GetHum()
end)

-- Speed
local speedBox = TextBox(mainPage,"WalkSpeed",16)
speedBox.FocusLost:Connect(function()
    local v = tonumber(speedBox.Text)
    if v and hum then
        hum.WalkSpeed = v
    end
end)

-- Jump
local jumpBox = TextBox(mainPage,"JumpPower",50)
jumpBox.FocusLost:Connect(function()
    local v = tonumber(jumpBox.Text)
    if v and hum then
        hum.JumpPower = v
    end
end)

-- Infinite Jump
local infJump = false
Button(mainPage,"Infinite Jump",function()
    infJump = not infJump
end)

UIS.JumpRequest:Connect(function()
    if infJump and hum then
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip
local noclip = false
Button(mainPage,"Noclip",function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip then
        for _,v in pairs(GetChar():GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Fly
local flying = false
local flySpeed = 60

local flyBox = TextBox(mainPage,"Fly Speed",60)
flyBox.FocusLost:Connect(function()
    local v = tonumber(flyBox.Text)
    if v then flySpeed = v end
end)

Button(mainPage,"Fly",function()
    flying = not flying

    local char = GetChar()
    local hrp = char:WaitForChild("HumanoidRootPart")

    if flying then
        local bv = Instance.new("BodyVelocity",hrp)
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)

        local bg = Instance.new("BodyGyro",hrp)
        bg.MaxTorque = Vector3.new(9e9,9e9,9e9)

        RunService.RenderStepped:Connect(function()
            if not flying then return end

            local cam = workspace.CurrentCamera
            bg.CFrame = cam.CFrame
            bv.Velocity = cam.CFrame.LookVector * flySpeed
        end)
    end
end)

-- Godmode
Button(mainPage,"Godmode",function()
    local char = GetChar()
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        h:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
    end
end)

-- ESP
local esp = false
Button(mainPage,"ESP",function()
    esp = not esp

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            if esp then
                local hl = Instance.new("Highlight",plr.Character)
            else
                if plr.Character:FindFirstChild("Highlight") then
                    plr.Character.Highlight:Destroy()
                end
            end
        end
    end
end)

-- Teleport
Button(mainPage,"Teleport Random Player",function()
    local list = Players:GetPlayers()
    local target = list[math.random(1,#list)]
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        GetChar():PivotTo(target.Character.HumanoidRootPart.CFrame)
    end
end)

---------------------------------------------------
-- UI PAGE
---------------------------------------------------

Button(uiPage,"Destroy UI",function()
    gui:Destroy()
end)
