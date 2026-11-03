-- Tek dosya UI Library + Kullanım

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Tema
local Theme = {
	Background = Color3.fromRGB(20, 25, 40),
	Sidebar = Color3.fromRGB(15, 20, 35),
	Accent = Color3.fromRGB(80, 140, 255),
	Text = Color3.fromRGB(230, 235, 255),
	TextDim = Color3.fromRGB(160, 170, 200),
	ToggleOn = Color3.fromRGB(80, 140, 255),
	ToggleOff = Color3.fromRGB(50, 55, 75),
	Stroke = Color3.fromRGB(40, 50, 80),
	Element = Color3.fromRGB(25, 30, 48)
}

-- UI Library
local UILibrary = {}
UILibrary.__index = UILibrary

function UILibrary.new(title)
	local self = setmetatable({}, UILibrary)

	self.ScreenGui = Instance.new("ScreenGui")
	self.ScreenGui.Name = "2btrHub"
	self.ScreenGui.ResetOnSpawn = false
	self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	self.ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- Ana Frame
	self.Main = Instance.new("Frame")
	self.Main.Name = "Main"
	self.Main.Size = UDim2.new(0, 520, 0, 380)
	self.Main.Position = UDim2.new(0.5, -260, 0.5, -190)
	self.Main.BackgroundColor3 = Theme.Background
	self.Main.BorderSizePixel = 0
	self.Main.ClipsDescendants = true
	self.Main.Parent = self.ScreenGui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = self.Main

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Stroke
	stroke.Thickness = 1
	stroke.Parent = self.Main

	-- Arka plan resmi
	local backgroundImage = Instance.new("ImageLabel")
	backgroundImage.Name = "BackgroundImage"
	backgroundImage.Size = UDim2.new(1, 0, 1, 0)
	backgroundImage.BackgroundTransparency = 1
	backgroundImage.Image = "rbxassetid://140222022471910"
	backgroundImage.ImageTransparency = 0.65
	backgroundImage.ScaleType = Enum.ScaleType.Crop
	backgroundImage.ZIndex = 0
	backgroundImage.Parent = self.Main

	local imageCorner = Instance.new("UICorner")
	imageCorner.CornerRadius = UDim.new(0, 12)
	imageCorner.Parent = backgroundImage

	-- Üst bar (sürükleme buradan yapılacak)
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 32)
	topBar.BackgroundTransparency = 1
	topBar.ZIndex = 10
	topBar.Parent = self.Main

	-- Minimize (-) butonu
	local minimizeBtn = Instance.new("TextButton")
	minimizeBtn.Name = "Minimize"
	minimizeBtn.Size = UDim2.new(0, 32, 0, 32)
	minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
	minimizeBtn.BackgroundTransparency = 1
	minimizeBtn.Text = "—"
	minimizeBtn.TextColor3 = Theme.TextDim
	minimizeBtn.Font = Enum.Font.GothamBold
	minimizeBtn.TextSize = 18
	minimizeBtn.ZIndex = 11
	minimizeBtn.Parent = topBar

	minimizeBtn.MouseEnter:Connect(function()
		minimizeBtn.TextColor3 = Theme.Text
	end)
	minimizeBtn.MouseLeave:Connect(function()
		minimizeBtn.TextColor3 = Theme.TextDim
	end)

	-- Close (X) butonu
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "Close"
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.Position = UDim2.new(1, -36, 0, 0)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Theme.TextDim
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.ZIndex = 11
	closeBtn.Parent = topBar

	closeBtn.MouseEnter:Connect(function()
		closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
	end)
	closeBtn.MouseLeave:Connect(function()
		closeBtn.TextColor3 = Theme.TextDim
	end)

	closeBtn.MouseButton1Click:Connect(function()
		self.ScreenGui:Destroy()
	end)

	-- ======================
	-- FLOATING LOGO BUTTON
	-- ======================
	local clickGUIButton = Instance.new("ImageButton")
	clickGUIButton.Name = "ClickGUIButton"
	clickGUIButton.Size = UDim2.new(0, 70, 0, 70)
	clickGUIButton.Position = UDim2.new(0.92, 0, 0.15, 0)
	clickGUIButton.Image = "rbxassetid://134803730453170"
	clickGUIButton.BackgroundTransparency = 1
	clickGUIButton.Visible = false
	clickGUIButton.ZIndex = 20
	clickGUIButton.Parent = self.ScreenGui

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = clickGUIButton

	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 1
	aspect.Parent = clickGUIButton

	-- Draggable logo
	local draggingLogo = false
	local dragInputLogo, dragStartLogo, startPosLogo

	local function updateLogo(input)
		local delta = input.Position - dragStartLogo
		clickGUIButton.Position = UDim2.new(
			startPosLogo.X.Scale,
			startPosLogo.X.Offset + delta.X,
			startPosLogo.Y.Scale,
			startPosLogo.Y.Offset + delta.Y
		)
	end

	clickGUIButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingLogo = true
			dragStartLogo = input.Position
			startPosLogo = clickGUIButton.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					draggingLogo = false
				end
			end)
		end
	end)

	clickGUIButton.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInputLogo = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInputLogo and draggingLogo then
			updateLogo(input)
		end
	end)

	-- Minimize
	minimizeBtn.MouseButton1Click:Connect(function()
		self.Main.Visible = false
		clickGUIButton.Visible = true
	end)

	-- Logo tıklanınca UI açılsın
	clickGUIButton.MouseButton1Click:Connect(function()
		if draggingLogo then return end
		self.Main.Visible = true
		clickGUIButton.Visible = false
	end)

	-- Sidebar
	self.Sidebar = Instance.new("Frame")
	self.Sidebar.Name = "Sidebar"
	self.Sidebar.Size = UDim2.new(0, 140, 1, 0)
	self.Sidebar.BackgroundColor3 = Theme.Sidebar
	self.Sidebar.BackgroundTransparency = 0.15
	self.Sidebar.BorderSizePixel = 0
	self.Sidebar.ZIndex = 1
	self.Sidebar.Parent = self.Main

	local sideCorner = Instance.new("UICorner")
	sideCorner.CornerRadius = UDim.new(0, 12)
	sideCorner.Parent = self.Sidebar

	-- Başlık
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 0, 40)
	titleLabel.Position = UDim2.new(0, 10, 0, 10)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title or "UI Library"
	titleLabel.TextColor3 = Theme.Text
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 15
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 2
	titleLabel.Parent = self.Sidebar

	-- Tab Listesi
	self.TabList = Instance.new("ScrollingFrame")
	self.TabList.Name = "TabList"
	self.TabList.Size = UDim2.new(1, -10, 1, -60)
	self.TabList.Position = UDim2.new(0, 5, 0, 55)
	self.TabList.BackgroundTransparency = 1
	self.TabList.ScrollBarThickness = 3
	self.TabList.ScrollBarImageColor3 = Theme.Accent
	self.TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
	self.TabList.ZIndex = 2
	self.TabList.Parent = self.Sidebar

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = self.TabList
	self.ListLayout = listLayout

	-- Content
	self.Content = Instance.new("Frame")
	self.Content.Name = "Content"
	self.Content.Size = UDim2.new(1, -150, 1, -20)
	self.Content.Position = UDim2.new(0, 145, 0, 10)
	self.Content.BackgroundTransparency = 1
	self.Content.ZIndex = 1
	self.Content.Parent = self.Main

	self.Tabs = {}
	self.CurrentTab = nil

	-- Sürükleme SADECE topBar'dan
	self:MakeDraggable(self.Main, topBar)

	return self
end

function UILibrary:MakeDraggable(frame, dragHandle)
	local dragging = false
	local dragInput, dragStart, startPos

	dragHandle.InputBegan:Connect(function(input)
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

	dragHandle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function UILibrary:CreateTab(name, icon)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, -10, 0, 32)
	tabButton.BackgroundColor3 = Color3.fromRGB(25, 30, 50)
	tabButton.BackgroundTransparency = 1
	tabButton.Text = "  " .. (icon or "•") .. "  " .. name
	tabButton.TextColor3 = Theme.TextDim
	tabButton.Font = Enum.Font.Gotham
	tabButton.TextSize = 13
	tabButton.TextXAlignment = Enum.TextXAlignment.Left
	tabButton.AutoButtonColor = false
	tabButton.ZIndex = 3
	tabButton.Parent = self.TabList

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabButton

	local tabContent = Instance.new("ScrollingFrame")
	tabContent.Name = name
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.Visible = false
	tabContent.ScrollBarThickness = 4
	tabContent.ScrollBarImageColor3 = Theme.Accent
	tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabContent.ZIndex = 2
	tabContent.Parent = self.Content

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.Parent = tabContent

	local contentPadding = Instance.new("UIPadding")
	contentPadding.PaddingLeft = UDim.new(0, 8)
	contentPadding.PaddingRight = UDim.new(0, 8)
	contentPadding.PaddingTop = UDim.new(0, 5)
	contentPadding.Parent = tabContent

	local tab = {
		Button = tabButton,
		Content = tabContent,
		Name = name
	}

	table.insert(self.Tabs, tab)

	contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 15)
	end)

	self.ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		self.TabList.CanvasSize = UDim2.new(0, 0, 0, self.ListLayout.AbsoluteContentSize.Y + 10)
	end)

	tabButton.MouseButton1Click:Connect(function()
		self:SelectTab(tab)
	end)

	if #self.Tabs == 1 then
		self:SelectTab(tab)
	end

	return tab
end

function UILibrary:SelectTab(tab)
	for _, t in pairs(self.Tabs) do
		t.Content.Visible = false
		t.Button.BackgroundTransparency = 1
		t.Button.TextColor3 = Theme.TextDim
	end

	tab.Content.Visible = true
	tab.Button.BackgroundTransparency = 0.6
	tab.Button.TextColor3 = Theme.Text
	self.CurrentTab = tab
end

function UILibrary:CreateSection(tab, text)
	local section = Instance.new("TextLabel")
	section.Size = UDim2.new(1, 0, 0, 24)
	section.BackgroundTransparency = 1
	section.Text = text
	section.TextColor3 = Theme.Accent
	section.Font = Enum.Font.GothamBold
	section.TextSize = 14
	section.TextXAlignment = Enum.TextXAlignment.Left
	section.ZIndex = 3
	section.Parent = tab.Content
end

function UILibrary:CreateToggle(tab, text, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 36)
	container.BackgroundColor3 = Theme.Element
	container.BackgroundTransparency = 0.25
	container.BorderSizePixel = 0
	container.ZIndex = 3
	container.Parent = tab.Content

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 4
	label.Parent = container

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 42, 0, 22)
	toggle.Position = UDim2.new(1, -52, 0.5, -11)
	toggle.BackgroundColor3 = default and Theme.ToggleOn or Theme.ToggleOff
	toggle.Text = ""
	toggle.AutoButtonColor = false
	toggle.ZIndex = 4
	toggle.Parent = container

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggle

	local circle = Instance.new("Frame")
	circle.Size = UDim2.new(0, 16, 0, 16)
	circle.Position = default and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
	circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	circle.BorderSizePixel = 0
	circle.ZIndex = 5
	circle.Parent = toggle

	local circleCorner = Instance.new("UICorner")
	circleCorner.CornerRadius = UDim.new(1, 0)
	circleCorner.Parent = circle

	local state = default or false

	toggle.MouseButton1Click:Connect(function()
		state = not state
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		TweenService:Create(toggle, tweenInfo, {
			BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
		}):Play()

		TweenService:Create(circle, tweenInfo, {
			Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		}):Play()

		if callback then
			callback(state)
		end
	end)

	return {
		Set = function(value)
			state = value
			toggle.BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff
			circle.Position = state and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		end,
		Get = function()
			return state
		end
	}
end

function UILibrary:CreateSlider(tab, text, min, max, default, callback)
	local container = Instance.new("Frame")
	container.Size = UDim2.new(1, 0, 0, 50)
	container.BackgroundColor3 = Theme.Element
	container.BackgroundTransparency = 0.25
	container.BorderSizePixel = 0
	container.ZIndex = 3
	container.Parent = tab.Content

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = container

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 20)
	label.Position = UDim2.new(0, 12, 0, 4)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Theme.Text
	label.Font = Enum.Font.Gotham
	label.TextSize = 13
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.ZIndex = 4
	label.Parent = container

	local valueLabel = Instance.new("TextLabel")
	valueLabel.Size = UDim2.new(0, 50, 0, 20)
	valueLabel.Position = UDim2.new(1, -58, 0, 4)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(default)
	valueLabel.TextColor3 = Theme.Accent
	valueLabel.Font = Enum.Font.GothamBold
	valueLabel.TextSize = 13
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.ZIndex = 4
	valueLabel.Parent = container

	local sliderBack = Instance.new("Frame")
	sliderBack.Size = UDim2.new(1, -24, 0, 6)
	sliderBack.Position = UDim2.new(0, 12, 0, 32)
	sliderBack.BackgroundColor3 = Color3.fromRGB(40, 45, 65)
	sliderBack.BorderSizePixel = 0
	sliderBack.ZIndex = 4
	sliderBack.Parent = container

	local backCorner = Instance.new("UICorner")
	backCorner.CornerRadius = UDim.new(1, 0)
	backCorner.Parent = sliderBack

	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = Theme.Accent
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 5
	sliderFill.Parent = sliderBack

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill

	local sliding = false

	local function update(input)
		local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
		local value = math.floor((min + (max - min) * pos) * 10) / 10

		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		valueLabel.Text = tostring(value)

		if callback then
			callback(value)
		end
	end

	sliderBack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = true
			update(input)
		end
	end)

	sliderBack.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			sliding = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)
end

-------------------------------------------------
-- KULLANIM
-------------------------------------------------

local Window = UILibrary.new("2btr Hub")

local MainTab = Window:CreateTab("Main", "🏠")
local PlayerTab = Window:CreateTab("Player", "👤")


local ESPEnabled = false
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "ESPFolder"
ESPFolder.Parent = game:GetService("CoreGui")

local ESPConnections = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function GetPlayerTeamColor(player)
	if player.Team and player.Team.TeamColor then
		return player.Team.TeamColor.Color
	elseif player.TeamColor then
		return player.TeamColor.Color
	end
	return Color3.fromRGB(255, 255, 255)
end

local function RemoveESP(player)
	local data = ESPConnections[player]

	if data then
		for _, connection in pairs(data.connections) do
			connection:Disconnect()
		end

		ESPConnections[player] = nil
	end

	local box = ESPFolder:FindFirstChild(player.Name)
	if box then
		box:Destroy()
	end

	local name = ESPFolder:FindFirstChild(player.Name .. "_Name")
	if name then
		name:Destroy()
	end
end

local function CreateESP(player)
	if player == LocalPlayer then return end
	if not ESPEnabled then return end

	RemoveESP(player)

	local character = player.Character
	if not character then return end

	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
		return
	end

	local teamColor = GetPlayerTeamColor(player)

	local connections = {}
	ESPConnections[player] = {
		connections = connections
	}

	local box = Instance.new("BoxHandleAdornment")
	box.Name = player.Name
	box.Adornee = humanoidRootPart
	box.AlwaysOnTop = true
	box.ZIndex = 10
	box.Size = humanoidRootPart.Size + Vector3.new(1, 2, 1)
	box.Transparency = 0.4
	box.Color3 = teamColor
	box.Parent = ESPFolder

	local billboard = Instance.new("BillboardGui")
	billboard.Name = player.Name .. "_Name"
	billboard.Adornee = humanoidRootPart
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = ESPFolder

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = player.Name
	nameLabel.TextColor3 = teamColor
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextSize = 14
	nameLabel.Parent = billboard

	local healthBar = Instance.new("Frame")
	healthBar.Size = UDim2.new(0.8, 0, 0, 4)
	healthBar.Position = UDim2.new(0.1, 0, 1, -8)
	healthBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	healthBar.BorderSizePixel = 0
	healthBar.Parent = billboard

	local function updateHealth()
		if not box.Parent or not billboard.Parent then return end

		local percent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)

		healthBar.Size = UDim2.new(0.8 * percent, 0, 0, 4)
		healthBar.BackgroundColor3 = Color3.fromRGB(
			255 * (1 - percent),
			255 * percent,
			0
		)
	end

	table.insert(connections, humanoid.HealthChanged:Connect(function()
		if humanoid.Health <= 0 then
			RemoveESP(player)
			return
		end

		updateHealth()
	end))

	table.insert(connections, player:GetPropertyChangedSignal("Team"):Connect(function()
		if box.Parent then
			local updatedColor = GetPlayerTeamColor(player)
			box.Color3 = updatedColor
			nameLabel.TextColor3 = updatedColor
		end
	end))

	table.insert(connections, humanoid.Died:Connect(function()
		RemoveESP(player)
	end))

	updateHealth()
end

local function ClearAllESP()
	for player in pairs(ESPConnections) do
		RemoveESP(player)
	end

	ESPFolder:ClearAllChildren()
end

local function ToggleESP(state)
	ESPEnabled = state
	ClearAllESP()

	if state then
		for _, player in ipairs(Players:GetPlayers()) do
			CreateESP(player)
		end
	end
end

local function SetupPlayer(player)
	player.CharacterAdded:Connect(function()
		if ESPEnabled then
			task.wait(0.5)

			if ESPEnabled then
				CreateESP(player)
			end
		end
	end)

	player.CharacterRemoving:Connect(function()
		RemoveESP(player)
	end)
end

Players.PlayerAdded:Connect(SetupPlayer)

Players.PlayerRemoving:Connect(function(player)
	RemoveESP(player)
end)

for _, player in ipairs(Players:GetPlayers()) do
	SetupPlayer(player)
end

-- Değerler
local SpeedEnabled = false
local SpeedValue = 23

local JumpEnabled = false
local JumpValue = 100

local function ApplyStats()
	local character = LocalPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if SpeedEnabled then
		humanoid.WalkSpeed = SpeedValue
	else
		humanoid.WalkSpeed = 16
	end

	if JumpEnabled then
		humanoid.JumpHeight = JumpValue
	else
		humanoid.JumpHeight = 7.2
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.3)
	ApplyStats()
end)

if LocalPlayer.Character then
	ApplyStats()
end


-------------------------------------------------
-- PLAYER TAB İÇERİK
-------------------------------------------------

Window:CreateSlider(PlayerTab, "Tween Speed", 20, 25, 25, function(value)
	FetchTweenSpeed = value
end)

local FetchTweenSpeed = 25 -- Fonksiyonlardan önce tanımlı olmalı!


Window:CreateToggle(PlayerTab, "Player ESP", false, function(state)
	ToggleESP(state)
end)


local TweenService = game:GetService("TweenService")

-- Pürüzsüz CFrame Tween fonksiyonu
local function TweenTo(root, targetCFrame, speed)
	speed = speed or FetchTweenSpeed
	local distance = (root.Position - targetCFrame.Position).Magnitude
	local duration = distance / speed

	if duration < 0.1 then duration = 0.1 end

	local tweenInfo = TweenInfo.new(
		duration,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)

	local tween = TweenService:Create(root, tweenInfo, { CFrame = targetCFrame })
	tween:Play()
	tween.Completed:Wait()
end

local function FetchBrickTool()
	local character = LocalPlayer.Character
	if not character then return end

	local root = character:FindFirstChild("HumanoidRootPart")
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	if not root then return end

	-- Alet elde veya çantada var mı kontrol et
	local hasInChar = character:FindFirstChild("BrickTool")
	local hasInBackpack = backpack and backpack:FindFirstChild("BrickTool")

	if not hasInChar and not hasInBackpack then
		-- Takım adını al
		local teamName = (LocalPlayer.Team and LocalPlayer.Team.Name) or LocalPlayer:GetAttribute("TeamName")
		if not teamName then return end

		-- Olası tüm harita modları:
		local possibleMaps = {"Classic", "Showdown", "Chaos", "Race"}
		local currentMap = nil

		for _, mapName in ipairs(possibleMaps) do
			local found = workspace:FindFirstChild(mapName)
			if found then
				currentMap = found
				break
			end
		end

		if not currentMap then
			warn("Desteklenen haritalardan hiçbiri (Classic, Showdown, Chaos) workspace içinde bulunamadı!")
			return
		end

		local teamFolder = currentMap:FindFirstChild(teamName)
		if not teamFolder then
			warn(currentMap.Name .. "." .. teamName .. " klasörü bulunamadı!")
			return
		end

		local giver = teamFolder:FindFirstChild("BlockMain") and teamFolder.BlockMain:FindFirstChild("Giver")
		if giver then
			-- 1. Başlangıç pozisyonunu sakla
			local startCFrame = root.CFrame
			local targetCFrame = giver.CFrame + Vector3.new(0, 3, 0)

			-- 2. Giver'a doğru tween ile git
			TweenTo(root, targetCFrame, FetchTweenSpeed)

			-- 3. Tool alımı için kısa bekleme
			task.wait(0.2)

			-- 4. Başlangıç noktasına geri dön
			TweenTo(root, startCFrame, FetchTweenSpeed)
		else
			warn(teamFolder.Name .. " içinde BlockMain.Giver bulunamadı!")
		end
	end
end

-- Açık kaldığı sürece alet yoksa otomatik gidip alan Toggle (Opsiyonel)
local AutoGetTool = false
Window:CreateToggle(PlayerTab, "Auto Get BrickTool", false, function(state)
	AutoGetTool = state
	if state then
		task.spawn(function()
			while AutoGetTool do
				FetchBrickTool()
				task.wait(1) -- Her 1 saniyede bir kontrol eder
			end
		end)
	end
end)
-------------------------------------------------
-- MAIN TAB İÇERİK
-------------------------------------------------

-- Değerler
local SpeedEnabled = false
local SpeedValue = 23

local JumpEnabled = false
local JumpValue = 70

local FlyEnabled = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyGyro = nil

local function ApplyStats()
	local character = LocalPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end

	if SpeedEnabled then
		humanoid.WalkSpeed = SpeedValue
	else
		humanoid.WalkSpeed = 16
	end

	if JumpEnabled then
		humanoid.JumpPower = JumpValue
	else
		humanoid.JumpPower = 50
	end
end

local function StartFly()
	local character = LocalPlayer.Character
	if not character then return end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end

	humanoid.PlatformStand = true

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	BodyVelocity.Velocity = Vector3.zero
	BodyVelocity.Parent = root

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	BodyGyro.P = 10000
	BodyGyro.Parent = root

	local connection
	connection = game:GetService("RunService").RenderStepped:Connect(function()
		if not FlyEnabled or not character or not character.Parent then
			connection:Disconnect()
			return
		end

		local camera = workspace.CurrentCamera
		local moveDirection = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			moveDirection = moveDirection + Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			moveDirection = moveDirection + Vector3.new(0, -1, 0)
		end

		if moveDirection.Magnitude > 0 then
			moveDirection = moveDirection.Unit * FlySpeed
		end

		BodyVelocity.Velocity = moveDirection
		BodyGyro.CFrame = camera.CFrame
	end)
end

local function StopFly()
	local character = LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
	end

	if BodyVelocity then
		BodyVelocity:Destroy()
		BodyVelocity = nil
	end
	if BodyGyro then
		BodyGyro:Destroy()
		BodyGyro = nil
	end
end

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(0.3)
	StopFly()
	FlyEnabled = false
	ApplyStats()
end)

if LocalPlayer.Character then
	ApplyStats()
end

local function OnCharacterSpawn(character)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then return end

	-- Roblox'un hızı varsayılana sıfırlamasını bekleyip ezmek için kısa gecikme
	task.wait(0.2)
	ApplyStats()

	-- Oyun motoru WalkSpeed veya Jump'ı sıfırlamaya çalışırsa hemen engelle
	humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if SpeedEnabled and humanoid.WalkSpeed ~= SpeedValue then
			humanoid.WalkSpeed = SpeedValue
		end
	end)

	humanoid:GetPropertyChangedSignal("JumpHeight"):Connect(function()
		if JumpEnabled and humanoid.JumpHeight ~= JumpValue then
			humanoid.JumpHeight = JumpValue
		end
	end)
end

LocalPlayer.CharacterAdded:Connect(OnCharacterSpawn)

if LocalPlayer.Character then
	task.spawn(function()
		OnCharacterSpawn(LocalPlayer.Character)
	end)
end


Window:CreateToggle(MainTab, "Speed", false, function(state)
	SpeedEnabled = state
	ApplyStats()
end)

Window:CreateSlider(MainTab, "Speed Value", 16, 26, 23, function(value)
	SpeedValue = value
	if SpeedEnabled then
		ApplyStats()
	end
end)

Window:CreateToggle(MainTab, "JumpPower", false, function(state)
	JumpEnabled = state
	ApplyStats()
end)

Window:CreateSlider(MainTab, "JumpPower Value", 50, 150, 100, function(value)
	JumpValue = value
	if JumpEnabled then
		ApplyStats()
	end
end)

Window:CreateToggle(MainTab, "Fly", false, function(state)
	FlyEnabled = state
	if state then
		StartFly()
	else
		StopFly()
	end
end)

Window:CreateSlider(MainTab, "Fly Speed", 10, 30, 26, function(value)
	FlySpeed = value
end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local AnchorMoveEnabled = false
local MoveSpeed = 0.3

local keys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Up = false,
    Down = false
}

local function SetKey(key, state)
    keys[key] = state
end

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    local key = input.KeyCode.Name
    if keys[key] ~= nil then
        SetKey(key, true)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    local key = input.KeyCode.Name
    if keys[key] ~= nil then
        SetKey(key, false)
    end
end)

-- Mobile GUI
local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "AnchorMobileControls"
mobileGui.ResetOnSpawn = false
mobileGui.Enabled = false
mobileGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180, 160)
frame.Position = UDim2.new(1, -200, 1, -190)
frame.BackgroundTransparency = 1
frame.Parent = mobileGui

local function CreateButton(name, text, x, y, key)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.fromOffset(52, 45)
    button.Position = UDim2.fromOffset(x, y)
    button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    button.BackgroundTransparency = 0.15
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Text = text
    button.TextSize = 20
    button.Parent = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = button

    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            SetKey(key, true)
        end
    end)

    button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            SetKey(key, false)
        end
    end)
end

CreateButton("Forward", "▲", 62, 0, "W")
CreateButton("Left", "◀", 6, 52, "A")
CreateButton("Backward", "▼", 62, 52, "S")
CreateButton("Right", "▶", 118, 52, "D")
CreateButton("Up", "+", 6, 105, "Up")
CreateButton("Down", "−", 118, 105, "Down")

-- Movement
RunService.RenderStepped:Connect(function()
    if not AnchorMoveEnabled then return end

    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    local camera = workspace.CurrentCamera
    local move = Vector3.zero

    if keys.W then move += camera.CFrame.LookVector end
    if keys.S then move -= camera.CFrame.LookVector end
    if keys.D then move += camera.CFrame.RightVector end
    if keys.A then move -= camera.CFrame.RightVector end
    if keys.Up then move += Vector3.new(0, 1, 0) end
    if keys.Down then move -= Vector3.new(0, 1, 0) end

    if move.Magnitude > 0 then
        root.CFrame += move.Unit * MoveSpeed
    end
end)

Window:CreateToggle(MainTab, "Blink Exploit", false, function(state)
    AnchorMoveEnabled = state
    mobileGui.Enabled = state and UserInputService.TouchEnabled

    if state then
        local character = player.Character or player.CharacterAdded:Wait()
        character.HumanoidRootPart.Anchored = true
    else
        local character = player.Character
        if character then
            character.HumanoidRootPart.Anchored = false
        end

        for key in pairs(keys) do
            keys[key] = false
        end
    end
end)