local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local GuiService = game:GetService("GuiService")
local VirtualUser = game:GetService("VirtualUser")

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
		Smoothness = 0.35,
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
	Background = Color3.fromRGB(6, 6, 8),
	Panel = Color3.fromRGB(13, 13, 16),
	Element = Color3.fromRGB(19, 19, 23),
	Stroke = Color3.fromRGB(38, 38, 46),
	Accent = Color3.fromRGB(110, 99, 255),
	AccentAlt = Color3.fromRGB(64, 156, 255),
	Text = Color3.fromRGB(236, 238, 247),
	TextDim = Color3.fromRGB(141, 147, 168),
	Success = Color3.fromRGB(52, 211, 153),
	Error = Color3.fromRGB(248, 113, 113),
	Warn = Color3.fromRGB(251, 191, 36),
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
}

local GUI_NAME = "MinhDiemHub"
local ESP_FOLDER_NAME = "MinhDiemHubEsp"
local AIM_BIND_NAME = "MinhDiemHubAim"

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

for _, name in ipairs({ GUI_NAME, ESP_FOLDER_NAME }) do
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
	return create("UICorner", { CornerRadius = UDim.new(0, radius) }, instance)
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

local Noclip = {
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

local LightingControl = {
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

local FixLag = {
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

local function isProtectedFromFixLag(instance)
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

local WalkSpeed = {
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

local function handleWalkSpeedOverride(humanoid)
	local now = os.clock()
	if now - WalkSpeed.windowStart > 2 then
		WalkSpeed.windowStart = now
		WalkSpeed.windowCount = 0
	end
	WalkSpeed.windowCount += 1
	if now - WalkSpeed.lastWarning > 10 then
		WalkSpeed.lastWarning = now
		notify("Server đang ghi đè WalkSpeed của bạn", "warn")
	end
	if WalkSpeed.windowCount <= 5 then
		writeWalkSpeed(humanoid)
	end
end

local function watchWalkSpeed(humanoid)
	WalkSpeed.watcher:Clean()
	WalkSpeed.original = humanoid.WalkSpeed
	writeWalkSpeed(humanoid)
	WalkSpeed.watcher:Add(humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if WalkSpeed.enabled and humanoid.WalkSpeed ~= WalkSpeed.value then
			handleWalkSpeedOverride(humanoid)
		end
	end))
end

local function setWalkSpeedValue(value)
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

local HighJump = { enabled = false, value = CONFIG.Jump.Default, original = nil }

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

local function setJumpValue(value)
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

local InfiniteJump = { janitor = Janitor.new() }

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

local PlayerTools = { selected = nil, tween = nil }

local function getEquippedTool()
	local character = CharacterWatcher.character
	return character and character:FindFirstChildOfClass("Tool")
end

local function attackTarget(target)
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
}

local function collectLoot(item)
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

local function getEnemyTypes()
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
	Noclip.request("Auto" .. mode)
	Automation.connection = RunService.Heartbeat:Connect(onAutomationStep)
end

local function setEnemyType(name)
	Automation.enemyType = name
	if Automation.mode == "Farm" then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
end

local function setLootTags(selection)
	Automation.lootTags = selection
	if Automation.mode == "Loot" then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
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
	setFeature("AutoLoot", false)
	setFeature("Fly", false)
	setFeature("FollowPlayer", false)
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
	setFeature("AutoFarm", false)
	setFeature("Fly", false)
	setFeature("FollowPlayer", false)
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
	setFeature("AutoFarm", false)
	setFeature("AutoLoot", false)
	setFeature("Fly", false)
	startAutomation("Follow")
	return true
end

local function selectPlayerByName(name)
	PlayerTools.selected = Players:FindFirstChild(name)
	if Automation.mode == "Follow" then
		clearTarget()
		Automation.searchClock = CONFIG.SearchInterval
	end
end

local function getPlayerNames()
	local names = {}
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer then
			table.insert(names, player.Name)
		end
	end
	table.sort(names)
	return names
end

local function setAttackRate(rate)
	Automation.attackInterval = 1 / rate
end

local function flyToSelectedPlayer()
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

local Spectate = { enabled = false, janitor = Janitor.new() }

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

local AutoClick = {
	rate = CONFIG.AutoClick.Default,
	clock = 0,
	noticed = false,
	janitor = Janitor.new(),
}

local function setClickRate(rate)
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

local Esp = {
	enabled = false,
	hideTeammates = CONFIG.Esp.HideTeammates,
	entries = {},
	trackers = {},
	folder = nil,
	showTracers = CONFIG.Esp.ShowTracers,
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
	return gui, nameLabel, infoLabel, barFill
end

local function buildEspInfoText(entry, healthFraction, distance)
	local parts = {}
	if CONFIG.Esp.ShowHealth then
		table.insert(parts, string.format("HP %d", math.floor(entry.humanoid.Health + 0.5)))
	end
	if CONFIG.Esp.ShowDistance and distance then
		table.insert(parts, string.format("%dm", math.floor(distance + 0.5)))
	end
	return table.concat(parts, " | ")
end

local function updateEspEntry(entry)
	local humanoid, root = entry.humanoid, entry.root
	if not humanoid.Parent or not root.Parent then
		return
	end
	local teammate = isTeammate(entry.player)
	local visible = not (teammate and Esp.hideTeammates)
	entry.highlight.Enabled = visible
	entry.gui.Enabled = visible
	entry.visible = visible
	if not visible then
		return
	end
	local color = teammate and CONFIG.Esp.TeamColor or CONFIG.Esp.EnemyColor
	entry.color = color
	entry.highlight.FillColor = color
	entry.highlight.OutlineColor = color
	local fraction = math.clamp(humanoid.Health / math.max(humanoid.MaxHealth, 1), 0, 1)
	local localRoot = CharacterWatcher.root
	local distance = localRoot and (root.Position - localRoot.Position).Magnitude or nil
	entry.nameLabel.Text = CONFIG.Esp.ShowName and entry.player.DisplayName or ""
	entry.nameLabel.TextColor3 = color
	entry.infoLabel.Text = buildEspInfoText(entry, fraction, distance)
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
	local gui, nameLabel, infoLabel, barFill = buildEspBillboard(character:FindFirstChild("Head") or root, player.Name)
	local entry = {
		player = player,
		humanoid = humanoid,
		root = root,
		highlight = highlight,
		gui = gui,
		nameLabel = nameLabel,
		infoLabel = infoLabel,
		barFill = barFill,
	}
	entry.tracer = create("Frame", {
		Name = player.Name,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = CONFIG.Esp.EnemyColor,
		BorderSizePixel = 0,
		Visible = false,
		Active = false,
	}, Esp.tracerLayer)
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
	if not entry.visible or not entry.root.Parent then
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
	if camera and Esp.showTracers then
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
	Esp.folder = create("Folder", { Name = ESP_FOLDER_NAME }, playerGui)
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

featureHandlers.EspEnemiesOnly = function(enabled)
	Esp.hideTeammates = enabled
	for _, entry in pairs(Esp.entries) do
		updateEspEntry(entry)
	end
	return true
end

featureHandlers.EspTracers = function(enabled)
	Esp.showTracers = enabled
	if not enabled then
		for _, entry in pairs(Esp.entries) do
			entry.tracer.Visible = false
		end
	end
	return true
end

local Fly = {
	enabled = false,
	speed = CONFIG.Fly.Default,
	janitor = Janitor.new(),
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
	local root, humanoid = CharacterWatcher.root, CharacterWatcher.humanoid
	local camera = workspace.CurrentCamera
	if not root or not humanoid or not camera or humanoid.Health <= 0 then
		return
	end
	local direction = readFlyDirection(camera, humanoid)
	if direction.Magnitude > 1 then
		direction = direction.Unit
	end
	root.AssemblyLinearVelocity = direction * Fly.speed
	root.AssemblyAngularVelocity = Vector3.zero
end

local function applyFlyState(humanoid)
	Fly.platformStandOriginal = humanoid.PlatformStand
	humanoid.PlatformStand = true
end

local function restoreFlyState(humanoid)
	humanoid.PlatformStand = Fly.platformStandOriginal or false
	Fly.platformStandOriginal = nil
end

local function setFlySpeed(value)
	Fly.speed = value
end

featureHandlers.Fly = function(enabled)
	if Fly.enabled == enabled then
		return true
	end
	local humanoid, root = CharacterWatcher.humanoid, CharacterWatcher.root
	if enabled then
		setFeature("AutoFarm", false)
		setFeature("AutoLoot", false)
		setFeature("FollowPlayer", false)
		Fly.enabled = true
		if humanoid then
			applyFlyState(humanoid)
		end
		Fly.janitor:Add(RunService.Heartbeat:Connect(onFlyStep))
	else
		Fly.enabled = false
		Fly.janitor:Clean()
		if humanoid then
			restoreFlyState(humanoid)
		end
		if root then
			root.AssemblyLinearVelocity = Vector3.zero
		end
	end
	return true
end

CharacterWatcher.subscribe(function(_, humanoid)
	if Fly.enabled then
		applyFlyState(humanoid)
	end
end, function()
	Fly.platformStandOriginal = nil
end)

local XRay = {
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

local function setXRayTransparency(fraction)
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

local AntiAfk = { janitor = Janitor.new() }

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

local Aim = {
	enabled = false,
	holding = false,
	janitor = Janitor.new(),
	raycastParams = RaycastParams.new(),
}
Aim.raycastParams.FilterType = Enum.RaycastFilterType.Exclude
Aim.raycastParams.RespectCanCollide = true

local isTouchOnly = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local function getAimPart(player)
	if player == localPlayer then
		return nil
	end
	if CONFIG.Aim.TeamCheck and isTeammate(player) then
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
	if not CONFIG.Aim.WallCheck then
		return true
	end
	Aim.raycastParams.FilterDescendantsInstances = { CharacterWatcher.character or workspace.Terrain }
	local origin = camera.CFrame.Position
	local result = workspace:Raycast(origin, part.Position - origin, Aim.raycastParams)
	return result == nil or result.Instance:IsDescendantOf(part.Parent)
end

local function findAimTarget(camera)
	local center = camera.ViewportSize / 2
	local bestPart, bestOffset = nil, CONFIG.Aim.FieldOfView
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

local function onAimStep()
	local camera = workspace.CurrentCamera
	if not camera then
		return
	end
	if CONFIG.Aim.RequireHold and not Aim.holding and not isTouchOnly then
		return
	end
	local part = findAimTarget(camera)
	if part then
		local goal = CFrame.lookAt(camera.CFrame.Position, part.Position)
		camera.CFrame = camera.CFrame:Lerp(goal, CONFIG.Aim.Smoothness)
	end
end

local function createAimCircle()
	local circle = create("Frame", {
		Name = "AimFov",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(CONFIG.Aim.FieldOfView * 2, CONFIG.Aim.FieldOfView * 2),
		BackgroundTransparency = 1,
		Active = false,
	}, screenGui)
	addCorner(circle, CONFIG.Aim.FieldOfView)
	addStroke(circle, THEME.Accent, 1.5)
	return circle
end

local function enableAim()
	Aim.enabled = true
	Aim.janitor:Add(createAimCircle())
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
	Aim.janitor:Clean()
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
		TextColor3 = Color3.new(1, 1, 1),
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
			TextColor3 = THEME.Text,
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
local menuWidth = math.min(350, viewport.X - 24)
local menuHeight = math.min(440, viewport.Y - 24)
local HEADER_HEIGHT = 44

local main = create("Frame", {
	Name = "Main",
	Size = UDim2.fromOffset(menuWidth, menuHeight),
	Position = UDim2.fromOffset(70, math.max(12, (viewport.Y - menuHeight) / 2)),
	BackgroundColor3 = THEME.Background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, screenGui)
addCorner(main, 12)
addStroke(main, THEME.Stroke, 1)

local header = create("Frame", {
	Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
	BackgroundColor3 = THEME.Panel,
	BorderSizePixel = 0,
	Active = true,
}, main)
local accentLine = create("Frame", {
	Position = UDim2.fromOffset(0, HEADER_HEIGHT),
	Size = UDim2.new(1, 0, 0, 2),
	BackgroundColor3 = THEME.Accent,
	BorderSizePixel = 0,
}, main)
create("UIGradient", { Color = ColorSequence.new(THEME.Accent, THEME.AccentAlt) }, accentLine)

local titleLabel = createLabel(header, CONFIG.Name, 16, THEME.Text, Enum.Font.GothamBlack)
titleLabel.Position = UDim2.fromOffset(14, 0)
titleLabel.Size = UDim2.new(0, 130, 1, 0)
local versionBadge = create("TextLabel", {
	Position = UDim2.fromOffset(14 + 128, 12),
	Size = UDim2.fromOffset(34, 20),
	BackgroundColor3 = THEME.Accent,
	Text = CONFIG.Version,
	TextColor3 = Color3.new(1, 1, 1),
	Font = THEME.FontBold,
	TextSize = 11,
	BorderSizePixel = 0,
}, header)
addCorner(versionBadge, 10)

local function createHeaderButton(text, offset, color)
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, offset, 0.5, 0),
		Size = UDim2.fromOffset(28, 28),
		BackgroundColor3 = color,
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		Font = THEME.FontBold,
		TextSize = 16,
		AutoButtonColor = true,
		BorderSizePixel = 0,
	}, header)
	addCorner(button, 8)
	return button
end

local minimizeButton = createHeaderButton("–", -48, THEME.Element)
local closeButton = createHeaderButton("×", -12, THEME.Error)

local body = create("Frame", {
	Position = UDim2.fromOffset(0, HEADER_HEIGHT + 2),
	Size = UDim2.new(1, 0, 1, -(HEADER_HEIGHT + 2)),
	BackgroundTransparency = 1,
}, main)

local tabBar = create("Frame", {
	Position = UDim2.fromOffset(8, 8),
	Size = UDim2.new(1, -16, 0, 34),
	BackgroundColor3 = THEME.Panel,
	BorderSizePixel = 0,
}, body)
addCorner(tabBar, 8)
addPadding(tabBar, 4)
create("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, tabBar)

local searchBox = create("TextBox", {
	Position = UDim2.fromOffset(8, 48),
	Size = UDim2.new(1, -16, 0, 30),
	BackgroundColor3 = THEME.Panel,
	PlaceholderText = "Tìm kiếm chức năng...",
	PlaceholderColor3 = THEME.TextDim,
	Text = "",
	TextColor3 = THEME.Text,
	Font = THEME.Font,
	TextSize = 12,
	ClearTextOnFocus = false,
	TextXAlignment = Enum.TextXAlignment.Left,
	BorderSizePixel = 0,
}, body)
addCorner(searchBox, 8)
addStroke(searchBox, THEME.Stroke, 1)
create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, searchBox)

local pageHolder = create("Frame", {
	Position = UDim2.fromOffset(8, 86),
	Size = UDim2.new(1, -16, 1, -94),
	BackgroundTransparency = 1,
}, body)

notifyContainer = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 56),
	Size = UDim2.fromOffset(280, 200),
	BackgroundTransparency = 1,
	ZIndex = 50,
}, screenGui)
create("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Top,
}, notifyContainer)

local tabButtons = {}
local TAB_DEFINITIONS = {
	{ key = "Features", label = "Chức năng" },
	{ key = "Auto", label = "Tự động" },
	{ key = "Visual", label = "Hiển thị" },
	{ key = "Players", label = "Người chơi" },
	{ key = "About", label = "Giới thiệu" },
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
		button.BackgroundColor3 = isActive and THEME.Accent or THEME.Panel
		button.TextColor3 = isActive and Color3.new(1, 1, 1) or THEME.TextDim
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
		Size = UDim2.new(0.2, -4, 1, 0),
		BackgroundColor3 = THEME.Panel,
		Text = definition.label,
		TextColor3 = THEME.TextDim,
		Font = THEME.FontBold,
		TextSize = 10,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		LayoutOrder = index,
	}, tabBar)
	addCorner(button, 6)
	button.Activated:Connect(function()
		selectTab(definition.key)
	end)
	tabButtons[definition.key] = button
end
searchPage = createPage(pageHolder)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	applySearch(searchBox.Text)
end)

local featuresPage = pages.Features
createToggle(featuresPage, "WalkSpeed", "Speed Walk", "Chạy nhanh", "speed walk chạy nhanh tốc độ walkspeed")
createSlider(featuresPage, "Tốc độ chạy", CONFIG.WalkSpeed.Min, CONFIG.WalkSpeed.Max, CONFIG.WalkSpeed.Default, setWalkSpeedValue, "speed walkspeed chạy")
createToggle(featuresPage, "HighJump", "High Jump", "Nhảy cao", "jump nhảy cao jumppower jumpheight")
createSlider(featuresPage, "Độ cao nhảy", CONFIG.Jump.Min, CONFIG.Jump.Max, CONFIG.Jump.Default, setJumpValue, "jump nhảy")
createToggle(featuresPage, "InfiniteJump", "Infinite Jump", "Nhảy liên tục trên không", "nhảy liên tục infinite jump")
createToggle(featuresPage, "Fly", "Fly", "Bay theo hướng camera (Space lên, Q xuống)", "bay fly camera")
createSlider(featuresPage, "Tốc độ bay", CONFIG.Fly.Min, CONFIG.Fly.Max, CONFIG.Fly.Default, setFlySpeed, "bay fly speed tốc độ")
createToggle(featuresPage, "Noclip", "Noclip", "Đi xuyên vật cản", "noclip xuyên tường")
createToggle(featuresPage, "FullBright", "Full Bright", "Sáng bản đồ, bật/tắt khôi phục", "sáng fullbright ánh sáng")
createToggle(featuresPage, "FixLag", "Fix Lag", "Giảm đồ họa, tắt để khôi phục", "lag giảm đồ họa fps")
createToggle(featuresPage, "AntiAfk", "Anti AFK", "Không bị kick khi đứng yên (mặc định bật)", "afk idle kick đứng yên")

local autoPage = pages.Auto
createStatus(autoPage, "Farm", "Auto Farm")
createDropdown(autoPage, "Loại quái", "Chọn quái...", getEnemyTypes, false, setEnemyType, "quái enemy farm")
createToggle(autoPage, "AutoFarm", "Auto Farm", "Bay trên đầu quái gần nhất", "farm quái tự động")
createStatus(autoPage, "Loot", "Auto Loot")
createDropdown(autoPage, "Loại loot", "Chọn loot...", function()
	return table.clone(CONFIG.Loot.Tags)
end, true, setLootTags, "loot rương trái ác quỷ nhặt đồ")
createToggle(autoPage, "AutoLoot", "Auto Loot", "Tự động đến vật phẩm gần nhất", "loot nhặt tự động")

local visualPage = pages.Visual
createToggle(visualPage, "Esp", "Player ESP", "Tên, máu, khoảng cách, viền", "esp người chơi highlight")
createToggle(visualPage, "EspEnemiesOnly", "ESP chỉ đối thủ", "Ẩn đồng đội", "esp team đồng đội")
toggleRenderers.EspEnemiesOnly(CONFIG.Esp.HideTeammates)
createToggle(visualPage, "EspTracers", "ESP Đường kẻ", "Vạch từ đáy màn hình tới người chơi", "tracer đường kẻ line esp")
toggleRenderers.EspTracers(CONFIG.Esp.ShowTracers)
createToggle(visualPage, "Aim", "Aim Assist", "Giữ chuột phải (PC) / tự động (mobile)", "aim ngắm camera")
createToggle(visualPage, "XRay", "X-Ray", "Nhìn xuyên tường, vật thể mờ đi", "xray nhìn xuyên tường")
createSlider(visualPage, "Độ mờ X-Ray (%)", CONFIG.XRay.MinPercent, CONFIG.XRay.MaxPercent, CONFIG.XRay.DefaultPercent, function(percent)
	setXRayTransparency(percent / 100)
end, "xray độ mờ")

local function reportResult(successMessage, accepted, reason)
	if accepted then
		notify(successMessage, "success")
	else
		notify(reason or "Không thực hiện được", "error")
	end
end

local playersPage = pages.Players
createStatus(playersPage, "Follow", "Auto bay")
createDropdown(playersPage, "Người chơi", "Chọn người chơi...", getPlayerNames, false, selectPlayerByName, "người chơi player chọn danh sách server")
createButton(playersPage, "Xem camera người chơi", THEME.Accent, function()
	reportResult("Đang xem người chơi", setFeature("Spectate", true))
end, "xem camera spectate")
createButton(playersPage, "Tắt xem", THEME.Element, function()
	reportResult("Đã tắt xem", setFeature("Spectate", false))
end, "tắt xem spectate camera")
createButton(playersPage, "Bay đến người chơi", THEME.AccentAlt, function()
	reportResult("Đang bay đến người chơi", flyToSelectedPlayer())
end, "bay đến teleport người chơi")
createToggle(playersPage, "FollowPlayer", "Auto bay trước mặt", "Tự bay đến và đứng trước mặt người chơi", "auto bay follow trước mặt người chơi")
createSlider(playersPage, "Tốc độ đánh (lần/giây)", CONFIG.AttackRate.Min, CONFIG.AttackRate.Max, CONFIG.AttackRate.Default, setAttackRate, "attack nhanh tốc độ đánh")
setAttackRate(CONFIG.AttackRate.Default)
createToggle(playersPage, "AutoClick", "Auto Click", "Tự kích hoạt vũ khí đang cầm", "auto click đánh nhanh")
createSlider(playersPage, "Tốc độ click (lần/giây)", CONFIG.AutoClick.Min, CONFIG.AutoClick.Max, CONFIG.AutoClick.Default, setClickRate, "click tốc độ")

local aboutPage = pages.About
createCard(aboutPage, CONFIG.Name .. " " .. CONFIG.Version, "Dev: " .. CONFIG.Developer .. "\nTelegram: " .. CONFIG.TelegramHandle)

local function openTelegram()
	local ok, errorMessage = pcall(GuiService.OpenBrowserWindow, GuiService, CONFIG.TelegramUrl)
	if ok then
		notify("Đang mở Telegram...", "success")
	else
		warn(string.format("[%s] Không thể tự mở link: %s", CONFIG.Name, tostring(errorMessage)))
		notify("Roblox không cho tự mở link. Hãy sao chép link bên dưới", "warn")
	end
end

createButton(aboutPage, "Mở Telegram " .. CONFIG.TelegramHandle, THEME.AccentAlt, openTelegram, "telegram liên hệ dev")

local linkRow = createRow(aboutPage, 36)
local linkBox = create("TextBox", {
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

createCard(aboutPage, "Giới thiệu", "MinhDiemHub là bộ tiện ích chạy hoàn toàn phía client cho trải nghiệm do bạn sở hữu. Giao diện tối, gọn nhẹ, hỗ trợ PC và điện thoại. Không gọi mạng, không tải mã bên ngoài.")
createCard(aboutPage, "Hướng dẫn sử dụng", table.concat({
	"1. Bấm nút M hoặc phím " .. CONFIG.MenuToggleKey.Name .. " để mở/đóng menu. Kéo thanh tiêu đề để di chuyển.",
	"2. Nút – thu gọn menu, nút × ẩn menu (chức năng vẫn chạy).",
	"3. Ô Tìm kiếm giúp lọc nhanh chức năng ở mọi tab.",
	"4. Speed Walk / High Jump: bật công tắc rồi kéo thanh trượt hoặc nhập số.",
	"5. Auto Farm: chọn loại quái rồi bật. Quái cần tag " .. CONFIG.Farm.EnemyTag .. " hoặc nằm trong thư mục " .. CONFIG.Farm.FallbackFolderName .. " ở Workspace. Cần nối hàm attackTarget.",
	"6. Auto Loot: chọn một hoặc nhiều loại rồi bật. Cần nối hàm collectLoot hoặc vật phẩm có ProximityPrompt.",
	"7. Auto Farm và Auto Loot không chạy cùng lúc.",
	"8. ESP hiện tên, máu, khoảng cách. Aim Assist: giữ chuột phải (PC), mobile tự hỗ trợ khi bật.",
	"9. Fix Lag: bật để giảm đồ họa, tắt để trả lại như cũ.",
	"10. Fly: bật rồi đẩy joystick/WASD, bạn bay theo hướng camera. Space bay lên, Q bay xuống. Chỉnh tốc độ bằng thanh trượt.",
	"11. X-Ray: làm vật thể trong map mờ đi để nhìn xuyên, chỉnh độ mờ bằng thanh trượt.",
	"12. ESP Đường kẻ: vạch từ đáy màn hình tới từng người chơi.",
	"13. Anti AFK mặc định bật, chỉ giúp không bị kick vì đứng yên quá lâu.",
	"14. Tab Người chơi: chọn người trong server rồi bấm Xem camera / Tắt xem, hoặc Bay đến để bay ra trước mặt họ.",
	"15. Auto bay trước mặt: tự bay theo người đã chọn (không chọn thì lấy người gần nhất, bỏ qua đồng đội) và đứng trước mặt họ.",
	"16. Tốc độ đánh gọi attackTarget, mặc định kích hoạt vũ khí đang cầm. Auto Click cũng kích hoạt vũ khí đang cầm theo tốc độ bạn chọn.",
}, "\n"))
createButton(aboutPage, "Gỡ MinhDiemHub (khôi phục mọi thứ)", THEME.Error, function()
	mainJanitor:Clean()
end, "gỡ tắt hoàn toàn")

local LAUNCHER_COLOR = Color3.fromRGB(0, 0, 0)

local function createIconPiece(icon, size, position, color, rotation)
	local piece = create("Frame", {
		Size = UDim2.fromOffset(size.X, size.Y),
		Position = UDim2.fromOffset(position.X, position.Y),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Rotation = rotation or 0,
		Active = false,
	}, icon)
	addCorner(piece, 100)
	return piece
end

local function buildAppleIcon(parent, backgroundColor)
	local icon = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.55),
		Size = UDim2.fromOffset(28, 28),
		BackgroundTransparency = 1,
		Active = false,
	}, parent)
	local white = Color3.new(1, 1, 1)
	createIconPiece(icon, Vector2.new(15, 15), Vector2.new(2, 8), white)
	createIconPiece(icon, Vector2.new(15, 15), Vector2.new(11, 8), white)
	createIconPiece(icon, Vector2.new(16, 15), Vector2.new(6, 12), white)
	createIconPiece(icon, Vector2.new(9, 9), Vector2.new(19, 10), backgroundColor)
	createIconPiece(icon, Vector2.new(2, 6), Vector2.new(13, 2), white, 12)
	createIconPiece(icon, Vector2.new(9, 5), Vector2.new(15, 1), THEME.Success, -30)
	return icon
end

local launcher = create("TextButton", {
	Name = "Launcher",
	Size = UDim2.fromOffset(44, 44),
	Position = UDim2.new(0, 12, 0.5, -22),
	BackgroundColor3 = LAUNCHER_COLOR,
	Text = "",
	AutoButtonColor = false,
	BorderSizePixel = 0,
}, screenGui)
addCorner(launcher, 12)
addStroke(launcher, THEME.Stroke, 1)
buildAppleIcon(launcher, LAUNCHER_COLOR)

local collapsed = false

local function toggleMenu()
	main.Visible = not main.Visible
end

local function toggleCollapse()
	collapsed = not collapsed
	body.Visible = not collapsed
	local height = collapsed and (HEADER_HEIGHT + 2) or menuHeight
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
	if not processed and input.KeyCode == CONFIG.MenuToggleKey then
		toggleMenu()
	end
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

local SHUTDOWN_ORDER = {
	"FollowPlayer", "Spectate", "AutoClick", "AutoFarm", "AutoLoot", "Noclip", "FixLag", "FullBright", "WalkSpeed",
	"HighJump", "InfiniteJump", "Fly", "XRay", "AntiAfk", "Esp", "Aim",
}

local function shutdown()
	if isShutdown then
		return
	end
	isShutdown = true
	for _, key in ipairs(SHUTDOWN_ORDER) do
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
notify(CONFIG.Name .. " " .. CONFIG.Version .. " đã sẵn sàng", "success")
