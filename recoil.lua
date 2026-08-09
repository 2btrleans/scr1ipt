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


-- ✅ Kill Effect Toggle Değişkeni
local killEffectEnabled = false

-- ✅ Senin UI Library sistemine göre toggle
createToggle("Kill Effect", "RENDER", function(on)
    killEffectEnabled = on
end)

-- ✅ Gerekli Servisler
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")

-- ✅ Ayarlar
local FADE_TIME = 3 -- Ruhun tamamen kaybolması
local NUMBER_OF_STEPS = 30 -- Fade adım sayısı
local RISE_HEIGHT = 8 -- Yukarı çıkma yüksekliği

-- ✅ Ruhu oluşturma fonksiyonu
local function createGhost(character: Model)
    local ghostCharacter = character:Clone()
    ghostCharacter.Name = character.Name .. "Ghost"

    -- Humanoid ve Animasyonları kaldır
    local humanoid = ghostCharacter:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid:Destroy()
    end
    for _, animTrack in ipairs(ghostCharacter:GetChildren()) do
        if animTrack:IsA("Animator") then
            animTrack:Destroy()
        end
    end

    local rootPart = ghostCharacter:FindFirstChild("HumanoidRootPart") :: BasePart?
    if not rootPart then
        ghostCharacter:Destroy()
        return
    end

    rootPart.Anchored = true
    rootPart.CanCollide = false
    local initialPosition = rootPart.Position

    -- Tüm parçaları şeffaflaştır ve CanCollide'ı kapat
    for _, obj in ipairs(ghostCharacter:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CanCollide = false
        elseif obj:IsA("Tool") then
            local toolHandle = obj:FindFirstChild("Handle") :: BasePart?
            if toolHandle then
                toolHandle.Anchored = true
                toolHandle.CanCollide = false
            end
            for _, toolPart in ipairs(obj:GetDescendants()) do
                if toolPart:IsA("BasePart") then
                    toolPart.CanCollide = false
                end
            end
        end
    end

    local player = Players:GetPlayerFromCharacter(character)
    if player then
        for _, item in ipairs(player.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                local clonedTool = item:Clone()
                clonedTool.Parent = ghostCharacter

                local toolHandle = clonedTool:FindFirstChild("Handle") :: BasePart?
                if toolHandle then
                    toolHandle.Anchored = true
                    toolHandle.CanCollide = false
                end
                for _, toolPart in ipairs(clonedTool:GetDescendants()) do
                    if toolPart:IsA("BasePart") then
                        toolPart.CanCollide = false
                    end
                end
            end
        end
    end

    ghostCharacter.Parent = workspace

    -- Fade-out işlemi
    local startTime = tick()
    local initialTransparencies: {[BasePart]: number} = {}

    for _, part in ipairs(ghostCharacter:GetDescendants()) do
        if part:IsA("BasePart") then
            initialTransparencies[part] = part.Transparency
        end
    end

    task.spawn(function()
        local stepDelay = FADE_TIME / NUMBER_OF_STEPS
        for i = 1, NUMBER_OF_STEPS do
            local elapsed = tick() - startTime
            local alpha = elapsed / FADE_TIME

            local currentRise = alpha * RISE_HEIGHT
            rootPart.CFrame = CFrame.new(initialPosition + Vector3.new(0, currentRise, 0)) * rootPart.CFrame.Rotation

            for _, obj in ipairs(ghostCharacter:GetDescendants()) do
                if obj:IsA("BasePart") then
                    obj.Transparency = initialTransparencies[obj] + alpha * (1 - initialTransparencies[obj])
                end
            end
            task.wait(stepDelay)
        end

        ghostCharacter:Destroy()
    end)
end

-- ✅ Karakter ölüm takip sistemi
local function onCharacterAdded(character: Model)
    local humanoid = character:WaitForChild("Humanoid") :: Humanoid

    humanoid.Died:Connect(function()
        if killEffectEnabled then
            createGhost(character)
        end
    end)
end

for _, player in Players:GetPlayers() do
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(onCharacterAdded)
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

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if isToggleActive("Speed") then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = getSlider("Speed", "Speed")
	end
end)


-- LocalScript (StarterPlayerScripts içine)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Toggle
local doubleJumpEnabled = false
createToggle("Double Jump", "MOVEMENT", function(on)
    doubleJumpEnabled = on
end)

-- Jump değişkenleri
local jumpCount = 0
local maxJumpCount = 2
local isGrounded = true

-- Karakter respawn olursa resetle
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    jumpCount = 0
    isGrounded = true
end)

-- Zemini kontrol için raycast
local function checkGrounded()
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -3, 0) -- 3 stud aşağı
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local rayResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    return rayResult ~= nil
end

-- Input kontrolü
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not doubleJumpEnabled or gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
        isGrounded = checkGrounded()
        if isGrounded then
            jumpCount = 1
        elseif jumpCount < maxJumpCount then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            jumpCount = jumpCount + 1
        end
    end
end)

-- RunService ile sürekli zemini kontrol et ve jumpCount resetle
game:GetService("RunService").RenderStepped:Connect(function()
    if not doubleJumpEnabled then return end
    if checkGrounded() then
        jumpCount = 0
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

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ==========================
-- Variables
-- ==========================
local player = LocalPlayer
local runService = RunService
local uis = UserInputService

-- Third person
local thirdPersonEnabled = false
local distance = 10
local height = 5
local cameraRotation = Vector2.new(0, 0)
local sensitivity = 0.2

-- Aimbot
local holdingRightClick = false

-- ==========================
-- UI
-- ==========================
-- Third person toggle
createToggle("Third Person", "RENDER", function(on)
    thirdPersonEnabled = on
end)

-- FOV toggle (örnek)
createToggle("FOV", "RENDER", function(on)
    if on then
        Camera.FieldOfView = getSlider("FOV", "FOV")
    else
        Camera.FieldOfView = 70
    end
end)

-- Aimbot sliders, color, mode
addSlider("Aimbot", "FOV", 30, 300, 120)
addSlider("Aimbot", "Smooth", 1, 30, 1)
addColor("Aimbot", "FOV Color", Color3.fromRGB(255,255,0))
addMode("Aimbot", "TargetPart", {"Head","HumanoidRootPart"}, 2)
addBoolean("Aimbot", "TeamCheck", false)
addBoolean("Aimbot", "WallCheck", true)

-- ==========================
-- FOV Circle
-- ==========================
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

-- ==========================
-- Helper Functions
-- ==========================
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

local function getTargetPartForCharacter(char)
	local modeIndex = getMode and getMode("Aimbot", "TargetPart") or 1
	local mode = (modeIndex == 1 and "Head") or "HumanoidRootPart"
	if mode == "Head" and char:FindFirstChild("Head") then
		return char.Head
	end
	return char:FindFirstChild("HumanoidRootPart")
end

local function isVisibleByRay(targetPart, targetPlayer)
	if not Camera or not targetPart then return false end
	local origin = Camera.CFrame.Position
	local direction = (targetPart.Position - origin)
	if direction.Magnitude <= 0 then return true end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = { player.Character, targetPlayer.Character }
	local result = workspace:Raycast(origin, direction, params)
	if not result then return true end
	if result.Instance and result.Instance:IsDescendantOf(targetPlayer.Character) then return true end
	return false
end

local function getClosestEnemy(fov)
	local closest = nil
	local shortest = math.huge
	local mousePos = getMouseVec2()
	local teamCheckOn = getBoolean and getBoolean("Aimbot", "TeamCheck") or false
	local wallCheckOn = getBoolean and getBoolean("Aimbot", "WallCheck") or false
	for _, ply in pairs(Players:GetPlayers()) do
		if ply ~= player and ply.Character and ply.Character:FindFirstChild("Humanoid") then
			if teamCheckOn and player.Team and ply.Team and player.Team == ply.Team then
				-- skip same team
			else
				local targetPart = getTargetPartForCharacter(ply.Character)
				if targetPart then
					local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						if wallCheckOn and not isVisibleByRay(targetPart, ply) then
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

-- ==========================
-- Input
-- ==========================
uis.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and thirdPersonEnabled then
		cameraRotation = cameraRotation + Vector2.new(input.Delta.x, input.Delta.y) * sensitivity
		cameraRotation = Vector2.new(cameraRotation.X, math.clamp(cameraRotation.Y, -80, 80))
	end
end)

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		holdingRightClick = true
	end
end)

uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton2 then
		holdingRightClick = false
	end
end)


createToggle("Aimbot", "COMBAT", function(on)
	-- toggle aç/kapa burada bağlantılar yok, RenderStepped ile merkezi yönetiliyor
end)

local cameraDummy = nil -- kameranın olduğu yere koyulacak dummy
local cameraDummyHumanoid = nil

local function createDummyAt(position)

end

-- ==========================
-- Main RenderStepped
-- ==========================
runService.RenderStepped:Connect(function()
	local camPos = Camera.CFrame.Position
	
	-- ✅ Dummy yoksa oluştur, varsa konumunu güncelle
	if not cameraDummy then
		createDummyAt(camPos)
	else
		cameraDummy.PrimaryPart.Position = camPos
	end

	-- ✅ FOV Circle
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

	-- ✅ Karakter kontrolü
	if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character.HumanoidRootPart
	local finalCFrame = nil

	-- ✅ Aimbot öncelik
	local target = nil
	if holdingRightClick and isToggleActive("Aimbot") then
		local fov = getSlider("Aimbot", "FOV") or 90
		target = getClosestEnemy(fov)
	end

	if target then
		local targetPos = target.Position
		local desiredDir = (targetPos - camPos)
		if desiredDir.Magnitude > 0 then
			desiredDir = desiredDir.Unit
			local currentDir = Camera.CFrame.LookVector
			local smooth = getSlider("Aimbot", "Smooth") or 6
			local t = math.clamp(1 / math.max(smooth, 1), 0, 1)
			local newDir = currentDir:Lerp(desiredDir, t)
			finalCFrame = CFrame.new(camPos, camPos + newDir)
		end
	elseif thirdPersonEnabled then
		local rot = CFrame.Angles(0, math.rad(-cameraRotation.X), 0) * CFrame.Angles(math.rad(-cameraRotation.Y), 0, 0)
		local camOffset = rot.LookVector * -distance + Vector3.new(0, height, 0)
		finalCFrame = CFrame.new(hrp.Position + camOffset, hrp.Position + Vector3.new(0, 2, 0))
	end

	if finalCFrame then
		Camera.CFrame = finalCFrame
	end
end)








local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function()
	if isToggleActive("FOV") then
		camera.FieldOfView = getSlider("FOV", "FOV")
	end
end)


-- Services
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ==========================
-- Hitbox UI Ayarları
-- ==========================
createToggle("Hitbox", "COMBAT", function(on)
    -- Mantık RenderStepped içinde yönetiliyor
end)

addSlider("Hitbox", "Size", 2, 20, 10)

-- ==========================
-- Değişkenler
-- ==========================
local originalSizes = {} -- Modellerin orijinal boyutlarını saklar

-- Bir modelin geçerli bir hedef (Bot/Oyuncu) olup olmadığını kontrol eder
local function isValidTarget(obj)
    if obj:IsA("Model") and obj ~= LocalPlayer.Character then
        local hum = obj:FindFirstChildOfClass("Humanoid")
        local hrp = obj:FindFirstChild("HumanoidRootPart")
        -- Canı 0'dan büyük ve gerekli parçaları varsa geçerlidir
        if hum and hrp and hum.Health > 0 then
            return true
        end
    end
    return false
end

-- Hitbox'ı büyüt
local function applyHitbox(model, size)
    local root = model:FindFirstChild("HumanoidRootPart")
    if root then
        if not originalSizes[root] then
            originalSizes[root] = root.Size -- Orijinal boyutu tabloya kaydet
        end
        root.Size = Vector3.new(size, size, size)
        root.Transparency = 0.6 -- Görünürlüğü ayarla (0.6 idealdir)
        root.CanCollide = false -- Takılmaları önlemek için collision kapat
    end
end

-- Hitbox'ı orijinal haline döndür
local function resetHitbox(model)
    local root = model:FindFirstChild("HumanoidRootPart")
    if root and originalSizes[root] then
        root.Size = originalSizes[root] -- Eski boyuta dön
        root.Transparency = 1 -- HumanoidRootPart genelde tamamen şeffaftır
        root.CanCollide = true
        originalSizes[root] = nil -- Tablodan temizle
    end
end

-- ==========================
-- Ana Döngü (Update)
-- ==========================
RunService.RenderStepped:Connect(function()
    local hitboxActive = isToggleActive("Hitbox")
    local hitboxSize = getSlider("Hitbox", "Size") or 10

    -- Workspace içindeki her şeyi tara (Oyuncular + Botlar)
    for _, obj in ipairs(workspace:GetChildren()) do
        if isValidTarget(obj) then
            if hitboxActive then
                applyHitbox(obj, hitboxSize)
            else
                resetHitbox(obj)
            end
        end
    end

    -- Tablodaki eski verileri temizle (Ölen veya silinen modeller için)
    for root, _ in pairs(originalSizes) do
        if not root or not root.Parent or not root.Parent:FindFirstChild("Humanoid") or root.Parent:FindFirstChild("Humanoid").Health <= 0 then
            -- Eğer obje silindiyse veya öldüyse referansı temizle
            originalSizes[root] = nil
        end
    end
end)



addSlider("FOV", "FOV",70, 120, 110)
addSlider("Speed", "Speed",20,35,35)
addSlider("HighJump", "Power",20,100,30)
addColor("ESP", "ESP Color", Color3.fromRGB(255,0,0))
addMode("ESP", "Mode", {"Box","Chams"}, 2)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPs = {} -- Artık anahtar olarak 'Model' kullanacağız

-- ESP Sil (Model üzerinden)
local function removeESP(model)
	if ESPs[model] then
		if typeof(ESPs[model]) == "Instance" then
			ESPs[model]:Destroy()
		end
		ESPs[model] = nil
	end
end

-- BOX ESP
local function createBoxESP(model)
	local hrp = model:FindFirstChild("HumanoidRootPart")
	local hum = model:FindFirstChild("Humanoid")
	if not hrp or not hum then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = "ESP_BOX"
	box.Adornee = hrp
	-- Karakter boyuna göre dinamik boyut
	box.Size = Vector3.new(4, 6, 4) 
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Transparency = 0.3
	box.Color3 = getColor("ESP", "ESP Color")
	box.Parent = hrp

	ESPs[model] = box
end

-- CHAMS (Highlight)
local function createChamsESP(model)
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_CHAMS"
	highlight.Adornee = model
	highlight.FillColor = getColor("ESP", "ESP Color")
	highlight.OutlineColor = getColor("ESP", "ESP Color")
	highlight.FillTransparency = 0.5
	highlight.OutlineTransparency = 0
	highlight.Parent = model

	ESPs[model] = highlight
end

-- ESP Oluşturma Karar Mekanizması
local function createESP(model)
	if not isToggleActive("ESP") then return end
	if model == LocalPlayer.Character then return end
	
	-- Zaten varsa önce temizle
	removeESP(model)

	local mode = getMode("ESP", "Mode")
	if mode == "Box" then
		createBoxESP(model)
	elseif mode == "Chams" then
		createChamsESP(model)
	end
end

-- Bir modelin "canlı" olup olmadığını kontrol et (Oyuncu veya Bot)
local function isValidTarget(obj)
	if obj:IsA("Model") and obj ~= LocalPlayer.Character then
		local hum = obj:FindFirstChildOfClass("Humanoid")
		local hrp = obj:FindFirstChild("HumanoidRootPart")
		if hum and hrp and hum.Health > 0 then
			return true
		end
	end
	return false
end

-- Workspace'i tara ve takip et
workspace.DescendantAdded:Connect(function(descendant)
	task.wait(0.5) -- Yüklenmesi için kısa süre bekle
	if isValidTarget(descendant) then
		createESP(descendant)
	end
end)

-- Ana Loop: Güncelleme ve Temizlik
RunService.RenderStepped:Connect(function()
	if not isToggleActive("ESP") then
		for model, _ in pairs(ESPs) do
			removeESP(model)
		end
		return
	end

	local currentColor = getColor("ESP", "ESP Color")
	local currentMode = getMode("ESP", "Mode")

	-- Workspace içindeki her şeyi kontrol et (Daha geniş kapsam)
	for _, obj in ipairs(workspace:GetChildren()) do
		if isValidTarget(obj) then
			local esp = ESPs[obj]
			
			if not esp then
				createESP(obj)
			else
				-- Mod değiştiyse yenile
				local isBox = esp:IsA("BoxHandleAdornment")
				if (currentMode == "Box" and not isBox) or (currentMode == "Chams" and isBox) then
					removeESP(obj)
					createESP(obj)
				else
					-- Renkleri güncelle
					if isBox then
						esp.Color3 = currentColor
					else
						esp.FillColor = currentColor
						esp.OutlineColor = currentColor
					end
				end
			end
		end
	end

	-- Ölen veya silinen modelleri temizle
	for model, _ in pairs(ESPs) do
		if not model.Parent or not model:FindFirstChild("Humanoid") or model:FindFirstChild("Humanoid").Health <= 0 then
			removeESP(model)
		end
	end
end)

-- Başlangıçta halihazırda var olanları tara
for _, obj in ipairs(workspace:GetChildren()) do
	if isValidTarget(obj) then
		createESP(obj)
	end
end

-- LocalScript (StarterPlayerScripts)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local ghostData = {} -- [Player] = {Model = ..., History = {...}}

local delayMultiplier = 1 -- Ping bazlı gecikme katsayısı
local isVisualizerActive = false

-- Toggle fonksiyonun UI sistemine göre değiştirilebilir
createToggle("Visualizer", "RENDER", function(on)
	isVisualizerActive = on

	if not on then
		for _, gd in pairs(ghostData) do
			if gd.Model then gd.Model:Destroy() end
		end
		ghostData = {}
	else
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				createGhost(plr)
			end
		end
	end
end)

-- Dummy/ghost oluşturma
function createGhost(player)
	if ghostData[player] then return end
	local char = player.Character
	if not char then return end

	local ghost = Instance.new("Model")
	ghost.Name = player.Name .. "_VisualizerGhost"

-- Ghost oluşturma kısmı güncellendi
for _, part in ipairs(char:GetChildren()) do
	if part:IsA("BasePart") then
		local ghostPart = Instance.new("Part")
		ghostPart.Name = part.Name
		ghostPart.Size = part.Size
		ghostPart.Anchored = false
		ghostPart.CanCollide = false
		ghostPart.Transparency = 0.4 -- biraz saydam
		ghostPart.Color = part.Color -- karakterle aynı renk
		ghostPart.Material = Enum.Material.SmoothPlastic -- parlamaz
		ghostPart.CFrame = part.CFrame
		ghostPart.Parent = ghost
	end
end


	-- HRP ekle
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		local ghostHrp = Instance.new("Part")
		ghostHrp.Name = "HumanoidRootPart"
		ghostHrp.Size = hrp.Size
		ghostHrp.Anchored = false
		ghostHrp.CanCollide = false
		ghostHrp.Transparency = 1
		ghostHrp.CFrame = hrp.CFrame
		ghostHrp.Parent = ghost
	end

	ghost.Parent = workspace
	ghostData[player] = {
		Model = ghost,
		History = {},
	}
end

-- Ghost kaldırma
function removeGhost(player)
	if ghostData[player] then
		if ghostData[player].Model then
			ghostData[player].Model:Destroy()
		end
		ghostData[player] = nil
	end
end

-- Oyuncuların karakter değişimi
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		if isVisualizerActive and player ~= LocalPlayer then
			task.wait(0.5)
			createGhost(player)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	removeGhost(player)
end)

-- Mevcut karakterler için ghost oluştur
for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= LocalPlayer and plr.Character then
		createGhost(plr)
	end
end

-- RenderStepped ile sürekli güncelle
RunService.RenderStepped:Connect(function()
	if not isVisualizerActive then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local hrp = player.Character.HumanoidRootPart
			local gd = ghostData[player]
			if not gd then
				createGhost(player)
				gd = ghostData[player]
			end

			-- Ping bazlı gecikme
			local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() or 100
			local delayTime = (ping / 1000) * delayMultiplier

			-- Tarihçe ekle
			table.insert(gd.History, {
				Time = tick(),
				CFrame = hrp.CFrame
			})

			local ghostModel = gd.Model
			local ghostHrp = ghostModel:FindFirstChild("HumanoidRootPart")

			-- Gecikmeli pozisyon uygula
			for i, record in ipairs(gd.History) do
				if tick() - record.Time >= delayTime then
					if ghostHrp then
						ghostHrp.CFrame = record.CFrame
						for _, ghostPart in ipairs(ghostModel:GetChildren()) do
							if ghostPart:IsA("BasePart") and ghostPart.Name ~= "HumanoidRootPart" then
								local orig = player.Character:FindFirstChild(ghostPart.Name)
								if orig and orig:IsA("BasePart") then
									local relative = orig.CFrame:ToObjectSpace(hrp.CFrame)
									ghostPart.CFrame = record.CFrame * relative
								end
							end
						end
					end
					table.remove(gd.History, i)
					break
				end
			end
		end
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