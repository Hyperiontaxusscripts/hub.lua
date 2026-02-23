--// Smok3yyy Hub Improved
--// Keybind: RightShift to toggle UI

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

----------------------------------------------------
-- UI
----------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 420, 0, 300)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Smok3yyy Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 22

----------------------------------------------------
-- Tabs
----------------------------------------------------

local Tabs = Instance.new("Frame", MainFrame)
Tabs.Size = UDim2.new(1,0,0,30)
Tabs.Position = UDim2.new(0,0,0,30)
Tabs.BackgroundColor3 = Color3.fromRGB(35,35,35)

local MainTab = Instance.new("TextButton", Tabs)
MainTab.Size = UDim2.new(0.5,0,1,0)
MainTab.Text = "Main"
MainTab.BackgroundColor3 = Color3.fromRGB(45,45,45)
MainTab.TextColor3 = Color3.new(1,1,1)

local UITab = Instance.new("TextButton", Tabs)
UITab.Size = UDim2.new(0.5,0,1,0)
UITab.Position = UDim2.new(0.5,0,0,0)
UITab.Text = "UI"
UITab.BackgroundColor3 = Color3.fromRGB(45,45,45)
UITab.TextColor3 = Color3.new(1,1,1)

local Container = Instance.new("Frame", MainFrame)
Container.Size = UDim2.new(1,0,1,-60)
Container.Position = UDim2.new(0,0,0,60)
Container.BackgroundTransparency = 1

local MainPage = Instance.new("Frame", Container)
MainPage.Size = UDim2.new(1,0,1,0)
MainPage.BackgroundTransparency = 1

local UIPage = Instance.new("Frame", Container)
UIPage.Size = UDim2.new(1,0,1,0)
UIPage.BackgroundTransparency = 1
UIPage.Visible = false

MainTab.MouseButton1Click:Connect(function()
    MainPage.Visible = true
    UIPage.Visible = false
end)

UITab.MouseButton1Click:Connect(function()
    MainPage.Visible = false
    UIPage.Visible = true
end)

----------------------------------------------------
-- Helper Button Creator
----------------------------------------------------

local function CreateButton(parent, text, posY, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0,180,0,30)
    btn.Position = UDim2.new(0,10,0,posY)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)

    btn.MouseButton1Click:Connect(callback)
end

----------------------------------------------------
-- FEATURES
----------------------------------------------------

-- Infinite Jump
local infJump = false
UIS.JumpRequest:Connect(function()
    if infJump then
        Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

CreateButton(MainPage,"Infinite Jump",10,function()
    infJump = not infJump
end)

----------------------------------------------------
-- Fly
----------------------------------------------------

local flying = false
local flySpeed = 50

local function Fly()
    local hrp = Character:WaitForChild("HumanoidRootPart")
    local bv = Instance.new("BodyVelocity", hrp)
    bv.MaxForce = Vector3.new(1e9,1e9,1e9)

    while flying do
        local dir = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
        bv.Velocity = dir * flySpeed
        RunService.RenderStepped:Wait()
    end

    bv:Destroy()
end

CreateButton(MainPage,"Fly Toggle",50,function()
    flying = not flying
    if flying then Fly() end
end)

CreateButton(MainPage,"Fly Speed +",90,function()
    flySpeed += 10
end)

CreateButton(MainPage,"Fly Speed -",130,function()
    flySpeed -= 10
end)

----------------------------------------------------
-- Noclip
----------------------------------------------------

local noclip = false

RunService.Stepped:Connect(function()
    if noclip and Character then
        for _,v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

CreateButton(MainPage,"Noclip",170,function()
    noclip = not noclip
end)

----------------------------------------------------
-- Godmode (basic)
----------------------------------------------------

CreateButton(MainPage,"Godmode",210,function()
    local hum = Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Health = hum.MaxHealth
        hum.Name = "Protected"
    end
end)

----------------------------------------------------
-- Teleport To Player
----------------------------------------------------

CreateButton(MainPage,"Teleport Random Player",250,function()
    local others = Players:GetPlayers()
    if #others > 1 then
        local target = others[math.random(1,#others)]
        if target ~= Player and target.Character then
            Character.HumanoidRootPart.CFrame =
                target.Character.HumanoidRootPart.CFrame
        end
    end
end)

----------------------------------------------------
-- ESP
----------------------------------------------------

local espEnabled = false

local function ESP(player)
    if player == Player then return end
    if not player.Character then return end

    local hl = Instance.new("Highlight")
    hl.Parent = player.Character
    hl.FillColor = Color3.new(1,0,0)
end

CreateButton(MainPage,"ESP Toggle",290,function()
    espEnabled = not espEnabled
    for _,plr in pairs(Players:GetPlayers()) do
        if espEnabled then
            ESP(plr)
        else
            if plr.Character then
                local h = plr.Character:FindFirstChildOfClass("Highlight")
                if h then h:Destroy() end
            end
        end
    end
end)

----------------------------------------------------
-- UI TAB
----------------------------------------------------

CreateButton(UIPage,"Destroy UI",10,function()
    ScreenGui:Destroy()
end)

----------------------------------------------------
-- Keybind Toggle
----------------------------------------------------

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
