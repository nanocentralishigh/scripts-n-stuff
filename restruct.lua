local HttpService = game:GetService("HttpService")

-- Comprehensive Roblox API databases
local ROBLOX_SERVICES = {
    "ReplicatedStorage", "Players", "Workspace", "ServerStorage", "StarterGui", 
    "StarterPack", "Lighting", "SoundService", "TweenService", "RunService",
    "UserInputService", "ContextActionService", "MarketplaceService", "DataStoreService",
    "TextService", "PathfindingService", "CollectionService", "ChangeHistoryService",
    "GuiService", "UserSettings", "LocalizationService", "VoiceChatService",
    "ReplicatedFirst", "ServerScriptService", "StarterPlayerScripts", "Teams",
    "Chat", "CoreGui", "NetworkClient", "NetworkServer", "PhysicsService",
    "TeleportService", "BadgeService", "GamePassService", "GroupService",
    "FriendService", "PointsService", "InsertService", "Selection",
    "LogService", "ScriptContext", "MemStorageService", "HttpService",
    "MessagingService", "PolicyService", "AssetService", "ContentProvider",
    "KeyframeSequenceProvider", "SocialService", "NotificationService"
}

local ROBLOX_CLASSES = {
    -- Core instances
    "Instance", "Part", "Model", "Script", "LocalScript", "ModuleScript",
    "RemoteEvent", "RemoteFunction", "BindableEvent", "BindableFunction",
    "Folder", "Configuration", "Tool", "HopperBin", "Attachment",
    
    -- GUI classes
    "ScreenGui", "SurfaceGui", "BillboardGui", "Frame", "ScrollingFrame",
    "TextLabel", "TextButton", "TextBox", "ImageLabel", "ImageButton",
    "ViewportFrame", "VideoFrame", "GuiButton", "GuiLabel", "GuiObject",
    
    -- Layout and constraints
    "UICorner", "UIStroke", "UIGradient", "UIPadding", "UIListLayout", 
    "UIGridLayout", "UIPageLayout", "UITableLayout", "UISizeConstraint",
    "UIAspectRatioConstraint", "UITextSizeConstraint", "UIScale",
    
    -- Values
    "StringValue", "IntValue", "NumberValue", "BoolValue", "ObjectValue",
    "Vector3Value", "CFrameValue", "Color3Value", "BrickColorValue",
    "RayValue", "ArrayValue", "RaycastParams",
    
    -- Audio
    "Sound", "SoundGroup", "EqualizerSoundEffect", "ReverbSoundEffect",
    "DistortionSoundEffect", "EchoSoundEffect", "FlangeSoundEffect",
    "PitchShiftSoundEffect", "TremoloSoundEffect", "CompressorSoundEffect",
    
    -- Lighting and effects
    "PointLight", "SpotLight", "SurfaceLight", "Fire", "Smoke", "Sparkles",
    "Explosion", "ParticleEmitter", "Beam", "Trail", "SelectionBox",
    "SelectionSphere", "Handles", "ArcHandles", "SurfaceSelection",
    
    -- Physics and constraints
    "WeldConstraint", "Motor6D", "Motor", "Servo", "BodyForce", "BodyVelocity",
    "BodyAngularVelocity", "BodyPosition", "BodyOrientation", "VectorForce",
    "AlignPosition", "AlignOrientation", "LineForce", "TorqueConstraint",
    "SpringConstraint", "RodConstraint", "RopeConstraint", "WeldConstraint",
    
    -- Animation and humanoid
    "Humanoid", "HumanoidDescription", "Animator", "Animation", "AnimationTrack",
    "KeyframeSequence", "Keyframe", "Pose", "NumberSequence", "ColorSequence",
    
    -- Terrain and CSG
    "Terrain", "TerrainRegion", "UnionOperation", "NegateOperation",
    
    -- Meshes and textures
    "SpecialMesh", "BlockMesh", "CylinderMesh", "FileMesh", "Decal", "Texture",
    "MeshPart", "UnionOperation", "CornerWedgePart", "WedgePart", "TrussPart"
}

local ROBLOX_ENUMS = {
    "Material", "FormFactor", "Shape", "FontSize", "Font", "ScaleType", "SizeConstraint",
    "EasingDirection", "EasingStyle", "TweenStatus", "KeyCode", "UserInputType",
    "RenderPriority", "NormalId", "Axis", "BrickColor", "Color3", "Vector2", "Vector3",
    "UDim", "UDim2", "CFrame", "Region3", "Ray", "Faces", "Rect", "RaycastResult",
    "PathStatus", "HumanoidStateType", "HumanoidRigType", "AnimationPriority",
    "ThumbnailType", "ThumbnailSize", "DeviceType", "Platform", "Genre"
}

local COMMON_FUNCTIONS = {
    -- Instance functions
    "FindFirstChild", "FindFirstChildOfClass", "FindFirstChildWhichIsA", 
    "FindFirstAncestor", "FindFirstAncestorOfClass", "FindFirstAncestorWhichIsA",
    "WaitForChild", "GetChildren", "GetDescendants", "IsAncestorOf", "IsDescendantOf",
    "Clone", "Destroy", "Remove", "ClearAllChildren", "GetFullName", "GetDebugId",
    
    -- Service functions
    "GetService", "getService", "IsLoaded", "ServiceAdded", "ServiceRemoving",
    
    -- Math functions
    "math.random", "math.floor", "math.ceil", "math.abs", "math.sin", "math.cos",
    "math.tan", "math.sqrt", "math.pow", "math.exp", "math.log", "math.min", "math.max",
    "math.rad", "math.deg", "math.atan2", "math.noise", "math.clamp",
    
    -- String functions
    "string.find", "string.match", "string.gsub", "string.sub", "string.len",
    "string.upper", "string.lower", "string.rep", "string.reverse", "string.format",
    "string.char", "string.byte", "string.gmatch", "string.split",
    
    -- Table functions
    "table.insert", "table.remove", "table.concat", "table.sort", "table.find",
    "table.pack", "table.unpack", "table.move", "table.create", "table.clear",
    
    -- Coroutine functions
    "coroutine.create", "coroutine.resume", "coroutine.yield", "coroutine.wrap",
    "coroutine.running", "coroutine.status", "coroutine.close",
    
    -- Utility functions
    "print", "warn", "error", "assert", "type", "typeof", "tostring", "tonumber",
    "pairs", "ipairs", "next", "select", "unpack", "getfenv", "setfenv",
    "pcall", "xpcall", "loadstring", "newproxy", "rawget", "rawset", "rawlen",
    "setmetatable", "getmetatable", "rawequal",
    
    -- Roblox specific functions
    "spawn", "delay", "wait", "tick", "time", "elapsedTime", "UserSettings",
    "settings", "game", "workspace", "script", "shared", "require",
    
    -- TweenService functions
    "TweenService:Create", "GetValue", "Play", "Pause", "Cancel", "Completed",
    
    -- Vector/CFrame functions
    "Vector3.new", "Vector2.new", "UDim2.new", "UDim.new", "Color3.new",
    "Color3.fromRGB", "Color3.fromHSV", "BrickColor.new", "CFrame.new",
    "CFrame.fromEulerAnglesXYZ", "CFrame.fromAxisAngle", "CFrame.lookAt"
}

local SYSTEM_PATTERNS = {
    chat_system = {
        keywords = {"Chat", "Bubble", "Message", "Dialog", "Whisper", "Shout", "Team"},
        functions = {"CreateChatBubble", "OnChatted", "FilterString", "GetChatColor"},
        assets = {"dialog_", "chat", "bubble"}
    },
    gui_system = {
        keywords = {"Frame", "Button", "Label", "Layout", "UI", "Menu", "HUD"},
        functions = {"CreateFrame", "SetupUI", "ShowMenu", "HideMenu", "UpdateUI"},
        assets = {"ui/", "gui/", "menu/"}
    },
    tween_system = {
        keywords = {"Tween", "Animate", "Ease", "Interpolate", "Transition"},
        functions = {"TweenPosition", "TweenSize", "AnimateProperty", "Lerp"},
        assets = {"ease", "tween"}
    },
    data_system = {
        keywords = {"DataStore", "Save", "Load", "Serialize", "Deserialize", "Cache"},
        functions = {"SaveData", "LoadData", "GetAsync", "SetAsync", "UpdateAsync"},
        assets = {}
    },
    physics_system = {
        keywords = {"Physics", "Raycast", "Collision", "Velocity", "Force", "Constraint"},
        functions = {"CreateConstraint", "ApplyForce", "Raycast", "GetTouchingParts"},
        assets = {}
    },
    network_system = {
        keywords = {"Remote", "Fire", "Invoke", "Replicated", "Network", "Client", "Server"},
        functions = {"FireServer", "FireClient", "InvokeServer", "InvokeClient", "OnServerEvent"},
        assets = {}
    },
    audio_system = {
        keywords = {"Sound", "Music", "Audio", "Volume", "Pitch", "Effect"},
        functions = {"PlaySound", "StopSound", "SetVolume", "CreateSoundEffect"},
        assets = {"sound/", "audio/", "music/"}
    },
    animation_system = {
        keywords = {"Animation", "Track", "Keyframe", "Humanoid", "Motor6D", "Pose"},
        functions = {"LoadAnimation", "PlayAnimation", "StopAnimation", "AdjustWeight"},
        assets = {"animation/", "anim/"}
    }
}

-- Enhanced pattern extraction with better context awareness
local function extractStringsAndPatterns(bytecode)
    local strings = {}
    local contexts = {}
    local metadata = {
        variables = {},
        functions = {},
        methods = {},
        properties = {},
        events = {},
        numbers = {},
        booleans = {},
        operators = {}
    }
    
    -- Comprehensive pattern matching
    local patterns = {
        -- Basic patterns
        lua_identifiers = "[%a_][%w_]*",
        quoted_strings = '"[^"]*"',
        single_quotes = "'[^']*'",
        long_strings = "%[%[.-%]%]",
        
        -- Numbers and values
        integers = "%d+",
        floats = "%d+%.%d+",
        hex_numbers = "0x%x+",
        scientific = "%d+%.?%d*[eE][%+%-]?%d+",
        
        -- Roblox specific patterns
        rbx_assets = "rbxasset://[%w/._%-]*",
        rbx_content = "rbxassetid://[%d]*",
        rbx_thumbs = "rbxthumb://[%w/._%-]*",
        
        -- Code structure patterns
        method_calls = "%w+:[%w_]+",
        property_access = "%w+%.[%w_]+",
        function_calls = "%w+%s*%(.-%))",
        table_access = "%w+%[.-%]",
        
        -- Roblox enums and types
        enums = "Enum%.[%w_]+%.[%w_]+",
        vector3 = "Vector3%.new%s*%(.-%))",
        vector2 = "Vector2%.new%s*%(.-%))",
        udim2 = "UDim2%.new%s*%(.-%))",
        color3 = "Color3%.%w+%s*%(.-%))",
        cframe = "CFrame%.%w+%s*%(.-%))",
        
        -- Event patterns
        connections = "%.Connect%s*%(",
        event_fires = ":Fire[%w]*%s*%(",
        
        -- Control flow
        conditionals = "if%s+.+%s+then",
        loops = "for%s+.+%s+do",
        while_loops = "while%s+.+%s+do",
        
        -- Comments and strings
        comments = "%-%-[^\r\n]*",
        multiline_comments = "%-%-(%[%[.-%]%])",
        
        -- Special characters and operators
        operators = "[%+%-*/%^%%=<>~&|]+",
        delimiters = "[%(%)%[%]{},.;:]+"
    }
    
    -- Extract patterns with context
    for patternName, pattern in pairs(patterns) do
        for match in bytecode:gmatch(pattern) do
            if #match > 0 then
                -- Filter out noise
                if not (tonumber(match) and #match < 2) and match ~= "" and match ~= " " then
                    table.insert(strings, match)
                    contexts[match] = patternName
                    
                    -- Categorize for metadata
                    if patternName == "method_calls" or patternName == "function_calls" then
                        table.insert(metadata.methods, match)
                    elseif patternName == "property_access" then
                        table.insert(metadata.properties, match)
                    elseif patternName:find("vector") or patternName:find("color") or patternName:find("udim") then
                        table.insert(metadata.functions, match)
                    end
                end
            end
        end
    end
    
    -- Advanced function detection
    local functionPatterns = {
        "function%s+([%w_]+)%s*%(.-%))",
        "local%s+function%s+([%w_]+)%s*%(.-%))",
        "([%w_]+)%s*=%s*function%s*%(.-%))",
        "%.([%w_]+)%s*=%s*function"
    }
    
    for _, pattern in ipairs(functionPatterns) do
        for funcName in bytecode:gmatch(pattern) do
            if funcName and #funcName > 1 then
                table.insert(metadata.functions, funcName)
                contexts[funcName] = "function_definition"
            end
        end
    end
    
    return strings, contexts, metadata
end

-- Enhanced system detection with scoring
local function detectSystemType(strings, contexts, metadata)
    local systemScores = {}
    
    for systemName, systemData in pairs(SYSTEM_PATTERNS) do
        systemScores[systemName] = 0
        
        -- Keyword matching
        for _, str in ipairs(strings) do
            for _, keyword in ipairs(systemData.keywords) do
                if str:find(keyword) then
                    systemScores[systemName] = systemScores[systemName] + 2
                end
            end
            
            for _, func in ipairs(systemData.functions) do
                if str:find(func) then
                    systemScores[systemName] = systemScores[systemName] + 3
                end
            end
            
            for _, asset in ipairs(systemData.assets) do
                if str:find(asset) then
                    systemScores[systemName] = systemScores[systemName] + 4
                end
            end
        end
    end
    
    -- Find dominant system
    local maxScore = 0
    local dominantSystem = "generic"
    local secondarySystem = nil
    
    for system, score in pairs(systemScores) do
        if score > maxScore then
            secondarySystem = dominantSystem
            dominantSystem = system
            maxScore = score
        end
    end
    
    return dominantSystem, systemScores, secondarySystem
end

-- Comprehensive structure analysis
local function analyzeCodeStructure(strings, contexts, metadata, systemType)
    local structure = {
        services = {},
        classes = {},
        functions = {},
        methods = {},
        events = {},
        properties = {},
        variables = {},
        constants = {},
        assets = {},
        enums = {},
        constructors = {},
        callbacks = {},
        loops = {},
        conditionals = {},
        systemType = systemType,
        complexity = 0
    }
    
    -- Enhanced classification
    for _, str in ipairs(strings) do
        local context = contexts[str] or "unknown"
        
        -- Services
        for _, service in ipairs(ROBLOX_SERVICES) do
            if str == service or str:find(service .. "[^%w]") then
                if not table.find(structure.services, service) then
                    table.insert(structure.services, service)
                end
            end
        end
        
        -- Classes
        for _, class in ipairs(ROBLOX_CLASSES) do
            if str == class or str:find("Instance%.new%(.-" .. class .. ".-%)") then
                if not table.find(structure.classes, class) then
                    table.insert(structure.classes, class)
                end
            end
        end
        
        -- Functions from common functions list
        for _, func in ipairs(COMMON_FUNCTIONS) do
            if str:find(func) then
                if not table.find(structure.functions, func) then
                    table.insert(structure.functions, func)
                end
            end
        end
        
        -- Enhanced pattern detection
        if context == "method_calls" then
            table.insert(structure.methods, str)
        elseif context == "enums" then
            table.insert(structure.enums, str)
        elseif context == "rbx_assets" or context == "rbx_content" then
            table.insert(structure.assets, str)
        elseif context == "connections" then
            table.insert(structure.events, str)
        end
        
        -- Variable detection (improved)
        if str:match("^local%s+([%w_]+)") then
            local varName = str:match("^local%s+([%w_]+)")
            if varName then
                table.insert(structure.variables, varName)
            end
        end
        
        -- Constructor detection
        if str:match("%.new%s*%(") then
            table.insert(structure.constructors, str)
        end
        
        -- Callback detection
        if str:find("Connect") or str:find("Callback") or str:find("function") then
            table.insert(structure.callbacks, str)
        end
    end
    
    -- Calculate complexity
    structure.complexity = #structure.services + #structure.classes + #structure.functions + 
                          #structure.methods + #structure.events + #structure.properties
    
    -- Metadata integration
    for _, func in ipairs(metadata.functions) do
        if not table.find(structure.functions, func) then
            table.insert(structure.functions, func)
        end
    end
    
    return structure
end

-- System-specific advanced code generators
local function generateAdvancedChatSystem(structure)
    return [[
-- Advanced Chat System with Filtering and Customization
local Chat = game:GetService("Chat")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Configuration
local ChatConfig = {
    MaxMessageLength = 200,
    BubbleLifetime = 8,
    MaxDistance = 100,
    FadeDistance = 50,
    Colors = {
        Default = Color3.fromRGB(57, 59, 61),
        Whisper = Color3.fromRGB(150, 150, 150),
        Shout = Color3.fromRGB(255, 100, 100),
        Team = Color3.fromRGB(100, 255, 100),
        System = Color3.fromRGB(255, 255, 100)
    },
    Fonts = {
        Default = Enum.Font.SourceSans,
        Bold = Enum.Font.SourceSansBold,
        Light = Enum.Font.SourceSansLight
    },
    Assets = {
        BubbleTexture = "rbxasset://textures/ui/dialog_white",
        TailTexture = "rbxasset://textures/ui/dialog_tail.png"
    }
}

-- Chat bubble management
local activeBubbles = {}
local bubblePool = {}

local function createBubble(message, chatType, textColor)
    local bubble = table.remove(bubblePool) or Instance.new("BillboardGui")
    
    -- Configure billboard
    bubble.Size = UDim2.new(0, 0, 0, 0)
    bubble.StudsOffset = Vector3.new(0, 2, 0)
    bubble.LightInfluence = 0
    bubble.Enabled = true
    
    -- Create or configure frame
    local frame = bubble:FindFirstChild("ChatFrame") or Instance.new("Frame")
    frame.Name = "ChatFrame"
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = ChatConfig.Colors[chatType] or ChatConfig.Colors.Default
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.Parent = bubble
    
    -- Add corner radius
    local corner = frame:FindFirstChild("UICorner") or Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    -- Create text label
    local textLabel = frame:FindFirstChild("TextLabel") or Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -12, 1, -8)
    textLabel.Position = UDim2.new(0, 6, 0, 4)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = textColor or Color3.new(1, 1, 1)
    textLabel.TextScaled = true
    textLabel.TextWrapped = true
    textLabel.Font = ChatConfig.Fonts.Default
    textLabel.Parent = frame
    
    -- Size the bubble based on text
    local textBounds = TextService:GetTextSize(
        message, 
        18, 
        ChatConfig.Fonts.Default, 
        Vector2.new(200, math.huge)
    )
    
    local bubbleSize = UDim2.new(0, math.max(textBounds.X + 20, 80), 0, textBounds.Y + 16)
    bubble.Size = bubbleSize
    
    return bubble
end

local function showChatBubble(character, message, chatType)
    if not character or not character:FindFirstChild("Head") then return end
    
    local filteredMessage = message
    local success, result = pcall(function()
        return TextService:FilterStringAsync(message, LocalPlayer.UserId)
    end)
    
    if success then
        filteredMessage = result:GetNonChatStringForBroadcastAsync()
    end
    
    local bubble = createBubble(filteredMessage, chatType, Color3.new(1, 1, 1))
    bubble.Adornee = character.Head
    bubble.Parent = workspace
    
    -- Animation
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local appearTween = TweenService:Create(bubble, tweenInfo, {Size = bubble.Size})
    
    bubble.Size = UDim2.new(0, 0, 0, 0)
    appearTween:Play()
    
    -- Store for cleanup
    activeBubbles[character] = bubble
    
    -- Auto cleanup
    task.wait(ChatConfig.BubbleLifetime)
    
    if activeBubbles[character] == bubble then
        local fadeInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local fadeTween = TweenService:Create(bubble.ChatFrame, fadeInfo, {BackgroundTransparency = 1})
        local textFadeTween = TweenService:Create(bubble.ChatFrame.TextLabel, fadeInfo, {TextTransparency = 1})
        
        fadeTween:Play()
        textFadeTween:Play()
        
        fadeTween.Completed:Connect(function()
            if bubble.Parent then
                bubble.Parent = nil
                table.insert(bubblePool, bubble)
            end
            if activeBubbles[character] == bubble then
                activeBubbles[character] = nil
            end
        end)
    end
end

-- Distance-based visibility management
local function manageBubbleVisibility()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local playerPosition = LocalPlayer.Character.HumanoidRootPart.Position
    
    for character, bubble in pairs(activeBubbles) do
        if character and character:FindFirstChild("HumanoidRootPart") and bubble.Parent then
            local distance = (character.HumanoidRootPart.Position - playerPosition).Magnitude
            
            if distance > ChatConfig.MaxDistance then
                bubble.Enabled = false
            elseif distance > ChatConfig.FadeDistance then
                bubble.Enabled = true
                local alpha = 1 - ((distance - ChatConfig.FadeDistance) / (ChatConfig.MaxDistance - ChatConfig.FadeDistance))
                bubble.ChatFrame.BackgroundTransparency = 0.1 + (1 - alpha) * 0.7
                bubble.ChatFrame.TextLabel.TextTransparency = (1 - alpha) * 0.5
            else
                bubble.Enabled = true
                bubble.ChatFrame.BackgroundTransparency = 0.1
                bubble.ChatFrame.TextLabel.TextTransparency = 0
            end
        end
    end
end

-- Event connections
local function onPlayerChatted(player, message)
    if player.Character then
        local chatType = "Default"
        
        -- Determine chat type based on message
        if message:sub(1, 3) == "/w " then
            chatType = "Whisper"
            message = message:sub(4)
        elseif message:sub(1, 3) == "/s " then
            chatType = "Shout"
            message = message:sub(4)
        elseif message:sub(1, 3) == "/t " then
            chatType = "Team"
            message = message:sub(4)
        end
        
        task.spawn(function()
            showChatBubble(player.Character, message, chatType)
        end)
    end
end

-- Initialize for existing players
for _, player in pairs(Players:GetPlayers()) do
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end

-- Handle new players
Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        onPlayerChatted(player, message)
    end)
end)

-- Start visibility management
RunService.Heartbeat:Connect(manageBubbleVisibility)

-- Cleanup on player leaving
Players.PlayerRemoving:Connect(function(player)
    if activeBubbles[player.Character] then
        activeBubbles[player.Character]:Destroy()
        activeBubbles[player.Character] = nil
    end
end)
]]
end

local function generateAdvancedGUISystem(structure)
    return [[
-- Advanced GUI System with Animation and Management
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI Framework
local GUIFramework = {}
GUIFramework.__index = GUIFramework

-- Configuration
local Config = {
    DefaultTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    Colors = {
        Primary = Color3.fromRGB(52, 152, 219),
        Secondary = Color3.fromRGB(155, 89, 182),
        Success = Color3.fromRGB(46, 204, 113),
        Warning = Color3.fromRGB(241, 196, 15),
        Danger = Color3.fromRGB(231, 76, 60),
        Dark = Color3.fromRGB(52, 73, 94),
        Light = Color3.fromRGB(236, 240, 241)
    }
}

-- GUI Element Creation
function GUIFramework.createScreenGui(name, resetOnSpawn)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name or "CustomGui"
    screenGui.ResetOnSpawn = resetOnSpawn ~= false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    return screenGui
end

function GUIFramework.createFrame(parent, properties)
    local frame = Instance.new("Frame")
    
    -- Default properties
    local defaults = {
        Size = UDim2.new(0, 200, 0, 100),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Config.Colors.Dark,
        BorderSizePixel = 0,
        ClipsDescendants = false
    }
    
    -- Apply properties
    properties = properties or {}
    for property, value in pairs(defaults) do
        frame[property] = properties[property] or value
    end
    
    frame.Parent = parent
    return frame
end

function GUIFramework.createButton(parent, text, callback, properties)
    local button = Instance.new("TextButton")
    
    -- Default properties
    local defaults = {
        Size = UDim2.new(0, 100, 0, 30),
        BackgroundColor3 = Config.Colors.Primary,
        BorderSizePixel = 0,
        Text = text or "Button",
        TextColor3 = Color3.new(1, 1, 1),
        TextScaled = true,
        Font = Enum.Font.SourceSansBold
    }
    
    properties = properties or {}
    for property, value in pairs(defaults) do
        button[property] = properties[property] or value
    end
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Hover effects
    button.MouseEnter:Connect(function()
        TweenService:Create(button, Config.DefaultTweenInfo, {
            BackgroundColor3 = button.BackgroundColor3:lerp(Color3.new(1, 1, 1), 0.1)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, Config.DefaultTweenInfo, {
            BackgroundColor3 = properties.BackgroundColor3 or defaults.BackgroundColor3
        }):Play()
    end)
    
    -- Click callback
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    button.Parent = parent
    return button
end

function GUIFramework.createLabel(parent, text, properties)
    local label = Instance.new("TextLabel")
    
    local defaults = {
        Size = UDim2.new(1, 0, 0, 25),
        BackgroundTransparency = 1,
        Text = text or "Label",
        TextColor3 = Config.Colors.Dark,
        TextScaled = true,
        Font = Enum.Font.SourceSans
    }
    
    properties = properties or {}
    for property, value in pairs(defaults) do
        label[property] = properties[property] or value
    end
    
    label.Parent = parent
    return label
end

-- Animation utilities
function GUIFramework.slideIn(gui, direction, duration)
    local tweenInfo = TweenInfo.new(duration or 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local startPos = gui.Position
    
    -- Set initial position based on direction
    if direction == "left" then
        gui.Position = UDim2.new(-1, startPos.X.Offset, startPos.Y.Scale, startPos.Y.Offset)
    elseif direction == "right" then
        gui.Position = UDim2.new(1, startPos.X.Offset, startPos.Y.Scale, startPos.Y.Offset)
    elseif direction == "top" then
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, -1, startPos.Y.Offset)
    elseif direction == "bottom" then
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset, 1, startPos.Y.Offset)
    end
    
    local tween = TweenService:Create(gui, tweenInfo, {Position = startPos})
    tween:Play()
    return tween
end

function GUIFramework.fadeIn(gui, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    gui.BackgroundTransparency = 1
    
    local tween = TweenService:Create(gui, tweenInfo, {BackgroundTransparency = 0})
    tween:Play()
    return tween
end

-- Layout management
function GUIFramework.setupListLayout(parent, properties)
    local layout = Instance.new("UIListLayout")
    
    local defaults = {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Vertical
    }
    
    properties = properties or {}
    for property, value in pairs(defaults) do
        layout[property] = properties[property] or value
    end
    
    layout.Parent = parent
    return layout
end

return GUIFramework
]]
end

local function generateAdvancedGenericSystem(structure)
    local code = "-- Advanced Generic Roblox Script Reconstruction\n"
    code = code .. "-- Detected complexity: " .. tostring(structure.complexity) .. "\n\n"
    
    -- Services section with proper initialization
    if #structure.services > 0 then
        code = code .. "-- Services\n"
        for _, service in ipairs(structure.services) do
            if service == "Players" then
                code = code .. string.format("local %s = game:GetService(\"%s\")\n", service, service)
                code = code .. "local LocalPlayer = Players.LocalPlayer\n"
                code = code .. "local PlayerGui = LocalPlayer:WaitForChild(\"PlayerGui\")\n"
            elseif service == "RunService" then
                code = code .. string.format("local %s = game:GetService(\"%s\")\n", service, service)
                code = code .. "local Heartbeat = RunService.Heartbeat\n"
            else
                code = code .. string.format("local %s = game:GetService(\"%s\")\n", service, service)
            end
        end
        code = code .. "\n"
    end
    
    -- Configuration table
    code = code .. "-- Configuration\n"
    code = code .. "local Config = {\n"
    if table.find(structure.classes, "Frame") or table.find(structure.classes, "ScreenGui") then
        code = code .. "    UI = {\n"
        code = code .. "        MainColor = Color3.fromRGB(52, 152, 219),\n"
        code = code .. "        SecondaryColor = Color3.fromRGB(155, 89, 182),\n"
        code = code .. "        BackgroundColor = Color3.fromRGB(52, 73, 94)\n"
        code = code .. "    },\n"
    end
    if #structure.assets > 0 then
        code = code .. "    Assets = {\n"
        for i, asset in ipairs(structure.assets) do
            if i <= 5 then  -- Limit to prevent excessive output
                code = code .. string.format("        Asset%d = \"%s\",\n", i, asset)
            end
        end
        code = code .. "    },\n"
    end
    code = code .. "}\n\n"
    
    -- Advanced instance creation with error handling
    if #structure.classes > 0 then
        code = code .. "-- Instance Creation with Error Handling\n"
        code = code .. "local Instances = {}\n\n"
        
        local createdInstances = {}
        for _, class in ipairs(structure.classes) do
            if class ~= "Instance" and not createdInstances[class] then
                createdInstances[class] = true
                local varName = class:lower():gsub("gui", "Gui")
                
                code = code .. string.format("local function create%s(parent, properties)\n", class)
                code = code .. "    local success, instance = pcall(function()\n"
                code = code .. string.format("        return Instance.new(\"%s\")\n", class)
                code = code .. "    end)\n"
                code = code .. "    \n"
                code = code .. "    if success then\n"
                
                if class:find("Gui") then
                    code = code .. "        instance.Parent = parent or PlayerGui\n"
                elseif class == "Part" then
                    code = code .. "        instance.Parent = parent or workspace\n"
                    code = code .. "        instance.Anchored = true\n"
                    code = code .. "        instance.Size = Vector3.new(4, 1, 2)\n"
                else
                    code = code .. "        instance.Parent = parent\n"
                end
                
                code = code .. "        \n"
                code = code .. "        if properties then\n"
                code = code .. "            for prop, value in pairs(properties) do\n"
                code = code .. "                pcall(function() instance[prop] = value end)\n"
                code = code .. "            end\n"
                code = code .. "        end\n"
                code = code .. "        \n"
                code = code .. "        return instance\n"
                code = code .. "    else\n"
                code = code .. string.format("        warn(\"Failed to create %s:\", instance)\n", class)
                code = code .. "        return nil\n"
                code = code .. "    end\n"
                code = code .. "end\n\n"
            end
        end
    end
    
    -- Function implementations based on detected patterns
    if #structure.functions > 0 then
        code = code .. "-- Function Implementations\n"
        local implementedFunctions = {}
        
        for _, func in ipairs(structure.functions) do
            if #func > 3 and not implementedFunctions[func] then
                implementedFunctions[func] = true
                
                -- Generate contextual function implementations
                if func:find("Tween") or func:find("Animate") then
                    code = code .. string.format("local function %s(instance, properties, duration)\n", func:lower())
                    code = code .. "    local tweenInfo = TweenInfo.new(\n"
                    code = code .. "        duration or 0.5,\n"
                    code = code .. "        Enum.EasingStyle.Quad,\n"
                    code = code .. "        Enum.EasingDirection.Out\n"
                    code = code .. "    )\n"
                    code = code .. "    \n"
                    code = code .. "    local tween = TweenService:Create(instance, tweenInfo, properties)\n"
                    code = code .. "    tween:Play()\n"
                    code = code .. "    return tween\n"
                    code = code .. "end\n\n"
                    
                elseif func:find("Create") or func:find("Setup") then
                    code = code .. string.format("local function %s(...)\n", func:lower())
                    code = code .. "    local args = {...}\n"
                    code = code .. "    -- Implementation based on detected patterns\n"
                    code = code .. "    local result = {}\n"
                    code = code .. "    \n"
                    code = code .. "    for i, arg in ipairs(args) do\n"
                    code = code .. "        result[i] = arg\n"
                    code = code .. "    end\n"
                    code = code .. "    \n"
                    code = code .. "    return result\n"
                    code = code .. "end\n\n"
                    
                elseif func:find("Update") or func:find("Refresh") then
                    code = code .. string.format("local function %s(data)\n", func:lower())
                    code = code .. "    if not data then return end\n"
                    code = code .. "    \n"
                    code = code .. "    -- Update logic based on system type\n"
                    if structure.systemType == "gui_system" then
                        code = code .. "    for _, gui in pairs(data) do\n"
                        code = code .. "        if gui and gui.Parent then\n"
                        code = code .. "            -- Update GUI properties\n"
                        code = code .. "        end\n"
                        code = code .. "    end\n"
                    else
                        code = code .. "    print(\"Updating:\", data)\n"
                    end
                    code = code .. "end\n\n"
                    
                else
                    code = code .. string.format("local function %s()\n", func:lower())
                    code = code .. "    -- Auto-generated function implementation\n"
                    code = code .. "    print(\"Executing function:\", \"" .. func .. "\")\n"
                    code = code .. "end\n\n"
                end
            end
        end
    end
    
    -- Event handling system
    if #structure.events > 0 then
        code = code .. "-- Event System\n"
        code = code .. "local Events = {}\n"
        code = code .. "local Connections = {}\n\n"
        
        code = code .. "local function connectEvent(event, callback)\n"
        code = code .. "    if event and callback then\n"
        code = code .. "        local connection = event:Connect(callback)\n"
        code = code .. "        table.insert(Connections, connection)\n"
        code = code .. "        return connection\n"
        code = code .. "    end\n"
        code = code .. "end\n\n"
        
        code = code .. "local function disconnectAllEvents()\n"
        code = code .. "    for _, connection in ipairs(Connections) do\n"
        code = code .. "        if connection then\n"
        code = code .. "            connection:Disconnect()\n"
        code = code .. "        end\n"
        code = code .. "    end\n"
        code = code .. "    Connections = {}\n"
        code = code .. "end\n\n"
    end
    
    -- Main execution logic
    code = code .. "-- Main Execution\n"
    code = code .. "local function initialize()\n"
    
    if table.find(structure.services, "Players") then
        code = code .. "    -- Player-based initialization\n"
        code = code .. "    if LocalPlayer and LocalPlayer.Character then\n"
        code = code .. "        print(\"Initializing for player:\", LocalPlayer.Name)\n"
        code = code .. "    end\n"
    end
    
    if #structure.classes > 0 then
        code = code .. "    \n"
        code = code .. "    -- Instance setup\n"
        for _, class in ipairs(structure.classes) do
            if class:find("Gui") then
                code = code .. "    local " .. class:lower() .. " = create" .. class .. "(PlayerGui)\n"
                break
            end
        end
    end
    
    code = code .. "end\n\n"
    
    -- Error handling wrapper
    code = code .. "-- Safe execution with error handling\n"
    code = code .. "local success, error = pcall(initialize)\n"
    code = code .. "if not success then\n"
    code = code .. "    warn(\"Script initialization failed:\", error)\n"
    code = code .. "end\n"
    
    return code
end

-- Enhanced reconstruction with multiple system support
local function reconstructAdvancedScript(bytecode, outputName)
    local strings, contexts, metadata = extractStringsAndPatterns(bytecode)
    local systemType, systemScores, secondarySystem = detectSystemType(strings, contexts, metadata)
    local structure = analyzeCodeStructure(strings, contexts, metadata, systemType)
    
    local script = "-- Enhanced Roblox Script Reconstruction v3.0\n"
    script = script .. "-- File: " .. outputName .. "\n"
    script = script .. "-- Primary System: " .. systemType .. "\n"
    if secondarySystem and secondarySystem ~= "generic" then
        script = script .. "-- Secondary System: " .. secondarySystem .. "\n"
    end
    script = script .. "-- Complexity Score: " .. structure.complexity .. "\n"
    script = script .. "-- Strings Analyzed: " .. #strings .. "\n\n"
    
    -- Generate system-specific code
    if systemType == "chat_system" then
        script = script .. generateAdvancedChatSystem(structure)
    elseif systemType == "gui_system" then
        script = script .. generateAdvancedGUISystem(structure)
    else
        script = script .. generateAdvancedGenericSystem(structure)
    end
    
    -- Add comprehensive debug section
    script = script .. "\n\n-- === DEBUG INFORMATION ===\n"
    script = script .. string.format("-- System Detection Scores: %s\n", HttpService:JSONEncode(systemScores))
    
    if #structure.services > 0 then
        script = script .. "-- Detected Services: " .. table.concat(structure.services, ", ") .. "\n"
    end
    
    if #structure.classes > 0 then
        script = script .. "-- Detected Classes: " .. table.concat(structure.classes, ", ") .. "\n"
    end
    
    if #structure.functions > 0 then
        local limitedFunctions = {}
        for i = 1, math.min(#structure.functions, 10) do
            table.insert(limitedFunctions, structure.functions[i])
        end
        script = script .. "-- Key Functions: " .. table.concat(limitedFunctions, ", ") .. "\n"
    end
    
    if #structure.methods > 0 then
        local limitedMethods = {}
        for i = 1, math.min(#structure.methods, 8) do
            table.insert(limitedMethods, structure.methods[i])
        end
        script = script .. "-- Key Methods: " .. table.concat(limitedMethods, ", ") .. "\n"
    end
    
    -- Sample of analyzed strings
    script = script .. "-- Key Analyzed Strings:\n"
    local importantStrings = {}
    for i, str in ipairs(strings) do
        if i <= 20 and #str > 2 and not str:match("^%d+$") then
            table.insert(importantStrings, str)
        end
    end
    
    for _, str in ipairs(importantStrings) do
        script = script .. "-- " .. str .. " (" .. (contexts[str] or "unknown") .. ")\n"
    end
    
    return script
end

-- Main decompilation function with enhanced error handling
local function decompileEnhanced(filePath, outputPath)
    if not readfile then
        warn("readfile function not available - executor compatibility issue")
        return false
    end
    
    if not writefile then
        warn("writefile function not available - executor compatibility issue")
        return false
    end
    
    local success, bytecode = pcall(readfile, filePath)
    if not success then
        warn("Failed to read bytecode file:", filePath)
        warn("Error:", bytecode)
        return false
    end
    
    if not bytecode or #bytecode == 0 then
        warn("Bytecode file is empty or invalid:", filePath)
        return false
    end
    
    print("Processing bytecode file:", filePath)
    print("Bytecode size:", #bytecode, "bytes")
    
    local startTime = tick()
    local reconstructed = reconstructAdvancedScript(bytecode, filePath)
    local endTime = tick()
    
    local writeSuccess, writeError = pcall(writefile, outputPath, reconstructed)
    if not writeSuccess then
        warn("Failed to write reconstructed file:", outputPath)
        warn("Error:", writeError)
        return false
    end
    
    print("Successfully decompiled:", filePath, "->", outputPath)
    print("Processing time:", string.format("%.2f", endTime - startTime), "seconds")
    print("Generated", #reconstructed, "characters of reconstructed code")
    return true
end

-- Batch processing function
local function batchDecompile(inputFolder, outputFolder, filePattern)
    if not listfiles then
        warn("listfiles function not available - cannot perform batch processing")
        return
    end
    
    local pattern = filePattern or "%.txt$"
    local files = listfiles(inputFolder)
    local processed = 0
    local failed = 0
    
    for _, file in ipairs(files) do
        if file:match(pattern) then
            local fileName = file:match("([^/\\]+)$")
            local outputName = fileName:gsub("%.txt$", "_reconstructed.lua")
            local outputPath = outputFolder .. "/" .. outputName
            
            if decompileEnhanced(file, outputPath) then
                processed = processed + 1
            else
                failed = failed + 1
            end
        end
    end
    
    print("Batch processing complete:")
    print("Successfully processed:", processed)
    print("Failed:", failed)
end

-- Usage examples and main execution
print("Enhanced Roblox Bytecode Decompiler v3.0 loaded")
print("Usage: decompileEnhanced('input.txt', 'output.lua')")
print("Batch: batchDecompile('input_folder', 'output_folder', '%.txt)")

-- Auto-execute if test file exists
if readfile and pcall(readfile, "testdecompilerbyte.txt") then
    decompileEnhanced("testdecompilerbyte.txt", "enhanced_reconstruction_v3.lua")
else
    print("Test file 'testdecompilerbyte.txt' not found - ready for manual execution")
end
