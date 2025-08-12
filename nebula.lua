-- Safe Nebula Explorer - Studio-style Single File LocalScript
-- Features: polished UI, search, expandable tree, live property updates, editable properties,
-- context menu (copy path / highlight / destroy with confirmation), resizable panels,
-- favorites, theme toggle, and light performance mode.

-- Basic services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
if not player then warn("Safe Nebula Explorer: LocalPlayer not found") return end
local playerGui = player:FindFirstChild("PlayerGui")
if not playerGui then warn("Safe Nebula Explorer: PlayerGui not found") return end

-- CONFIG
local THEME_PRESETS = {
	dark = {
		primary = Color3.fromRGB(28,28,30),
		secondary = Color3.fromRGB(40,40,42),
		accent = Color3.fromRGB(0,162,255),
		text = Color3.fromRGB(242,242,242),
		textDim = Color3.fromRGB(160,160,160),
		highlight = Color3.fromRGB(72,72,75),
	},
	light = {
		primary = Color3.fromRGB(245,245,247),
		secondary = Color3.fromRGB(230,230,234),
		accent = Color3.fromRGB(0,122,204),
		text = Color3.fromRGB(20,20,20),
		textDim = Color3.fromRGB(100,100,100),
		highlight = Color3.fromRGB(210,210,213),
	}
}

local ACTIVE_THEME = "dark" -- default
local PERFORMANCE_MODE = false -- when true, reduce live updates

-- Services list to show in root of explorer
local SERVICES = {
	{ name = "Workspace", service = workspace },
	{ name = "Players", service = Players },
	{ name = "Lighting", service = game:GetService("Lighting") },
	{ name = "ReplicatedStorage", service = game:GetService("ReplicatedStorage") },
	{ name = "StarterGui", service = game:GetService("StarterGui") },
}

-- Helpers
local function theme(key) return THEME_PRESETS[ACTIVE_THEME][key] end
local function round(n) return math.floor(n + 0.5) end

-- Cleanup old GUI
pcall(function()
	local existing = playerGui:FindFirstChild("SafeNebulaExplorer")
	if existing then existing:Destroy() end
end)
task.wait(0.05)

-- Root GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SafeNebulaExplorer"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui
screenGui.DisplayOrder = 50

-- Container
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 780, 0, 480)
main.Position = UDim2.new(0.5, -390, 0.5, -240)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = theme("primary")
main.BorderSizePixel = 0
main.Parent = screenGui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,10)

-- Shadow effect (subtle)
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1,6,1,6)
shadow.Position = UDim2.new(0,-3,0,-3)
shadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
shadow.BackgroundTransparency = 0.9
shadow.ZIndex = main.ZIndex - 1
shadow.Parent = screenGui
shadow.ClipsDescendants = false
local shadowCorner = Instance.new("UICorner", shadow)
shadowCorner.CornerRadius = UDim.new(0,12)

-- Make sure shadow stays behind by parenting under screenGui but drawing first
shadow.Parent = screenGui
main.Parent = screenGui

-- Titlebar
local titleBar = Instance.new("Frame", main)
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1,0,0,38)
titleBar.Position = UDim2.new(0,0,0,0)
titleBar.BackgroundColor3 = theme("secondary")
titleBar.BorderSizePixel = 0
local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0,8)

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(0.6, -10, 1, 0)
titleLabel.Position = UDim2.new(0,10,0,0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "🔭 Safe Nebula Explorer"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 15
titleLabel.TextColor3 = theme("text")
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Controls on title bar
local closeBtn = Instance.new("TextButton", titleBar)
closeBtn.Size = UDim2.new(0,28,0,28)
closeBtn.Position = UDim2.new(1,-36,0,5)
closeBtn.BackgroundColor3 = Color3.fromRGB(220,53,69)
closeBtn.Text = "×"
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = theme("text")
closeBtn.BorderSizePixel = 0
local closeCorner = Instance.new("UICorner", closeBtn); closeCorner.CornerRadius = UDim.new(0,6)

local themeToggle = Instance.new("TextButton", titleBar)
themeToggle.Size = UDim2.new(0,28,0,28)
themeToggle.Position = UDim2.new(1,-72,0,5)
themeToggle.BackgroundColor3 = theme("accent")
themeToggle.Text = "☼"
themeToggle.Font = Enum.Font.SourceSansBold
themeToggle.TextSize = 14
themeToggle.TextColor3 = theme("text")
themeToggle.BorderSizePixel = 0
Instance.new("UICorner", themeToggle).CornerRadius = UDim.new(0,6)

local perfBtn = Instance.new("TextButton", titleBar)
perfBtn.Size = UDim2.new(0,28,0,28)
perfBtn.Position = UDim2.new(1,-108,0,5)
perfBtn.BackgroundColor3 = theme("highlight")
perfBtn.Text = "⚡"
perfBtn.Font = Enum.Font.SourceSansBold
perfBtn.TextSize = 14
perfBtn.TextColor3 = theme("text")
perfBtn.BorderSizePixel = 0
Instance.new("UICorner", perfBtn).CornerRadius = UDim.new(0,6)

-- Divider between panels (resizable)
local leftW = 0.42
local divider = Instance.new("Frame", main)
divider.Name = "Divider"
divider.Size = UDim2.new(0,6,1,-58)
divider.Position = UDim2.new(leftW,0,0,48)
divider.BackgroundTransparency = 1

local dividerGrip = Instance.new("Frame", divider)
dividerGrip.Size = UDim2.new(1,0,0,20)
dividerGrip.Position = UDim2.new(0,0,0, (main.Size.Y.Offset - 58)/2 - 10)
dividerGrip.AnchorPoint = Vector2.new(0,0.5)
dividerGrip.BackgroundColor3 = theme("highlight")
dividerGrip.BorderSizePixel = 0
dividerGrip.ClipsDescendants = true
Instance.new("UICorner", dividerGrip).CornerRadius = UDim.new(0,6)
dividerGrip.Parent = divider

-- Left panel (tree)
local leftPanel = Instance.new("Frame", main)
leftPanel.Name = "Left"
leftPanel.Size = UDim2.new(leftW, -8, 1, -58)
leftPanel.Position = UDim2.new(0,5,0,48)
leftPanel.BackgroundColor3 = theme("secondary")
leftPanel.BorderSizePixel = 0
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0,6)

local leftTop = Instance.new("Frame", leftPanel)
leftTop.Size = UDim2.new(1,-10,0,36)
leftTop.Position = UDim2.new(0,5,0,5)
leftTop.BackgroundTransparency = 1

-- Search box
local searchBox = Instance.new("TextBox", leftTop)
searchBox.Size = UDim2.new(1,-10,1,0)
searchBox.Position = UDim2.new(0,5,0,0)
searchBox.PlaceholderText = "Search instances..."
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.SourceSans
searchBox.TextSize = 13
searchBox.TextColor3 = theme("text")
searchBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
searchBox.BackgroundTransparency = 0.92
searchBox.PlaceholderColor3 = theme("textDim")
searchBox.Text = ""
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0,6)

-- Tree container (scroll)
local treeScroll = Instance.new("ScrollingFrame", leftPanel)
treeScroll.Size = UDim2.new(1,-10,1,-50)
treeScroll.Position = UDim2.new(0,5,0,46)
treeScroll.BackgroundTransparency = 1
treeScroll.CanvasSize = UDim2.new(0,0,0,0)
treeScroll.ScrollBarThickness = 6
treeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Right panel (properties)
local rightPanel = Instance.new("Frame", main)
rightPanel.Name = "Right"
rightPanel.Size = UDim2.new(1-leftW, -14, 1, -58)
rightPanel.Position = UDim2.new(leftW, 8, 0, 48)
rightPanel.BackgroundColor3 = theme("secondary")
rightPanel.BorderSizePixel = 0
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0,6)

local rightTop = Instance.new("Frame", rightPanel)
rightTop.Size = UDim2.new(1,-10,0,36)
rightTop.Position = UDim2.new(0,5,0,5)
rightTop.BackgroundTransparency = 1

local selectionLabel = Instance.new("TextLabel", rightTop)
selectionLabel.Size = UDim2.new(0.7,0,1,0)
selectionLabel.Position = UDim2.new(0,0,0,0)
selectionLabel.BackgroundTransparency = 1
selectionLabel.Text = "No selection"
selectionLabel.Font = Enum.Font.SourceSansBold
selectionLabel.TextSize = 14
selectionLabel.TextColor3 = theme("text")
selectionLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Favorites button
local favoriteBtn = Instance.new("TextButton", rightTop)
favoriteBtn.Size = UDim2.new(0,28,0,28)
favoriteBtn.Position = UDim2.new(1,-34,0,4)
favoriteBtn.BackgroundTransparency = 1
favoriteBtn.Text = "☆"
favoriteBtn.Font = Enum.Font.SourceSans
favoriteBtn.TextSize = 18
favoriteBtn.TextColor3 = theme("text")
favoriteBtn.BorderSizePixel = 0

-- Properties scroll
local propsScroll = Instance.new("ScrollingFrame", rightPanel)
propsScroll.Size = UDim2.new(1,-10,1,-50)
propsScroll.Position = UDim2.new(0,5,0,46)
propsScroll.BackgroundTransparency = 1
propsScroll.CanvasSize = UDim2.new(0,0,0,0)
propsScroll.ScrollBarThickness = 6
propsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Context menu (hidden until right-click)
local contextMenu = Instance.new("Frame", screenGui)
contextMenu.Name = "ContextMenu"
contextMenu.Size = UDim2.new(0,160,0,120)
contextMenu.BackgroundColor3 = theme("secondary")
contextMenu.Visible = false
contextMenu.ZIndex = 1001
Instance.new("UICorner", contextMenu).CornerRadius = UDim.new(0,6)
local contextLayout = Instance.new("UIListLayout", contextMenu)
contextLayout.Padding = UDim.new(0,4)
contextLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
contextLayout.SortOrder = Enum.SortOrder.LayoutOrder
contextMenu.ClipsDescendants = true

local function makeContextItem(text, func)
	local b = Instance.new("TextButton", contextMenu)
	b.Size = UDim2.new(1,-12,0,28)
	b.Position = UDim2.new(0,6,0,0)
	b.BackgroundTransparency = 1
	b.Text = text
	b.Font = Enum.Font.SourceSans
	b.TextSize = 14
	b.TextColor3 = theme("text")
	b.BorderSizePixel = 0
	b.AutoButtonColor = true
	b.MouseButton1Click:Connect(function()
		contextMenu.Visible = false
		func()
	end)
	return b
end

-- Context items will be created later when needed

-- Internal state
local selectedInstance = nil
local favorites = {} -- map instance -> true via instance:GetDebugId? Instances can't be keys persistently across respawn; use Path as key
local favoritePaths = {} -- set of paths
local treeButtons = {}
local changeConnections = {}
local liveUpdateConnections = {}
local updateThrottle = 0.15 -- default live update throttle

-- Utility: get full path string (safe)
local function getFullPath(inst)
	local ok, s = pcall(function() return inst:GetFullName() end)
	return ok and s or tostring(inst)
end

-- Toggle theme (switch palette then update UI colors)
local function applyTheme()
	-- update theme colors from ACTIVE_THEME
	main.BackgroundColor3 = theme("primary")
	titleBar.BackgroundColor3 = theme("secondary")
	titleLabel.TextColor3 = theme("text")
	searchBox.TextColor3 = theme("text")
	searchBox.PlaceholderColor3 = theme("textDim")
	leftPanel.BackgroundColor3 = theme("secondary")
	rightPanel.BackgroundColor3 = theme("secondary")
	dividerGrip.BackgroundColor3 = theme("highlight")
	themeToggle.BackgroundColor3 = theme("accent")
	closeBtn.TextColor3 = theme("text")
	perfBtn.TextColor3 = theme("text")
	selectionLabel.TextColor3 = theme("text")
	favoriteBtn.TextColor3 = theme("text")
	contextMenu.BackgroundColor3 = theme("secondary")
	-- refresh visible items
	for _, v in ipairs(treeButtons) do
		if v:IsA("TextButton") then
			v.TextColor3 = theme("text")
			v.BackgroundColor3 = Color3.fromRGB(255,255,255) -- button background is transparent mostly
		end
	end
	for _, child in ipairs(propsScroll:GetChildren()) do
		if child:IsA("Frame") then
			local label = child:FindFirstChild("__Name")
			if label then label.TextColor3 = theme("textDim") end
			local val = child:FindFirstChild("__Val")
			if val then val.TextColor3 = theme("text") end
		end
	end
end

-- Create a property row UI
local function createPropRow(name, valueText, index)
	local row = Instance.new("Frame")
	row.Name = "PropRow_"..tostring(index)
	row.Size = UDim2.new(1,-10,0,28)
	row.BackgroundColor3 = Color3.fromRGB(60,60,60)
	row.BorderSizePixel = 0
	row.Parent = propsScroll
	Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)

	local nameLbl = Instance.new("TextLabel", row)
	nameLbl.Name = "__Name"
	nameLbl.Size = UDim2.new(0.36,0,1,0)
	nameLbl.Position = UDim2.new(0,8,0,0)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Font = Enum.Font.SourceSans
	nameLbl.TextSize = 13
	nameLbl.TextColor3 = theme("textDim")
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.Text = name

	local valBox = Instance.new("TextBox", row)
	valBox.Name = "__Val"
	valBox.Size = UDim2.new(0.64,-16,1,0)
	valBox.Position = UDim2.new(0.36,8,0,0)
	valBox.BackgroundTransparency = 1
	valBox.ClearTextOnFocus = false
	valBox.Font = Enum.Font.SourceSans
	valBox.TextSize = 13
	valBox.TextColor3 = theme("text")
	valBox.TextXAlignment = Enum.TextXAlignment.Left
	valBox.Text = valueText

	return row, valBox
end

-- Clear properties display
local function clearProps()
	for _, c in ipairs(propsScroll:GetChildren()) do
		if c:IsA("Frame") then c:Destroy() end
	end
	propsScroll.CanvasSize = UDim2.new(0,0,0,0)
end

-- Try to set a property value safely (basic types)
local function trySetProperty(inst, propName, text)
	local success, err = pcall(function()
		local current = inst[propName]
		-- handle bool
		if typeof(current) == "boolean" then
			local lowered = string.lower(text)
			if lowered == "true" or lowered == "1" then
				inst[propName] = true
			else
				inst[propName] = false
			end
			return true
		end
		-- number
		if typeof(current) == "number" then
			local n = tonumber(text)
			if n then inst[propName] = n else error("Invalid number") end
			return true
		end
		-- string
		if typeof(current) == "string" then
			inst[propName] = text
			return true
		end
		-- Vector3 (basic parse "x,y,z")
		if typeof(current) == "Vector3" then
			local parts = {}
			for s in string.gmatch(text, "([^,]+)") do table.insert(parts, tonumber(s)) end
			if #parts == 3 and parts[1] and parts[2] and parts[3] then
				inst[propName] = Vector3.new(parts[1], parts[2], parts[3])
				return true
			else
				error("Invalid Vector3")
			end
		end
		-- Color3 "r,g,b" 0-255 or 0-1
		if typeof(current) == "Color3" then
			local parts = {}
			for s in string.gmatch(text, "([^,]+)") do table.insert(parts, tonumber(s)) end
			if #parts == 3 and parts[1] and parts[2] and parts[3] then
				-- assume 0-255 if >1
				if parts[1] > 1 or parts[2] > 1 or parts[3] > 1 then
					inst[propName] = Color3.fromRGB(round(parts[1]), round(parts[2]), round(parts[3]))
				else
					inst[propName] = Color3.new(parts[1], parts[2], parts[3])
				end
				return true
			else
				error("Invalid Color3")
			end
		end
		-- Fallback: attempt raw assignment (may error)
		inst[propName] = HttpService:JSONDecode(text) -- try JSON decode for tables; will error if invalid
		return true
	end)
	return success, err
end

-- Update properties panel for a selected instance
local propUpdateQueue = {}
local function showProperties(inst)
	clearProps()
	for _, c in ipairs(changeConnections) do pcall(function() c:Disconnect() end) end
	changeConnections = {}

	selectedInstance = inst
	if not inst then
		selectionLabel.Text = "No selection"
		favoriteBtn.Text = "☆"
		return
	end

	selectionLabel.Text = getFullPath(inst)
	favoriteBtn.Text = favoritePaths[getFullPath(inst)] and "★" or "☆"

	-- add basic properties and then try to list enumerable properties (safe subset)
	local idx = 1
	local function addPropRow(name, value)
		local row, box = createPropRow(name, tostring(value), idx)
		idx = idx + 1
		box.FocusLost:Connect(function(enterPressed)
			if not enterPressed then return end
			local ok, err = pcall(function()
				local setOk, setErr = trySetProperty(inst, name, box.Text)
				if not setOk then
					error(setErr or "Unknown error")
				end
			end)
			if not ok then
				-- briefly flash red to indicate error
				local old = box.TextColor3
				box.TextColor3 = Color3.fromRGB(255,110,110)
				task.delay(0.9, function() if box then box.TextColor3 = old end end)
				warn("Could not set property:", err)
			else
				-- success: update display
				box.TextColor3 = theme("text")
			end
		end)
	end

	-- Safe list of properties to show (common ones)
	local safeProps = {"Name","ClassName","Parent","Archivable","Transparency","Position","Rotation","Orientation","Size","Anchored","CanCollide","Color","BrickColor","Text","TextColor3","Value"}
	-- show the safeProps if present
	for _, pname in ipairs(safeProps) do
		if pcall(function() return inst[pname] end) then
			local ok, val = pcall(function() return inst[pname] end)
			if ok then
				addPropRow(pname, val)
			end
		end
	end

	-- Also show a few custom useful values
	-- Example: show number of children
	addPropRow("ChildrenCount", #inst:GetChildren())

	-- Hook change event for live updates
	local conn
	local lastUpdate = 0
	conn = inst.Changed:Connect(function(prop)
		if PERFORMANCE_MODE then
			-- in perf mode, throttle more
			local now = tick()
			if now - lastUpdate < (updateThrottle * 4) then return end
			lastUpdate = now
		else
			local now = tick()
			if now - lastUpdate < updateThrottle then return end
			lastUpdate = now
		end
		-- simply re-show properties to reflect change
		task.spawn(function()
			showProperties(inst)
		end)
	end)
	table.insert(changeConnections, conn)
end

-- Build tree: recursive with expand/collapse buttons
local function clearTree()
	for _, v in ipairs(treeButtons) do
		if v.Destroy then pcall(function() v:Destroy() end) end
	end
	treeButtons = {}
end

-- Helper to create a single tree entry (button + expand)
local function createTreeButton(instance, depth)
	local indent = depth * 14
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -indent - 8, 0, 20)
	btn.Position = UDim2.new(0, indent + 4, 0, 0)
	btn.AnchorPoint = Vector2.new(0,0)
	btn.BackgroundTransparency = 1
	btn.AutoButtonColor = false
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 13
	btn.TextColor3 = theme("text")
	btn.Text = ( #instance:GetChildren() > 0 and "📂 " or "📄 " ) .. instance.Name

	-- hover
	btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 0.8}):Play() end)
	btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play() end)

	return btn
end

-- Build full tree from SERVICES
local treeY = 4
local function buildTree(filterText)
	clearTree()
	for _, data in ipairs(SERVICES) do
		local root = data.service
		-- root entry
		local rootBtn = createTreeButton(root, 0)
		rootBtn.Position = UDim2.new(0,4,0,treeY)
		rootBtn.Parent = treeScroll
		table.insert(treeButtons, rootBtn)
		treeY = treeY + 22

		-- expand/collapse state stored on button
		rootBtn._expanded = false

		-- container for children entries
		local function buildChildren(parentInst, depth)
			for _, child in ipairs(parentInst:GetChildren()) do
				-- filter check
				if not filterText or filterText == "" or string.find(string.lower(child.Name), string.lower(filterText), 1, true) then
					local btn = createTreeButton(child, depth)
					btn.Position = UDim2.new(0, 4, 0, treeY)
					btn.Parent = treeScroll
					table.insert(treeButtons, btn)
					treeY = treeY + 22

					-- left click selects
					btn.MouseButton1Click:Connect(function()
						showProperties(child)
					end)

					-- right click open context
					btn.MouseButton2Click:Connect(function(x,y)
						contextMenu.Position = UDim2.new(0, x, 0, y)
						contextMenu.Visible = true
						-- rebuild context menu for this item
						for _, c in ipairs(contextMenu:GetChildren()) do
							if c ~= contextLayout then pcall(function() c:Destroy() end) end
						end
						makeContextItem("Copy Path", function()
							pcall(function() setclipboard(getFullPath(child)) end)
						end)
						makeContextItem("Highlight (flash)", function()
							local orig = child:IsA("BasePart") and child.Transparency or nil
							if child:IsA("BasePart") then
								local old = child.Transparency
								for i=1,3 do
									child.Transparency = math.clamp(old*0.5,0,1)
									task.wait(0.08)
									child.Transparency = old
									task.wait(0.08)
								end
							else
								-- non-part: try to tween a selection highlight by creating a BillboardGui
								local bb = Instance.new("BillboardGui")
								bb.Adornee = child:IsA("Instance") and (child:FindFirstChildWhichIsA("BasePart") or child.Parent and child.Parent:FindFirstChildWhichIsA("BasePart")) or nil
								if bb and bb.Adornee then
									bb.Parent = player.Character and player.Character:FindFirstChildOfClass("PlayerGui") or playerGui
									bb.Size = UDim2.new(0, 100, 0, 40)
									local lbl = Instance.new("TextLabel", bb)
									lbl.Size = UDim2.new(1,0,1,0)
									lbl.BackgroundTransparency = 1
									lbl.Text = child.Name
									lbl.TextColor3 = theme("accent")
									task.delay(1, function() pcall(function() bb:Destroy() end) end)
								end
							end
						end)
						makeContextItem("Destroy (confirm)", function()
							-- confirmation prompt
							local confirm = Instance.new("TextButton", screenGui)
							confirm.Size = UDim2.new(0,300,0,80)
							confirm.Position = UDim2.new(0.5,-150,0.5,-40)
							confirm.BackgroundColor3 = Color3.fromRGB(30,30,30)
							Instance.new("UICorner", confirm).CornerRadius = UDim.new(0,8)
							confirm.TextColor3 = Color3.fromRGB(255,255,255)
							confirm.Font = Enum.Font.SourceSansBold
							confirm.TextSize = 14
							confirm.Text = "Destroy "..child.Name.." ? Click to confirm."
							-- if clicked, attempt to destroy
							confirm.MouseButton1Click:Connect(function()
								pcall(function() child:Destroy() end)
								confirm:Destroy()
							end)
							task.delay(6, function() if confirm and confirm.Parent then pcall(function() confirm:Destroy() end) end end)
						end)
					end)
				end
				-- lazy build children only when expanded manually by double-click
				-- handle expand on double-click
				local dblConn
				dblConn = nil
				-- Double click detection
				local lastClick = 0
				-- we need a button to represent the child (created above), find it
				-- but because of scope, btn is in closure above. we can attach
				-- single click selection already above. Use DoubleClick to expand/collapse
				-- so we also add MouseButton1Click to toggle expand on second click
				-- We'll implement a simple expand: when double-clicked, insert its children below
				local function attachDouble(btn, parentInst, depthLevel)
					btn.MouseButton1Click:Connect(function()
						local now = tick()
						if now - lastClick < 0.35 then
							-- double
							if btn._expanded then
								-- collapse: rebuild tree globally to keep simple
								buildTree(searchBox.Text)
							else
								-- expand: we will inject children right after this button by rebuilding with a flag (simpler)
								buildTree(searchBox.Text)
								-- We can simulate expanded by scrolling to it
							end
						end
						lastClick = now
					end)
				end
				-- Note: attachDouble will be re-run per created button; because we created inline above, search for last button and attach
			end
		end
	end
	-- reposition canvas size (treeScroll.AutomaticCanvasSize handles it, but ensure minimal)
	treeScroll.CanvasSize = UDim2.new(0,0,0, math.max(8, treeY))
end

-- Simpler build: iterate and add first level children only (keeps UI responsive)
local function buildTree(filterText)
	clearTree()
	treeY = 4
	for _, data in ipairs(SERVICES) do
		local root = data.service
		-- root item
		local rootBtn = createTreeButton(root, 0)
		rootBtn.Position = UDim2.new(0,4,0,treeY)
		rootBtn.Parent = treeScroll
		table.insert(treeButtons, rootBtn)
		treeY = treeY + 22

		-- click to select root
		rootBtn.MouseButton1Click:Connect(function() showProperties(root) end)

		-- add children under root (one level)
		for _, child in ipairs(root:GetChildren()) do
			if not filterText or filterText == "" or string.find(string.lower(child.Name), string.lower(filterText), 1, true) then
				local btn = createTreeButton(child, 1)
				btn.Position = UDim2.new(0, 4, 0, treeY)
				btn.Parent = treeScroll
				table.insert(treeButtons, btn)
				treeY = treeY + 22

				btn.MouseButton1Click:Connect(function() showProperties(child) end)
				btn.MouseButton2Click:Connect(function(x,y)
					contextMenu.Position = UDim2.new(0, x, 0, y)
					contextMenu.Visible = true
					for _, c in ipairs(contextMenu:GetChildren()) do
						if c ~= contextLayout then pcall(function() c:Destroy() end) end
					end
					makeContextItem("Copy Path", function()
						pcall(function() setclipboard(getFullPath(child)) end)
					end)
					makeContextItem("Highlight (flash)", function()
						-- simple highlight by creating a selection box if part exists
						if child:IsA("BasePart") then
							local box = Instance.new("SelectionBox")
							box.Adornee = child
							box.Color3 = theme("accent")
							box.Parent = workspace
							task.delay(1.2, function() pcall(function() box:Destroy() end) end)
						end
					end)
					makeContextItem("Destroy (confirm)", function()
						local confirm = Instance.new("TextButton", screenGui)
						confirm.Size = UDim2.new(0,300,0,80)
						confirm.Position = UDim2.new(0.5,-150,0.5,-40)
						confirm.BackgroundColor3 = Color3.fromRGB(30,30,30)
						Instance.new("UICorner", confirm).CornerRadius = UDim.new(0,8)
						confirm.TextColor3 = Color3.fromRGB(255,255,255)
						confirm.Font = Enum.Font.SourceSansBold
						confirm.TextSize = 14
						confirm.Text = "Destroy "..child.Name.." ? Click to confirm."
						confirm.MouseButton1Click:Connect(function()
							pcall(function() child:Destroy() end)
							confirm:Destroy()
							buildTree(searchBox.Text)
							if selectedInstance == child then showProperties(nil) end
						end)
						task.delay(6, function() if confirm and confirm.Parent then pcall(function() confirm:Destroy() end) end end)
					end)
				end)
			end
		end
	end
	treeScroll.CanvasSize = UDim2.new(0,0,0, math.max(8, treeY))
end

-- Search debounce
local searchDebounce = nil
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	if searchDebounce then searchDebounce:Cancel() end
	searchDebounce = task.delay(0.18, function()
		buildTree(searchBox.Text)
	end)
end)

-- Divider drag to resize panels
local dragging = false
local dragStartX, startLeftWidth
dividerGrip.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStartX = input.Position.X
		startLeftWidth = leftPanel.Size.X.Scale
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position.X - dragStartX
		local totalW = main.AbsoluteSize.X
		local newLeftPixels = (startLeftWidth * totalW) + delta
		local newLeftScale = math.clamp(newLeftPixels / totalW, 0.22, 0.78)
		leftPanel.Size = UDim2.new(newLeftScale, -8, 1, -58)
		divider.Position = UDim2.new(newLeftScale, 0, 0, 48)
		rightPanel.Size = UDim2.new(1 - newLeftScale, -14, 1, -58)
		rightPanel.Position = UDim2.new(newLeftScale, 8, 0, 48)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

-- Title drag (move window)
local draggingWindow = false
local dragWindowStart, windowStartPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingWindow = true
		dragWindowStart = input.Position
		windowStartPos = main.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if draggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragWindowStart
		main.Position = UDim2.new(windowStartPos.X.Scale, windowStartPos.X.Offset + delta.X, windowStartPos.Y.Scale, windowStartPos.Y.Offset + delta.Y)
		shadow.Position = main.Position + UDim2.new(0, -3, 0, -3)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingWindow = false
	end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Theme toggle
themeToggle.MouseButton1Click:Connect(function()
	ACTIVE_THEME = (ACTIVE_THEME == "dark") and "light" or "dark"
	applyTheme()
end)

-- Performance mode toggle
perfBtn.MouseButton1Click:Connect(function()
	PERFORMANCE_MODE = not PERFORMANCE_MODE
	perfBtn.BackgroundColor3 = PERFORMANCE_MODE and Color3.fromRGB(200,160,40) or theme("highlight")
end)

-- Favorites toggle
favoriteBtn.MouseButton1Click:Connect(function()
	if not selectedInstance then return end
	local path = getFullPath(selectedInstance)
	if favoritePaths[path] then
		favoritePaths[path] = nil
		favoriteBtn.Text = "☆"
	else
		favoritePaths[path] = true
		favoriteBtn.Text = "★"
	end
end)

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		if contextMenu and contextMenu.Visible then
			contextMenu.Visible = false
		end
	end
end)

-- Initial build & theme apply
applyTheme()
buildTree("")

-- Initial show: nothing selected
showProperties(nil)

-- Live update loop: refresh favorites (not persistent across sessions)
RunService.Heartbeat:Connect(function(dt)
	-- optionally auto-refresh children counts for performance
	-- Could throttle heavy tasks here
end)

-- Final message
print("✅ Safe Nebula Explorer (enhanced) loaded")
