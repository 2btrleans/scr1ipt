local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui oluştur
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- ImageLabel oluştur
local imageLabel = Instance.new("ImageLabel")
imageLabel.Parent = screenGui
imageLabel.Size = UDim2.new(0, 300, 0, 300)
imageLabel.Position = UDim2.new(0.5, -150, -0.3, 0) -- yukarıdan başlasın
imageLabel.BackgroundTransparency = 0
imageLabel.Image = "rbxassetid://140222022471910"
imageLabel.ImageTransparency = 0

-- Aşağı inme animasyonu
local appearTween = TweenService:Create(
	imageLabel,
	TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Position = UDim2.new(0.5, -150, 0.5, -150)}
)

appearTween:Play()
appearTween.Completed:Wait()

local Player = game.Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "benimiariyorsun"
ScreenGui.Parent = Player:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local Categories = {"COMBAT", "PLAYER", "MOVEMENT", "RENDER", "HUD"}
local CategoryFrames = {}

local ModuleProperties = {}

local OpenPropertyPanels = {}

-- Search bar oluşturma
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 200, 0, 26)
searchBox.Position = UDim2.new(0.5, -100, 0, 5) -- orta üst
searchBox.PlaceholderText = "Search..."
searchBox.Text = ""
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.Parent = ScreenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,6)
corner.Parent = searchBox

-- Arama fonksiyonu
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local query = searchBox.Text:lower()
	for catName, frame in pairs(CategoryFrames) do
		for _, btn in ipairs(frame:GetChildren()) do
			if btn:IsA("TextButton") then
				if query == "" or btn.Text:lower():find(query) then
					btn.Visible = true
				else
					btn.Visible = false
				end
			end
		end
	end
end)


local function playSound(assetId)
	local sound = Instance.new("Sound")
	sound.SoundId = assetId
	sound.Volume = 1
	sound.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	sound:Play()
	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

local function openProperties(moduleName)
	-- Eğer panel açık ise kapat
	if OpenPropertyPanels[moduleName] then
		OpenPropertyPanels[moduleName]:Destroy()
		OpenPropertyPanels[moduleName] = nil
		return
	end

	local props = ModuleProperties[moduleName]
	if not props then return end

	local propFrame = Instance.new("Frame")
	propFrame.Size = UDim2.new(0, 220, 0, 200)
	propFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
	propFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	propFrame.BorderSizePixel = 0
	propFrame.Parent = ScreenGui
	OpenPropertyPanels[moduleName] = propFrame  -- kaydet

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,10)
	corner.Parent = propFrame

	-- Title Bar
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,30)
	title.Text = moduleName .. " Özellikleri"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.BackgroundColor3 = Color3.fromRGB(180,20,20)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.Parent = propFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0,10)
	titleCorner.Parent = title

	-- Draggable
	local dragging = false
	local dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		propFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = propFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	title.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	local layout = Instance.new("UIListLayout")
	layout.Parent = propFrame
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,5)



	for _, feature in ipairs(props) do
		if feature.Type == "Slider" then
			local sliderFrame = Instance.new("Frame")
			sliderFrame.Size = UDim2.new(1, -10, 0, 30)
			sliderFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
			sliderFrame.Parent = propFrame

			local sliderCorner = Instance.new("UICorner")
			sliderCorner.CornerRadius = UDim.new(0,6)
			sliderCorner.Parent = sliderFrame

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(0.4,0,1,0)
			label.Text = feature.Name
			label.TextColor3 = Color3.fromRGB(255,255,255)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.TextSize = 14
			label.Parent = sliderFrame

			local slider = Instance.new("TextBox")
			slider.Size = UDim2.new(0.5,0,1,0)
			slider.Position = UDim2.new(0.45,0,0,0)
			slider.Text = tostring(feature.Value)
			slider.BackgroundColor3 = Color3.fromRGB(80,80,80)
			slider.TextColor3 = Color3.fromRGB(255,255,255)
			slider.Parent = sliderFrame

			slider.FocusLost:Connect(function()
				local val = tonumber(slider.Text)
				if val then
					if val < feature.Min then val = feature.Min end
					if val > feature.Max then val = feature.Max end
					feature.Value = val
					slider.Text = tostring(val)
				end
			end)

		elseif feature.Type == "Boolean" then
			local boolBtn = Instance.new("TextButton")
			boolBtn.Size = UDim2.new(1, -10, 0, 26)
			boolBtn.BackgroundColor3 = feature.Value and Color3.fromRGB(100,100,100) or Color3.fromRGB(60,60,60)
			boolBtn.Text = feature.Name
			boolBtn.TextColor3 = Color3.fromRGB(255,255,255)
			boolBtn.Font = Enum.Font.Gotham
			boolBtn.TextSize = 14
			boolBtn.Parent = propFrame

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,6)
			corner.Parent = boolBtn

			boolBtn.MouseButton1Click:Connect(function()
				feature.Value = not feature.Value
				boolBtn.BackgroundColor3 = feature.Value and Color3.fromRGB(100,100,100) or Color3.fromRGB(60,60,60)
			end)
		elseif feature.Type == "Color" then
			local colorBtn = Instance.new("TextButton")
			colorBtn.Size = UDim2.new(1, -10, 0, 26)
			colorBtn.BackgroundColor3 = feature.Value
			colorBtn.Text = feature.Name
			colorBtn.TextColor3 = Color3.fromRGB(255,255,255)
			colorBtn.Font = Enum.Font.Gotham
			colorBtn.TextSize = 14
			colorBtn.Parent = propFrame

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,6)
			corner.Parent = colorBtn

			local pickerOpen = false
			local pickerFrame
			local rainbowEnabled = false -- Rainbow aktif mi?

			colorBtn.MouseButton1Click:Connect(function()
				if pickerOpen then
					pickerFrame:Destroy()
					pickerOpen = false
					return
				end
				pickerOpen = true

				-- Panel oluştur
				pickerFrame = Instance.new("Frame")
				pickerFrame.Size = UDim2.new(0, 200, 0, 130) -- biraz daha büyük çünkü rainbow için yer lazım
				pickerFrame.Position = UDim2.new(0, 0, 0, 30)
				pickerFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
				pickerFrame.Parent = propFrame

				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0,6)
				corner.Parent = pickerFrame

				local function createSlider(name, colorComponent)
					local sliderFrame = Instance.new("Frame")
					sliderFrame.Size = UDim2.new(1, -10, 0, 20)
					sliderFrame.Position = UDim2.new(0,5,0, (#pickerFrame:GetChildren()-1)*25)
					sliderFrame.BackgroundColor3 = Color3.fromRGB(60,60,60)
					sliderFrame.Parent = pickerFrame

					local sliderCorner = Instance.new("UICorner")
					sliderCorner.CornerRadius = UDim.new(0,4)
					sliderCorner.Parent = sliderFrame

					local label = Instance.new("TextLabel")
					label.Size = UDim2.new(0.3,0,1,0)
					label.Text = name
					label.TextColor3 = Color3.fromRGB(255,255,255)
					label.BackgroundTransparency = 1
					label.Font = Enum.Font.Gotham
					label.TextSize = 12
					label.Parent = sliderFrame

					local input = Instance.new("TextBox")
					input.Size = UDim2.new(0.65,0,1,0)
					input.Position = UDim2.new(0.32,0,0,0)
					input.Text = tostring(math.floor(feature.Value[colorComponent]*255))
					input.TextColor3 = Color3.fromRGB(255,255,255)
					input.BackgroundColor3 = Color3.fromRGB(80,80,80)
					input.Font = Enum.Font.Gotham
					input.TextSize = 12
					input.Parent = sliderFrame

					input.FocusLost:Connect(function()
						local val = tonumber(input.Text)
						if val then
							if val < 0 then val = 0 end
							if val > 255 then val = 255 end
							feature.Value = Color3.new(
								colorComponent=="R" and val/255 or feature.Value.R,
								colorComponent=="G" and val/255 or feature.Value.G,
								colorComponent=="B" and val/255 or feature.Value.B
							)
							colorBtn.BackgroundColor3 = feature.Value
							input.Text = tostring(val)
						end
					end)
				end

				createSlider("R","R")
				createSlider("G","G")
				createSlider("B","B")

				-- Rainbow toggle
				local rainbowBtn = Instance.new("TextButton")
				rainbowBtn.Size = UDim2.new(1,-10,0,20)
				rainbowBtn.Position = UDim2.new(0,5,0,(#pickerFrame:GetChildren()-1)*25)
				rainbowBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
				rainbowBtn.Text = "Rainbow: OFF"
				rainbowBtn.TextColor3 = Color3.fromRGB(255,255,255)
				rainbowBtn.Font = Enum.Font.Gotham
				rainbowBtn.TextSize = 12
				rainbowBtn.Parent = pickerFrame

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0,4)
				btnCorner.Parent = rainbowBtn

				rainbowBtn.MouseButton1Click:Connect(function()
					rainbowEnabled = not rainbowEnabled
					rainbowBtn.Text = rainbowEnabled and "Rainbow: ON" or "Rainbow: OFF"
				end)
			end)

			-- Rainbow güncelleme
			game:GetService("RunService").RenderStepped:Connect(function()
				if rainbowEnabled then
					local t = tick()
					local r = math.sin(t*2)*0.5+0.5
					local g = math.sin(t*2 + 2)*0.5+0.5
					local b = math.sin(t*2 + 4)*0.5+0.5
					feature.Value = Color3.new(r,g,b)
					colorBtn.BackgroundColor3 = feature.Value
				end
			end)
		elseif feature.Type == "Mode" then
			local modeBtn = Instance.new("TextButton")
			modeBtn.Size = UDim2.new(1, -10, 0, 26)
			modeBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
			modeBtn.Text = feature.Name .. ": " .. feature.Value
			modeBtn.TextColor3 = Color3.fromRGB(255,255,255)
			modeBtn.Font = Enum.Font.Gotham
			modeBtn.TextSize = 14
			modeBtn.Parent = propFrame

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(0,6)
			corner.Parent = modeBtn

			modeBtn.MouseButton1Click:Connect(function()
				feature.Index = feature.Index + 1
				if feature.Index > #feature.Modes then feature.Index = 1 end
				feature.Value = feature.Modes[feature.Index]
				modeBtn.Text = feature.Name .. ": " .. feature.Value
			end)

		end
	end
end


local function addColor(moduleName, name, value)
	ModuleProperties[moduleName] = ModuleProperties[moduleName] or {}
	table.insert(ModuleProperties[moduleName], {Type="Color", Name=name, Value=value})
end

local function addSlider(moduleName, name, min, max, value)
	ModuleProperties[moduleName] = ModuleProperties[moduleName] or {}
	table.insert(ModuleProperties[moduleName], {Type="Slider", Name=name, Min=min, Max=max, Value=value})
end

local function addBoolean(moduleName, name, value)
	ModuleProperties[moduleName] = ModuleProperties[moduleName] or {}
	table.insert(ModuleProperties[moduleName], {Type="Boolean", Name=name, Value=value})
end

local function addMode(moduleName, name, modes, defaultIndex)
	ModuleProperties[moduleName] = ModuleProperties[moduleName] or {}
	table.insert(ModuleProperties[moduleName], {
		Type = "Mode",
		Name = name,
		Modes = modes,
		Index = defaultIndex or 1,
		Value = modes[defaultIndex or 1]
	})
end

-- Slider değerini al
local function getSlider(moduleName, featureName)
	local props = ModuleProperties[moduleName]
	if not props then return nil end
	for _, f in ipairs(props) do
		if f.Type == "Slider" and f.Name == featureName then
			return f.Value
		end
	end
	return nil
end

-- Boolean değerini al
local function getBoolean(moduleName, featureName)
	local props = ModuleProperties[moduleName]
	if not props then return nil end
	for _, f in ipairs(props) do
		if f.Type == "Boolean" and f.Name == featureName then
			return f.Value
		end
	end
	return nil
end

-- Color değerini al
local function getColor(moduleName, featureName)
	local props = ModuleProperties[moduleName]
	if not props then return nil end
	for _, f in ipairs(props) do
		if f.Type == "Color" and f.Name == featureName then
			return f.Value
		end
	end
	return nil
end

-- Mode değerini al
local function getMode(moduleName, featureName)
	local props = ModuleProperties[moduleName]
	if not props then return nil end
	for _, f in ipairs(props) do
		if f.Type == "Mode" and f.Name == featureName then
			return f.Value
		end
	end
	return nil
end

local NotifyContainer = Instance.new("Frame")
NotifyContainer.Size = UDim2.new(0, 250, 0, 0)
NotifyContainer.Position = UDim2.new(1, -10, 1, -10)  -- ekranın sağ altından 10px içeri
NotifyContainer.AnchorPoint = Vector2.new(1,1)         -- sağ alt köşe referans
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.Parent = ScreenGui

local UIList = Instance.new("UIListLayout")
UIList.Parent = NotifyContainer
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Padding = UDim.new(0, 5)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right
UIList.VerticalAlignment = Enum.VerticalAlignment.Bottom  -- önemli: aşağıdan yukarı



local function Notify(text, duration)
	duration = duration or 3
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
	frame.BorderSizePixel = 0
	frame.Parent = NotifyContainer

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,6)
	corner.Parent = frame

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 1, -10)
	label.Position = UDim2.new(0,5,0,5)
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextWrapped = true
	label.Parent = frame

	frame.BackgroundTransparency = 1
	label.TextTransparency = 1
	game.TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
	game.TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 0}):Play()

	delay(duration, function()
		local tweenFrame = game.TweenService:Create(frame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
		local tweenText = game.TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 1})
		tweenFrame:Play()
		tweenText:Play()
		tweenFrame.Completed:Connect(function()
			frame:Destroy()
		end)
	end)
end

local ToggleStates = {}

local function createCategoryWindow(name, position)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 220, 0, 280)
	frame.Position = position
	frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	frame.BorderSizePixel = 0
	frame.AnchorPoint = Vector2.new(0,0)
	frame.ClipsDescendants = true
	frame.Parent = ScreenGui

	local shadow = Instance.new("UICorner")
	shadow.CornerRadius = UDim.new(0, 10)
	shadow.Parent = frame

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 28)

	local clickGUIProps = ModuleProperties["ClickGUI"]
	if clickGUIProps then
		for _, feature in ipairs(clickGUIProps) do
			if feature.Type == "Color" and feature.Name == "Kategori Rengi" then
				title.BackgroundColor3 = feature.Value
			end
		end
	end

	if not title.BackgroundColor3 then
		title.BackgroundColor3 = Color3.fromRGB(180, 20, 20)
	end

	title.Text = name
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.Parent = frame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = title

	local dragging = false
	local dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	title.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)


	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			update(input)
		end
	end)

	local layout = Instance.new("UIListLayout")
	layout.Parent = frame
	layout.Padding = UDim.new(0,5)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.FillDirection = Enum.FillDirection.Vertical

	return frame
end

for i, cat in ipairs(Categories) do
	local pos = UDim2.new(0.05 + (i-1)*0.19, 0, 0.15, 0)
	CategoryFrames[cat] = createCategoryWindow(cat, pos)
end

local function createToggle(name, category, callback)
	local frame = CategoryFrames[category]
	if not frame then
		warn("Kategori bulunamadı:", category)
		return
	end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 26)
	btn.Position = UDim2.new(0,1,0,0)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = false
	btn.Parent = frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0,6)
	corner.Parent = btn

	local state = false
	ToggleStates[name] = state

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = state and Color3.fromRGB(100,100,100) or Color3.fromRGB(75,75,75)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = state and Color3.fromRGB(100,100,100) or Color3.fromRGB(60,60,60)
	end)

	btn.MouseButton1Click:Connect(function()
		state = not state
		ToggleStates[name] = state
		btn.BackgroundColor3 = state and Color3.fromRGB(100,100,100) or Color3.fromRGB(60,60,60)
		if callback then callback(state) end
		local notifyColor = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		Notify(name .. (state and " on!" or " off!"), 3, notifyColor)
		playSound("rbxassetid://15675059323")
	end)

end

local player = game.Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local watermarkGui = Instance.new("ScreenGui")
watermarkGui.Name = "WatermarkGui"
watermarkGui.ResetOnSpawn = false
watermarkGui.Parent = PlayerGui

local watermarkLabel = Instance.new("TextLabel")
watermarkLabel.Size = UDim2.new(0, 400, 0, 100)
watermarkLabel.Position = UDim2.new(1, -310, 0, -78)
watermarkLabel.BackgroundTransparency = 1
watermarkLabel.Text = "2btr & monster ON TOP"
watermarkLabel.TextSize = 30
watermarkLabel.Font = Enum.Font.SourceSansBold
watermarkLabel.Visible = false
watermarkLabel.Parent = watermarkGui

addColor("Watermark", "Color", Color3.fromRGB(255,0,0))

local function isToggleActive(name)
	return ToggleStates[name] or false
end

createToggle("ESP", "RENDER", function(on)
	print("ESP:", on)
end)

createToggle("Watermark", "HUD", function(on)
	if on then
		watermarkLabel.Visible = true
	else
		watermarkLabel.Visible = false
	end
end)

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if isToggleActive("Watermark") then
		watermarkLabel.TextColor3 = getColor("Watermark", "Color")
	end
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

createToggle("Speed", "MOVEMENT", function(on)
	if not on then
		-- kapatılınca ekstra bir şey yapmaya gerek yok
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if not isToggleActive("Speed") then return end

	local character = player.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end

	local moveDir = humanoid.MoveDirection
	if moveDir.Magnitude > 0 then
		local speed = getSlider("Speed", "Speed")
		root.CFrame = root.CFrame + (moveDir * speed * dt)
	end
end)


createToggle("HighJump", "MOVEMENT", function(on)
	local player = game.Players.LocalPlayer
	if on then
		player.Character.Humanoid.JumpHeight = getSlider("HighJump", "Power")
	else
		player.Character.Humanoid.JumpHeight = 16
	end
end)

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if isToggleActive("HighJump") then
		game.Players.LocalPlayer.Character.Humanoid.JumpHeight = getSlider("HighJump", "Power")
	end
end)


game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 99999
game:GetService("Players").LocalPlayer.CameraMode = Enum.CameraMode.Classic


local camera = workspace.CurrentCamera
createToggle("FOV", "RENDER", function(on)
    if on then
        camera.FieldOfView = getSlider("FOV", "FOV")
    else
        camera.FieldOfView = 70
    end
end)

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if isToggleActive("FOV") then
		camera.FieldOfView = getSlider("FOV", "FOV")
	end
end)

addSlider("FOV", "FOV",70, 120, 110)
addSlider("Speed", "Speed",20,50,40)
addSlider("HighJump", "Power",20,100,30)
addColor("ESP", "ESP Color", Color3.fromRGB(255,0,0))
addMode("ESP", "Mode", {"Box"}, 1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ESPs = {}

local function removeESP(player)
	local esp = ESPs[player]
	if esp then
		if typeof(esp) == "table" then
			for _, part in pairs(esp) do
				part:Destroy()
			end
		else
			esp:Destroy()
		end
		ESPs[player] = nil
	end
end

local function createESP(player)
	removeESP(player) -- varsa sil

	if not player.Character then return end
	local hrp = player.Character:WaitForChild("HumanoidRootPart", 5)
	local humanoid = player.Character:WaitForChild("Humanoid", 5)
	if not hrp or not humanoid then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Adornee = hrp
	box.Size = Vector3.new(2, humanoid.HipHeight * 2 + 2, 2)
	box.ZIndex = 0
	box.AlwaysOnTop = true
	box.Transparency = 0.2
	box.Parent = hrp

	ESPs[player] = box

	-- ölünce temizle
	humanoid.Died:Connect(function()
		removeESP(player)
	end)
end

-- Render loop
RunService.RenderStepped:Connect(function()
	if isToggleActive("ESP") then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= Players.LocalPlayer then
				if not ESPs[player] then
					createESP(player)
				else
					local esp = ESPs[player]
					if esp and esp:IsA("BoxHandleAdornment") then
						-- Eğer oyuncunun takımı varsa o rengini al, yoksa kırmızı yap
						local teamColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 0, 0)
						esp.Color3 = teamColor
					end
				end
			end
		end
	else
		for _, player in pairs(Players:GetPlayers()) do
			removeESP(player)
		end
	end
end)

-- Oyuncu yeniden doğduğunda ESP ekle
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		task.defer(function()
			if isToggleActive("ESP") then
				createESP(player)
			end
		end)
	end)
end)

-- Oyuncu çıkınca temizle
Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)

-- İlkten var olan oyunculara bağlan
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Players.LocalPlayer then
		if player.Character then
			createESP(player)
		end
		player.CharacterAdded:Connect(function()
			task.defer(function()
				if isToggleActive("ESP") then
					createESP(player)
				end
			end)
		end)
	end
end



-- =========================
-- Aimbot Modülü (Boolean: TeamCheck, WallCheck)
-- =========================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer


-- ModuleProperties tablosuna ekleme
addSlider("Spin", "Speed", 1, 5000, 1000) -- Slider: 1-5000, default 1000
createToggle("Spin", "MOVEMENT", function(on)
	local RunService = game:GetService("RunService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	if on then
		print("Spin aktif")

		-- RenderStepped ile döngü
		local conn
		conn = RunService.RenderStepped:Connect(function(dt)
			if not isToggleActive("Spin") then
				conn:Disconnect()
				return
			end
			local speed = getSlider("Spin", "Speed") or 1000
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(speed * dt), 0)
		end)

	else
		print("Spin kapalı")
		-- Toggle kapandığında bağlantıyı otomatik sonlandırıyoruz
	end
end)


createToggle("Hitbox", "COMBAT", function(on)
	-- RenderStepped ile yönetiliyor
end)

addSlider("Hitbox", "Size", 5, 20, 20)

local originalSizes = {}

local function updateHitbox(char, size)
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root then
		if not originalSizes[root] then
			originalSizes[root] = root.Size
		end
		root.Size = Vector3.new(size, size, size)
		root.Transparency = 0.5
		root.CanCollide = false
	end
end

local function resetHitbox(char)
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if root and originalSizes[root] then
		root.Size = originalSizes[root]
		root.Transparency = 0
		root.CanCollide = true
	end
end

RunService.RenderStepped:Connect(function()
	for _, ply in pairs(Players:GetPlayers()) do
		if ply ~= LocalPlayer and ply.Character and ply.Character:FindFirstChild("Humanoid") then
			if isToggleActive("Hitbox") then
				updateHitbox(ply.Character, getSlider("Hitbox", "Size") or 10)
			else
				resetHitbox(ply.Character)
			end
		end
	end
end)


-- Oyuncu ayrılırsa temizle
Players.PlayerRemoving:Connect(function(ply)
	if ply.Character then
		resetHitbox(ply.Character)
	end
end)


-- Menü girişleri (slider/color/mode/boolean)
addSlider("Aimbot", "FOV", 30, 300, 90)
addSlider("Aimbot", "Smooth", 1, 30, 6)
addColor("Aimbot", "FOV Color", Color3.fromRGB(255,255,0))
addMode("Aimbot", "TargetPart", {"Head","HumanoidRootPart"}, 1)

-- Yeni: boolean özellikler için addBoolean kullan
addBoolean("Aimbot", "TeamCheck", true)   -- aynı takımı hedefleme
addBoolean("Aimbot", "WallCheck", true)   -- duvar arkasındakini hedefleme (raycast)

-- FOV çemberi (Drawing)
local fovCircle
local function createFOVCircle()
	if Drawing and Drawing.new and not fovCircle then
		fovCircle = Drawing.new("Circle")
		fovCircle.Visible = false
		fovCircle.Thickness = 1.5
		fovCircle.NumSides = 64
		fovCircle.Radius = getSlider("Aimbot", "FOV") or 90
		fovCircle.Filled = false
		fovCircle.ZIndex = 999
		fovCircle.Transparency = 1
	end
end
createFOVCircle()

-- Mouse pozisyonunu güvenli al
local function getMouseVec2()
	local ok, m = pcall(function() return UserInputService:GetMouseLocation() end)
	if not ok or not m then
		return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
	end
	if typeof(m) == "Vector2" then
		return m
	elseif type(m) == "table" then
		return Vector2.new(m.X or m.x or 0, m.Y or m.y or 0)
	elseif type(m) == "userdata" and m.X and m.Y then
		return Vector2.new(m.X, m.Y)
	else
		return Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
	end
end

-- Hedef parçası alıcı
local function getTargetPartForCharacter(char)
	local modeIndex = getMode and getMode("Aimbot", "TargetPart") or 1
	local mode = (modeIndex == 1 and "Head") or "HumanoidRootPart"
	if mode == "Head" and char:FindFirstChild("Head") then
		return char.Head
	end
	return char:FindFirstChild("HumanoidRootPart")
end

-- Wall check: camera -> target raycast. Eğer ray başka bir şeyi vuruyorsa ve o şey hedef karakterinin descendant'ı değilse blocked.
local function isVisibleByRay(targetPart, targetPlayer)
	if not Camera or not targetPart then return false end

	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin)
	if direction.Magnitude <= 0 then return true end

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = { LocalPlayer.Character, targetPlayer.Character }
	-- gerekirse burada local silah gibi instance'lar eklenebilir

	local result = workspace:Raycast(origin, direction, params)
	if not result then
		return true
	end

	if result.Instance and result.Instance:IsDescendantOf(targetPlayer.Character) then
		return true
	end

	return false
end

-- En yakın düşmanı bul (mouse merkezli, piksel cinsinden FOV)
local function getClosestEnemy(fov)
	local closest = nil
	local shortest = math.huge
	local mousePos = getMouseVec2()
	if not Camera then return nil end

	-- boolean değerleri al (nil -> false)
	local teamCheckOn = getBoolean and getBoolean("Aimbot", "TeamCheck") or false
	local wallCheckOn = getBoolean and getBoolean("Aimbot", "WallCheck") or false

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
			-- TEAM CHECK: eğer açık ve her iki Team değeri varsa aynı takımı atla
			if teamCheckOn and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
				-- skip
			else
				local targetPart = getTargetPartForCharacter(player.Character)
				if targetPart then
					local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						-- WALL CHECK: eğer açık ve görünür değilse atla
						if wallCheckOn and not isVisibleByRay(targetPart, player) then
							-- blocked
						else
							local screenPos = Vector2.new(pos.X, pos.Y)
							local dist = (screenPos - mousePos).Magnitude
							if dist < shortest and dist <= fov then
								shortest = dist
								closest = targetPart
							end
						end
					end
				end
			end
		end
	end

	return closest
end

-- Kamerayı yumuşakça hedefe döndür
local function aimAt(targetPart, smooth)
	if not targetPart or not Camera then return end
	local camPos = Camera.CFrame.Position
	local targetPos = targetPart.Position

	local desiredDir = (targetPos - camPos)
	if desiredDir.Magnitude == 0 then return end
	desiredDir = desiredDir.Unit

	local currentDir = Camera.CFrame.LookVector

	local t = math.clamp(1 / math.max(smooth, 1), 0, 1)
	local newDir = currentDir:Lerp(desiredDir, t)

	local newCFrame = CFrame.new(camPos, camPos + newDir)
	Camera.CFrame = newCFrame
end

-- createToggle callback için persistent değişkenler (bağlantıları saklamak için)
local inputBeganConn, inputEndedConn, renderConn
local holdingRightClick = false

createToggle("Aimbot", "COMBAT", function(on)
	-- Açma
	if on then
		-- input eventleri (disconnect edilmiş olabilir, önce temizle)
		if inputBeganConn then inputBeganConn:Disconnect() inputBeganConn = nil end
		if inputEndedConn then inputEndedConn:Disconnect() inputEndedConn = nil end
		if renderConn then renderConn:Disconnect() renderConn = nil end

		holdingRightClick = false

		inputBeganConn = UserInputService.InputBegan:Connect(function(input, gpe)
			if gpe then return end
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				holdingRightClick = true
			end
		end)

		inputEndedConn = UserInputService.InputEnded:Connect(function(input, gpe)
			if input.UserInputType == Enum.UserInputType.MouseButton2 then
				holdingRightClick = false
			end
		end)

		-- Render loop
		renderConn = RunService.RenderStepped:Connect(function()
			-- FOV çemberi
			if fovCircle then
				if isToggleActive("Aimbot") then
					fovCircle.Visible = true
					fovCircle.Radius = getSlider("Aimbot", "FOV") or 90
					local color = getColor and getColor("Aimbot", "FOV Color") or Color3.fromRGB(255,255,0)
					fovCircle.Color = color
					local mpos = getMouseVec2()
					fovCircle.Position = Vector2.new(mpos.X, mpos.Y)
				else
					fovCircle.Visible = false
				end
			end

			-- Aimbot çalışması
			if holdingRightClick and isToggleActive("Aimbot") then
				local fov = getSlider("Aimbot", "FOV") or 90
				local smooth = getSlider("Aimbot", "Smooth") or 6

				local target = getClosestEnemy(fov)
				if target then
					aimAt(target, smooth)
				end
			end
		end)
	else
		-- Kapat -> bağlantıları temizle
		if inputBeganConn then inputBeganConn:Disconnect() inputBeganConn = nil end
		if inputEndedConn then inputEndedConn:Disconnect() inputEndedConn = nil end
		if renderConn then renderConn:Disconnect() renderConn = nil end
		holdingRightClick = false
		if fovCircle then fovCircle.Visible = false end
	end
end)

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = game.Players.LocalPlayer

createToggle("Bhop", "MOVEMENT", function(on)
    local holdingSpace = false
    local inputBeganConn, inputEndedConn, renderConn

    if on then
        -- Space tuşunu takip et
        inputBeganConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if not gpe and input.KeyCode == Enum.KeyCode.Space then
                holdingSpace = true
            end
        end)
        inputEndedConn = UserInputService.InputEnded:Connect(function(input, gpe)
            if input.KeyCode == Enum.KeyCode.Space then
                holdingSpace = false
            end
        end)

        -- Render loop
        renderConn = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            local humanoid = char and char:FindFirstChildOfClass("Humanoid")

            if humanoid and holdingSpace then
                -- Yerdeyse zıpla
                local state = humanoid:GetState()
                if state ~= Enum.HumanoidStateType.Freefall 
                and state ~= Enum.HumanoidStateType.Jumping then
                    humanoid.Jump = true
                end
            end
        end)
    else
        -- Kapatıldığında temizle
        if inputBeganConn then inputBeganConn:Disconnect() inputBeganConn = nil end
        if inputEndedConn then inputEndedConn:Disconnect() inputEndedConn = nil end
        if renderConn then renderConn:Disconnect() renderConn = nil end
        holdingSpace = false
    end
end)



-- Sağ tık ile panel açma
for modName,_ in pairs(CategoryFrames) do
	local frame = CategoryFrames[modName]
	for _, child in ipairs(frame:GetChildren()) do
		if child:IsA("TextButton") then
			child.MouseButton2Click:Connect(function()
				openProperties(child.Text)
			end)
		end
	end
end

-- ClickGUI Button
local clickGUIButton = Instance.new("ImageButton")
clickGUIButton.Size = UDim2.new(0, 80, 0, 80)
clickGUIButton.Position = UDim2.new(0.9, 0, 0.05, 0)
clickGUIButton.Image = "rbxassetid://92180089052568"
clickGUIButton.BackgroundTransparency = 1
clickGUIButton.Parent = ScreenGui

-- Yuvarlatılmış köşeler
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)  -- köşe yarıçapı 12px
corner.Parent = clickGUIButton

-- UIAspectRatioConstraint
local aspect = Instance.new("UIAspectRatioConstraint")
aspect.AspectRatio = 1
aspect.Parent = clickGUIButton

-- Draggable
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	clickGUIButton.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

clickGUIButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = clickGUIButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

clickGUIButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- ClickGUI aç/kapa
local clickGUIVisible = true
clickGUIButton.MouseButton1Click:Connect(function()
	clickGUIVisible = not clickGUIVisible
	for _, frame in pairs(CategoryFrames) do
		frame.Visible = clickGUIVisible
		searchBox.Visible = clickGUIVisible
	end
	Notify("ClickGUI " .. (clickGUIVisible and "on!" or "off!"), 2)
end)

-- Category Frame'leri için UICorner
for _, frame in pairs(CategoryFrames) do
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 10)  -- kategori köşeleri
	frameCorner.Parent = frame

	-- İçerik layout
	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,5)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Parent = frame
end

-- 4 saniye bekle
task.wait(4)

loadstring(game:HttpGet("https://pastebin.com/raw/AUFQ1WX3"))()

-- Kaybolma animasyonu
local disappearTween = TweenService:Create(
	imageLabel,
	TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{
		ImageTransparency = 1,
		Position = UDim2.new(0.5, -150, 0.55, -150)
	}
)

disappearTween:Play()

disappearTween.Completed:Connect(function()
	screenGui:Destroy()
end)
