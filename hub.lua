--// Smok3yyy Hub v2

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

----------------------------------------------------
-- UI CREATION
----------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "Smok3yyyHub"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 460, 0, 340)
main.Position = UDim2.new(0.5, -230, 0.5, -170)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.BorderSizePixel = 0
main.Active = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- Smooth Drag
local dragging, dragInput, dragStart, startPos

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

----------------------------------------------------
-- TITLE
----------------------------------------------------

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(30,30,30)
title.Text = "🔥 Smok3yyy Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.fromRGB(255,170,0)

Instance.new("UICorner", title)

----------------------------------------------------
-- TAB SYSTEM
----------------------------------------------------

local tabs = Instance.new("Frame", main)
tabs.Size = UDim2.new(0,120,1,-50)
tabs.Position = UDim2.new(0,0,0,50)
tabs.BackgroundColor3 = Color3.fromRGB(25,25,25)

local pages = Instance.new("Frame", main)
pages.Size = UDim2.new(1,-120,1,-50)
pages.Position = UDim2.new(0,120,0,50)
pages.BackgroundTransparency = 1

local function createPage(name)
	local page = Instance.new("Frame", pages)
	page.Name = name
	page.Size = UDim2.new(1,0,1,0)
	page.Visible = false
	page.BackgroundTransparency = 1
	
	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0,8)
	
	return page
end

local function createTab(name, page)
	local btn = Instance.new("TextButton", tabs)
	btn.Size = UDim2.new(1,0,0,40)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.TextColor3 = Color3.new(1,1,1)
	
	btn.MouseButton1Click:Connect(function()
		for _,p in pairs(pages:GetChildren()) do
			if p:IsA("Frame") then p.Visible = false end
		end
		page.Visible = true
	end)
end

----------------------------------------------------
-- ELEMENT HELPERS
----------------------------------------------------

local function button(parent, text, callback)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	
	Instance.new("UICorner", b)
	
	b.MouseButton1Click:Connect(callback)
end

local function slider(parent, name, min, max, default, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(0.9,0,0,60)
	frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Instance.new("UICorner", frame)
	
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1,0,0,25)
	label.BackgroundTransparency = 1
	label.Text = name..": "..default
	label.TextColor3 = Color3.new(1,1,1)
	label.Font = Enum.Font.Gotham
	
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0.5,0,0,25)
	box.Position = UDim2.new(0.25,0,0,30)
	box.Text = tostring(default)
	box.BackgroundColor3 = Color3.fromRGB(50,50,50)
	box.TextColor3 = Color3.new(1,1,1)
	
	box.FocusLost:Connect(function()
		local num = tonumber(box.Text)
		if num then
			num = math.clamp(num,min,max)
			box.Text = num
			label.Text = name..": "..num
			callback(num)
		end
	end)
end

----------------------------------------------------
-- PAGES
----------------------------------------------------

local movementPage = createPage("Movement")
local playerPage = createPage("Player")
local uiPage = createPage("UI")

createTab("Movement", movementPage)
createTab("Player", playerPage)
createTab("UI", uiPage)

movementPage.Visible = true

----------------------------------------------------
-- FEATURES
----------------------------------------------------

-- Fly
local flying = false
local bv, bg
local speed = 60

local function flyToggle()
	flying = not flying
	
	if flying then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		
		bg = Instance.new("BodyGyro", root)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
		
		hum.PlatformStand = true
		
		RunService.RenderStepped:Connect(function()
			if not flying then return end
			
			local cam = workspace.CurrentCamera
			bg.CFrame = cam.CFrame
			
			local dir = Vector3.zero
			
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
			
			bv.Velocity = dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero
		end)
	else
		hum.PlatformStand = false
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end

button(movementPage,"Toggle Fly (F)", flyToggle)

slider(movementPage,"Fly Speed",10,200,60,function(v)
	speed = v
end)

-- Noclip
local noclip = false

button(movementPage,"Toggle Noclip", function()
	noclip = not noclip
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

-- WalkSpeed / Jump
slider(playerPage,"WalkSpeed",8,300,hum.WalkSpeed,function(v)
	hum.WalkSpeed = v
end)

slider(playerPage,"JumpPower",20,300,hum.JumpPower,function(v)
	hum.JumpPower = v
end)

-- UI Toggle
button(uiPage,"Toggle UI (RightShift)", function()
	gui.Enabled = not gui.Enabled
end)

----------------------------------------------------
-- KEYBINDS
----------------------------------------------------

UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		flyToggle()
	end
	
	if input.KeyCode == Enum.KeyCode.RightShift then
		gui.Enabled = not gui.Enabled
	end
end)
