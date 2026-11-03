local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CONFIG = {
	Name = "MinhDiemHub",
	Version = "v1.0",
	Developer = "Tran Khoa Diem",
	TelegramHandle = "@TranKhoaDiem",
	TelegramUrl = "https://t.me/TranKhoaDiem",
	MenuToggleKey = Enum.KeyCode.RightControl,
	WalkSpeed = { Min = 16, Max = 200, Default = 50, RestoreFallback = 16 },
	Jump = { Min = 50, Max = 300, Default = 120 },
	TweenSpeed = 120,
	Fly = { Min = 10, Max = 300, Default = 60, UpKey = Enum.KeyCode.Space, DownKey = Enum.KeyCode.Q },
	XRay = { MinPercent = 10, MaxPercent = 90, DefaultPercent = 60, BatchSize = 400 },
	Follow = { FrontDistance = 5, HeightOffset = 0, SkipTeammates = true, SnapDistance = 8, Sharpness = 14 },
	Hop = { Min = 1, Max = 30, DefaultSeconds = 3 },
	PanicKey = Enum.KeyCode.End,
	AutoAttack = { Min = 1, Max = 20, Default = 3 },
	Orbit = {
		Radius = { Min = 3, Max = 60, Default = 12 },
		Speed = { Min = 10, Max = 360, Default = 90 },
		Height = 3,
	},
	Fov = { Min = 40, Max = 120, Default = 90 },
	AutoChat = { Enabled = true, Message = "Chào Mừng Bạn Đến Với MinhDiemHub", DelaySeconds = 2 },
	ObjectEsp = {
		EnemyColor = Color3.fromRGB(255, 170, 0),
		LootColor = Color3.fromRGB(80, 200, 255),
		MaxHighlights = 28,
		FillTransparency = 0.6,
	},
	AutoClick = { Min = 1, Max = 30, Default = 10 },
	AttackRate = { Min = 1, Max = 30, Default = 4 },
	SearchInterval = 0.5,
	Farm = {
		EnemyTag = "FarmableEnemy",
		FallbackFolderName = "Enemies",
		HeightAboveEnemy = 8,
		HorizontalOffset = 2,
		SnapDistance = 8,
		FollowSharpness = 14,
		AttackInterval = 0.25,
	},
	Loot = {
		Tags = { "LootChest", "DevilFruit" },
		StopDistance = 4,
		HeightOffset = 2,
		ArriveTolerance = 1.5,
		CollectInterval = 1,
		GiveUpSeconds = 6,
		SkipSeconds = 20,
	},
	FullBright = {
		Brightness = 2,
		Ambient = Color3.fromRGB(150, 150, 150),
		OutdoorAmbient = Color3.fromRGB(150, 150, 150),
		ExposureCompensation = 0.3,
		GlobalShadows = false,
	},
	FixLag = {
		FogEnd = 1000000,
		BatchSize = 400,
		SimplifiedMaterial = Enum.Material.SmoothPlastic,
		DecorativeMaterials = {
			Enum.Material.Grass, Enum.Material.LeafyGrass, Enum.Material.Sand, Enum.Material.Slate,
			Enum.Material.Wood, Enum.Material.WoodPlanks, Enum.Material.Brick, Enum.Material.Cobblestone,
			Enum.Material.Concrete, Enum.Material.Marble, Enum.Material.Granite, Enum.Material.Pebble,
			Enum.Material.Ground, Enum.Material.Mud, Enum.Material.Snow, Enum.Material.Ice,
			Enum.Material.Sandstone, Enum.Material.Limestone, Enum.Material.Asphalt, Enum.Material.Basalt,
			Enum.Material.Pavement, Enum.Material.Rock, Enum.Material.Fabric, Enum.Material.CorrodedMetal,
			Enum.Material.DiamondPlate, Enum.Material.Glacier, Enum.Material.Salt,
		},
	},
	Esp = {
		EnemyColor = Color3.fromRGB(255, 80, 80),
		TeamColor = Color3.fromRGB(80, 255, 140),
		FillTransparency = 0.8,
		UpdateInterval = 0.2,
		MaxDistance = 2000,
		ShowName = true,
		ShowHealth = true,
		ShowDistance = true,
		HideTeammates = false,
		ShowTracers = true,
		TracerThickness = 1.5,
	},
	Aim = {
		FieldOfView = 150,
		Smoothness = 1,
		Mode = "Enemies",
		MaxDistance = 800,
		TargetPart = "Head",
		RequireHold = true,
		HoldInput = Enum.UserInputType.MouseButton2,
		TeamCheck = true,
		WallCheck = true,
	},
	NotificationSeconds = 2.5,
}

local THEME = {
	Background = Color3.fromRGB(0, 0, 0),
	Panel = Color3.fromRGB(7, 9, 8),
	Element = Color3.fromRGB(11, 16, 13),
	Stroke = Color3.fromRGB(0, 80, 48),
	Accent = Color3.fromRGB(0, 230, 120),
	AccentAlt = Color3.fromRGB(0, 190, 255),
	Text = Color3.fromRGB(205, 255, 228),
	TextDim = Color3.fromRGB(95, 145, 118),
	Success = Color3.fromRGB(0, 230, 120),
	Error = Color3.fromRGB(255, 60, 80),
	Warn = Color3.fromRGB(255, 196, 0),
	Font = Enum.Font.RobotoMono,
	FontBold = Enum.Font.RobotoMono,
}

local GUI_NAME = "MinhDiemHub"
local ESP_FOLDER_NAME = "MinhDiemHubEsp"
local AIM_BIND_NAME = "MinhDiemHubAim"

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

for _, name in ipairs({ ESP_FOLDER_NAME, ESP_FOLDER_NAME .. "ObjectsEnemies", ESP_FOLDER_NAME .. "ObjectsLoot" }) do
	local previousWorld = workspace:FindFirstChild(name)
	if previousWorld then
		previousWorld:Destroy()
	end
end

for _, name in ipairs({ GUI_NAME, ESP_FOLDER_NAME, ESP_FOLDER_NAME .. "Objects" }) do
	local previous = playerGui:FindFirstChild(name)
	if previous then
		previous:Destroy()
	end
end

local Janitor = {}
Janitor.__index = Janitor

function Janitor.new()
	return setmetatable({ items = {} }, Janitor)
end

function Janitor:Add(item)
	table.insert(self.items, item)
	return item
end

function Janitor:Clean()
	local items = self.items
	self.items = {}
	for index = #items, 1, -1 do
		local item = items[index]
		local kind = typeof(item)
		if kind == "RBXScriptConnection" then
			item:Disconnect()
		elseif kind == "thread" then
			task.cancel(item)
		elseif kind == "function" then
			item()
		elseif kind == "Instance" then
			if item:IsA("Tween") then
				item:Cancel()
			end
			item:Destroy()
		end
	end
end

local mainJanitor = Janitor.new()
local isShutdown = false

local function create(className, properties, parent)
	local instance = Instance.new(className)
	for property, value in pairs(properties) do
		instance[property] = value
	end
	instance.Parent = parent
	return instance
end

local function addCorner(instance, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, math.min(radius, 4)) }, instance)
end

local function addStroke(instance, color, thickness)
	return create("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, instance)
end

local function addPadding(instance, amount)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, amount),
		PaddingBottom = UDim.new(0, amount),
		PaddingLeft = UDim.new(0, amount),
		PaddingRight = UDim.new(0, amount),
	}, instance)
end

local function addList(instance, padding)
	return create("UIListLayout", {
		Padding = UDim.new(0, padding),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, instance)
end

local function createLabel(parent, text, textSize, color, font)
	return create("TextLabel", {
		BackgroundTransparency = 1,
		Text = text,
		TextSize = textSize,
		TextColor3 = color,
		Font = font or THEME.Font,
		TextXAlignment = Enum.TextXAlignment.Left,
		Size = UDim2.new(1, 0, 0, textSize + 4),
	}, parent)
end

local screenGui = create("ScreenGui", {
	Name = GUI_NAME,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local notifyContainer = nil
local toastCounter = 0
local NOTIFY_COLORS = { success = THEME.Success, error = THEME.Error, warn = THEME.Warn }

local function trimToasts()
	local toasts = {}
	for _, child in ipairs(notifyContainer:GetChildren()) do
		if child:IsA("Frame") then
			table.insert(toasts, child)
		end
	end
	table.sort(toasts, function(first, second)
		return first.LayoutOrder < second.LayoutOrder
	end)
	while #toasts > 4 do
		table.remove(toasts, 1):Destroy()
	end
end

local function notify(message, kind)
	if isShutdown or not notifyContainer then
		return
	end
	toastCounter += 1
	local accent = NOTIFY_COLORS[kind] or THEME.Accent
	local toast = create("Frame", {
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = THEME.Panel,
		BorderSizePixel = 0,
		LayoutOrder = toastCounter,
	}, notifyContainer)
	addCorner(toast, 8)
	local stroke = addStroke(toast, accent, 1)
	local label = createLabel(toast, message, 12, THEME.Text, THEME.Font)
	label.Size = UDim2.new(1, -16, 1, 0)
	label.Position = UDim2.fromOffset(10, 0)
	label.TextTruncate = Enum.TextTruncate.AtEnd
	trimToasts()
	task.delay(CONFIG.NotificationSeconds, function()
		if not toast.Parent then
			return
		end
		local info = TweenInfo.new(0.25)
		TweenService:Create(label, info, { TextTransparency = 1 }):Play()
		TweenService:Create(stroke, info, { Transparency = 1 }):Play()
		local fade = TweenService:Create(toast, info, { BackgroundTransparency = 1 })
		fade.Completed:Once(function()
			toast:Destroy()
		end)
		fade:Play()
	end)
end

local featureHandlers = {}
local toggleRenderers = {}
local statusSetters = {}

local function setFeature(key, enabled)
	local accepted, reason = featureHandlers[key](enabled)
	if toggleRenderers[key] then
		toggleRenderers[key](accepted == true and enabled or false)
	end
	return accepted, reason
end

local function setStatus(kind, text)
	local setter = statusSetters[kind]
	if setter then
		setter(text)
	end
end

local function flatDirection(vector)
	local flat = Vector3.new(vector.X, 0, vector.Z)
	if flat.Magnitude < 0.001 then
		return Vector3.zero
	end
	return flat.Unit
end

local function isTeammate(player)
	return localPlayer.Team ~= nil and player.Team == localPlayer.Team
end

local CharacterWatcher = {
	character = nil,
	humanoid = nil,
	root = nil,
	readyCallbacks = {},
	leavingCallbacks = {},
}

function CharacterWatcher.subscribe(onReady, onLeaving)
	table.insert(CharacterWatcher.readyCallbacks, onReady)
	table.insert(CharacterWatcher.leavingCallbacks, onLeaving)
	if CharacterWatcher.character then
		onReady(CharacterWatcher.character, CharacterWatcher.humanoid, CharacterWatcher.root)
	end
end

local function handleCharacterAdded(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	local root = character:WaitForChild("HumanoidRootPart", 10)
	if isShutdown or not humanoid or not root or localPlayer.Character ~= character then
		return
	end
	CharacterWatcher.character = character
	CharacterWatcher.humanoid = humanoid
	CharacterWatcher.root = root
	for _, callback in ipairs(CharacterWatcher.readyCallbacks) do
		callback(character, humanoid, root)
	end
end

local function handleCharacterRemoving(character)
	for _, callback in ipairs(CharacterWatcher.leavingCallbacks) do
		callback(character)
	end
	CharacterWatcher.character = nil
	CharacterWatcher.humanoid = nil
	CharacterWatcher.root = nil
end

local Noclip
do
Noclip = {
	requests = {},
	originals = setmetatable({}, { __mode = "k" }),
	active = false,
	steppedJanitor = Janitor.new(),
	characterJanitor = Janitor.new(),
}

local function forceCollisionOff(part)
	if not part:IsA("BasePart") then
		return
	end
	if Noclip.originals[part] == nil then
		Noclip.originals[part] = part.CanCollide
	end
	part.CanCollide = false
end

local function bindNoclipCharacter(character)
	Noclip.characterJanitor:Clean()
	for _, descendant in ipairs(character:GetDescendants()) do
		forceCollisionOff(descendant)
	end
	Noclip.characterJanitor:Add(character.DescendantAdded:Connect(forceCollisionOff))
end

local function enforceNoclip()
	for part in pairs(Noclip.originals) do
		if part.Parent then
			part.CanCollide = false
		end
	end
end

local function activateNoclip()
	if Noclip.active then
		return
	end
	Noclip.active = true
	if CharacterWatcher.character then
		bindNoclipCharacter(CharacterWatcher.character)
	end
	Noclip.steppedJanitor:Add(RunService.Stepped:Connect(enforceNoclip))
end

local function deactivateNoclip()
	if not Noclip.active then
		return
	end
	Noclip.active = false
	Noclip.steppedJanitor:Clean()
	Noclip.characterJanitor:Clean()
	for part, original in pairs(Noclip.originals) do
		if part.Parent then
			part.CanCollide = original
		end
		Noclip.originals[part] = nil
	end
end

local function refreshNoclip()
	if next(Noclip.requests) ~= nil then
		activateNoclip()
	else
		deactivateNoclip()
	end
end

function Noclip.request(owner)
	Noclip.requests[owner] = true
	refreshNoclip()
end

function Noclip.release(owner)
	Noclip.requests[owner] = nil
	refreshNoclip()
end

CharacterWatcher.subscribe(function(character)
	if Noclip.active then
		bindNoclipCharacter(character)
	end
end, function()
	Noclip.characterJanitor:Clean()
	table.clear(Noclip.originals)
end)

featureHandlers.Noclip = function(enabled)
	if enabled then
		Noclip.request("Manual")
	else
		Noclip.release("Manual")
	end
	return true
end
end

local LightingControl
do
LightingControl = {
	base = {},
	layers = {},
	priority = { "FullBright", "FixLag" },
}

local function resolveLightingValue(property)
	for index = #LightingControl.priority, 1, -1 do
		local layer = LightingControl.layers[LightingControl.priority[index]]
		if layer and layer[property] ~= nil then
			return layer[property], true
		end
	end
	return LightingControl.base[property], false
end

local function applyLighting()
	local released = {}
	for property in pairs(LightingControl.base) do
		local value, fromLayer = resolveLightingValue(property)
		if value ~= nil then
			Lighting[property] = value
		end
		if not fromLayer then
			table.insert(released, property)
		end
	end
	for _, property in ipairs(released) do
		LightingControl.base[property] = nil
	end
end

function LightingControl.setLayer(owner, values)
	for property in pairs(values) do
		if LightingControl.base[property] == nil then
			LightingControl.base[property] = Lighting[property]
		end
	end
	LightingControl.layers[owner] = values
	applyLighting()
end

function LightingControl.clearLayer(owner)
	LightingControl.layers[owner] = nil
	applyLighting()
end

featureHandlers.FullBright = function(enabled)
	if enabled then
		LightingControl.setLayer("FullBright", CONFIG.FullBright)
	else
		LightingControl.clearLayer("FullBright")
	end
	return true
end
end

local FixLag, isProtectedFromFixLag
do
FixLag = {
	enabled = false,
	generation = 0,
	saved = setmetatable({}, { __mode = "k" }),
	janitor = Janitor.new(),
}

local EFFECT_CLASSES = {
	ParticleEmitter = true, Trail = true, Beam = true, Smoke = true, Fire = true, Sparkles = true,
	PointLight = true, SpotLight = true, SurfaceLight = true, BloomEffect = true, BlurEffect = true,
	SunRaysEffect = true, ColorCorrectionEffect = true, DepthOfFieldEffect = true,
}

local decorativeLookup = {}
for _, material in ipairs(CONFIG.FixLag.DecorativeMaterials) do
	decorativeLookup[material] = true
end

local function overrideProperty(instance, property, value)
	local record = FixLag.saved[instance]
	if not record then
		record = {}
		FixLag.saved[instance] = record
	end
	if record[property] == nil then
		record[property] = instance[property]
	end
	instance[property] = value
end

local function hasProtectedTag(instance)
	if CollectionService:HasTag(instance, CONFIG.Farm.EnemyTag) then
		return true
	end
	for _, tag in ipairs(CONFIG.Loot.Tags) do
		if CollectionService:HasTag(instance, tag) then
			return true
		end
	end
	return false
end

function isProtectedFromFixLag(instance)
	if string.find(string.lower(instance.Name), "hitbox", 1, true) then
		return true
	end
	local ancestor = instance
	while ancestor and ancestor ~= workspace do
		if hasProtectedTag(ancestor) then
			return true
		end
		if ancestor:IsA("Model") and ancestor:FindFirstChildOfClass("Humanoid") then
			return true
		end
		ancestor = ancestor.Parent
	end
	return false
end

local function simplifyPart(part)
	if part == workspace.Terrain or part.Transparency >= 1 or isProtectedFromFixLag(part) then
		return
	end
	if part.CastShadow then
		overrideProperty(part, "CastShadow", false)
	end
	if decorativeLookup[part.Material] then
		overrideProperty(part, "Material", CONFIG.FixLag.SimplifiedMaterial)
	end
	if part.Reflectance ~= 0 then
		overrideProperty(part, "Reflectance", 0)
	end
	if part:IsA("MeshPart") and part.RenderFidelity ~= Enum.RenderFidelity.Performance then
		overrideProperty(part, "RenderFidelity", Enum.RenderFidelity.Performance)
	end
end

local function reduceEffect(effect)
	if effect.Enabled then
		overrideProperty(effect, "Enabled", false)
	end
	if effect:IsA("ParticleEmitter") then
		overrideProperty(effect, "Lifetime", NumberRange.new(0))
	end
end

local function hideDecal(decal)
	if decal.Transparency < 1 and not isProtectedFromFixLag(decal) then
		overrideProperty(decal, "Transparency", 1)
	end
end

local function reduceAtmosphere(atmosphere)
	overrideProperty(atmosphere, "Density", 0)
	overrideProperty(atmosphere, "Haze", 0)
end

local function processFixLagInstance(instance)
	if not FixLag.enabled then
		return
	end
	if EFFECT_CLASSES[instance.ClassName] then
		reduceEffect(instance)
	elseif instance:IsA("BasePart") then
		simplifyPart(instance)
	elseif instance:IsA("Decal") or instance:IsA("Texture") then
		hideDecal(instance)
	elseif instance:IsA("Atmosphere") then
		reduceAtmosphere(instance)
	end
end

local function scanForFixLag(container, generation)
	local processed = 0
	for _, instance in ipairs(container:GetDescendants()) do
		if FixLag.generation ~= generation then
			return
		end
		processFixLagInstance(instance)
		processed += 1
		if processed % CONFIG.FixLag.BatchSize == 0 then
			task.wait()
		end
	end
end

local function queueFixLagInstance(instance)
	task.defer(processFixLagInstance, instance)
end

local function startFixLag()
	FixLag.generation += 1
	local generation = FixLag.generation
	LightingControl.setLayer("FixLag", { GlobalShadows = false, FogEnd = CONFIG.FixLag.FogEnd })
	FixLag.janitor:Add(workspace.DescendantAdded:Connect(queueFixLagInstance))
	FixLag.janitor:Add(Lighting.DescendantAdded:Connect(queueFixLagInstance))
	FixLag.janitor:Add(task.spawn(function()
		scanForFixLag(Lighting, generation)
		scanForFixLag(workspace, generation)
	end))
end

local function stopFixLag()
	FixLag.generation += 1
	FixLag.janitor:Clean()
	LightingControl.clearLayer("FixLag")
	for instance, record in pairs(FixLag.saved) do
		for property, value in pairs(record) do
			instance[property] = value
		end
		FixLag.saved[instance] = nil
	end
end

featureHandlers.FixLag = function(enabled)
	if FixLag.enabled == enabled then
		return true
	end
	FixLag.enabled = enabled
	if enabled then
		startFixLag()
	else
		stopFixLag()
	end
	return true
end
end

local WalkSpeed, setWalkSpeedValue
do
WalkSpeed = {
	enabled = false,
	value = CONFIG.WalkSpeed.Default,
	original = nil,
	watcher = Janitor.new(),
	windowStart = 0,
	windowCount = 0,
	lastWarning = 0,
}

local function writeWalkSpeed(humanoid)
	if humanoid.WalkSpeed ~= WalkSpeed.value then
		humanoid.WalkSpeed = WalkSpeed.value
	end
end

local function warnWalkSpeedOverride()
	local now = os.clock()
	if now - WalkSpeed.lastWarning > 10 then
		WalkSpeed.lastWarning = now
		notify("Game đang ghi đè WalkSpeed, script giữ lại liên tục", "warn")
	end
end

local function watchWalkSpeed(humanoid)
	WalkSpeed.watcher:Clean()
	WalkSpeed.original = humanoid.WalkSpeed
	writeWalkSpeed(humanoid)
	WalkSpeed.watcher:Add(humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if WalkSpeed.enabled and humanoid.WalkSpeed ~= WalkSpeed.value then
			warnWalkSpeedOverride()
		end
	end))
	WalkSpeed.watcher:Add(RunService.Heartbeat:Connect(function()
		if WalkSpeed.enabled and humanoid.Parent and humanoid.Health > 0 then
			writeWalkSpeed(humanoid)
		end
	end))
end

function setWalkSpeedValue(value)
	WalkSpeed.value = value
	local humanoid = CharacterWatcher.humanoid
	if WalkSpeed.enabled and humanoid then
		writeWalkSpeed(humanoid)
	end
end

featureHandlers.WalkSpeed = function(enabled)
	if WalkSpeed.enabled == enabled then
		return true
	end
	WalkSpeed.enabled = enabled
	local humanoid = CharacterWatcher.humanoid
	if enabled then
		if humanoid then
			watchWalkSpeed(humanoid)
		end
	else
		WalkSpeed.watcher:Clean()
		if humanoid then
			humanoid.WalkSpeed = WalkSpeed.original or CONFIG.WalkSpeed.RestoreFallback
		end
		WalkSpeed.original = nil
	end
	return true
end

CharacterWatcher.subscribe(function(_, humanoid)
	if WalkSpeed.enabled then
		watchWalkSpeed(humanoid)
	end
end, function()
	WalkSpeed.watcher:Clean()
end)
end

local HighJump, setJumpValue
do
HighJump = { enabled = false, value = CONFIG.Jump.Default, original = nil }

local function getJumpProperty(humanoid)
	return humanoid.UseJumpPower and "JumpPower" or "JumpHeight"
end

local function convertJumpValue(humanoid, power)
	if humanoid.UseJumpPower then
		return power
	end
	return (power * power) / (2 * workspace.Gravity)
end

local function writeJump(humanoid)
	local property = getJumpProperty(humanoid)
	humanoid[property] = convertJumpValue(humanoid, HighJump.value)
end

local function captureJump(humanoid)
	local property = getJumpProperty(humanoid)
	HighJump.original = { property = property, value = humanoid[property] }
	writeJump(humanoid)
end

function setJumpValue(value)
	HighJump.value = value
	local humanoid = CharacterWatcher.humanoid
	if HighJump.enabled and humanoid then
		writeJump(humanoid)
	end
end

featureHandlers.HighJump = function(enabled)
	if HighJump.enabled == enabled then
		return true
	end
	HighJump.enabled = enabled
	local humanoid = CharacterWatcher.humanoid
	if enabled then
		if humanoid then
			captureJump(humanoid)
		end
	else
		if humanoid and HighJump.original then
			humanoid[HighJump.original.property] = HighJump.original.value
		end
		HighJump.original = nil
	end
	return true
end

CharacterWatcher.subscribe(function(_, humanoid)
	if HighJump.enabled then
		captureJump(humanoid)
	end
end, function() end)
end

local InfiniteJump
do
InfiniteJump = { janitor = Janitor.new() }

local function requestExtraJump()
	local humanoid = CharacterWatcher.humanoid
	if humanoid and humanoid.Health > 0 then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end

featureHandlers.InfiniteJump = function(enabled)
	InfiniteJump.janitor:Clean()
	if enabled then
		InfiniteJump.janitor:Add(UserInputService.JumpRequest:Connect(requestExtraJump))
	end
	return true
end
end

local setOrbitRadius, setOrbitSpeed, setAutoAttackRange, getEquippedTool, stopOtherMovers, setHopDwell, AutoClick, PlayerTools, Spectate, attackTarget, collectLoot, flyToSelectedPlayer, getEnemyTypes, getPlayerNames, selectPlayerByName, setAttackRate, setClickRate, setEnemyType, setLootTags
do
PlayerTools = { selected = nil, tween = nil }

function getEquippedTool()
	local character = CharacterWatcher.character
	return character and character:FindFirstChildOfClass("Tool")
end

function attackTarget(target)
	local tool = getEquippedTool()
	if not tool then
		return false
	end
	tool:Activate()
	return true
end

local function findPrompt(item)
	if item:IsA("ProximityPrompt") then
		return item
	end
	return item:FindFirstChildWhichIsA("ProximityPrompt", true)
end

local Automation = {
	mode = nil,
	target = nil,
	tween = nil,
	tweenGoal = nil,
	connection = nil,
	searchClock = 0,
	attackClock = 0,
	collectClock = 0,
	arrivedAt = nil,
	enemyType = nil,
	lootTags = {},
	enemyFolder = nil,
	skipped = setmetatable({}, { __mode = "k" }),
	collectThread = nil,
	activePrompt = nil,
	noticed = {},
	attackInterval = CONFIG.Farm.AttackInterval,
	hopSeconds = CONFIG.Hop.DefaultSeconds,
	hopStartedAt = 0,
	visited = setmetatable({}, { __mode = "k" }),
	orbitAngle = 0,
	orbitRadius = CONFIG.Orbit.Radius.Default,
	orbitSpeed = CONFIG.Orbit.Speed.Default,
}

function collectLoot(item)
	local prompt = findPrompt(item)
	if not prompt or not prompt.Enabled then
		return false
	end
	if Automation.collectThread then
		return true
	end
	Automation.activePrompt = prompt
	Automation.collectThread = task.spawn(function()
		prompt:InputHoldBegin()
		task.wait(prompt.HoldDuration + 0.1)
		prompt:InputHoldEnd()
		Automation.activePrompt = nil
		Automation.collectThread = nil
	end)
	return true
end

local function callUserHook(label, hook, argument)
	local ok, result = pcall(hook, argument)
	if not ok then
		warn(string.format("[%s] %s gặp lỗi: %s", CONFIG.Name, label, tostring(result)))
		if not Automation.noticed[label .. "Error"] then
			Automation.noticed[label .. "Error"] = true
			notify(label .. " gặp lỗi, xem Output", "error")
		end
		return false
	end
	if result ~= true and not Automation.noticed[label] then
		Automation.noticed[label] = true
		notify(label .. " chưa hoạt động (chưa kết nối hoặc chưa cầm vũ khí)", "warn")
	end
	return result == true
end

local function cancelAutomationTween()
	if Automation.tween then
		Automation.tween:Cancel()
		Automation.tween = nil
	end
	Automation.tweenGoal = nil
end

local function clearTarget()
	Automation.target = nil
	Automation.arrivedAt = nil
	cancelAutomationTween()
end

local function tweenRootTo(root, goal)
	local goalMoved = Automation.tweenGoal == nil or (Automation.tweenGoal.Position - goal.Position).Magnitude > 6
	local playing = Automation.tween ~= nil and Automation.tween.PlaybackState == Enum.PlaybackState.Playing
	if playing and not goalMoved then
		return
	end
	cancelAutomationTween()
	local distance = (root.Position - goal.Position).Magnitude
	local duration = math.max(distance / CONFIG.TweenSpeed, 0.05)
	Automation.tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = goal })
	Automation.tweenGoal = goal
	Automation.tween:Play()
end

local function zeroVelocity(root)
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
end

local function resolveEnemyFolder()
	local folder = Automation.enemyFolder
	if folder and folder:IsDescendantOf(workspace) then
		return folder
	end
	Automation.enemyFolder = workspace:FindFirstChild(CONFIG.Farm.FallbackFolderName)
	return Automation.enemyFolder
end

local function getEnemyModels()
	local models = {}
	for _, instance in ipairs(CollectionService:GetTagged(CONFIG.Farm.EnemyTag)) do
		if instance:IsA("Model") and instance:IsDescendantOf(workspace) then
			table.insert(models, instance)
		end
	end
	if #models > 0 then
		return models
	end
	local folder = resolveEnemyFolder()
	if not folder then
		return models
	end
	for _, descendant in ipairs(folder:GetDescendants()) do
		if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
			table.insert(models, descendant)
		end
	end
	return models
end

function getEnemyTypes()
	local seen, names = {}, {}
	for _, model in ipairs(getEnemyModels()) do
		if not seen[model.Name] then
			seen[model.Name] = true
			table.insert(names, model.Name)
		end
	end
	table.sort(names)
	return names
end

local function isEnemyAlive(model)
	if not model or not model:IsDescendantOf(workspace) then
		return false
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

local function findNearestEnemy(typeName, origin)
	local nearest, nearestDistance = nil, math.huge
	for _, model in ipairs(getEnemyModels()) do
		if model.Name == typeName and isEnemyAlive(model) then
			local distance = (model:GetPivot().Position - origin).Magnitude
			if distance < nearestDistance then
				nearest, nearestDistance = model, distance
			end
		end
	end
	return nearest
end

local function getItemPosition(item)
	if item:IsA("BasePart") then
		return item.Position
	end
	return item:GetPivot().Position
end

local function isLootValid(item)
	if not item or not item:IsDescendantOf(workspace) then
		return false
	end
	if not (item:IsA("BasePart") or item:IsA("Model")) then
		return false
	end
	local expiry = Automation.skipped[item]
	return expiry == nil or os.clock() >= expiry
end

local function findNearestLoot(origin)
	local nearest, nearestDistance = nil, math.huge
	for tag in pairs(Automation.lootTags) do
		for _, item in ipairs(CollectionService:GetTagged(tag)) do
			if isLootValid(item) then
				local distance = (getItemPosition(item) - origin).Magnitude
				if distance < nearestDistance then
					nearest, nearestDistance = item, distance
				end
			end
		end
	end
	return nearest
end

local function computeFarmGoal(root, targetCFrame)
	local behind = flatDirection(targetCFrame.LookVector) * -CONFIG.Farm.HorizontalOffset
	local position = targetCFrame.Position + Vector3.new(0, CONFIG.Farm.HeightAboveEnemy, 0) + behind
	local facing = flatDirection(targetCFrame.Position - position)
	if facing == Vector3.zero then
		facing = flatDirection(root.CFrame.LookVector)
	end
	if facing == Vector3.zero then
		facing = Vector3.zAxis
	end
	return CFrame.lookAt(position, position + facing)
end

local function runAttack(enemy, deltaTime)
	Automation.attackClock += deltaTime
	if Automation.attackClock < Automation.attackInterval then
		return
	end
	Automation.attackClock = 0
	callUserHook("attackTarget", attackTarget, enemy)
end

local function followEnemy(root, enemy, deltaTime)
	local goal = computeFarmGoal(root, enemy:GetPivot())
	zeroVelocity(root)
	if (root.Position - goal.Position).Magnitude > CONFIG.Farm.SnapDistance then
		tweenRootTo(root, goal)
		return
	end
	cancelAutomationTween()
	local alpha = 1 - math.exp(-CONFIG.Farm.FollowSharpness * deltaTime)
	root.CFrame = root.CFrame:Lerp(goal, alpha)
	runAttack(enemy, deltaTime)
end

local function stepFarm(root, deltaTime)
	if Automation.target and not isEnemyAlive(Automation.target) then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
	if not Automation.target then
		Automation.searchClock += deltaTime
		if Automation.searchClock >= CONFIG.SearchInterval then
			Automation.searchClock = 0
			Automation.target = findNearestEnemy(Automation.enemyType, root.Position)
		end
	end
	local target = Automation.target
	if not target then
		setStatus("Farm", "Waiting for enemy to spawn")
		return
	end
	setStatus("Farm", "Farming: " .. target.Name)
	followEnemy(root, target, deltaTime)
end

local function attemptCollect(item)
	local now = os.clock()
	Automation.arrivedAt = Automation.arrivedAt or now
	if now - Automation.arrivedAt > CONFIG.Loot.GiveUpSeconds then
		Automation.skipped[item] = now + CONFIG.Loot.SkipSeconds
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
		return
	end
	if now - Automation.collectClock < CONFIG.Loot.CollectInterval then
		return
	end
	Automation.collectClock = now
	callUserHook("collectLoot", collectLoot, item)
end

local function approachLoot(root, item)
	local position = getItemPosition(item)
	local away = flatDirection(root.Position - position)
	if away == Vector3.zero then
		away = Vector3.xAxis
	end
	local distance = math.max(CONFIG.Loot.StopDistance, 0.5)
	local standPosition = position + away * distance + Vector3.new(0, CONFIG.Loot.HeightOffset, 0)
	local lookTarget = Vector3.new(position.X, standPosition.Y, position.Z)
	local goal = CFrame.lookAt(standPosition, lookTarget)
	zeroVelocity(root)
	if (root.Position - standPosition).Magnitude > CONFIG.Loot.ArriveTolerance then
		Automation.arrivedAt = nil
		tweenRootTo(root, goal)
		return
	end
	cancelAutomationTween()
	root.CFrame = goal
	attemptCollect(item)
end

local function stepLoot(root, deltaTime)
	if Automation.target and not isLootValid(Automation.target) then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
	if not Automation.target then
		Automation.searchClock += deltaTime
		if Automation.searchClock >= CONFIG.SearchInterval then
			Automation.searchClock = 0
			Automation.target = findNearestLoot(root.Position)
		end
	end
	local item = Automation.target
	if not item then
		setStatus("Loot", "Waiting for loot to spawn")
		return
	end
	setStatus("Loot", "Looting: " .. item.Name)
	approachLoot(root, item)
end

local function isFollowCandidate(player)
	if player == localPlayer then
		return false
	end
	if CONFIG.Follow.SkipTeammates and isTeammate(player) then
		return false
	end
	local character = player.Character
	return isEnemyAlive(character) and character:FindFirstChild("HumanoidRootPart") ~= nil
end

local function findFollowTarget(origin)
	local selected = PlayerTools.selected
	if selected then
		if selected.Parent == Players and isEnemyAlive(selected.Character) then
			return selected.Character
		end
		return nil
	end
	local nearest, nearestDistance = nil, math.huge
	for _, player in ipairs(Players:GetPlayers()) do
		if isFollowCandidate(player) then
			local distance = (player.Character:GetPivot().Position - origin).Magnitude
			if distance < nearestDistance then
				nearest, nearestDistance = player.Character, distance
			end
		end
	end
	return nearest
end

local function computeFrontGoal(targetCFrame)
	local front = flatDirection(targetCFrame.LookVector)
	if front == Vector3.zero then
		front = Vector3.zAxis
	end
	local position = targetCFrame.Position + front * CONFIG.Follow.FrontDistance + Vector3.new(0, CONFIG.Follow.HeightOffset, 0)
	local facing = flatDirection(targetCFrame.Position - position)
	if facing == Vector3.zero then
		facing = -front
	end
	return CFrame.lookAt(position, position + facing)
end

local function stepFollow(root, deltaTime)
	if Automation.target and not isEnemyAlive(Automation.target) then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
	if not Automation.target then
		Automation.searchClock += deltaTime
		if Automation.searchClock >= CONFIG.SearchInterval then
			Automation.searchClock = 0
			Automation.target = findFollowTarget(root.Position)
		end
	end
	local target = Automation.target
	if not target then
		setStatus("Follow", "Waiting for player")
		return
	end
	setStatus("Follow", "Following: " .. target.Name)
	local goal = computeFrontGoal(target:GetPivot())
	zeroVelocity(root)
	if (root.Position - goal.Position).Magnitude > CONFIG.Follow.SnapDistance then
		tweenRootTo(root, goal)
		return
	end
	cancelAutomationTween()
	root.CFrame = root.CFrame:Lerp(goal, 1 - math.exp(-CONFIG.Follow.Sharpness * deltaTime))
	runAttack(target, deltaTime)
end

local function findHopTarget(origin)
	for _ = 1, 2 do
		local nearest, nearestDistance = nil, math.huge
		for _, player in ipairs(Players:GetPlayers()) do
			if isFollowCandidate(player) and not Automation.visited[player] then
				local distance = (player.Character:GetPivot().Position - origin).Magnitude
				if distance < nearestDistance then
					nearest, nearestDistance = player, distance
				end
			end
		end
		if nearest then
			return nearest
		end
		table.clear(Automation.visited)
	end
	return nil
end

local function stepHop(root, deltaTime)
	local target = Automation.target
	if target and (not isEnemyAlive(target) or os.clock() - Automation.hopStartedAt >= Automation.hopSeconds) then
		clearTarget()
		target = nil
	end
	if not target then
		local player = findHopTarget(root.Position)
		if not player then
			setStatus("Hop", "Waiting for player")
			return
		end
		Automation.visited[player] = true
		Automation.target = player.Character
		Automation.hopStartedAt = os.clock()
		target = player.Character
		root.CFrame = computeFrontGoal(target:GetPivot())
	end
	setStatus("Hop", "Teleport: " .. target.Name)
	zeroVelocity(root)
	local goal = computeFrontGoal(target:GetPivot())
	root.CFrame = root.CFrame:Lerp(goal, 1 - math.exp(-CONFIG.Follow.Sharpness * deltaTime))
end

local function stepOrbit(root, deltaTime)
	local selected = PlayerTools.selected
	local character = selected and selected.Character
	if not selected or selected.Parent ~= Players or not isEnemyAlive(character) then
		cancelAutomationTween()
		setStatus("Orbit", "Waiting for player")
		return
	end
	setStatus("Orbit", "Orbit: " .. selected.Name)
	Automation.orbitAngle = (Automation.orbitAngle + math.rad(Automation.orbitSpeed) * deltaTime) % (math.pi * 2)
	local center = character:GetPivot().Position
	local offset = Vector3.new(math.cos(Automation.orbitAngle) * Automation.orbitRadius, CONFIG.Orbit.Height, math.sin(Automation.orbitAngle) * Automation.orbitRadius)
	local position = center + offset
	local goal = CFrame.lookAt(position, Vector3.new(center.X, position.Y, center.Z))
	zeroVelocity(root)
	if (root.Position - position).Magnitude > CONFIG.Follow.SnapDistance then
		tweenRootTo(root, goal)
		return
	end
	cancelAutomationTween()
	root.CFrame = goal
end

local function onAutomationStep(deltaTime)
	local root, humanoid = CharacterWatcher.root, CharacterWatcher.humanoid
	if not root or not humanoid or not root.Parent or humanoid.Health <= 0 then
		cancelAutomationTween()
		setStatus(Automation.mode, "Waiting for respawn")
		return
	end
	if Automation.mode == "Farm" then
		stepFarm(root, deltaTime)
	elseif Automation.mode == "Follow" then
		stepFollow(root, deltaTime)
	elseif Automation.mode == "Hop" then
		stepHop(root, deltaTime)
	elseif Automation.mode == "Orbit" then
		stepOrbit(root, deltaTime)
	else
		stepLoot(root, deltaTime)
	end
end

local function stopAutomation()
	if Automation.connection then
		Automation.connection:Disconnect()
		Automation.connection = nil
	end
	cancelAutomationTween()
	if Automation.collectThread then
		task.cancel(Automation.collectThread)
		Automation.collectThread = nil
	end
	if Automation.activePrompt then
		Automation.activePrompt:InputHoldEnd()
		Automation.activePrompt = nil
	end
	Automation.target = nil
	Automation.arrivedAt = nil
	Noclip.release("AutoFarm")
	Noclip.release("AutoLoot")
	Noclip.release("AutoFollow")
	Noclip.release("AutoHop")
	Noclip.release("AutoOrbit")
	if Automation.mode then
		setStatus(Automation.mode, "Idle")
	end
	Automation.mode = nil
end

local function startAutomation(mode)
	stopAutomation()
	Automation.mode = mode
	Automation.searchClock = CONFIG.SearchInterval
	Automation.noticed = {}
	table.clear(Automation.visited)
	Noclip.request("Auto" .. mode)
	Automation.connection = RunService.Heartbeat:Connect(onAutomationStep)
end

function setEnemyType(name)
	Automation.enemyType = name
	if Automation.mode == "Farm" then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
end

function setLootTags(selection)
	Automation.lootTags = selection
	if Automation.mode == "Loot" then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
end

function stopOtherMovers(except)
	for _, key in ipairs({ "AutoFarm", "AutoLoot", "FollowPlayer", "HopPlayers", "OrbitPlayer", "Fly" }) do
		if key ~= except then
			setFeature(key, false)
		end
	end
end

featureHandlers.AutoFarm = function(enabled)
	if not enabled then
		if Automation.mode == "Farm" then
			stopAutomation()
		end
		return true
	end
	if not Automation.enemyType then
		return false, "Hãy chọn loại quái trước khi bật Auto Farm"
	end
	stopOtherMovers("AutoFarm")
	startAutomation("Farm")
	return true
end

featureHandlers.AutoLoot = function(enabled)
	if not enabled then
		if Automation.mode == "Loot" then
			stopAutomation()
		end
		return true
	end
	if next(Automation.lootTags) == nil then
		return false, "Hãy chọn ít nhất một loại loot"
	end
	stopOtherMovers("AutoLoot")
	startAutomation("Loot")
	return true
end

featureHandlers.FollowPlayer = function(enabled)
	if not enabled then
		if Automation.mode == "Follow" then
			stopAutomation()
		end
		return true
	end
	stopOtherMovers("FollowPlayer")
	startAutomation("Follow")
	return true
end

featureHandlers.HopPlayers = function(enabled)
	if not enabled then
		if Automation.mode == "Hop" then
			stopAutomation()
		end
		return true
	end
	stopOtherMovers("HopPlayers")
	startAutomation("Hop")
	return true
end

function setHopDwell(seconds)
	Automation.hopSeconds = seconds
end

featureHandlers.OrbitPlayer = function(enabled)
	if not enabled then
		if Automation.mode == "Orbit" then
			stopAutomation()
		end
		return true
	end
	local selected = PlayerTools.selected
	if not selected or selected.Parent ~= Players then
		return false, "Hãy chọn người chơi trước khi bay vòng"
	end
	stopOtherMovers("OrbitPlayer")
	startAutomation("Orbit")
	return true
end

function setOrbitRadius(value)
	Automation.orbitRadius = value
end

function setOrbitSpeed(value)
	Automation.orbitSpeed = value
end

local AutoAttack = {
	enabled = false,
	range = CONFIG.AutoAttack.Default,
	scanClock = 0,
	attackClock = 0,
	target = nil,
	janitor = Janitor.new(),
}

local function findAttackTarget(root)
	local best, bestDistance = nil, AutoAttack.range
	for _, player in ipairs(Players:GetPlayers()) do
		if isFollowCandidate(player) then
			local distance = (player.Character:GetPivot().Position - root.Position).Magnitude
			if distance <= bestDistance then
				best, bestDistance = player.Character, distance
			end
		end
	end
	for _, model in ipairs(getEnemyModels()) do
		if isEnemyAlive(model) then
			local distance = (model:GetPivot().Position - root.Position).Magnitude
			if distance <= bestDistance then
				best, bestDistance = model, distance
			end
		end
	end
	return best
end

local function onAutoAttackStep(deltaTime)
	local root, humanoid = CharacterWatcher.root, CharacterWatcher.humanoid
	if not root or not humanoid or humanoid.Health <= 0 then
		return
	end
	AutoAttack.scanClock += deltaTime
	if AutoAttack.scanClock >= 0.2 then
		AutoAttack.scanClock = 0
		AutoAttack.target = findAttackTarget(root)
	end
	AutoAttack.attackClock += deltaTime
	if AutoAttack.attackClock < Automation.attackInterval then
		return
	end
	AutoAttack.attackClock = 0
	local target = AutoAttack.target
	if target and isEnemyAlive(target) then
		callUserHook("attackTarget", attackTarget, target)
	end
end

featureHandlers.AutoAttack = function(enabled)
	AutoAttack.janitor:Clean()
	AutoAttack.target = nil
	AutoAttack.scanClock = 0
	AutoAttack.attackClock = 0
	AutoAttack.enabled = enabled
	if enabled then
		AutoAttack.janitor:Add(RunService.Heartbeat:Connect(onAutoAttackStep))
	end
	return true
end

function setAutoAttackRange(value)
	AutoAttack.range = value
end

function selectPlayerByName(name)
	PlayerTools.selected = Players:FindFirstChild(name)
	if Automation.mode == "Follow" then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
end

function getPlayerNames()
	local names = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			table.insert(names, player.Name)
		end
	end
	table.sort(names)
	return names
end

function setAttackRate(rate)
	Automation.attackInterval = 1 / rate
end

function flyToSelectedPlayer()
	local player = PlayerTools.selected
	local root = CharacterWatcher.root
	if not player or player.Parent ~= Players then
		return false, "Hãy chọn người chơi trước"
	end
	if Automation.mode then
		return false, "Hãy tắt chức năng tự động đang chạy trước"
	end
	local character = player.Character
	if not root or not isEnemyAlive(character) then
		return false, "Không thể bay tới người chơi này"
	end
	if PlayerTools.tween then
		PlayerTools.tween:Cancel()
	end
	local goal = computeFrontGoal(character:GetPivot())
	local duration = math.max((root.Position - goal.Position).Magnitude / CONFIG.TweenSpeed, 0.05)
	local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = goal })
	tween.Completed:Once(function()
		root.AssemblyLinearVelocity = Vector3.zero
	end)
	PlayerTools.tween = tween
	tween:Play()
	return true
end

Spectate = { enabled = false, janitor = Janitor.new() }

local function getPlayerHumanoid(player)
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function pointCameraAt(humanoid)
	local camera = workspace.CurrentCamera
	if camera and humanoid then
		camera.CameraSubject = humanoid
	end
end

featureHandlers.Spectate = function(enabled)
	Spectate.janitor:Clean()
	Spectate.enabled = false
	if not enabled then
		pointCameraAt(CharacterWatcher.humanoid)
		return true
	end
	local player = PlayerTools.selected
	if not player or player.Parent ~= Players then
		return false, "Hãy chọn người chơi trước"
	end
	local humanoid = getPlayerHumanoid(player)
	if not humanoid then
		return false, "Người chơi này chưa có nhân vật"
	end
	Spectate.enabled = true
	pointCameraAt(humanoid)
	Spectate.janitor:Add(player.CharacterAdded:Connect(function(character)
		local newHumanoid = character:WaitForChild("Humanoid", 10)
		if Spectate.enabled and newHumanoid then
			pointCameraAt(newHumanoid)
		end
	end))
	Spectate.janitor:Add(Players.PlayerRemoving:Connect(function(leaving)
		if leaving == player then
			setFeature("Spectate", false)
			notify("Người chơi đã thoát, đã tắt xem", "warn")
		end
	end))
	return true
end

CharacterWatcher.subscribe(function()
	if not Spectate.enabled or not PlayerTools.selected then
		return
	end
	task.delay(0.25, function()
		if Spectate.enabled and PlayerTools.selected then
			pointCameraAt(getPlayerHumanoid(PlayerTools.selected))
		end
	end)
end, function() end)

AutoClick = {
	rate = CONFIG.AutoClick.Default,
	clock = 0,
	noticed = false,
	janitor = Janitor.new(),
}

function setClickRate(rate)
	AutoClick.rate = rate
end

local function onAutoClickStep(deltaTime)
	AutoClick.clock += deltaTime
	local interval = 1 / AutoClick.rate
	if AutoClick.clock < interval then
		return
	end
	AutoClick.clock = math.min(AutoClick.clock - interval, interval)
	local tool = getEquippedTool()
	if tool then
		tool:Activate()
	elseif not AutoClick.noticed then
		AutoClick.noticed = true
		notify("Hãy cầm vũ khí để Auto Click hoạt động", "warn")
	end
end

featureHandlers.AutoClick = function(enabled)
	AutoClick.janitor:Clean()
	AutoClick.clock = 0
	AutoClick.noticed = false
	if enabled then
		AutoClick.janitor:Add(RunService.Heartbeat:Connect(onAutoClickStep))
	end
	return true
end
end

do
local Esp = {
	enabled = false,
	hideTeammates = CONFIG.Esp.HideTeammates,
	options = {
		Chams = true,
		Box = true,
		Name = CONFIG.Esp.ShowName,
		Health = CONFIG.Esp.ShowHealth,
		Distance = CONFIG.Esp.ShowDistance,
		Tracer = CONFIG.Esp.ShowTracers,
	},
	entries = {},
	trackers = {},
	folder = nil,
	tracerLayer = nil,
	janitor = Janitor.new(),
	clock = 0,
}

local function buildEspBillboard(adornee, playerName)
	local gui = create("BillboardGui", {
		Name = playerName,
		Adornee = adornee,
		AlwaysOnTop = true,
		Size = UDim2.fromOffset(130, 44),
		StudsOffset = Vector3.new(0, 3, 0),
		MaxDistance = CONFIG.Esp.MaxDistance,
		ResetOnSpawn = false,
		LightInfluence = 0,
	}, Esp.folder)
	local nameLabel = createLabel(gui, "", 13, Color3.new(1, 1, 1), THEME.FontBold)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextStrokeTransparency = 0.4
	local infoLabel = createLabel(gui, "", 11, Color3.new(1, 1, 1), THEME.Font)
	infoLabel.TextXAlignment = Enum.TextXAlignment.Center
	infoLabel.TextStrokeTransparency = 0.4
	infoLabel.Position = UDim2.fromOffset(0, 17)
	local barBack = create("Frame", {
		Position = UDim2.new(0.1, 0, 0, 36),
		Size = UDim2.new(0.8, 0, 0, 5),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
	}, gui)
	local barFill = create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = THEME.Success,
		BorderSizePixel = 0,
	}, barBack)
	return gui, nameLabel, infoLabel, barBack, barFill
end

local function buildEspBox(root, playerName)
	local gui = create("BillboardGui", {
		Name = playerName .. "Box",
		Adornee = root,
		AlwaysOnTop = true,
		Size = UDim2.fromScale(4, 6),
		MaxDistance = CONFIG.Esp.MaxDistance,
		ResetOnSpawn = false,
		LightInfluence = 0,
	}, Esp.folder)
	local frame = create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, gui)
	local stroke = addStroke(frame, Color3.new(1, 1, 1), 1.5)
	return gui, stroke
end

local function buildEspInfoText(entry, distance)
	local parts = {}
	if Esp.options.Health then
		table.insert(parts, string.format("HP %d", math.floor(entry.humanoid.Health + 0.5)))
	end
	if Esp.options.Distance and distance then
		table.insert(parts, string.format("%dm", math.floor(distance + 0.5)))
	end
	return table.concat(parts, " | ")
end

local function updateEspEntry(entry)
	local humanoid, root = entry.humanoid, entry.root
	if not humanoid.Parent or not root.Parent then
		return
	end
	local options = Esp.options
	local teammate = isTeammate(entry.player)
	local visible = humanoid.Health > 0 and not (teammate and Esp.hideTeammates)
	entry.visible = visible
	entry.highlight.Enabled = visible and options.Chams
	entry.boxGui.Enabled = visible and options.Box
	entry.gui.Enabled = visible and (options.Name or options.Health or options.Distance)
	if not visible then
		return
	end
	local color = teammate and CONFIG.Esp.TeamColor or CONFIG.Esp.EnemyColor
	entry.color = color
	entry.highlight.FillColor = color
	entry.highlight.OutlineColor = color
	entry.boxStroke.Color = color
	local fraction = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
	local localRoot = CharacterWatcher.root
	local distance = localRoot and (root.Position - localRoot.Position).Magnitude or nil
	entry.nameLabel.Text = options.Name and entry.player.DisplayName or ""
	entry.nameLabel.TextColor3 = color
	entry.infoLabel.Text = buildEspInfoText(entry, distance)
	entry.barBack.Visible = options.Health
	entry.barFill.Size = UDim2.fromScale(fraction, 1)
	entry.barFill.BackgroundColor3 = Color3.fromRGB(255, 70, 70):Lerp(THEME.Success, fraction)
end

local function detachEsp(player)
	local entry = Esp.entries[player]
	if not entry then
		return
	end
	entry.highlight:Destroy()
	entry.gui:Destroy()
	entry.boxGui:Destroy()
	entry.tracer:Destroy()
	Esp.entries[player] = nil
end

local function attachEsp(player, character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	local root = character:WaitForChild("HumanoidRootPart", 10)
	if not humanoid or not root then
		return
	end
	if not Esp.enabled or Esp.trackers[player] == nil or player.Character ~= character then
		return
	end
	detachEsp(player)
	local highlight = create("Highlight", {
		Name = player.Name,
		Adornee = character,
		FillTransparency = CONFIG.Esp.FillTransparency,
		OutlineTransparency = 0,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	}, Esp.folder)
	local gui, nameLabel, infoLabel, barBack, barFill = buildEspBillboard(character:FindFirstChild("Head") or root, player.Name)
	local boxGui, boxStroke = buildEspBox(root, player.Name)
	local tracer = create("Frame", {
		Name = player.Name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = CONFIG.Esp.EnemyColor,
		BorderSizePixel = 0,
		Visible = false,
		Active = false,
	}, Esp.tracerLayer)
	local entry = {
		player = player,
		humanoid = humanoid,
		root = root,
		highlight = highlight,
		gui = gui,
		boxGui = boxGui,
		boxStroke = boxStroke,
		nameLabel = nameLabel,
		infoLabel = infoLabel,
		barBack = barBack,
		barFill = barFill,
		tracer = tracer,
		visible = false,
	}
	Esp.entries[player] = entry
	updateEspEntry(entry)
end

local function trackEspPlayer(player)
	if player == localPlayer or Esp.trackers[player] then
		return
	end
	local tracker = Janitor.new()
	Esp.trackers[player] = tracker
	tracker:Add(player.CharacterAdded:Connect(function(character)
		attachEsp(player, character)
	end))
	tracker:Add(player.CharacterRemoving:Connect(function()
		detachEsp(player)
	end))
	if player.Character then
		task.spawn(attachEsp, player, player.Character)
	end
end

local function untrackEspPlayer(player)
	local tracker = Esp.trackers[player]
	if tracker then
		tracker:Clean()
		Esp.trackers[player] = nil
	end
	detachEsp(player)
end

local function updateTracer(entry, camera, origin)
	local tracer = entry.tracer
	if not Esp.options.Tracer or not entry.visible or not entry.root.Parent then
		tracer.Visible = false
		return
	end
	local screenPoint, onScreen = camera:WorldToViewportPoint(entry.root.Position)
	if not onScreen then
		tracer.Visible = false
		return
	end
	local target = Vector2.new(screenPoint.X, screenPoint.Y)
	local delta = target - origin
	tracer.Visible = true
	tracer.BackgroundColor3 = entry.color or CONFIG.Esp.EnemyColor
	tracer.Size = UDim2.fromOffset(delta.Magnitude, CONFIG.Esp.TracerThickness)
	tracer.Position = UDim2.fromOffset((origin.X + target.X) / 2, (origin.Y + target.Y) / 2)
	tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
end

local function onEspRender(deltaTime)
	local camera = workspace.CurrentCamera
	if camera and Esp.options.Tracer then
		local size = camera.ViewportSize
		local origin = Vector2.new(size.X / 2, size.Y)
		for _, entry in pairs(Esp.entries) do
			updateTracer(entry, camera, origin)
		end
	end
	Esp.clock += deltaTime
	if Esp.clock < CONFIG.Esp.UpdateInterval then
		return
	end
	Esp.clock = 0
	for _, entry in pairs(Esp.entries) do
		updateEspEntry(entry)
	end
end

local function enableEsp()
	Esp.enabled = true
	Esp.folder = create("Folder", { Name = ESP_FOLDER_NAME }, workspace)
	Esp.janitor:Add(Esp.folder)
	Esp.janitor:Add(Players.PlayerAdded:Connect(trackEspPlayer))
	Esp.janitor:Add(Players.PlayerRemoving:Connect(untrackEspPlayer))
	Esp.tracerLayer = Esp.janitor:Add(create("Frame", {
		Name = "Tracers",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Active = false,
		ZIndex = 0,
	}, screenGui))
	Esp.janitor:Add(RunService.RenderStepped:Connect(onEspRender))
	for _, player in ipairs(Players:GetPlayers()) do
		trackEspPlayer(player)
	end
end

local function disableEsp()
	Esp.enabled = false
	Esp.janitor:Clean()
	for _, tracker in pairs(Esp.trackers) do
		tracker:Clean()
	end
	table.clear(Esp.trackers)
	table.clear(Esp.entries)
	Esp.folder = nil
	Esp.tracerLayer = nil
end

featureHandlers.Esp = function(enabled)
	if Esp.enabled == enabled then
		return true
	end
	if enabled then
		enableEsp()
	else
		disableEsp()
	end
	return true
end

local function refreshEspEntries()
	for _, entry in pairs(Esp.entries) do
		updateEspEntry(entry)
	end
end

featureHandlers.EspEnemiesOnly = function(enabled)
	Esp.hideTeammates = enabled
	refreshEspEntries()
	return true
end

local function createEspOptionHandler(optionKey)
	return function(enabled)
		Esp.options[optionKey] = enabled
		if optionKey == "Tracer" and not enabled then
			for _, entry in pairs(Esp.entries) do
				entry.tracer.Visible = false
			end
		end
		refreshEspEntries()
		return true
	end
end

featureHandlers.EspChams = createEspOptionHandler("Chams")
featureHandlers.EspBox = createEspOptionHandler("Box")
featureHandlers.EspName = createEspOptionHandler("Name")
featureHandlers.EspHealth = createEspOptionHandler("Health")
featureHandlers.EspDistance = createEspOptionHandler("Distance")
featureHandlers.EspTracers = createEspOptionHandler("Tracer")

local objectEspKinds = {
	Enemies = {
		color = CONFIG.ObjectEsp.EnemyColor,
		getTags = function()
			return { CONFIG.Farm.EnemyTag }
		end,
	},
	Loot = {
		color = CONFIG.ObjectEsp.LootColor,
		getTags = function()
			return CONFIG.Loot.Tags
		end,
	},
}
local objectEspStates = {}

local function addObjectHighlight(kind, instance)
	local state = objectEspStates[kind]
	if not state or state.highlights[instance] or state.count >= CONFIG.ObjectEsp.MaxHighlights then
		return
	end
	if not (instance:IsA("Model") or instance:IsA("BasePart")) or not instance:IsDescendantOf(workspace) then
		return
	end
	local color = objectEspKinds[kind].color
	state.highlights[instance] = create("Highlight", {
		Name = instance.Name,
		Adornee = instance,
		FillColor = color,
		OutlineColor = color,
		FillTransparency = CONFIG.ObjectEsp.FillTransparency,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	}, state.folder)
	state.count += 1
end

local function removeObjectHighlight(kind, instance)
	local state = objectEspStates[kind]
	local highlight = state and state.highlights[instance]
	if highlight then
		highlight:Destroy()
		state.highlights[instance] = nil
		state.count -= 1
	end
end

local function enableObjectEsp(kind)
	local state = {
		highlights = {},
		count = 0,
		janitor = Janitor.new(),
		folder = create("Folder", { Name = ESP_FOLDER_NAME .. "Objects" .. kind }, workspace),
	}
	state.janitor:Add(state.folder)
	objectEspStates[kind] = state
	for _, tag in ipairs(objectEspKinds[kind].getTags()) do
		for _, instance in ipairs(CollectionService:GetTagged(tag)) do
			addObjectHighlight(kind, instance)
		end
		state.janitor:Add(CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance)
			addObjectHighlight(kind, instance)
		end))
		state.janitor:Add(CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance)
			removeObjectHighlight(kind, instance)
		end))
	end
end

local function disableObjectEsp(kind)
	local state = objectEspStates[kind]
	if state then
		state.janitor:Clean()
		objectEspStates[kind] = nil
	end
end

local function createObjectEspHandler(kind)
	return function(enabled)
		if (objectEspStates[kind] ~= nil) == enabled then
			return true
		end
		if enabled then
			enableObjectEsp(kind)
		else
			disableObjectEsp(kind)
		end
		return true
	end
end

CharacterWatcher.subscribe(function()
	if Esp.enabled then
		disableEsp()
		enableEsp()
	end
end, function() end)

featureHandlers.EnemyEsp = createObjectEspHandler("Enemies")
featureHandlers.LootEsp = createObjectEspHandler("Loot")
end

local Fly, setFlySpeed
do
Fly = {
	enabled = false,
	speed = CONFIG.Fly.Default,
	janitor = Janitor.new(),
	bodyJanitor = Janitor.new(),
	velocity = nil,
	align = nil,
	platformStandOriginal = nil,
}

local function readFlyDirection(camera, humanoid)
	local look = camera.CFrame.LookVector
	local right = camera.CFrame.RightVector
	local move = humanoid.MoveDirection
	local direction = Vector3.zero
	if move.Magnitude > 0.01 then
		local forwardAmount = move:Dot(flatDirection(look))
		local sideAmount = move:Dot(flatDirection(right))
		direction = look * forwardAmount + right * sideAmount
	end
	local vertical = 0
	if UserInputService:IsKeyDown(CONFIG.Fly.UpKey) or humanoid.Jump then
		vertical += 1
	end
	if UserInputService:IsKeyDown(CONFIG.Fly.DownKey) then
		vertical -= 1
	end
	return direction + Vector3.new(0, vertical, 0)
end

local function onFlyStep()
	local humanoid = CharacterWatcher.humanoid
	local camera = workspace.CurrentCamera
	if not humanoid or not camera or humanoid.Health <= 0 or not Fly.velocity then
		return
	end
	local direction = readFlyDirection(camera, humanoid)
	if direction.Magnitude > 1 then
		direction = direction.Unit
	end
	Fly.velocity.VectorVelocity = direction * Fly.speed
	local facing = flatDirection(camera.CFrame.LookVector)
	if facing ~= Vector3.zero then
		Fly.align.CFrame = CFrame.lookAt(Vector3.zero, facing)
	end
end

local function applyFlyBody(humanoid, root)
	Fly.bodyJanitor:Clean()
	Fly.platformStandOriginal = humanoid.PlatformStand
	humanoid.PlatformStand = true
	local facing = flatDirection(root.CFrame.LookVector)
	if facing == Vector3.zero then
		facing = Vector3.zAxis
	end
	local attachment = Fly.bodyJanitor:Add(create("Attachment", { Name = "MinhDiemFlyAnchor" }, root))
	Fly.velocity = Fly.bodyJanitor:Add(create("LinearVelocity", {
		Attachment0 = attachment,
		MaxForce = 1e9,
		VelocityConstraintMode = Enum.VelocityConstraintMode.Vector,
		RelativeTo = Enum.ActuatorRelativeTo.World,
		VectorVelocity = Vector3.zero,
	}, root))
	Fly.align = Fly.bodyJanitor:Add(create("AlignOrientation", {
		Attachment0 = attachment,
		Mode = Enum.OrientationAlignmentMode.OneAttachment,
		MaxTorque = 1e9,
		Responsiveness = 100,
		CFrame = CFrame.lookAt(Vector3.zero, facing),
	}, root))
end

local function releaseFlyBody(humanoid)
	Fly.bodyJanitor:Clean()
	Fly.velocity = nil
	Fly.align = nil
	if humanoid then
		humanoid.PlatformStand = Fly.platformStandOriginal or false
	end
	Fly.platformStandOriginal = nil
end

function setFlySpeed(value)
	Fly.speed = value
end

featureHandlers.Fly = function(enabled)
	if Fly.enabled == enabled then
		return true
	end
	local humanoid, root = CharacterWatcher.humanoid, CharacterWatcher.root
	if enabled then
		if not humanoid or not root then
			return false, "Chưa có nhân vật để bay"
		end
		stopOtherMovers("Fly")
		Fly.enabled = true
		applyFlyBody(humanoid, root)
		Fly.janitor:Add(RunService.Heartbeat:Connect(onFlyStep))
	else
		Fly.enabled = false
		Fly.janitor:Clean()
		releaseFlyBody(humanoid)
	end
	return true
end

CharacterWatcher.subscribe(function(_, humanoid, root)
	if Fly.enabled then
		applyFlyBody(humanoid, root)
	end
end, function()
	Fly.bodyJanitor:Clean()
	Fly.velocity = nil
	Fly.align = nil
	Fly.platformStandOriginal = nil
end)
end

local GodMode
do
GodMode = {
	enabled = false,
	burning = false,
	janitor = Janitor.new(),
	fire = nil,
}

local function refreshFire(root)
	if GodMode.fire then
		GodMode.fire:Destroy()
		GodMode.fire = nil
	end
	if GodMode.burning and root then
		GodMode.fire = create("Fire", {
			Size = 9,
			Heat = 12,
			Color = Color3.fromRGB(255, 110, 0),
			SecondaryColor = Color3.fromRGB(255, 220, 40),
		}, root)
	end
end

local function protectHumanoid(humanoid)
	GodMode.janitor:Clean()
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	GodMode.janitor:Add(function()
		if humanoid.Parent then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
		end
	end)
	GodMode.janitor:Add(humanoid.HealthChanged:Connect(function(health)
		if health < humanoid.MaxHealth then
			humanoid.Health = humanoid.MaxHealth
		end
	end))
end

featureHandlers.GodMode = function(enabled)
	if GodMode.enabled == enabled then
		return true
	end
	GodMode.enabled = enabled
	local humanoid = CharacterWatcher.humanoid
	if enabled then
		if humanoid then
			protectHumanoid(humanoid)
		end
	else
		GodMode.janitor:Clean()
	end
	return true
end

featureHandlers.BurnEffect = function(enabled)
	GodMode.burning = enabled
	refreshFire(CharacterWatcher.root)
	return true
end

CharacterWatcher.subscribe(function(_, humanoid, root)
	if GodMode.enabled then
		protectHumanoid(humanoid)
	end
	if GodMode.burning then
		refreshFire(root)
	end
end, function()
	GodMode.janitor:Clean()
	GodMode.fire = nil
end)
end

local setFovValue
do
local FieldOfView = {
	enabled = false,
	value = CONFIG.Fov.Default,
	original = nil,
	janitor = Janitor.new(),
}

local function applyFov()
	local camera = workspace.CurrentCamera
	if camera and camera.FieldOfView ~= FieldOfView.value then
		camera.FieldOfView = FieldOfView.value
	end
end

function setFovValue(value)
	FieldOfView.value = value
	if FieldOfView.enabled then
		applyFov()
	end
end

featureHandlers.Fov = function(enabled)
	if FieldOfView.enabled == enabled then
		return true
	end
	FieldOfView.enabled = enabled
	local camera = workspace.CurrentCamera
	if enabled then
		FieldOfView.original = camera and camera.FieldOfView
		applyFov()
		if camera then
			FieldOfView.janitor:Add(camera:GetPropertyChangedSignal("FieldOfView"):Connect(applyFov))
		end
	else
		FieldOfView.janitor:Clean()
		if camera and FieldOfView.original then
			camera.FieldOfView = FieldOfView.original
		end
		FieldOfView.original = nil
	end
	return true
end
end

local XRay, setXRayTransparency
do
XRay = {
	enabled = false,
	transparency = CONFIG.XRay.DefaultPercent / 100,
	generation = 0,
	modified = setmetatable({}, { __mode = "k" }),
	janitor = Janitor.new(),
}

local function applyXRay(instance)
	if not XRay.enabled or not instance:IsA("BasePart") then
		return
	end
	if instance == workspace.Terrain or instance.Transparency >= 1 or isProtectedFromFixLag(instance) then
		return
	end
	XRay.modified[instance] = true
	instance.LocalTransparencyModifier = XRay.transparency
end

local function scanXRay(generation)
	local processed = 0
	for _, instance in ipairs(workspace:GetDescendants()) do
		if XRay.generation ~= generation then
			return
		end
		applyXRay(instance)
		processed += 1
		if processed % CONFIG.XRay.BatchSize == 0 then
			task.wait()
		end
	end
end

local function queueXRayInstance(instance)
	task.defer(applyXRay, instance)
end

function setXRayTransparency(fraction)
	XRay.transparency = fraction
	for part in pairs(XRay.modified) do
		if part.Parent then
			part.LocalTransparencyModifier = fraction
		end
	end
end

featureHandlers.XRay = function(enabled)
	if XRay.enabled == enabled then
		return true
	end
	XRay.enabled = enabled
	XRay.generation += 1
	if enabled then
		local generation = XRay.generation
		XRay.janitor:Add(workspace.DescendantAdded:Connect(queueXRayInstance))
		XRay.janitor:Add(task.spawn(scanXRay, generation))
	else
		XRay.janitor:Clean()
		for part in pairs(XRay.modified) do
			if part.Parent then
				part.LocalTransparencyModifier = 0
			end
			XRay.modified[part] = nil
		end
	end
	return true
end
end

local AntiAfk
do
AntiAfk = { janitor = Janitor.new() }

local function simulateActivity()
	local ok, errorMessage = pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.zero)
	end)
	if not ok then
		warn(string.format("[%s] Anti AFK lỗi: %s", CONFIG.Name, tostring(errorMessage)))
	end
end

featureHandlers.AntiAfk = function(enabled)
	AntiAfk.janitor:Clean()
	if enabled then
		AntiAfk.janitor:Add(localPlayer.Idled:Connect(simulateActivity))
	end
	return true
end
end

local Aim
do
Aim = {
	enabled = false,
	holding = false,
	janitor = Janitor.new(),
	raycastParams = RaycastParams.new(),
	circle = nil,
	mode = CONFIG.Aim.Mode,
	selectedPlayer = nil,
	fieldOfView = CONFIG.Aim.FieldOfView,
	smoothness = CONFIG.Aim.Smoothness,
	wallCheck = CONFIG.Aim.WallCheck,
	requireHold = CONFIG.Aim.RequireHold,
}
Aim.raycastParams.FilterType = Enum.RaycastFilterType.Exclude
Aim.raycastParams.RespectCanCollide = true

local isTouchOnly = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function isAimTargetAllowed(player)
	if player == localPlayer then
		return false
	end
	if Aim.mode == "Selected" then
		return player == Aim.selectedPlayer
	end
	if Aim.mode == "Enemies" and isTeammate(player) then
		return false
	end
	return true
end

local function getAimPart(player)
	if not isAimTargetAllowed(player) then
		return nil
	end
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return nil
	end
	return character:FindFirstChild(CONFIG.Aim.TargetPart) or character:FindFirstChild("HumanoidRootPart")
end

local function isAimVisible(camera, part)
	if not Aim.wallCheck then
		return true
	end
	Aim.raycastParams.FilterDescendantsInstances = { CharacterWatcher.character or workspace.Terrain }
	local origin = camera.CFrame.Position
	local result = workspace:Raycast(origin, part.Position - origin, Aim.raycastParams)
	return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function getAimOrigin(camera)
	if isTouchOnly or UserInputService.MouseBehavior == Enum.MouseBehavior.LockCenter then
		return camera.ViewportSize / 2
	end
	return UserInputService:GetMouseLocation()
end

local function findSelectedTarget(camera)
	local player = Aim.selectedPlayer
	if not player or player.Parent ~= Players then
		return nil
	end
	local part = getAimPart(player)
	if part and (part.Position - camera.CFrame.Position).Magnitude <= CONFIG.Aim.MaxDistance and isAimVisible(camera, part) then
		return part
	end
	return nil
end

local function findAimTarget(camera, center)
	if Aim.mode == "Selected" then
		return findSelectedTarget(camera)
	end
	local bestPart, bestOffset = nil, Aim.fieldOfView
	for _, player in ipairs(Players:GetPlayers()) do
		local part = getAimPart(player)
		if part and (part.Position - camera.CFrame.Position).Magnitude <= CONFIG.Aim.MaxDistance then
			local screenPoint, onScreen = camera:WorldToViewportPoint(part.Position)
			local offset = (Vector2.new(screenPoint.X, screenPoint.Y) - center).Magnitude
			if onScreen and offset < bestOffset and isAimVisible(camera, part) then
				bestPart, bestOffset = part, offset
			end
		end
	end
	return bestPart
end

local function onAimStep(deltaTime)
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end
	local center = getAimOrigin(camera)
	if Aim.circle then
		Aim.circle.Position = UDim2.fromOffset(center.X, center.Y)
	end
	if Aim.requireHold and not Aim.holding and not isTouchOnly then
		return
	end
	local part = findAimTarget(camera, center)
	if not part then
		return
	end
	local alpha = 1
	if Aim.smoothness < 0.99 then
		alpha = 1 - (1 - Aim.smoothness) ^ (deltaTime * 60)
	end
	local goal = CFrame.lookAt(camera.CFrame.Position, part.Position)
	camera.CFrame = camera.CFrame:Lerp(goal, alpha)
end

local function createAimCircle()
	local circle = create("Frame", {
		Name = "AimFov",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(Aim.fieldOfView * 2, Aim.fieldOfView * 2),
		BackgroundTransparency = 1,
		Active = false,
	}, screenGui)
	create("UICorner", { CornerRadius = UDim.new(0.5, 0) }, circle)
	addStroke(circle, THEME.Accent, 1.5)
	return circle
end

local function enableAim()
	Aim.enabled = true
	Aim.circle = Aim.janitor:Add(createAimCircle())
	Aim.janitor:Add(UserInputService.InputBegan:Connect(function(input, processed)
		if not processed and input.UserInputType == CONFIG.Aim.HoldInput then
			Aim.holding = true
		end
	end))
	Aim.janitor:Add(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == CONFIG.Aim.HoldInput then
			Aim.holding = false
		end
	end))
	RunService:BindToRenderStep(AIM_BIND_NAME, Enum.RenderPriority.Camera.Value + 1, onAimStep)
	Aim.janitor:Add(function()
		RunService:UnbindFromRenderStep(AIM_BIND_NAME)
	end)
end

local function disableAim()
	Aim.enabled = false
	Aim.holding = false
	Aim.circle = nil
	Aim.janitor:Clean()
end

function Aim.setMode(mode)
	Aim.mode = mode
end

function Aim.setSelectedPlayer(name)
	Aim.selectedPlayer = Players:FindFirstChild(name)
end

function Aim.setFieldOfView(value)
	Aim.fieldOfView = value
	if Aim.circle then
		Aim.circle.Size = UDim2.fromOffset(value * 2, value * 2)
	end
end

function Aim.setSmoothness(percent)
	Aim.smoothness = percent / 100
end

featureHandlers.Aim = function(enabled)
	if Aim.enabled == enabled then
		return true
	end
	if enabled then
		enableAim()
	else
		disableAim()
	end
	return true
end

featureHandlers.AimWallCheck = function(enabled)
	Aim.wallCheck = enabled
	return true
end

featureHandlers.AimHold = function(enabled)
	Aim.requireHold = enabled
	return true
end
end

do
local rowCounter = 0
local searchEntries = {}
local pages = {}
local dragState = { handler = nil, scrollFrame = nil }
local activeTab = "Features"
local searchPage = nil

local function nextOrder()
	rowCounter += 1
	return rowCounter
end

local function registerSearchable(frame, page, keywords)
	table.insert(searchEntries, { frame = frame, page = page, text = string.lower(keywords) })
end

local function createRow(page, height)
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, height),
		BackgroundColor3 = THEME.Element,
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(),
	}, page)
	addCorner(row, 8)
	addStroke(row, THEME.Stroke, 1)
	return row
end

local function createToggle(page, key, title, description, keywords)
	local row = createRow(page, 46)
	local titleLabel = createLabel(row, title, 13, THEME.Text, THEME.FontBold)
	titleLabel.Position = UDim2.fromOffset(12, 6)
	titleLabel.Size = UDim2.new(1, -70, 0, 18)
	local descriptionLabel = createLabel(row, description, 11, THEME.TextDim)
	descriptionLabel.Position = UDim2.fromOffset(12, 25)
	descriptionLabel.Size = UDim2.new(1, -70, 0, 14)
	local track = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -12, 0.5, 0),
		Size = UDim2.fromOffset(38, 20),
		BackgroundColor3 = THEME.Stroke,
		BorderSizePixel = 0,
	}, row)
	addCorner(track, 10)
	local knob = create("Frame", {
		Position = UDim2.fromOffset(2, 2),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, track)
	addCorner(knob, 8)
	local button = create("TextButton", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	}, row)
	local state = false
	local info = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
	toggleRenderers[key] = function(value)
		state = value
		TweenService:Create(track, info, { BackgroundColor3 = value and THEME.Accent or THEME.Stroke }):Play()
		TweenService:Create(knob, info, { Position = value and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2) }):Play()
	end
	button.Activated:Connect(function()
		local value = not state
		local accepted, reason = setFeature(key, value)
		if accepted then
			notify(title .. (value and " đã bật" or " đã tắt"), "success")
		else
			notify(reason or ("Không thể bật " .. title), "error")
		end
	end)
	registerSearchable(row, page, title .. " " .. description .. " " .. (keywords or ""))
	return row
end

local function createSlider(page, title, minimum, maximum, default, onChange, keywords)
	local row = createRow(page, 62)
	local titleLabel = createLabel(row, title, 13, THEME.Text, THEME.FontBold)
	titleLabel.Position = UDim2.fromOffset(12, 8)
	titleLabel.Size = UDim2.new(1, -90, 0, 18)
	local input = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -12, 0, 6),
		Size = UDim2.fromOffset(58, 24),
		BackgroundColor3 = THEME.Panel,
		Text = tostring(default),
		TextColor3 = THEME.Text,
		Font = THEME.Font,
		TextSize = 12,
		ClearTextOnFocus = false,
	}, row)
	addCorner(input, 6)
	addStroke(input, THEME.Stroke, 1)
	local track = create("Frame", {
		Position = UDim2.fromOffset(12, 45),
		Size = UDim2.new(1, -24, 0, 6),
		BackgroundColor3 = THEME.Stroke,
		BorderSizePixel = 0,
	}, row)
	addCorner(track, 3)
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = THEME.Accent, BorderSizePixel = 0 }, track)
	addCorner(fill, 3)
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, track)
	addCorner(knob, 7)
	local hit = create("TextButton", {
		Position = UDim2.new(0, 0, 0.5, -12),
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	}, track)
	local current = default
	local function setValue(value)
		current = math.clamp(math.floor(value + 0.5), minimum, maximum)
		local alpha = (current - minimum) / (maximum - minimum)
		fill.Size = UDim2.fromScale(alpha, 1)
		knob.Position = UDim2.fromScale(alpha, 0.5)
		input.Text = tostring(current)
		return current
	end
	setValue(default)
	local function updateFromPosition(position)
		local alpha = math.clamp((position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		onChange(setValue(minimum + alpha * (maximum - minimum)))
	end
	hit.InputBegan:Connect(function(inputObject)
		local inputType = inputObject.UserInputType
		if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
			return
		end
		updateFromPosition(inputObject.Position)
		dragState.handler = function(moved)
			updateFromPosition(moved.Position)
		end
		dragState.scrollFrame = page
		page.ScrollingEnabled = false
	end)
	input.FocusLost:Connect(function()
		local parsed = tonumber(input.Text)
		if not parsed or parsed ~= parsed then
			notify("Giá trị không hợp lệ", "error")
			input.Text = tostring(current)
			return
		end
		local applied = setValue(parsed)
		if applied ~= math.floor(parsed + 0.5) then
			notify(string.format("Đã giới hạn trong khoảng %d - %d", minimum, maximum), "warn")
		end
		onChange(applied)
	end)
	registerSearchable(row, page, title .. " " .. (keywords or ""))
	return row
end

local function createButton(page, text, color, callback, keywords)
	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 36),
		BackgroundColor3 = color,
		Text = text,
		TextColor3 = (color == THEME.Error or color == THEME.Element) and THEME.Text or Color3.new(0, 0, 0),
		Font = THEME.FontBold,
		TextSize = 13,
		AutoButtonColor = true,
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(),
	}, page)
	addCorner(button, 8)
	button.Activated:Connect(callback)
	registerSearchable(button, page, text .. " " .. (keywords or ""))
	return button
end

local function createStatus(page, kind, title)
	local row = createRow(page, 34)
	local titleLabel = createLabel(row, title, 13, THEME.Text, THEME.FontBold)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
	local valueLabel = createLabel(row, "Idle", 12, THEME.TextDim)
	valueLabel.Position = UDim2.new(0.4, 0, 0, 0)
	valueLabel.Size = UDim2.new(0.6, -12, 1, 0)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local lastText = "Idle"
	statusSetters[kind] = function(text)
		if text == lastText then
			return
		end
		lastText = text
		valueLabel.Text = text
		if string.find(text, "Waiting", 1, true) then
			valueLabel.TextColor3 = THEME.Warn
		elseif text == "Idle" then
			valueLabel.TextColor3 = THEME.TextDim
		else
			valueLabel.TextColor3 = THEME.Success
		end
	end
	registerSearchable(row, page, title .. " status trạng thái")
end

local function createCard(page, heading, body)
	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 30),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = THEME.Element,
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(),
	}, page)
	addCorner(card, 8)
	addStroke(card, THEME.Stroke, 1)
	addPadding(card, 12)
	addList(card, 6)
	local headingLabel = createLabel(card, heading, 14, THEME.Text, THEME.FontBold)
	headingLabel.LayoutOrder = 1
	local bodyLabel = createLabel(card, body, 12, THEME.TextDim)
	bodyLabel.LayoutOrder = 2
	bodyLabel.TextWrapped = true
	bodyLabel.AutomaticSize = Enum.AutomaticSize.Y
	bodyLabel.Size = UDim2.new(1, 0, 0, 0)
	bodyLabel.TextYAlignment = Enum.TextYAlignment.Top
	registerSearchable(card, page, heading .. " " .. body)
	return card
end

local function createDropdown(page, title, placeholder, getOptions, multiple, onChange, keywords)
	local root = create("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = THEME.Element,
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(),
	}, page)
	addCorner(root, 8)
	addStroke(root, THEME.Stroke, 1)
	addList(root, 0)
	local header = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		LayoutOrder = 1,
	}, root)
	local titleLabel = createLabel(header, title, 13, THEME.Text, THEME.FontBold)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.Size = UDim2.new(0.4, 0, 1, 0)
	local summaryLabel = createLabel(header, placeholder, 12, THEME.TextDim)
	summaryLabel.Position = UDim2.new(0.4, 0, 0, 0)
	summaryLabel.Size = UDim2.new(0.6, -32, 1, 0)
	summaryLabel.TextXAlignment = Enum.TextXAlignment.Right
	summaryLabel.TextTruncate = Enum.TextTruncate.AtEnd
	local arrow = createLabel(header, "▾", 14, THEME.TextDim)
	arrow.AnchorPoint = Vector2.new(1, 0.5)
	arrow.Position = UDim2.new(1, -12, 0.5, 0)
	arrow.Size = UDim2.fromOffset(12, 16)
	local panel = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		LayoutOrder = 2,
	}, root)
	addPadding(panel, 8)
	addList(panel, 6)
	local search = create("TextBox", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = THEME.Panel,
		PlaceholderText = "Tìm kiếm...",
		PlaceholderColor3 = THEME.TextDim,
		Text = "",
		TextColor3 = THEME.Text,
		Font = THEME.Font,
		TextSize = 12,
		ClearTextOnFocus = false,
		LayoutOrder = 1,
	}, panel)
	addCorner(search, 6)
	addPadding(search, 6)
	local optionList = create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 110),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		LayoutOrder = 2,
	}, panel)
	addList(optionList, 4)
	local selected = {}
	local function updateSummary()
		local names = {}
		for name in pairs(selected) do
			table.insert(names, name)
		end
		table.sort(names)
		summaryLabel.Text = #names > 0 and table.concat(names, ", ") or placeholder
		summaryLabel.TextColor3 = #names > 0 and THEME.Text or THEME.TextDim
	end
	local rebuildOptions
	local function selectOption(name)
		if multiple then
			selected[name] = (not selected[name]) or nil
			onChange(table.clone(selected))
			rebuildOptions()
		else
			selected = { [name] = true }
			panel.Visible = false
			onChange(name)
		end
		updateSummary()
	end
	local function createOptionButton(name, order)
		local button = create("TextButton", {
			Size = UDim2.new(1, -6, 0, 26),
			BackgroundColor3 = selected[name] and THEME.Accent or THEME.Panel,
			Text = name,
			TextColor3 = selected[name] and Color3.new(0, 0, 0) or THEME.Text,
			Font = THEME.Font,
			TextSize = 12,
			AutoButtonColor = true,
			BorderSizePixel = 0,
			LayoutOrder = order,
		}, optionList)
		addCorner(button, 6)
		button.Activated:Connect(function()
			selectOption(name)
		end)
	end
	rebuildOptions = function()
		for _, child in ipairs(optionList:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
		local query = string.lower(search.Text)
		local shown = 0
		for _, name in ipairs(getOptions()) do
			if query == "" or string.find(string.lower(name), query, 1, true) then
				shown += 1
				createOptionButton(name, shown)
			end
		end
		if shown == 0 then
			local empty = createLabel(optionList, "Không có dữ liệu", 12, THEME.TextDim)
			empty.TextXAlignment = Enum.TextXAlignment.Center
		end
	end
	header.Activated:Connect(function()
		panel.Visible = not panel.Visible
		if panel.Visible then
			rebuildOptions()
		end
	end)
	search:GetPropertyChangedSignal("Text"):Connect(rebuildOptions)
	registerSearchable(root, page, title .. " " .. (keywords or ""))
	updateSummary()
	return {
		refresh = rebuildOptions,
		select = function(name)
			selected = { [name] = true }
			updateSummary()
		end,
	}
end

local function createPage(parent)
	local page = create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = THEME.Accent,
		CanvasSize = UDim2.fromOffset(0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
		Visible = false,
	}, parent)
	addList(page, 6)
	create("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8) }, page)
	return page
end

local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local menuWidth = math.min(500, viewport.X - 24)
local menuHeight = math.min(380, viewport.Y - 24)
local HEADER_HEIGHT = 40
local FOOTER_HEIGHT = 22
local SIDEBAR_WIDTH = 108

local main = create("Frame", {
	Name = "Main",
	Size = UDim2.fromOffset(menuWidth, menuHeight),
	Position = UDim2.fromOffset(70, math.max(12, (viewport.Y - menuHeight) / 2)),
	BackgroundColor3 = THEME.Background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, screenGui)
addCorner(main, 3)
addStroke(main, THEME.Accent, 1)

local header = create("Frame", {
	Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
	BackgroundColor3 = THEME.Panel,
	BorderSizePixel = 0,
	Active = true,
}, main)
create("Frame", {
	Position = UDim2.fromOffset(0, HEADER_HEIGHT),
	Size = UDim2.new(1, 0, 0, 1),
	BackgroundColor3 = THEME.Accent,
	BorderSizePixel = 0,
}, main)

local titleLabel = createLabel(header, ">_ " .. CONFIG.Name, 15, THEME.Accent, THEME.FontBold)
titleLabel.Position = UDim2.fromOffset(12, 5)
titleLabel.Size = UDim2.new(0, 220, 0, 18)
local subtitleLabel = createLabel(header, "dev: " .. CONFIG.Developer .. "  |  tg: " .. CONFIG.TelegramHandle, 10, THEME.TextDim)
subtitleLabel.Position = UDim2.fromOffset(12, 23)
subtitleLabel.Size = UDim2.new(0, 300, 0, 12)
local versionBadge = create("TextLabel", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -78, 0.5, 0),
	Size = UDim2.fromOffset(44, 18),
	BackgroundTransparency = 1,
	Text = "[" .. CONFIG.Version .. "]",
	TextColor3 = THEME.Accent,
	Font = THEME.FontBold,
	TextSize = 12,
}, header)

local function createHeaderButton(text, offset, color)
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, offset, 0.5, 0),
		Size = UDim2.fromOffset(26, 26),
		BackgroundColor3 = color,
		Text = text,
		TextColor3 = THEME.Text,
		Font = THEME.FontBold,
		TextSize = 14,
		AutoButtonColor = true,
		BorderSizePixel = 0,
	}, header)
	addCorner(button, 3)
	addStroke(button, THEME.Stroke, 1)
	return button
end

local minimizeButton = createHeaderButton("-", -42, THEME.Element)
local closeButton = createHeaderButton("x", -10, THEME.Error)

local body = create("Frame", {
	Position = UDim2.fromOffset(0, HEADER_HEIGHT + 1),
	Size = UDim2.new(1, 0, 1, -(HEADER_HEIGHT + 1)),
	BackgroundTransparency = 1,
}, main)

local sidebar = create("Frame", {
	Size = UDim2.new(0, SIDEBAR_WIDTH, 1, -FOOTER_HEIGHT),
	BackgroundColor3 = THEME.Panel,
	BorderSizePixel = 0,
}, body)
addPadding(sidebar, 6)
addList(sidebar, 4)
create("Frame", {
	Position = UDim2.fromOffset(SIDEBAR_WIDTH, 0),
	Size = UDim2.new(0, 1, 1, -FOOTER_HEIGHT),
	BackgroundColor3 = THEME.Stroke,
	BorderSizePixel = 0,
}, body)

local content = create("Frame", {
	Position = UDim2.fromOffset(SIDEBAR_WIDTH + 8, 8),
	Size = UDim2.new(1, -(SIDEBAR_WIDTH + 16), 1, -(FOOTER_HEIGHT + 16)),
	BackgroundTransparency = 1,
}, body)

local searchBox = create("TextBox", {
	Size = UDim2.new(1, 0, 0, 28),
	BackgroundColor3 = THEME.Panel,
	PlaceholderText = "> tim kiem chuc nang...",
	PlaceholderColor3 = THEME.TextDim,
	Text = "",
	TextColor3 = THEME.Accent,
	Font = THEME.Font,
	TextSize = 12,
	ClearTextOnFocus = false,
	TextXAlignment = Enum.TextXAlignment.Left,
	BorderSizePixel = 0,
}, content)
addCorner(searchBox, 3)
addStroke(searchBox, THEME.Stroke, 1)
create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, searchBox)

local pageHolder = create("Frame", {
	Position = UDim2.fromOffset(0, 36),
	Size = UDim2.new(1, 0, 1, -36),
	BackgroundTransparency = 1,
}, content)

local footer = create("Frame", {
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, FOOTER_HEIGHT),
	BackgroundColor3 = THEME.Panel,
	BorderSizePixel = 0,
}, body)
local statusLabel = createLabel(footer, "FPS -- | PING -- | PLAYERS --", 10, THEME.TextDim)
statusLabel.Position = UDim2.fromOffset(10, 0)
statusLabel.Size = UDim2.new(1, -20, 1, 0)

notifyContainer = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 56),
	Size = UDim2.fromOffset(300, 200),
	BackgroundTransparency = 1,
	ZIndex = 50,
}, screenGui)
create("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Top,
}, notifyContainer)

local tabButtons = {}
local tabBars = {}
local TAB_DEFINITIONS = {
	{ key = "Features", label = "CHUC NANG" },
	{ key = "Auto", label = "TU DONG" },
	{ key = "Visual", label = "HIEN THI" },
	{ key = "Aim", label = "AIM" },
	{ key = "Players", label = "NGUOI CHOI" },
	{ key = "Actions", label = "HANH DONG" },
	{ key = "About", label = "GIOI THIEU" },
}

local function applySearch(query)
	local normalized = string.lower(query):match("^%s*(.-)%s*$")
	if normalized == "" then
		for _, entry in ipairs(searchEntries) do
			entry.frame.Parent = entry.page
		end
		searchPage.Visible = false
		for key, page in pairs(pages) do
			page.Visible = key == activeTab
		end
		return
	end
	for _, entry in ipairs(searchEntries) do
		entry.frame.Parent = string.find(entry.text, normalized, 1, true) and searchPage or entry.page
	end
	for _, page in pairs(pages) do
		page.Visible = false
	end
	searchPage.Visible = true
end

local function selectTab(key)
	activeTab = key
	for tabKey, button in pairs(tabButtons) do
		local isActive = tabKey == key
		button.BackgroundTransparency = isActive and 0 or 1
		button.TextColor3 = isActive and THEME.Accent or THEME.TextDim
		tabBars[tabKey].Visible = isActive
	end
	if searchBox.Text ~= "" then
		searchBox.Text = ""
	else
		applySearch("")
	end
end

for index, definition in ipairs(TAB_DEFINITIONS) do
	pages[definition.key] = createPage(pageHolder)
	local button = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = THEME.Element,
		BackgroundTransparency = 1,
		Text = "  " .. definition.label,
		TextColor3 = THEME.TextDim,
		Font = THEME.FontBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = index,
	}, sidebar)
	addCorner(button, 3)
	tabBars[definition.key] = create("Frame", {
		Size = UDim2.new(0, 2, 1, 0),
		BackgroundColor3 = THEME.Accent,
		BorderSizePixel = 0,
		Visible = false,
	}, button)
	button.Activated:Connect(function()
		selectTab(definition.key)
	end)
	tabButtons[definition.key] = button
end
searchPage = createPage(pageHolder)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	applySearch(searchBox.Text)
end)

local function reportResult(successMessage, accepted, reason)
	if accepted then
		notify(successMessage, "success")
	else
		notify(reason or "Khong thuc hien duoc", "error")
	end
end

local ALL_FEATURE_KEYS = {
	"HopPlayers", "OrbitPlayer", "FollowPlayer", "Spectate", "AutoAttack", "AutoClick", "AutoFarm", "AutoLoot",
	"Fly", "Noclip", "GodMode", "BurnEffect", "FixLag", "FullBright", "WalkSpeed", "HighJump", "InfiniteJump",
	"Fov", "XRay", "AntiAfk", "Esp", "EnemyEsp", "LootEsp", "Aim",
}

local function disableAllFeatures()
	for _, key in ipairs(ALL_FEATURE_KEYS) do
		setFeature(key, false)
	end
	notify("Da tat tat ca chuc nang", "success")
end

do
	local featuresPage = pages.Features
	createButton(featuresPage, "TAT TAT CA CHUC NANG", THEME.Error, disableAllFeatures, "tat tat ca panic stop all")
	createToggle(featuresPage, "WalkSpeed", "Speed Walk", "Chay nhanh", "speed walk chay nhanh toc do walkspeed")
	createSlider(featuresPage, "Toc do chay", CONFIG.WalkSpeed.Min, CONFIG.WalkSpeed.Max, CONFIG.WalkSpeed.Default, setWalkSpeedValue, "speed walkspeed chay")
	createToggle(featuresPage, "HighJump", "High Jump", "Nhay cao", "jump nhay cao jumppower jumpheight")
	createSlider(featuresPage, "Do cao nhay", CONFIG.Jump.Min, CONFIG.Jump.Max, CONFIG.Jump.Default, setJumpValue, "jump nhay")
	createToggle(featuresPage, "InfiniteJump", "Infinite Jump", "Nhay lien tuc tren khong", "nhay lien tuc infinite jump")
	createToggle(featuresPage, "Fly", "Fly", "Bay theo huong camera, dung yen khi khong di chuyen", "bay fly camera")
	createSlider(featuresPage, "Toc do bay", CONFIG.Fly.Min, CONFIG.Fly.Max, CONFIG.Fly.Default, setFlySpeed, "bay fly speed toc do")
	createToggle(featuresPage, "Noclip", "Noclip", "Di xuyen vat can", "noclip xuyen tuong")
	createToggle(featuresPage, "GodMode", "Bat tu", "Chan chet o phia client (xem huong dan)", "bat tu god mode khong chet lava")
	createToggle(featuresPage, "BurnEffect", "Hieu ung chay nguoi", "Lua boc quanh nhan vat", "chay lua fire hieu ung")
	createToggle(featuresPage, "FullBright", "Full Bright", "Sang ban do, tat de khoi phuc", "sang fullbright anh sang")
	createToggle(featuresPage, "FixLag", "Fix Lag", "Giam do hoa, tat de khoi phuc", "lag giam do hoa fps")
	createToggle(featuresPage, "Fov", "Camera FOV", "Doi goc nhin camera", "fov goc nhin camera")
	createSlider(featuresPage, "Goc nhin (FOV)", CONFIG.Fov.Min, CONFIG.Fov.Max, CONFIG.Fov.Default, setFovValue, "fov goc nhin")
	createToggle(featuresPage, "AntiAfk", "Anti AFK", "Khong bi kick khi dung yen (mac dinh bat)", "afk idle kick dung yen")
end

do
	local autoPage = pages.Auto
	createStatus(autoPage, "Farm", "Auto Farm")
	createDropdown(autoPage, "Loai quai", "Chon quai...", getEnemyTypes, false, setEnemyType, "quai enemy farm")
	createToggle(autoPage, "AutoFarm", "Auto Farm", "Bay tren dau quai gan nhat", "farm quai tu dong")
	createStatus(autoPage, "Loot", "Auto Loot")
	createDropdown(autoPage, "Loai loot", "Chon loot...", function()
		return table.clone(CONFIG.Loot.Tags)
	end, true, setLootTags, "loot ruong trai ac quy nhat do")
	createToggle(autoPage, "AutoLoot", "Auto Loot", "Tu dong den vat pham gan nhat", "loot nhat tu dong")
	createToggle(autoPage, "AutoAttack", "Auto danh gan nhat", "Tu danh muc tieu trong tam gan", "auto attack danh gan nhat 3m")
	createSlider(autoPage, "Tam danh (met)", CONFIG.AutoAttack.Min, CONFIG.AutoAttack.Max, CONFIG.AutoAttack.Default, setAutoAttackRange, "tam danh met range")
	createSlider(autoPage, "Toc do danh (lan/giay)", CONFIG.AttackRate.Min, CONFIG.AttackRate.Max, CONFIG.AttackRate.Default, setAttackRate, "attack nhanh toc do danh")
	setAttackRate(CONFIG.AttackRate.Default)
	createToggle(autoPage, "AutoClick", "Auto Click", "Tu kich hoat vu khi dang cam", "auto click danh nhanh")
	createSlider(autoPage, "Toc do click (lan/giay)", CONFIG.AutoClick.Min, CONFIG.AutoClick.Max, CONFIG.AutoClick.Default, setClickRate, "click toc do")
end

do
	local visualPage = pages.Visual
	createToggle(visualPage, "Esp", "Player ESP", "Bat ESP nguoi choi", "esp nguoi choi highlight")
	createToggle(visualPage, "EspEnemiesOnly", "ESP chi doi thu", "An dong doi", "esp team dong doi")
	toggleRenderers.EspEnemiesOnly(CONFIG.Esp.HideTeammates)
	createToggle(visualPage, "EspChams", "ESP Vien", "Vien va mau phu nhin xuyen tuong", "chams vien highlight esp")
	toggleRenderers.EspChams(true)
	createToggle(visualPage, "EspBox", "ESP Hop", "Khung hop quanh nguoi choi", "box hop khung esp")
	toggleRenderers.EspBox(true)
	createToggle(visualPage, "EspName", "ESP Ten", "Hien ten nguoi choi", "ten name esp")
	toggleRenderers.EspName(CONFIG.Esp.ShowName)
	createToggle(visualPage, "EspHealth", "ESP Mau", "Hien so mau va thanh mau", "mau health hp esp")
	toggleRenderers.EspHealth(CONFIG.Esp.ShowHealth)
	createToggle(visualPage, "EspDistance", "ESP Khoang cach", "Hien khoang cach", "khoang cach distance esp")
	toggleRenderers.EspDistance(CONFIG.Esp.ShowDistance)
	createToggle(visualPage, "EspTracers", "ESP Duong ke", "Vach tu day man hinh toi nguoi choi", "tracer duong ke line esp")
	toggleRenderers.EspTracers(CONFIG.Esp.ShowTracers)
	createToggle(visualPage, "EnemyEsp", "ESP Quai", "Vien quai co tag FarmableEnemy", "quai enemy npc esp")
	createToggle(visualPage, "LootEsp", "ESP Vat pham", "Vien ruong, trai ac quy theo tag", "loot vat pham ruong esp")
	createToggle(visualPage, "XRay", "X-Ray", "Nhin xuyen tuong, vat the mo di", "xray nhin xuyen tuong")
	createSlider(visualPage, "Do mo X-Ray (%)", CONFIG.XRay.MinPercent, CONFIG.XRay.MaxPercent, CONFIG.XRay.DefaultPercent, function(percent)
		setXRayTransparency(percent / 100)
	end, "xray do mo")
end

local playerDropdown, aimDropdown

do
	local aimPage = pages.Aim
	local modeLookup = { ["Tat ca moi nguoi"] = "All", ["Chi doi thu"] = "Enemies", ["Nguoi da chon"] = "Selected" }
	createToggle(aimPage, "Aim", "Aim Assist", "Khoa camera vao dau muc tieu", "aim ngam camera dau")
	createDropdown(aimPage, "Che do aim", "Chon che do...", function()
		return { "Tat ca moi nguoi", "Chi doi thu", "Nguoi da chon" }
	end, false, function(name)
		Aim.setMode(modeLookup[name])
	end, "che do aim tat ca doi thu chon")
	aimDropdown = createDropdown(aimPage, "Nguoi de aim", "Chon nguoi...", getPlayerNames, false, function(name)
		Aim.setSelectedPlayer(name)
	end, "nguoi aim chon player")
	createSlider(aimPage, "Do chat (%)", 10, 100, 100, Aim.setSmoothness, "do chat lock cung smooth")
	createSlider(aimPage, "Vung FOV aim", 20, 400, CONFIG.Aim.FieldOfView, Aim.setFieldOfView, "fov vung aim vong tron")
	createToggle(aimPage, "AimWallCheck", "Kiem tra vat can", "Khong aim xuyen tuong", "wall check vat can")
	toggleRenderers.AimWallCheck(CONFIG.Aim.WallCheck)
	createToggle(aimPage, "AimHold", "Giu chuot phai de aim", "Tat = aim lien tuc khi bat Aim", "giu chuot phai hold")
	toggleRenderers.AimHold(CONFIG.Aim.RequireHold)
end

local function spectateNextPlayer()
	local names = getPlayerNames()
	if #names == 0 then
		return false, "Khong co nguoi choi nao khac"
	end
	local current = PlayerTools.selected and PlayerTools.selected.Name
	local nextIndex = 1
	for index, name in ipairs(names) do
		if name == current then
			nextIndex = index % #names + 1
		end
	end
	selectPlayerByName(names[nextIndex])
	playerDropdown.select(names[nextIndex])
	return setFeature("Spectate", true)
end

do
	local playersPage = pages.Players
	createStatus(playersPage, "Follow", "Auto bay")
	playerDropdown = createDropdown(playersPage, "Nguoi choi", "Chon nguoi choi...", getPlayerNames, false, selectPlayerByName, "nguoi choi player chon danh sach server")
	createButton(playersPage, "Lam moi danh sach", THEME.Element, function()
		playerDropdown.refresh()
		aimDropdown.refresh()
		notify("Da lam moi danh sach nguoi choi", "success")
	end, "lam moi reset danh sach nguoi choi")
	createButton(playersPage, "Xem camera nguoi choi", THEME.Accent, function()
		reportResult("Dang xem nguoi choi", setFeature("Spectate", true))
	end, "xem camera spectate")
	createButton(playersPage, "Xem nguoi ke tiep", THEME.AccentAlt, function()
		reportResult("Dang xem nguoi ke tiep", spectateNextPlayer())
	end, "xem nguoi ke tiep next spectate")
	createButton(playersPage, "Tat xem", THEME.Element, function()
		reportResult("Da tat xem", setFeature("Spectate", false))
	end, "tat xem spectate camera")
	createButton(playersPage, "Bay den nguoi choi", THEME.AccentAlt, function()
		reportResult("Dang bay den nguoi choi", flyToSelectedPlayer())
	end, "bay den teleport nguoi choi")
	createToggle(playersPage, "FollowPlayer", "Auto bay truoc mat", "Tu bay den va dung truoc mat nguoi choi", "auto bay follow truoc mat nguoi choi")
	createButton(playersPage, "Dung bay theo", THEME.Element, function()
		reportResult("Da dung bay theo", setFeature("FollowPlayer", false))
	end, "dung stop bay theo")
	createStatus(playersPage, "Orbit", "Bay vong tron")
	createToggle(playersPage, "OrbitPlayer", "Bay vong quanh nguoi choi", "Bay tron quanh nguoi da chon nhu compa", "bay vong tron compa orbit")
	createSlider(playersPage, "Ban kinh vong", CONFIG.Orbit.Radius.Min, CONFIG.Orbit.Radius.Max, CONFIG.Orbit.Radius.Default, setOrbitRadius, "ban kinh vong orbit")
	createSlider(playersPage, "Toc do vong (do/giay)", CONFIG.Orbit.Speed.Min, CONFIG.Orbit.Speed.Max, CONFIG.Orbit.Speed.Default, setOrbitSpeed, "toc do vong orbit")
	createButton(playersPage, "Dung bay vong", THEME.Error, function()
		reportResult("Da dung bay vong", setFeature("OrbitPlayer", false))
	end, "dung stop bay vong orbit")
	createStatus(playersPage, "Hop", "Dich chuyen")
	createToggle(playersPage, "HopPlayers", "Dich chuyen toi nguoi gan nhat", "Lan luot toi tung nguoi tu gan den xa", "dich chuyen teleport hop nguoi gan nhat")
	createSlider(playersPage, "Thoi gian moi nguoi (giay)", CONFIG.Hop.Min, CONFIG.Hop.Max, CONFIG.Hop.DefaultSeconds, setHopDwell, "dich chuyen thoi gian")
	createButton(playersPage, "Dung dich chuyen", THEME.Error, function()
		reportResult("Da dung dich chuyen", setFeature("HopPlayers", false))
	end, "dung stop dich chuyen teleport")
end

mainJanitor:Add(Players.PlayerAdded:Connect(function()
	playerDropdown.refresh()
	aimDropdown.refresh()
end))
mainJanitor:Add(Players.PlayerRemoving:Connect(function()
	task.defer(function()
		if not isShutdown then
			playerDropdown.refresh()
			aimDropdown.refresh()
		end
	end)
end))

local ACTIONS = {
	{ label = "Vay tay", emote = "wave" },
	{ label = "Chi tay", emote = "point" },
	{ label = "Nhay mua 1", emote = "dance" },
	{ label = "Nhay mua 2", emote = "dance2" },
	{ label = "Nhay mua 3", emote = "dance3" },
	{ label = "Cuoi", emote = "laugh" },
	{ label = "Reo ho", emote = "cheer" },
}
local actionLookup = {}
local actionLabels = {}
for _, action in ipairs(ACTIONS) do
	actionLookup[action.label] = action.emote
	table.insert(actionLabels, action.label)
end
local selectedAction = nil

local function playSelectedAction()
	local humanoid = CharacterWatcher.humanoid
	if not selectedAction then
		return false, "Hay chon hanh dong truoc"
	end
	if not humanoid then
		return false, "Chua co nhan vat"
	end
	local ok, played = pcall(humanoid.PlayEmote, humanoid, actionLookup[selectedAction])
	if not ok or not played then
		return false, "Hanh dong khong kha dung voi nhan vat nay"
	end
	return true
end

local function jumpAction()
	local humanoid = CharacterWatcher.humanoid
	if not humanoid then
		return false, "Chua co nhan vat"
	end
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	return true
end

local function sitAction()
	local humanoid = CharacterWatcher.humanoid
	if not humanoid then
		return false, "Chua co nhan vat"
	end
	humanoid.Sit = not humanoid.Sit
	return true
end

local function useToolAction()
	local tool = getEquippedTool()
	if not tool then
		return false, "Ban chua cam vu khi nao"
	end
	tool:Activate()
	return true
end

local function resetCharacterAction()
	local character = CharacterWatcher.character
	if not character then
		return false, "Chua co nhan vat"
	end
	character:BreakJoints()
	return true
end

local function sendWelcomeChat()
	local message = CONFIG.AutoChat.Message
	local ok, errorMessage = pcall(function()
		local channels = TextChatService:FindFirstChild("TextChannels")
		local general = channels and channels:FindFirstChild("RBXGeneral")
		if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService and general then
			general:SendAsync(message)
			return
		end
		local events = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		local sayRequest = events and events:FindFirstChild("SayMessageRequest")
		if not sayRequest then
			error("Khong tim thay he thong chat")
		end
		sayRequest:FireServer(message, "All")
	end)
	if ok then
		return true
	end
	warn(string.format("[%s] Khong gui duoc tin nhan chat: %s", CONFIG.Name, tostring(errorMessage)))
	return false, "Khong gui duoc tin nhan chat"
end

do
	local actionsPage = pages.Actions
	createDropdown(actionsPage, "Hanh dong", "Chon hanh dong...", function()
		return table.clone(actionLabels)
	end, false, function(name)
		selectedAction = name
	end, "hanh dong emote action")
	createButton(actionsPage, "Dung hanh dong", THEME.Accent, function()
		reportResult("Dang thuc hien hanh dong", playSelectedAction())
	end, "dung hanh dong emote")
	createButton(actionsPage, "Nhay", THEME.Element, function()
		reportResult("Da nhay", jumpAction())
	end, "nhay jump")
	createButton(actionsPage, "Ngoi / Dung day", THEME.Element, function()
		reportResult("Da doi tu the ngoi", sitAction())
	end, "ngoi sit dung day")
	createButton(actionsPage, "Dung vu khi dang cam", THEME.AccentAlt, function()
		reportResult("Da dung vu khi", useToolAction())
	end, "dung vu khi tool activate")
	createButton(actionsPage, "Gui loi chao vao chat", THEME.Element, function()
		reportResult("Da gui loi chao", sendWelcomeChat())
	end, "chat loi chao welcome")
	createButton(actionsPage, "Reset nhan vat", THEME.Error, function()
		reportResult("Da reset nhan vat", resetCharacterAction())
	end, "reset nhan vat respawn")
end

local linkBox

local function selectLinkText()
	linkBox:CaptureFocus()
	linkBox.CursorPosition = #linkBox.Text + 1
	linkBox.SelectionStart = 1
end

local function openTelegram()
	local ok, errorMessage = pcall(GuiService.OpenBrowserWindow, GuiService, CONFIG.TelegramUrl)
	if ok then
		notify("Dang mo Telegram...", "success")
		return
	end
	warn(string.format("[%s] Khong the tu mo link: %s", CONFIG.Name, tostring(errorMessage)))
	selectLinkText()
	notify("Khong mo duoc link. Da chon san link, nhan Ctrl+C de sao chep", "warn")
end

do
	local aboutPage = pages.About
	createCard(aboutPage, CONFIG.Name .. " " .. CONFIG.Version, "Dev: " .. CONFIG.Developer .. "\nTelegram: " .. CONFIG.TelegramHandle)
	createButton(aboutPage, "Mo Telegram " .. CONFIG.TelegramHandle, THEME.AccentAlt, openTelegram, "telegram lien he dev")
	local linkRow = createRow(aboutPage, 36)
	linkBox = create("TextBox", {
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(8, 0),
		BackgroundTransparency = 1,
		Text = CONFIG.TelegramUrl,
		TextColor3 = THEME.AccentAlt,
		Font = THEME.Font,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, linkRow)
	linkBox.FocusLost:Connect(function()
		linkBox.Text = CONFIG.TelegramUrl
	end)
	registerSearchable(linkRow, aboutPage, "telegram link")
	createCard(aboutPage, "Gioi thieu", "MinhDiemHub la bo tien ich chay hoan toan phia client cho trai nghiem do ban so huu. Giao dien den kieu terminal, ho tro PC va dien thoai. Khong goi mang, khong tai ma ben ngoai.")
	createCard(aboutPage, "Huong dan su dung", table.concat({
		"1. Bam nut qua tao hoac phim " .. CONFIG.MenuToggleKey.Name .. " de mo/dong menu. Keo thanh tieu de de di chuyen.",
		"2. Nut - thu gon menu, nut x an menu (chuc nang van chay).",
		"3. O tim kiem loc nhanh chuc nang o moi tab.",
		"4. Speed Walk / High Jump / Fly: bat cong tac roi keo thanh truot. Fly: Space bay len, Q bay xuong, dung yen khi khong di chuyen.",
		"5. Bat tu: chi chan o phia client. Neu server tru mau thi van co the chet. Hieu ung chay chi la hinh anh.",
		"6. Auto Farm: chon loai quai roi bat. Quai can tag " .. CONFIG.Farm.EnemyTag .. " hoac nam trong thu muc " .. CONFIG.Farm.FallbackFolderName .. " o Workspace.",
		"7. Auto Loot: chon mot hoac nhieu loai roi bat. Can vat pham co ProximityPrompt hoac noi ham collectLoot.",
		"8. Auto danh gan nhat: tu danh muc tieu trong tam chon (mac dinh 3m). Mac dinh dung vu khi dang cam, hoac noi ham attackTarget.",
		"9. ESP: bat rieng tung loai (Vien, Hop, Ten, Mau, Khoang cach, Duong ke, Quai, Vat pham).",
		"10. Aim: chon che do (tat ca, chi doi thu, nguoi da chon). Giu chuot phai de aim tren PC, mobile tu ho tro. Do chat 100% la khoa cung vao dau.",
		"11. Tab Nguoi choi: chon nguoi, xem camera / tat xem / xem nguoi ke tiep, bay den, bay truoc mat, bay vong tron nhu compa, dich chuyen tuan tu.",
		"12. Tab Hanh dong: dung emote, nhay, ngoi, dung vu khi, reset nhan vat, gui loi chao vao chat.",
		"13. Nut TAT TAT CA CHUC NANG (hoac phim " .. CONFIG.PanicKey.Name .. ") tat moi chuc nang va khoi phuc trang thai.",
		"14. Fix Lag: bat de giam do hoa, tat de tra lai nhu cu.",
	}, "\n"))
	createButton(aboutPage, "Go MinhDiemHub (khoi phuc moi thu)", THEME.Error, function()
		mainJanitor:Clean()
	end, "go tat hoan toan")
end

local LAUNCHER_COLOR = Color3.fromRGB(0, 0, 0)

local function createIconPiece(icon, size, position, color, rotation, transparency)
	local piece = create("Frame", {
		Size = UDim2.fromOffset(size.X, size.Y),
		Position = UDim2.fromOffset(position.X, position.Y),
		BackgroundColor3 = color,
		BackgroundTransparency = transparency or 0,
		BorderSizePixel = 0,
		Rotation = rotation or 0,
		Active = false,
	}, icon)
	create("UICorner", { CornerRadius = UDim.new(0.5, 0) }, piece)
	return piece
end

local function buildAppleIcon(parent, backgroundColor)
	local icon = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.56),
		Size = UDim2.fromOffset(30, 30),
		BackgroundTransparency = 1,
		Active = false,
	}, parent)
	local red = Color3.fromRGB(226, 40, 52)
	local darkRed = Color3.fromRGB(150, 18, 32)
	createIconPiece(icon, Vector2.new(15, 16), Vector2.new(2, 9), red)
	createIconPiece(icon, Vector2.new(15, 16), Vector2.new(13, 9), red)
	createIconPiece(icon, Vector2.new(19, 15), Vector2.new(5, 13), red)
	createIconPiece(icon, Vector2.new(13, 9), Vector2.new(13, 18), darkRed, 0, 0.55)
	createIconPiece(icon, Vector2.new(6, 6), Vector2.new(12, 7), backgroundColor)
	createIconPiece(icon, Vector2.new(4, 8), Vector2.new(6, 12), Color3.fromRGB(255, 160, 160), 20, 0.3)
	createIconPiece(icon, Vector2.new(3, 8), Vector2.new(14, 2), Color3.fromRGB(112, 72, 40), 12)
	createIconPiece(icon, Vector2.new(11, 6), Vector2.new(16, 2), Color3.fromRGB(70, 205, 95), -35)
	return icon
end

local launcher = create("TextButton", {
	Name = "Launcher",
	Size = UDim2.fromOffset(46, 46),
	Position = UDim2.new(0, 12, 0.5, -23),
	BackgroundColor3 = LAUNCHER_COLOR,
	Text = "",
	AutoButtonColor = false,
	BorderSizePixel = 0,
}, screenGui)
addCorner(launcher, 4)
addStroke(launcher, THEME.Accent, 1)
buildAppleIcon(launcher, LAUNCHER_COLOR)

local collapsed = false

local function toggleMenu()
	main.Visible = not main.Visible
end

local function toggleCollapse()
	collapsed = not collapsed
	body.Visible = not collapsed
	local height = collapsed and (HEADER_HEIGHT + 1) or menuHeight
	TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), { Size = UDim2.fromOffset(menuWidth, height) }):Play()
end

launcher.Activated:Connect(toggleMenu)
closeButton.Activated:Connect(function()
	main.Visible = false
end)
minimizeButton.Activated:Connect(toggleCollapse)

local function clampMenuPosition(x, y)
	local bounds = screenGui.AbsoluteSize
	local size = main.AbsoluteSize
	return math.clamp(x, 0, math.max(bounds.X - size.X, 0)), math.clamp(y, 0, math.max(bounds.Y - HEADER_HEIGHT, 0))
end

header.InputBegan:Connect(function(input)
	local inputType = input.UserInputType
	if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
		return
	end
	local startPointer = input.Position
	local startPosition = main.AbsolutePosition
	dragState.handler = function(moved)
		local delta = moved.Position - startPointer
		local x, y = clampMenuPosition(startPosition.X + delta.X, startPosition.Y + delta.Y)
		main.Position = UDim2.fromOffset(x, y)
	end
end)

local function endDrag()
	dragState.handler = nil
	if dragState.scrollFrame then
		dragState.scrollFrame.ScrollingEnabled = true
		dragState.scrollFrame = nil
	end
end

mainJanitor:Add(UserInputService.InputChanged:Connect(function(input)
	local handler = dragState.handler
	local inputType = input.UserInputType
	if handler and (inputType == Enum.UserInputType.MouseMovement or inputType == Enum.UserInputType.Touch) then
		handler(input)
	end
end))

mainJanitor:Add(UserInputService.InputEnded:Connect(function(input)
	local inputType = input.UserInputType
	if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
		endDrag()
	end
end))

mainJanitor:Add(UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end
	if input.KeyCode == CONFIG.MenuToggleKey then
		toggleMenu()
	elseif input.KeyCode == CONFIG.PanicKey then
		disableAllFeatures()
	end
end))

local statusClock, statusFrames = 0, 0
mainJanitor:Add(RunService.Heartbeat:Connect(function(deltaTime)
	statusFrames += 1
	statusClock += deltaTime
	if statusClock < 0.5 then
		return
	end
	local fps = math.floor(statusFrames / statusClock + 0.5)
	local ping = math.floor(localPlayer:GetNetworkPing() * 1000 + 0.5)
	statusLabel.Text = string.format("FPS %d | PING %dms | PLAYERS %d", fps, ping, #Players:GetPlayers())
	statusClock, statusFrames = 0, 0
end))

mainJanitor:Add(function()
	if PlayerTools.tween then
		PlayerTools.tween:Cancel()
		PlayerTools.tween = nil
	end
end)

mainJanitor:Add(Players.PlayerRemoving:Connect(function(leaving)
	if leaving == PlayerTools.selected then
		PlayerTools.selected = nil
	end
end))

mainJanitor:Add(localPlayer.CharacterAdded:Connect(handleCharacterAdded))
mainJanitor:Add(localPlayer.CharacterRemoving:Connect(handleCharacterRemoving))
if localPlayer.Character then
	task.spawn(handleCharacterAdded, localPlayer.Character)
end

local function shutdown()
	if isShutdown then
		return
	end
	isShutdown = true
	for _, key in ipairs(ALL_FEATURE_KEYS) do
		featureHandlers[key](false)
	end
	mainJanitor:Clean()
	if screenGui.Parent then
		screenGui:Destroy()
	end
end

mainJanitor:Add(function()
	shutdown()
end)
screenGui.Destroying:Connect(shutdown)

selectTab("Features")
setFeature("AntiAfk", true)
notify(CONFIG.Name .. " " .. CONFIG.Version .. " da san sang", "success")
if CONFIG.AutoChat.Enabled then
	mainJanitor:Add(task.delay(CONFIG.AutoChat.DelaySeconds, function()
		local ok, reason = sendWelcomeChat()
		if not ok then
			notify(reason, "warn")
		end
	end))
end
end
