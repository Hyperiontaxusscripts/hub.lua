-- Smok3yyy Hub

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "Smok3yyyHub"

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 300)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Smok3yyy Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Toggle with RightShift
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Tabs
local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(0,100,1,-30)
Tabs.Position = UDim2.new(0,0,0,30)
Tabs.BackgroundColor3 = Color3.fromRGB(30,30,30)

local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1,-100,1,-30)
Content.Position = UDim2.new(0,100,0,30)
Content.BackgroundTransparency = 1

local function CreateButton(text, parent, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(1,0,0,35)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Pages
local MainPage = Instance.new("Frame", Content)
MainPage.Size = UDim2.new(1,0,1,0)
MainPage.BackgroundTransparency = 1

local UIPage = Instance.new("Frame", Content)
UIPage.Size = UDim2.new(1,0,1,0)
UIPage.Visible = false
UIPage.BackgroundTransparency = 1

-- Tab Buttons
CreateButton("Main", Tabs, function()
    MainPage.Visible = true
    UIPage.Visible = false
end)

CreateButton("UI", Tabs, function()
    MainPage.Visible = false
    UIPage.Visible = true
end)

-- Features
local humanoid
local function GetHumanoid()
    Character = Player.Character or Player.CharacterAdded:Wait()
    humanoid = Character:FindFirstChildOfClass("Humanoid")
end

GetHumanoid()

Player.CharacterAdded:Connect(function()
    task.wait(1)
    GetHumanoid()
end)

-- WalkSpeed
CreateButton("Speed 50", MainPage, function()
    humanoid.WalkSpeed = 50
end)

-- JumpPower
CreateButton("Jump 100", MainPage, function()
    humanoid.JumpPower = 100
end)

-- Infinite Jump
local infJump = false
CreateButton("Infinite Jump", MainPage, function()
    infJump = not infJump
end)

UIS.JumpRequest:Connect(function()
    if infJump and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Noclip
local noclip = false
CreateButton("Noclip", MainPage, function()
    noclip = not noclip
end)

RunService.Stepped:Connect(function()
    if noclip and Character then
        for _,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- Fly
local flying = false
local flySpeed = 60
local bodyVel, bodyGyro

CreateButton("Fly", MainPage, function()
    flying = not flying
    
    if flying then
        local hrp = Character:WaitForChild("HumanoidRootPart")
        
        bodyVel = Instance.new("BodyVelocity", hrp)
        bodyVel.MaxForce = Vector3.new(1e5,1e5,1e5)
        
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)
        
        RunService.RenderStepped:Connect(function()
            if flying then
                bodyVel.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            end
        end)
        
    else
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

-- Godmode (basic)
CreateButton("Godmode", MainPage, function()
    if humanoid then
        humanoid.Name = "1"
        local clone = humanoid:Clone()
        clone.Parent = Character
        clone.Name = "Humanoid"
        task.wait()
        humanoid:Destroy()
    end
end)

-- ESP
local espEnabled = false

CreateButton("ESP", MainPage, function()
    espEnabled = not espEnabled
    
    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character then
            if espEnabled then
                local highlight = Instance.new("Highlight")
                highlight.Parent = plr.Character
            else
                if plr.Character:FindFirstChild("Highlight") then
                    plr.Character.Highlight:Destroy()
                end
            end
        end
    end
end)

-- Teleport to Player
CreateButton("Teleport Random Player", MainPage, function()
    local list = Players:GetPlayers()
    local target = list[math.random(1,#list)]
    
    if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        Character:PivotTo(target.Character.HumanoidRootPart.CFrame)
    end
end)

-- UI Page
CreateButton("Destroy UI", UIPage, function()
    ScreenGui:Destroy()
end)
