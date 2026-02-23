-- Smok3yyy Hub Script
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")

local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
local hum=char:WaitForChild("Humanoid")
local hrp=char:WaitForChild("HumanoidRootPart")

-- GUI
local sg=Instance.new("ScreenGui")
sg.Name="Smok3yyyHub"
sg.ResetOnSpawn=false
sg.Parent=player:WaitForChild("PlayerGui")

local main=Instance.new("Frame",sg)
main.Size=UDim2.new(0,420,0,320)
main.Position=UDim2.new(0.5,-210,0.5,-160)
main.BackgroundColor3=Color3.fromRGB(25,25,25)
main.BorderSizePixel=0
main.Active=true
main.Draggable=true

local title=Instance.new("TextLabel",main)
title.Size=UDim2.new(1,0,0,50)
title.BackgroundColor3=Color3.fromRGB(35,35,35)
title.Text="🔥 Smok3yyy Hub"
title.TextColor3=Color3.fromRGB(255,170,0)
title.Font=Enum.Font.GothamBold
title.TextSize=26

local layout=Instance.new("UIListLayout",main)
layout.Padding=UDim.new(0,10)
layout.SortOrder=Enum.SortOrder.LayoutOrder

-- Helper: Button
local function createButton(text, callback)
    local btn=Instance.new("TextButton",main)
    btn.Size=UDim2.new(0.9,0,0,40)
    btn.BackgroundColor3=Color3.fromRGB(55,55,55)
    btn.TextColor3=Color3.new(1,1,1)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=18
    btn.Text=text
    btn.MouseButton1Click:Connect(callback)
end

-- Helper: Slider
local function createSlider(name,min,max,default,callback)
    local frm=Instance.new("Frame",main)
    frm.Size=UDim2.new(0.9,0,0,60)
    frm.BackgroundColor3=Color3.fromRGB(40,40,40)

    local lbl=Instance.new("TextLabel",frm)
    lbl.Size=UDim2.new(1,0,0,25)
    lbl.BackgroundTransparency=1
    lbl.Text=name.." : "..default
    lbl.TextColor3=Color3.new(1,1,1)
    lbl.Font=Enum.Font.Gotham
    lbl.TextSize=16

    local box=Instance.new("TextBox",frm)
    box.Size=UDim2.new(0.6,0,0,25)
    box.Position=UDim2.new(0.2,0,0,30)
    box.Text=tostring(default)
    box.BackgroundColor3=Color3.fromRGB(70,70,70)
    box.TextColor3=Color3.new(1,1,1)
    box.Font=Enum.Font.Gotham
    box.TextSize=16
    box.ClearTextOnFocus=false

    box.FocusLost:Connect(function()
        local val=tonumber(box.Text)
        if val then
            val=math.clamp(val,min,max)
            box.Text=tostring(val)
            lbl.Text=name.." : "..val
            callback(val)
        else
            box.Text=tostring(default)
        end
    end)
end

-- FLY
local flying=false
local flyBV,flyBG
local keys={W=false,A=false,S=false,D=false,Space=false,Shift=false}

UserInputService.InputBegan:Connect(function(i,gpe)
    if gpe then return end
    if keys[i.KeyCode.Name]~=nil then keys[i.KeyCode.Name]=true end
end)

UserInputService.InputEnded:Connect(function(i)
    if keys[i.KeyCode.Name]~=nil then keys[i.KeyCode.Name]=false end
end)

local function startFly()
    flying=true
    flyBV=Instance.new("BodyVelocity",hrp)
    flyBV.MaxForce=Vector3.new(1e5,1e5,1e5)
    flyBG=Instance.new("BodyGyro",hrp)
    flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5)
    flyBG.P=1e4
    hum.PlatformStand=true

    RunService.RenderStepped:Connect(function()
        if not flying then return end
        local cam=workspace.CurrentCamera
        flyBG.CFrame=cam.CFrame
        local dir=Vector3.zero
        if keys.W then dir+=cam.CFrame.LookVector end
        if keys.S then dir-=cam.CFrame.LookVector end
        if keys.A then dir-=cam.CFrame.RightVector end
        if keys.D then dir+=cam.CFrame.RightVector end
        if keys.Space then dir+=Vector3.new(0,1,0) end
        if keys.Shift then dir-=Vector3.new(0,1,0) end
        flyBV.Velocity=(dir.Magnitude>0 and dir.Unit*60) or Vector3.zero
    end)
end

local function stopFly()
    flying=false
    hum.PlatformStand=false
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
end

createButton("🕊 Toggle Fly",function()
    if flying then stopFly() else startFly() end
end)

-- NOCLIP
local noclip=false
createButton("👻 Toggle Noclip",function() noclip=not noclip end)

RunService.Stepped:Connect(function()
    if noclip then
        for _,p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide=false
            end
        end
    end
end)

-- SLIDERS
createSlider("WalkSpeed",8,500,hum.WalkSpeed,function(v) hum.WalkSpeed=v end)
createSlider("JumpPower",10,500,hum.JumpPower,function(v) hum.JumpPower=v end)

-- TOGGLE UI
createButton("👁 Toggle UI",function() sg.Enabled=not sg.Enabled end)
