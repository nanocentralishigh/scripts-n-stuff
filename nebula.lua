-- Enhanced Nebula Explorer - Professional Edition
-- Advanced UI, search, filtering, and property editing capabilities

print("=== Enhanced Nebula Explorer Starting ===")

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

-- Player validation
local player = Players.LocalPlayer
if not player then warn("LocalPlayer not found") return end
local playerGui = player:FindFirstChild("PlayerGui")
if not playerGui then warn("PlayerGui not found") return end

-- Enhanced theme with gradients and modern colors
local THEME = {
    primary = Color3.fromRGB(25, 25, 30),
    secondary = Color3.fromRGB(35, 35, 45),
    tertiary = Color3.fromRGB(45, 45, 55),
    accent = Color3.fromRGB(88, 166, 255),
    accentHover = Color3.fromRGB(108, 186, 255),
    success = Color3.fromRGB(46, 204, 113),
    warning = Color3.fromRGB(241, 196, 15),
    danger = Color3.fromRGB(231, 76, 60),
    text = Color3.fromRGB(245, 245, 250),
    textDim = Color3.fromRGB(160, 160, 170),
    textMuted = Color3.fromRGB(120, 120, 130),
    border = Color3.fromRGB(60, 60, 70)
}

-- Service definitions with icons
local SERVICES = {
    {name = "Workspace", service = workspace, icon = "🌍", expanded = false},
    {name = "Players", service = Players, icon = "👤", expanded = false},
    {name = "Lighting", service = game:GetService("Lighting"), icon = "💡", expanded = false},
    {name = "ReplicatedStorage", service = game:GetService("ReplicatedStorage"), icon = "📦", expanded = false},
    {name = "StarterGui", service = game:GetService("StarterGui"), icon = "🎮", expanded = false},
    {name = "StarterPlayer", service = game:GetService("StarterPlayer"), icon = "🏃", expanded = false},
    {name = "SoundService", service = game:GetService("SoundService"), icon = "🔊", expanded = false},
    {name = "TweenService", service = TweenService, icon = "📈", expanded = false}
}

-- Class icons mapping
local CLASS_ICONS = {
    Folder = "📁", Part = "🧊", Script = "📜", LocalScript = "📄",
    RemoteEvent = "📡", RemoteFunction = "📞", ModuleScript = "📚",
    Frame = "🖼️", TextLabel = "📝", TextButton = "🔘", ImageLabel = "🖼️",
    Camera = "📷", SpawnLocation = "🎯", Model = "🏗️", Mesh = "🔺"
}

-- Animation utilities
local function animateScale(obj, targetScale, duration)
    duration = duration or 0.2
    local originalSize = obj.Size
    local targetSize = UDim2.new(originalSize.X.Scale * targetScale, originalSize.X.Offset, 
                                originalSize.Y.Scale * targetScale, originalSize.Y.Offset)
    local tween = TweenService:Create(obj, 
        TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = targetSize}
    )
    tween:Play()
    return tween
end

local function animateColor(obj, targetColor, duration)
    duration = duration or 0.15
    local tween = TweenService:Create(obj,
        TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundColor3 = targetColor}
    )
    tween:Play()
    return tween
end

-- Cleanup existing instances
pcall(function()
    local existing = playerGui:FindFirstChild("EnhancedNebulaExplorer")
    if existing then existing:Destroy() end
end)
task.wait(0.1)

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EnhancedNebulaExplorer"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Connection management
local connections = {}
local function trackConnection(conn)
    table.insert(connections, conn)
    return conn
end

-- UI creation helpers
local function createFrame(properties)
    local frame = Instance.new("Frame")
    for prop, value in pairs(properties) do
        frame[prop] = value
    end
    return frame
end

local function createTextLabel(properties)
    local label = Instance.new("TextLabel")
    for prop, value in pairs(properties) do
        label[prop] = value
    end
    return label
end

local function createTextButton(properties)
    local button = Instance.new("TextButton")
    for prop, value in pairs(properties) do
        button[prop] = value
    end
    return button
end

-- Main container with shadow effect
local shadowFrame = createFrame({
    Name = "ShadowFrame",
    Size = UDim2.new(0, 810, 0, 560),
    Position = UDim2.new(0.5, -405, 0.5, -280),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 0.7,
    BorderSizePixel = 0,
    Parent = screenGui
})
Instance.new("UICorner", shadowFrame).CornerRadius = UDim.new(0, 12)

local mainFrame = createFrame({
    Name = "MainFrame",
    Size = UDim2.new(1, -4, 1, -4),
    Position = UDim2.new(0, 2, 0, 2),
    BackgroundColor3 = THEME.primary,
    BorderSizePixel = 0,
    Parent = shadowFrame
})

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.primary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 25))
})
gradient.Rotation = 135
gradient.Parent = mainFrame

-- Enhanced title bar
local titleBar = createFrame({
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 45),
    BackgroundColor3 = THEME.secondary,
    BorderSizePixel = 0,
    Parent = mainFrame
})

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- Title bar gradient
local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, THEME.secondary),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
})
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

-- App icon and title
local appIcon = createTextLabel({
    Size = UDim2.new(0, 30, 0, 30),
    Position = UDim2.new(0, 10, 0, 7.5),
    BackgroundTransparency = 1,
    Text = "🔍",
    TextColor3 = THEME.accent,
    TextSize = 18,
    Font = Enum.Font.SourceSansBold,
    Parent = titleBar
})

local titleLabel = createTextLabel({
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(0, 50, 0, 0),
    BackgroundTransparency = 1,
    Text = "Enhanced Nebula Explorer",
    TextColor3 = THEME.text,
    TextSize = 16,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = titleBar
})

-- Window controls
local minimizeBtn = createTextButton({
    Size = UDim2.new(0, 30, 0, 25),
    Position = UDim2.new(1, -100, 0, 10),
    BackgroundColor3 = THEME.warning,
    Text = "−",
    TextColor3 = THEME.text,
    Font = Enum.Font.SourceSansBold,
    TextSize = 18,
    BorderSizePixel = 0,
    Parent = titleBar
})
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 4)

local maximizeBtn = createTextButton({
    Size = UDim2.new(0, 30, 0, 25),
    Position = UDim2.new(1, -65, 0, 10),
    BackgroundColor3 = THEME.success,
    Text = "□",
    TextColor3 = THEME.text,
    Font = Enum.Font.SourceSansBold,
    TextSize = 14,
    BorderSizePixel = 0,
    Parent = titleBar
})
Instance.new("UICorner", maximizeBtn).CornerRadius = UDim.new(0, 4)

local closeBtn = createTextButton({
    Size = UDim2.new(0, 30, 0, 25),
    Position = UDim2.new(1, -30, 0, 10),
    BackgroundColor3 = THEME.danger,
    Text = "×",
    TextColor3 = THEME.text,
    Font = Enum.Font.SourceSansBold,
    TextSize = 16,
    BorderSizePixel = 0,
    Parent = titleBar
})
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 4)

-- Toolbar
local toolbar = createFrame({
    Name = "Toolbar",
    Size = UDim2.new(1, 0, 0, 40),
    Position = UDim2.new(0, 0, 0, 45),
    BackgroundColor3 = THEME.tertiary,
    BorderSizePixel = 0,
    Parent = mainFrame
})

-- Search box
local searchFrame = createFrame({
    Size = UDim2.new(0, 250, 0, 28),
    Position = UDim2.new(0, 10, 0, 6),
    BackgroundColor3 = THEME.secondary,
    BorderColor3 = THEME.border,
    BorderSizePixel = 1,
    Parent = toolbar
})
Instance.new("UICorner", searchFrame).CornerRadius = UDim.new(0, 6)

local searchIcon = createTextLabel({
    Size = UDim2.new(0, 25, 1, 0),
    BackgroundTransparency = 1,
    Text = "🔍",
    TextColor3 = THEME.textMuted,
    TextSize = 12,
    Parent = searchFrame
})

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -30, 1, 0)
searchBox.Position = UDim2.new(0, 25, 0, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Search instances..."
searchBox.PlaceholderColor3 = THEME.textMuted
searchBox.Text = ""
searchBox.TextColor3 = THEME.text
searchBox.TextSize = 12
searchBox.Font = Enum.Font.SourceSans
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.Parent = searchFrame

-- Filter variables
local showScripts = false
local showGUIs = false
local showParts = false

-- Filter buttons
local filterFrame = createFrame({
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 270, 0, 0),
    BackgroundTransparency = 1,
    Parent = toolbar
})

local function createFilterBtn(text, position, callback)
    local btn = createTextButton({
        Size = UDim2.new(0, 45, 0, 24),
        Position = UDim2.new(0, position, 0, 8),
        BackgroundColor3 = THEME.secondary,
        Text = text,
        TextColor3 = THEME.textDim,
        TextSize = 10,
        Font = Enum.Font.SourceSans,
        BorderSizePixel = 0,
        Parent = filterFrame
    })
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local isActive = false
    trackConnection(btn.MouseButton1Click:Connect(function()
        isActive = not isActive
        animateColor(btn, isActive and THEME.accent or THEME.secondary)
        btn.TextColor3 = isActive and THEME.text or THEME.textDim
        if callback then callback(isActive) end
    end))
    
    return btn
end

createFilterBtn("Scripts", 0, function(active) showScripts = active end)
createFilterBtn("GUIs", 50, function(active) showGUIs = active end)
createFilterBtn("Parts", 100, function(active) showParts = active end)

-- Refresh button
local refreshBtn = createTextButton({
    Size = UDim2.new(0, 70, 0, 28),
    Position = UDim2.new(1, -80, 0, 6),
    BackgroundColor3 = THEME.accent,
    Text = "🔄 Refresh",
    TextColor3 = THEME.text,
    TextSize = 11,
    Font = Enum.Font.SourceSansBold,
    BorderSizePixel = 0,
    Parent = toolbar
})
Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

-- Main content area
local contentFrame = createFrame({
    Name = "ContentFrame",
    Size = UDim2.new(1, 0, 1, -85),
    Position = UDim2.new(0, 0, 0, 85),
    BackgroundTransparency = 1,
    Parent = mainFrame
})

-- Left panel (Explorer tree)
local leftPanel = createFrame({
    Name = "LeftPanel",
    Size = UDim2.new(0.45, -5, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundColor3 = THEME.secondary,
    BorderSizePixel = 0,
    Parent = contentFrame
})
Instance.new("UICorner", leftPanel).CornerRadius = UDim.new(0, 8)

-- Explorer header
local explorerHeader = createFrame({
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = THEME.tertiary,
    BorderSizePixel = 0,
    Parent = leftPanel
})
Instance.new("UICorner", explorerHeader).CornerRadius = UDim.new(0, 8)

local explorerTitle = createTextLabel({
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "🌲 Explorer",
    TextColor3 = THEME.text,
    TextSize = 14,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = explorerHeader
})

-- Tree scroll frame
local treeScroll = Instance.new("ScrollingFrame")
treeScroll.Name = "TreeScroll"
treeScroll.Size = UDim2.new(1, -10, 1, -45)
treeScroll.Position = UDim2.new(0, 5, 0, 40)
treeScroll.BackgroundTransparency = 1
treeScroll.ScrollBarThickness = 4
treeScroll.ScrollBarImageColor3 = THEME.accent
treeScroll.BorderSizePixel = 0
treeScroll.Parent = leftPanel

-- Right panel (Properties)
local rightPanel = createFrame({
    Name = "RightPanel",
    Size = UDim2.new(0.55, -15, 1, 0),
    Position = UDim2.new(0.45, 5, 0, 0),
    BackgroundColor3 = THEME.secondary,
    BorderSizePixel = 0,
    Parent = contentFrame
})
Instance.new("UICorner", rightPanel).CornerRadius = UDim.new(0, 8)

-- Properties header
local propsHeader = createFrame({
    Size = UDim2.new(1, 0, 0, 35),
    BackgroundColor3 = THEME.tertiary,
    BorderSizePixel = 0,
    Parent = rightPanel
})
Instance.new("UICorner", propsHeader).CornerRadius = UDim.new(0, 8)

local propsTitle = createTextLabel({
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "⚙️ Properties",
    TextColor3 = THEME.text,
    TextSize = 14,
    Font = Enum.Font.SourceSansBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = propsHeader
})

-- Properties scroll frame
local propsScroll = Instance.new("ScrollingFrame")
propsScroll.Name = "PropsScroll"
propsScroll.Size = UDim2.new(1, -10, 1, -45)
propsScroll.Position = UDim2.new(0, 5, 0, 40)
propsScroll.BackgroundTransparency = 1
propsScroll.ScrollBarThickness = 4
propsScroll.ScrollBarImageColor3 = THEME.accent
propsScroll.BorderSizePixel = 0
propsScroll.Parent = rightPanel

-- Status bar
local statusBar = createFrame({
    Size = UDim2.new(1, 0, 0, 25),
    Position = UDim2.new(0, 0, 1, -25),
    BackgroundColor3 = THEME.tertiary,
    BorderSizePixel = 0,
    Parent = mainFrame
})

local statusText = createTextLabel({
    Size = UDim2.new(1, -20, 1, 0),
    Position = UDim2.new(0, 10, 0, 0),
    BackgroundTransparency = 1,
    Text = "Ready",
    TextColor3 = THEME.textDim,
    TextSize = 10,
    Font = Enum.Font.SourceSans,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = statusBar
})

-- Instance management variables
local selectedInstance
local expandedInstances = {}
local treeItems = {}

-- Utility functions
local function getClassIcon(className)
    return CLASS_ICONS[className] or "📄"
end

local function passesFilter(instance)
    if not showScripts and not showGUIs and not showParts then return true end
    
    local className = instance.ClassName
    if showScripts and (className:find("Script") or className == "ModuleScript") then return true end
    if showGUIs and (className:find("Gui") or className:find("Frame") or className:find("Label") or className:find("Button")) then return true end
    if showParts and (className == "Part" or className == "MeshPart" or className == "UnionOperation") then return true end
    
    return false
end

-- Clear functions
local function clearTree()
    for _, item in pairs(treeItems) do
        if item and item.Destroy then
            item:Destroy()
        end
    end
    table.clear(treeItems)
end

local function clearProps()
    for _, child in ipairs(propsScroll:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

-- Properties display function
local function showProperties(instance)
    clearProps()
    if not instance then
        statusText.Text = "No instance selected"
        return
    end

    statusText.Text = "Viewing: " .. instance.Name .. " (" .. instance.ClassName .. ")"
    
    local yPos = 5
    local function addPropertySection(title, properties)
        -- Section header
        local sectionHeader = createFrame({
            Size = UDim2.new(1, -10, 0, 25),
            Position = UDim2.new(0, 5, 0, yPos),
            BackgroundColor3 = THEME.accent,
            BorderSizePixel = 0,
            Parent = propsScroll
        })
        Instance.new("UICorner", sectionHeader).CornerRadius = UDim.new(0, 4)
        
        local sectionLabel = createTextLabel({
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.new(0, 8, 0, 0),
            BackgroundTransparency = 1,
            Text = title,
            TextColor3 = THEME.text,
            TextSize = 12,
            Font = Enum.Font.SourceSansBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = sectionHeader
        })
        
        yPos = yPos + 30
        
        -- Properties
        for name, value in pairs(properties) do
            local propFrame = createFrame({
                Size = UDim2.new(1, -10, 0, 22),
                Position = UDim2.new(0, 5, 0, yPos),
                BackgroundColor3 = Color3.fromRGB(50, 50, 60),
                BorderColor3 = THEME.border,
                BorderSizePixel = 1,
                Parent = propsScroll
            })
            Instance.new("UICorner", propFrame).CornerRadius = UDim.new(0, 4)
            
            local nameLabel = createTextLabel({
                Size = UDim2.new(0.35, 0, 1, 0),
                Position = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = name,
                TextColor3 = THEME.textDim,
                TextSize = 11,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = propFrame
            })
            
            local valueLabel = createTextLabel({
                Size = UDim2.new(0.65, -16, 1, 0),
                Position = UDim2.new(0.35, 8, 0, 0),
                BackgroundTransparency = 1,
                Text = tostring(value),
                TextColor3 = THEME.text,
                TextSize = 11,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = propFrame
            })
            
            yPos = yPos + 26
        end
        
        yPos = yPos + 10
    end

    -- Basic properties
    local basicProps = {
        Name = instance.Name,
        ClassName = instance.ClassName,
        Parent = instance.Parent and instance.Parent.Name or "nil"
    }
    
    addPropertySection("📋 Basic", basicProps)
    
    -- Try to get more properties safely
    local advancedProps = {}
    pcall(function()
        if instance:IsA("BasePart") then
            advancedProps.Size = tostring(instance.Size)
            advancedProps.Position = tostring(instance.Position)
            advancedProps.Material = tostring(instance.Material)
            advancedProps.Color = tostring(instance.Color)
        elseif instance:IsA("GuiObject") then
            advancedProps.Size = tostring(instance.Size)
            advancedProps.Position = tostring(instance.Position)
            advancedProps.Visible = tostring(instance.Visible)
        end
    end)
    
    if next(advancedProps) then
        addPropertySection("⚡ Advanced", advancedProps)
    end

    propsScroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

-- Tree item creation
local function addTreeItem(parent, instance, depth, yPos)
    local indent = depth * 20
    local isExpanded = expandedInstances[instance]
    
    -- Main button frame
    local itemFrame = createFrame({
        Size = UDim2.new(1, -5, 0, 22),
        Position = UDim2.new(0, 5, 0, yPos),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    -- Expand/collapse button for items with children
    local hasChildren = #instance:GetChildren() > 0
    if hasChildren then
        local expandBtn = createTextButton({
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new(0, indent, 0, 3),
            BackgroundColor3 = THEME.tertiary,
            Text = isExpanded and "−" or "+",
            TextColor3 = THEME.text,
            TextSize = 12,
            Font = Enum.Font.SourceSansBold,
            BorderSizePixel = 0,
            Parent = itemFrame
        })
        Instance.new("UICorner", expandBtn).CornerRadius = UDim.new(0, 8)
        
        trackConnection(expandBtn.MouseButton1Click:Connect(function()
            expandedInstances[instance] = not isExpanded
            buildTree() -- This will be defined later
        end))
    end
    
    -- Instance button
    local btn = createTextButton({
        Size = UDim2.new(1, -indent - (hasChildren and 20 or 5), 0, 20),
        Position = UDim2.new(0, indent + (hasChildren and 20 or 0), 0, 1),
        BackgroundTransparency = 1,
        Text = getClassIcon(instance.ClassName) .. " " .. instance.Name,
        TextColor3 = THEME.text,
        TextSize = 11,
        Font = Enum.Font.SourceSans,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = itemFrame
    })
    
    -- Hover effect
    trackConnection(btn.MouseEnter:Connect(function()
        animateColor(btn, Color3.fromRGB(60, 60, 70), 0.1)
    end))
    
    trackConnection(btn.MouseLeave:Connect(function()
        if selectedInstance ~= instance then
            animateColor(btn, Color3.fromRGB(0, 0, 0), 0.1)
            btn.BackgroundTransparency = 1
        end
    end))
    
    -- Selection
    trackConnection(btn.MouseButton1Click:Connect(function()
        selectedInstance = instance
        
        -- Update all buttons
        for _, item in pairs(treeItems) do
            if item and item:FindFirstChild("Button") then
                local itemBtn = item.Button
                if itemBtn ~= btn then
                    animateColor(itemBtn, Color3.fromRGB(0, 0, 0), 0.1)
                    itemBtn.BackgroundTransparency = 1
                end
            end
        end
        
        -- Highlight selected
        btn.BackgroundTransparency = 0
        animateColor(btn, THEME.accent, 0.1)
        
        showProperties(instance)
    end))
    
    itemFrame.Button = btn
    table.insert(treeItems, itemFrame)
    yPos = yPos + 24
    
    -- Add children if expanded
    if isExpanded and hasChildren then
        local children = instance:GetChildren()
        table.sort(children, function(a, b)
            return a.Name < b.Name
        end)
        
        for _, child in ipairs(children) do
            if passesFilter(child) then
                yPos = addTreeItem(parent, child, depth + 1, yPos)
            end
        end
    end
    
    return yPos
end

-- Build tree function - NOW PROPERLY DEFINED
function buildTree()
    clearTree()
    local yPos = 5
    
    for _, serviceData in ipairs(SERVICES) do
        local serviceFrame = createFrame({
            Size = UDim2.new(1, -5, 0, 26),
            Position = UDim2.new(0, 5, 0, yPos),
            BackgroundColor3 = Color3.fromRGB(40, 40, 50),
            BorderSizePixel = 0,
            Parent = treeScroll
        })
        Instance.new("UICorner", serviceFrame).CornerRadius = UDim.new(0, 6)
        
        -- Service expand button
        local expandBtn = createTextButton({
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 3, 0, 3),
            BackgroundColor3 = THEME.accent,
            Text = serviceData.expanded and "−" or "+",
            TextColor3 = THEME.text,
            TextSize = 12,
            Font = Enum.Font.SourceSansBold,
            BorderSizePixel = 0,
            Parent = serviceFrame
        })
        Instance.new("UICorner", expandBtn).CornerRadius = UDim.new(0, 10)
        
        -- Service label
        local serviceLabel = createTextLabel({
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 28, 0, 0),
            BackgroundTransparency = 1,
            Text = serviceData.icon .. " " .. serviceData.name,
            TextColor3 = THEME.text,
            TextSize = 13,
            Font = Enum.Font.SourceSansBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = serviceFrame
        })
        
        -- Service expand functionality
        trackConnection(expandBtn.MouseButton1Click:Connect(function()
            serviceData.expanded = not serviceData.expanded
            buildTree()
        end))
        
        table.insert(treeItems, serviceFrame)
        yPos = yPos + 30
        
        -- Add service children if expanded
        if serviceData.expanded then
            local children = serviceData.service:GetChildren()
            table.sort(children, function(a, b) return a.Name < b.Name end)
            
            for _, child in ipairs(children) do
                if passesFilter(child) then
                    yPos = addTreeItem(treeScroll, child, 1, yPos)
                end
            end
            yPos = yPos + 5
        end
    end
    
    treeScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(yPos, 100))
end

-- Search functionality
local function performSearch(query)
    if query == "" then
        buildTree()
        return
    end
    
    clearTree()
    local yPos = 5
    local results = {}
    
    -- Search through all services
    local function searchInInstance(instance, path)
        path = path or instance.Name
        if instance.Name:lower():find(query:lower()) then
            table.insert(results, {instance = instance, path = path})
        end
        
        for _, child in ipairs(instance:GetChildren()) do
            searchInInstance(child, path .. " > " .. child.Name)
        end
    end
    
    for _, serviceData in ipairs(SERVICES) do
        searchInInstance(serviceData.service)
    end
    
    -- Display search results
    for _, result in ipairs(results) do
        if passesFilter(result.instance) then
            local resultFrame = createFrame({
                Size = UDim2.new(1, -10, 0, 24),
                Position = UDim2.new(0, 5, 0, yPos),
                BackgroundColor3 = Color3.fromRGB(45, 45, 55),
                BorderSizePixel = 0,
                Parent = treeScroll
            })
            Instance.new("UICorner", resultFrame).CornerRadius = UDim.new(0, 4)
            
            local resultBtn = createTextButton({
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = getClassIcon(result.instance.ClassName) .. " " .. result.path,
                TextColor3 = THEME.text,
                TextSize = 10,
                Font = Enum.Font.SourceSans,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                Parent = resultFrame
            })
            
            trackConnection(resultBtn.MouseButton1Click:Connect(function()
                selectedInstance = result.instance
                showProperties(result.instance)
                animateColor(resultFrame, THEME.accent, 0.15)
            end))
            
            table.insert(treeItems, resultFrame)
            yPos = yPos + 28
        end
    end
    
    if #results == 0 then
        local noResults = createTextLabel({
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, yPos),
            BackgroundTransparency = 1,
            Text = "No results found for '" .. query .. "'",
            TextColor3 = THEME.textMuted,
            TextSize = 12,
            Font = Enum.Font.SourceSansItalic,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = treeScroll
        })
        table.insert(treeItems, noResults)
        yPos = yPos + 35
    end
    
    treeScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(yPos, 100))
    statusText.Text = "Search: " .. #results .. " results for '" .. query .. "'"
end

-- Search box functionality
local searchDebounce = false
trackConnection(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    if searchDebounce then return end
    searchDebounce = true
    
    task.spawn(function()
        task.wait(0.3) -- Debounce search
        performSearch(searchBox.Text)
        searchDebounce = false
    end)
end))

-- Window dragging with smooth animation
local dragging = false
local dragStart, startPos

trackConnection(titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = shadowFrame.Position
        
        local dragTween = TweenService:Create(shadowFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 814, 0, 564)}
        )
        dragTween:Play()
    end
end))

trackConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        shadowFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end))

trackConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
        dragging = false
        
        local releaseTween = TweenService:Create(shadowFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            {Size = UDim2.new(0, 810, 0, 560)}
        )
        releaseTween:Play()
    end
end))

-- Window controls functionality
local isMinimized = false
local originalSize = shadowFrame.Size
local originalPosition = shadowFrame.Position

trackConnection(minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    local targetSize = isMinimized and UDim2.new(0, 810, 0, 45) or originalSize
    local tween = TweenService:Create(shadowFrame,
        TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = targetSize}
    )
    tween:Play()
    
    contentFrame.Visible = not isMinimized
    toolbar.Visible = not isMinimized
    statusBar.Visible = not isMinimized
    
    minimizeBtn.Text = isMinimized and "□" or "−"
    animateColor(minimizeBtn, isMinimized and THEME.success or THEME.warning)
end))

local isMaximized = false
trackConnection(maximizeBtn.MouseButton1Click:Connect(function()
    isMaximized = not isMaximized
    
    local targetSize = isMaximized and UDim2.new(0, 1200, 0, 700) or originalSize
    local targetPosition = isMaximized and UDim2.new(0.5, -600, 0.5, -350) or originalPosition
    
    local sizeTween = TweenService:Create(shadowFrame,
        TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Size = targetSize, Position = targetPosition}
    )
    sizeTween:Play()
    
    maximizeBtn.Text = isMaximized and "⧉" or "□"
end))

-- Enhanced close with animation
trackConnection(closeBtn.MouseButton1Click:Connect(function()
    local closeTween = TweenService:Create(shadowFrame,
        TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
        {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        }
    )
    closeTween:Play()
    
    closeTween.Completed:Connect(function()
        screenGui:Destroy()
    end)
end))

-- Button hover effects
local buttons = {closeBtn, minimizeBtn, maximizeBtn, refreshBtn}
for _, btn in ipairs(buttons) do
    local originalColor = btn.BackgroundColor3
    
    trackConnection(btn.MouseEnter:Connect(function()
        animateColor(btn, Color3.new(
            math.min(originalColor.R + 0.1, 1),
            math.min(originalColor.G + 0.1, 1),
            math.min(originalColor.B + 0.1, 1)
        ))
        -- Fixed scale animation
        local tween = TweenService:Create(btn,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(btn.Size.X.Scale * 1.05, btn.Size.X.Offset, btn.Size.Y.Scale * 1.05, btn.Size.Y.Offset)}
        )
        tween:Play()
    end))
    
    trackConnection(btn.MouseLeave:Connect(function()
        animateColor(btn, originalColor)
        local tween = TweenService:Create(btn,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {Size = UDim2.new(btn.Size.X.Scale / 1.05, btn.Size.X.Offset, btn.Size.Y.Scale / 1.05, btn.Size.Y.Offset)}
        )
        tween:Play()
    end))
end

-- Refresh functionality
trackConnection(refreshBtn.MouseButton1Click:Connect(function()
    -- Refresh animation
    local refreshTween = TweenService:Create(refreshBtn,
        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 0),
        {Rotation = 360}
    )
    refreshTween:Play()
    
    refreshTween.Completed:Connect(function()
        refreshBtn.Rotation = 0
    end)
    
    -- Clear search and rebuild
    searchBox.Text = ""
    selectedInstance = nil
    expandedInstances = {}
    buildTree()
    clearProps()
    statusText.Text = "Tree refreshed"
    
    -- Flash status
    local statusFlash = TweenService:Create(statusText,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, true),
        {TextColor3 = THEME.success}
    )
    statusFlash:Play()
end))

-- Keyboard shortcuts
trackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Enum.KeyCode.F5 then
            refreshBtn.MouseButton1Click:Fire()
        elseif input.KeyCode == Enum.KeyCode.F and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            searchBox:CaptureFocus()
        elseif input.KeyCode == Enum.KeyCode.Escape then
            if searchBox:IsFocused() then
                searchBox:ReleaseFocus()
                searchBox.Text = ""
            end
        end
    end
end))

-- Cleanup on destroy
screenGui.Destroying:Connect(function()
    for _, conn in ipairs(connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(connections)
    clearTree()
    clearProps()
    table.clear(expandedInstances)
end)

-- Initialize with smooth entrance animation
task.spawn(function()
    -- Start hidden
    shadowFrame.Size = UDim2.new(0, 0, 0, 0)
    shadowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    task.wait(0.1)
    
    -- Smooth entrance
    local entranceTween = TweenService:Create(shadowFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 810, 0, 560),
            Position = UDim2.new(0.5, -405, 0.5, -280)
        }
    )
    entranceTween:Play()
    
    entranceTween.Completed:Connect(function()
        buildTree()
        statusText.Text = "Enhanced Nebula Explorer ready • F5: Refresh • Ctrl+F: Search • ESC: Clear"
    end)
end)

print("✨ Enhanced Nebula Explorer loaded successfully!")
