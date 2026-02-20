local NexusLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function getGuiParent()
    local ok1, r1 = pcall(function() return gethui() end)
    if ok1 and r1 then return r1 end
    local ok2 = pcall(function()
        local t = Instance.new("ScreenGui")
        t.Parent = game:GetService("CoreGui")
        t:Destroy()
    end)
    if ok2 then return game:GetService("CoreGui") end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getGuiParent()

local Themes = {
    Default = {
        Background = Color3.fromRGB(12, 12, 18),
        SideBar = Color3.fromRGB(16, 16, 24),
        TopBar = Color3.fromRGB(18, 18, 28),
        TabActive = Color3.fromRGB(25, 25, 40),
        TabInactive = Color3.fromRGB(16, 16, 24),
        Element = Color3.fromRGB(25, 25, 38),
        ElementHover = Color3.fromRGB(30, 30, 48),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(240, 240, 245),
        TextDark = Color3.fromRGB(150, 150, 170),
        TextDarker = Color3.fromRGB(100, 100, 120),
        Toggle_On = Color3.fromRGB(88, 101, 242),
        Toggle_Off = Color3.fromRGB(55, 55, 75),
        Slider_Fill = Color3.fromRGB(88, 101, 242),
        Slider_Bg = Color3.fromRGB(35, 35, 50),
        Dropdown_Bg = Color3.fromRGB(18, 18, 28),
        Input_Bg = Color3.fromRGB(18, 18, 28),
        Divider = Color3.fromRGB(35, 35, 50),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Error = Color3.fromRGB(237, 66, 69),
    },
    Ocean = {
        Background = Color3.fromRGB(8, 15, 22),
        SideBar = Color3.fromRGB(10, 20, 30),
        TopBar = Color3.fromRGB(12, 22, 35),
        TabActive = Color3.fromRGB(15, 30, 50),
        TabInactive = Color3.fromRGB(10, 20, 30),
        Element = Color3.fromRGB(15, 28, 42),
        ElementHover = Color3.fromRGB(20, 35, 55),
        Accent = Color3.fromRGB(0, 150, 200),
        Text = Color3.fromRGB(220, 235, 245),
        TextDark = Color3.fromRGB(120, 160, 180),
        TextDarker = Color3.fromRGB(80, 110, 130),
        Toggle_On = Color3.fromRGB(0, 150, 200),
        Toggle_Off = Color3.fromRGB(40, 60, 75),
        Slider_Fill = Color3.fromRGB(0, 150, 200),
        Slider_Bg = Color3.fromRGB(20, 40, 55),
        Dropdown_Bg = Color3.fromRGB(10, 20, 30),
        Input_Bg = Color3.fromRGB(10, 20, 30),
        Divider = Color3.fromRGB(25, 45, 60),
        Success = Color3.fromRGB(40, 200, 150),
        Warning = Color3.fromRGB(255, 180, 40),
        Error = Color3.fromRGB(255, 80, 80),
    },
    Rose = {
        Background = Color3.fromRGB(18, 10, 15),
        SideBar = Color3.fromRGB(22, 12, 20),
        TopBar = Color3.fromRGB(28, 15, 25),
        TabActive = Color3.fromRGB(40, 20, 35),
        TabInactive = Color3.fromRGB(22, 12, 20),
        Element = Color3.fromRGB(35, 18, 30),
        ElementHover = Color3.fromRGB(45, 25, 40),
        Accent = Color3.fromRGB(230, 70, 120),
        Text = Color3.fromRGB(245, 230, 240),
        TextDark = Color3.fromRGB(170, 140, 160),
        TextDarker = Color3.fromRGB(120, 90, 110),
        Toggle_On = Color3.fromRGB(230, 70, 120),
        Toggle_Off = Color3.fromRGB(70, 45, 60),
        Slider_Fill = Color3.fromRGB(230, 70, 120),
        Slider_Bg = Color3.fromRGB(45, 25, 40),
        Dropdown_Bg = Color3.fromRGB(22, 12, 20),
        Input_Bg = Color3.fromRGB(22, 12, 20),
        Divider = Color3.fromRGB(50, 30, 45),
        Success = Color3.fromRGB(100, 200, 130),
        Warning = Color3.fromRGB(250, 170, 50),
        Error = Color3.fromRGB(255, 60, 60),
    },
    Emerald = {
        Background = Color3.fromRGB(8, 16, 12),
        SideBar = Color3.fromRGB(10, 22, 16),
        TopBar = Color3.fromRGB(12, 26, 20),
        TabActive = Color3.fromRGB(18, 38, 28),
        TabInactive = Color3.fromRGB(10, 22, 16),
        Element = Color3.fromRGB(16, 32, 24),
        ElementHover = Color3.fromRGB(22, 42, 32),
        Accent = Color3.fromRGB(40, 200, 120),
        Text = Color3.fromRGB(230, 245, 238),
        TextDark = Color3.fromRGB(130, 170, 150),
        TextDarker = Color3.fromRGB(80, 120, 100),
        Toggle_On = Color3.fromRGB(40, 200, 120),
        Toggle_Off = Color3.fromRGB(35, 60, 48),
        Slider_Fill = Color3.fromRGB(40, 200, 120),
        Slider_Bg = Color3.fromRGB(25, 45, 35),
        Dropdown_Bg = Color3.fromRGB(10, 22, 16),
        Input_Bg = Color3.fromRGB(10, 22, 16),
        Divider = Color3.fromRGB(30, 50, 40),
        Success = Color3.fromRGB(60, 220, 140),
        Warning = Color3.fromRGB(240, 180, 40),
        Error = Color3.fromRGB(230, 70, 70),
    },
    Sunset = {
        Background = Color3.fromRGB(20, 12, 10),
        SideBar = Color3.fromRGB(26, 15, 12),
        TopBar = Color3.fromRGB(30, 18, 14),
        TabActive = Color3.fromRGB(45, 25, 20),
        TabInactive = Color3.fromRGB(26, 15, 12),
        Element = Color3.fromRGB(38, 22, 18),
        ElementHover = Color3.fromRGB(50, 30, 24),
        Accent = Color3.fromRGB(255, 120, 50),
        Text = Color3.fromRGB(250, 240, 235),
        TextDark = Color3.fromRGB(180, 150, 140),
        TextDarker = Color3.fromRGB(130, 100, 90),
        Toggle_On = Color3.fromRGB(255, 120, 50),
        Toggle_Off = Color3.fromRGB(75, 50, 40),
        Slider_Fill = Color3.fromRGB(255, 120, 50),
        Slider_Bg = Color3.fromRGB(50, 30, 25),
        Dropdown_Bg = Color3.fromRGB(26, 15, 12),
        Input_Bg = Color3.fromRGB(26, 15, 12),
        Divider = Color3.fromRGB(55, 35, 28),
        Success = Color3.fromRGB(80, 200, 120),
        Warning = Color3.fromRGB(255, 200, 60),
        Error = Color3.fromRGB(240, 60, 60),
    },
    Purple = {
        Background = Color3.fromRGB(14, 10, 22),
        SideBar = Color3.fromRGB(18, 12, 28),
        TopBar = Color3.fromRGB(22, 15, 34),
        TabActive = Color3.fromRGB(32, 22, 50),
        TabInactive = Color3.fromRGB(18, 12, 28),
        Element = Color3.fromRGB(28, 18, 42),
        ElementHover = Color3.fromRGB(38, 25, 55),
        Accent = Color3.fromRGB(160, 80, 255),
        Text = Color3.fromRGB(240, 235, 250),
        TextDark = Color3.fromRGB(160, 145, 180),
        TextDarker = Color3.fromRGB(110, 95, 130),
        Toggle_On = Color3.fromRGB(160, 80, 255),
        Toggle_Off = Color3.fromRGB(55, 40, 75),
        Slider_Fill = Color3.fromRGB(160, 80, 255),
        Slider_Bg = Color3.fromRGB(38, 28, 55),
        Dropdown_Bg = Color3.fromRGB(18, 12, 28),
        Input_Bg = Color3.fromRGB(18, 12, 28),
        Divider = Color3.fromRGB(42, 30, 60),
        Success = Color3.fromRGB(80, 200, 140),
        Warning = Color3.fromRGB(250, 180, 50),
        Error = Color3.fromRGB(240, 70, 70),
    },
    Midnight = {
        Background = Color3.fromRGB(5, 5, 10),
        SideBar = Color3.fromRGB(8, 8, 15),
        TopBar = Color3.fromRGB(10, 10, 20),
        TabActive = Color3.fromRGB(18, 18, 35),
        TabInactive = Color3.fromRGB(8, 8, 15),
        Element = Color3.fromRGB(14, 14, 28),
        ElementHover = Color3.fromRGB(20, 20, 40),
        Accent = Color3.fromRGB(100, 100, 255),
        Text = Color3.fromRGB(200, 200, 220),
        TextDark = Color3.fromRGB(120, 120, 150),
        TextDarker = Color3.fromRGB(70, 70, 100),
        Toggle_On = Color3.fromRGB(100, 100, 255),
        Toggle_Off = Color3.fromRGB(35, 35, 55),
        Slider_Fill = Color3.fromRGB(100, 100, 255),
        Slider_Bg = Color3.fromRGB(25, 25, 45),
        Dropdown_Bg = Color3.fromRGB(8, 8, 15),
        Input_Bg = Color3.fromRGB(8, 8, 15),
        Divider = Color3.fromRGB(25, 25, 45),
        Success = Color3.fromRGB(60, 180, 120),
        Warning = Color3.fromRGB(230, 170, 40),
        Error = Color3.fromRGB(220, 60, 60),
    },
    Snow = {
        Background = Color3.fromRGB(235, 238, 242),
        SideBar = Color3.fromRGB(225, 228, 235),
        TopBar = Color3.fromRGB(240, 242, 246),
        TabActive = Color3.fromRGB(215, 220, 230),
        TabInactive = Color3.fromRGB(225, 228, 235),
        Element = Color3.fromRGB(245, 247, 250),
        ElementHover = Color3.fromRGB(230, 235, 242),
        Accent = Color3.fromRGB(60, 80, 200),
        Text = Color3.fromRGB(20, 20, 30),
        TextDark = Color3.fromRGB(80, 80, 100),
        TextDarker = Color3.fromRGB(130, 130, 150),
        Toggle_On = Color3.fromRGB(60, 80, 200),
        Toggle_Off = Color3.fromRGB(180, 185, 195),
        Slider_Fill = Color3.fromRGB(60, 80, 200),
        Slider_Bg = Color3.fromRGB(200, 205, 215),
        Dropdown_Bg = Color3.fromRGB(240, 242, 246),
        Input_Bg = Color3.fromRGB(240, 242, 246),
        Divider = Color3.fromRGB(200, 205, 215),
        Success = Color3.fromRGB(40, 160, 100),
        Warning = Color3.fromRGB(220, 150, 20),
        Error = Color3.fromRGB(200, 50, 50),
    },
}

local Theme = Themes.Default
local currentThemeName = "Default"

local function tween(obj, props, duration, style, dir)
    if not obj or not obj.Parent then return end
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function tweenWait(obj, props, duration, style, dir)
    if not obj or not obj.Parent then return end
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    t:Play()
    t.Completed:Wait()
end

local function rippleEffect(button, x, y)
    if not button or not button.Parent then return end
    local ripple = Instance.new("Frame")
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.85
    ripple.BorderSizePixel = 0
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
    ripple.Position = UDim2.new(0, x - button.AbsolutePosition.X, 0, y - button.AbsolutePosition.Y)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    local s = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5
    tween(ripple, { Size = UDim2.new(0, s, 0, s), BackgroundTransparency = 1 }, 0.6)
    task.delay(0.6, function() if ripple and ripple.Parent then ripple:Destroy() end end)
end

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function createShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.Position = UDim2.new(0, -12, 0, -12)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function saveConfig(name, data)
    pcall(function()
        if writefile then
            writefile("NexusLib_" .. name .. ".json", HttpService:JSONEncode(data))
        end
    end)
end

local function loadConfig(name)
    local ok, result = pcall(function()
        if readfile and isfile and isfile("NexusLib_" .. name .. ".json") then
            return HttpService:JSONDecode(readfile("NexusLib_" .. name .. ".json"))
        end
    end)
    if ok then return result end
    return nil
end

local allElements = {}
local configData = {}

function NexusLib:SetTheme(themeName)
    if Themes[themeName] then
        Theme = Themes[themeName]
        currentThemeName = themeName
    end
end

function NexusLib:GetThemes()
    local t = {}
    for name in pairs(Themes) do
        table.insert(t, name)
    end
    table.sort(t)
    return t
end

function NexusLib:AddTheme(name, themeData)
    Themes[name] = themeData
end

function NexusLib:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Nexus Hub"
    local windowSize = config.Size or UDim2.new(0, 580, 0, 420)
    local introText = config.IntroText or "Nexus Hub"
    local introIcon = config.IntroIcon or "rbxassetid://10734950309"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local configName = config.ConfigName or "default"
    local introEnabled = config.Intro == nil and true or config.Intro
    local introDuration = config.IntroDuration or 2.5
    local accentColor = config.AccentColor

    if config.Theme and Themes[config.Theme] then
        Theme = Themes[config.Theme]
        currentThemeName = config.Theme
    end

    if accentColor then
        Theme.Accent = accentColor
        Theme.Toggle_On = accentColor
        Theme.Slider_Fill = accentColor
    end

    local Window = {}
    Window._tabs = {}
    Window._activeTab = nil
    Window._elements = {}
    Window._configName = configName
    local notifCount = 0
    local notifFrames = {}
    local windowVisible = true

    for _, v in ipairs(GuiParent:GetChildren()) do
        if v.Name == "NexusLib" then v:Destroy() end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexusLib"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = false
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(screenGui) end end)
    screenGui.Parent = GuiParent

    if introEnabled then
        local introFrame = Instance.new("Frame")
        introFrame.Size = UDim2.new(0, 0, 0, 0)
        introFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        introFrame.BackgroundColor3 = Theme.Background
        introFrame.BackgroundTransparency = 0.1
        introFrame.ZIndex = 100
        introFrame.Parent = screenGui
        Instance.new("UICorner", introFrame).CornerRadius = UDim.new(0, 14)

        local introStroke = Instance.new("UIStroke")
        introStroke.Color = Theme.Accent
        introStroke.Thickness = 1.5
        introStroke.Transparency = 0.3
        introStroke.Parent = introFrame

        createShadow(introFrame)

        local introImg = Instance.new("ImageLabel")
        introImg.Size = UDim2.new(0, 45, 0, 45)
        introImg.Position = UDim2.new(0.5, -22, 0, 18)
        introImg.BackgroundTransparency = 1
        introImg.Image = introIcon
        introImg.ImageColor3 = Theme.Accent
        introImg.ImageTransparency = 1
        introImg.ZIndex = 101
        introImg.Parent = introFrame

        local introTitle = Instance.new("TextLabel")
        introTitle.Size = UDim2.new(1, -20, 0, 28)
        introTitle.Position = UDim2.new(0, 10, 0, 68)
        introTitle.BackgroundTransparency = 1
        introTitle.Text = introText
        introTitle.TextColor3 = Theme.Text
        introTitle.TextScaled = true
        introTitle.Font = Enum.Font.GothamBold
        introTitle.TextTransparency = 1
        introTitle.ZIndex = 101
        introTitle.Parent = introFrame

        local introSub = Instance.new("TextLabel")
        introSub.Size = UDim2.new(1, -20, 0, 16)
        introSub.Position = UDim2.new(0, 10, 0, 96)
        introSub.BackgroundTransparency = 1
        introSub.Text = "Loading..."
        introSub.TextColor3 = Theme.TextDark
        introSub.TextScaled = true
        introSub.Font = Enum.Font.Gotham
        introSub.TextTransparency = 1
        introSub.ZIndex = 101
        introSub.Parent = introFrame

        local loadBarBg = Instance.new("Frame")
        loadBarBg.Size = UDim2.new(0.7, 0, 0, 4)
        loadBarBg.Position = UDim2.new(0.15, 0, 0, 124)
        loadBarBg.BackgroundColor3 = Theme.Divider
        loadBarBg.BorderSizePixel = 0
        loadBarBg.ZIndex = 101
        loadBarBg.Parent = introFrame
        Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(1, 0)

        local loadBarFill = Instance.new("Frame")
        loadBarFill.Size = UDim2.new(0, 0, 1, 0)
        loadBarFill.BackgroundColor3 = Theme.Accent
        loadBarFill.BorderSizePixel = 0
        loadBarFill.ZIndex = 102
        loadBarFill.Parent = loadBarBg
        Instance.new("UICorner", loadBarFill).CornerRadius = UDim.new(1, 0)

        task.spawn(function()
            tween(introFrame, { Size = UDim2.new(0, 280, 0, 150), Position = UDim2.new(0.5, -140, 0.5, -75) }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            task.wait(0.4)
            tween(introImg, { ImageTransparency = 0 }, 0.3)
            task.wait(0.2)
            tween(introTitle, { TextTransparency = 0 }, 0.3)
            task.wait(0.15)
            tween(introSub, { TextTransparency = 0 }, 0.2)
            task.wait(0.1)
            tween(loadBarFill, { Size = UDim2.new(1, 0, 1, 0) }, introDuration - 1, Enum.EasingStyle.Quad)
            task.wait(introDuration - 0.65)
            tween(introFrame, { Size = UDim2.new(0, 260, 0, 140), Position = UDim2.new(0.5, -130, 0.5, -70), BackgroundTransparency = 1 }, 0.3)
            tween(introStroke, { Transparency = 1 }, 0.3)
            tween(introImg, { ImageTransparency = 1 }, 0.2)
            tween(introTitle, { TextTransparency = 1 }, 0.2)
            tween(introSub, { TextTransparency = 1 }, 0.2)
            tween(loadBarBg, { BackgroundTransparency = 1 }, 0.2)
            tween(loadBarFill, { BackgroundTransparency = 1 }, 0.2)
            task.wait(0.35)
            if introFrame and introFrame.Parent then introFrame:Destroy() end
        end)
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 1
    mainFrame.ClipsDescendants = true
    mainFrame.Visible = false
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Divider
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    local showDelay = introEnabled and introDuration or 0.1

    task.delay(showDelay, function()
        mainFrame.Visible = true
        tween(mainFrame, {
            Size = windowSize,
            Position = UDim2.new(0.5, -(windowSize.X.Offset / 2), 0.5, -(windowSize.Y.Offset / 2)),
            BackgroundTransparency = 0,
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 5
    topBar.Parent = mainFrame
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 15)
    topBarFix.Position = UDim2.new(0, 0, 1, -15)
    topBarFix.BackgroundColor3 = Theme.TopBar
    topBarFix.BorderSizePixel = 0
    topBarFix.ZIndex = 5
    topBarFix.Parent = topBar

    makeDraggable(mainFrame, topBar)

    local topIcon = Instance.new("ImageLabel")
    topIcon.Size = UDim2.new(0, 22, 0, 22)
    topIcon.Position = UDim2.new(0, 12, 0.5, -11)
    topIcon.BackgroundTransparency = 1
    topIcon.Image = introIcon
    topIcon.ImageColor3 = Theme.Accent
    topIcon.ZIndex = 6
    topIcon.Parent = topBar

    local topTitle = Instance.new("TextLabel")
    topTitle.Size = UDim2.new(0, 250, 1, 0)
    topTitle.Position = UDim2.new(0, 42, 0, 0)
    topTitle.BackgroundTransparency = 1
    topTitle.Text = windowName
    topTitle.TextColor3 = Theme.Text
    topTitle.TextSize = 15
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.ZIndex = 6
    topTitle.Parent = topBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Theme.TextDark
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.ZIndex = 6
    closeBtn.Parent = topBar
    closeBtn.MouseEnter:Connect(function() tween(closeBtn, { TextColor3 = Theme.Error }, 0.15) end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, { TextColor3 = Theme.TextDark }, 0.15) end)
    closeBtn.MouseButton1Click:Connect(function()
        tween(mainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 }, 0.3)
        task.delay(0.35, function() if screenGui and screenGui.Parent then screenGui:Destroy() end end)
    end)

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -65, 0.5, -15)
    minBtn.BackgroundTransparency = 1
    minBtn.Text = "-"
    minBtn.TextColor3 = Theme.TextDark
    minBtn.TextSize = 20
    minBtn.Font = Enum.Font.GothamBold
    minBtn.ZIndex = 6
    minBtn.Parent = topBar
    minBtn.MouseEnter:Connect(function() tween(minBtn, { TextColor3 = Theme.Warning }, 0.15) end)
    minBtn.MouseLeave:Connect(function() tween(minBtn, { TextColor3 = Theme.TextDark }, 0.15) end)
    minBtn.MouseButton1Click:Connect(function()
        windowVisible = not windowVisible
        if windowVisible then
            mainFrame.Visible = true
            tween(mainFrame, {
                Size = windowSize,
                Position = UDim2.new(0.5, -(windowSize.X.Offset / 2), 0.5, -(windowSize.Y.Offset / 2)),
                BackgroundTransparency = 0,
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            tween(mainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 }, 0.25)
            task.delay(0.25, function() mainFrame.Visible = false end)
        end
    end)

    local sideBar = Instance.new("Frame")
    sideBar.Size = UDim2.new(0, 150, 1, -40)
    sideBar.Position = UDim2.new(0, 0, 0, 40)
    sideBar.BackgroundColor3 = Theme.SideBar
    sideBar.BorderSizePixel = 0
    sideBar.ZIndex = 3
    sideBar.Parent = mainFrame

    local sideDiv = Instance.new("Frame")
    sideDiv.Size = UDim2.new(0, 1, 1, 0)
    sideDiv.Position = UDim2.new(1, 0, 0, 0)
    sideDiv.BackgroundColor3 = Theme.Divider
    sideDiv.BorderSizePixel = 0
    sideDiv.ZIndex = 4
    sideDiv.Parent = sideBar

    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Size = UDim2.new(1, -10, 1, -20)
    tabContainer.Position = UDim2.new(0, 5, 0, 10)
    tabContainer.BackgroundTransparency = 1
    tabContainer.ScrollBarThickness = 0
    tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContainer.ZIndex = 4
    tabContainer.Parent = sideBar

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 4)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabContainer
    tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
    end)

    local contentArea = Instance.new("Frame")
    contentArea.Size = UDim2.new(1, -151, 1, -40)
    contentArea.Position = UDim2.new(0, 151, 0, 40)
    contentArea.BackgroundColor3 = Theme.Background
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 2
    contentArea.Parent = mainFrame

    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            windowVisible = not windowVisible
            if windowVisible then
                mainFrame.Visible = true
                tween(mainFrame, {
                    Size = windowSize,
                    Position = UDim2.new(0.5, -(windowSize.X.Offset / 2), 0.5, -(windowSize.Y.Offset / 2)),
                    BackgroundTransparency = 0,
                }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            else
                tween(mainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 }, 0.25)
                task.delay(0.25, function() mainFrame.Visible = false end)
            end
        end
    end)

    local function repositionNotifs()
        local index = 0
        for _, nf in ipairs(notifFrames) do
            if nf and nf.Parent then
                local yOffset = -10 - (80 * index)
                tween(nf, { Position = UDim2.new(1, -290, 1, yOffset) }, 0.3)
                index = index + 1
            end
        end
    end

    function Window:Notify(c)
        c = c or {}
        local nColor = ({ Info = Theme.Accent, Success = Theme.Success, Warning = Theme.Warning, Error = Theme.Error })[c.Type or "Info"] or Theme.Accent
        local dur = c.Duration or 4

        local yOffset = -10 - (80 * #notifFrames)

        local nf = Instance.new("Frame")
        nf.Size = UDim2.new(0, 280, 0, 70)
        nf.Position = UDim2.new(1, 10, 1, yOffset)
        nf.BackgroundColor3 = Theme.SideBar
        nf.ZIndex = 50
        nf.Parent = screenGui
        Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 10)

        local ns = Instance.new("UIStroke")
        ns.Color = nColor
        ns.Thickness = 1
        ns.Transparency = 0.5
        ns.Parent = nf

        createShadow(nf)

        local na = Instance.new("Frame")
        na.Size = UDim2.new(0, 3, 0.7, 0)
        na.Position = UDim2.new(0, 8, 0.15, 0)
        na.BackgroundColor3 = nColor
        na.BorderSizePixel = 0
        na.ZIndex = 51
        na.Parent = nf
        Instance.new("UICorner", na).CornerRadius = UDim.new(0, 2)

        local typeIcons = { Info = "i", Success = "!", Warning = "!", Error = "X" }
        local iconText = typeIcons[c.Type or "Info"] or "i"

        local iconCircle = Instance.new("Frame")
        iconCircle.Size = UDim2.new(0, 22, 0, 22)
        iconCircle.Position = UDim2.new(0, 18, 0, 12)
        iconCircle.BackgroundColor3 = nColor
        iconCircle.BackgroundTransparency = 0.8
        iconCircle.ZIndex = 51
        iconCircle.Parent = nf
        Instance.new("UICorner", iconCircle).CornerRadius = UDim.new(1, 0)

        local iconLabel = Instance.new("TextLabel")
        iconLabel.Size = UDim2.new(1, 0, 1, 0)
        iconLabel.BackgroundTransparency = 1
        iconLabel.Text = iconText
        iconLabel.TextColor3 = nColor
        iconLabel.TextSize = 12
        iconLabel.Font = Enum.Font.GothamBold
        iconLabel.ZIndex = 52
        iconLabel.Parent = iconCircle

        local nt = Instance.new("TextLabel")
        nt.Size = UDim2.new(1, -50, 0, 20)
        nt.Position = UDim2.new(0, 46, 0, 10)
        nt.BackgroundTransparency = 1
        nt.Text = c.Title or "Notification"
        nt.TextColor3 = Theme.Text
        nt.TextSize = 13
        nt.Font = Enum.Font.GothamBold
        nt.TextXAlignment = Enum.TextXAlignment.Left
        nt.TextTruncate = Enum.TextTruncate.AtEnd
        nt.ZIndex = 51
        nt.Parent = nf

        local nc = Instance.new("TextLabel")
        nc.Size = UDim2.new(1, -50, 0, 20)
        nc.Position = UDim2.new(0, 46, 0, 30)
        nc.BackgroundTransparency = 1
        nc.Text = c.Content or ""
        nc.TextColor3 = Theme.TextDark
        nc.TextSize = 11
        nc.Font = Enum.Font.Gotham
        nc.TextXAlignment = Enum.TextXAlignment.Left
        nc.TextTruncate = Enum.TextTruncate.AtEnd
        nc.ZIndex = 51
        nc.Parent = nf

        local np = Instance.new("Frame")
        np.Size = UDim2.new(1, 0, 0, 2)
        np.Position = UDim2.new(0, 0, 1, -2)
        np.BackgroundColor3 = nColor
        np.BorderSizePixel = 0
        np.ZIndex = 51
        np.Parent = nf

        table.insert(notifFrames, nf)

        tween(nf, { Position = UDim2.new(1, -290, 1, yOffset) }, 0.4, Enum.EasingStyle.Back)
        tween(np, { Size = UDim2.new(0, 0, 0, 2) }, dur)

        task.delay(dur, function()
            tween(nf, { Position = UDim2.new(1, 10, 1, yOffset) }, 0.3)
            task.delay(0.35, function()
                if nf and nf.Parent then nf:Destroy() end
                for i, f in ipairs(notifFrames) do
                    if f == nf then table.remove(notifFrames, i) break end
                end
                repositionNotifs()
            end)
        end)
    end

    function Window:SaveConfig(name)
        name = name or configName
        saveConfig(name, configData)
        Window:Notify({ Title = "Config", Content = "Saved: " .. name, Type = "Success", Duration = 2 })
    end

    function Window:LoadConfig(name)
        name = name or configName
        local data = loadConfig(name)
        if data then
            for id, value in pairs(data) do
                if allElements[id] then
                    allElements[id]:Set(value)
                end
            end
            Window:Notify({ Title = "Config", Content = "Loaded: " .. name, Type = "Success", Duration = 2 })
        else
            Window:Notify({ Title = "Config", Content = "Not found: " .. name, Type = "Error", Duration = 2 })
        end
    end

    function Window:Destroy()
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        end
    end

    function Window:Toggle(state)
        if state ~= nil then
            windowVisible = state
        else
            windowVisible = not windowVisible
        end
        if windowVisible then
            mainFrame.Visible = true
            tween(mainFrame, {
                Size = windowSize,
                Position = UDim2.new(0.5, -(windowSize.X.Offset / 2), 0.5, -(windowSize.Y.Offset / 2)),
                BackgroundTransparency = 0,
            }, 0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        else
            tween(mainFrame, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1 }, 0.25)
            task.delay(0.25, function() mainFrame.Visible = false end)
        end
    end

    function Window:CreateTab(tc)
        tc = tc or {}
        local tabName = tc.Name or "Tab"
        local tabIcon = tc.Icon or "rbxassetid://10734950309"
        local Tab = {}
        Tab._elements = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, 0, 0, 38)
        tabBtn.BackgroundColor3 = Theme.TabInactive
        tabBtn.BackgroundTransparency = 0.5
        tabBtn.Text = ""
        tabBtn.AutoButtonColor = false
        tabBtn.ZIndex = 5
        tabBtn.Parent = tabContainer
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

        local tabAccent = Instance.new("Frame")
        tabAccent.Size = UDim2.new(0, 3, 0.6, 0)
        tabAccent.Position = UDim2.new(0, 0, 0.2, 0)
        tabAccent.BackgroundColor3 = Theme.Accent
        tabAccent.BackgroundTransparency = 1
        tabAccent.BorderSizePixel = 0
        tabAccent.ZIndex = 6
        tabAccent.Parent = tabBtn
        Instance.new("UICorner", tabAccent).CornerRadius = UDim.new(0, 2)

        local tabIconImg = Instance.new("ImageLabel")
        tabIconImg.Size = UDim2.new(0, 18, 0, 18)
        tabIconImg.Position = UDim2.new(0, 12, 0.5, -9)
        tabIconImg.BackgroundTransparency = 1
        tabIconImg.Image = tabIcon
        tabIconImg.ImageColor3 = Theme.TextDark
        tabIconImg.ZIndex = 6
        tabIconImg.Parent = tabBtn

        local tabText = Instance.new("TextLabel")
        tabText.Size = UDim2.new(1, -42, 1, 0)
        tabText.Position = UDim2.new(0, 38, 0, 0)
        tabText.BackgroundTransparency = 1
        tabText.Text = tabName
        tabText.TextColor3 = Theme.TextDark
        tabText.TextSize = 13
        tabText.Font = Enum.Font.GothamMedium
        tabText.TextXAlignment = Enum.TextXAlignment.Left
        tabText.ZIndex = 6
        tabText.Parent = tabBtn

        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Theme.Accent
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.ZIndex = 3
        tabContent.Parent = contentArea

        local cLayout = Instance.new("UIListLayout")
        cLayout.Padding = UDim.new(0, 8)
        cLayout.SortOrder = Enum.SortOrder.LayoutOrder
        cLayout.Parent = tabContent
        cLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, cLayout.AbsoluteContentSize.Y + 20)
        end)

        local function activate()
            for _, t in ipairs(Window._tabs) do t._deactivate() end
            tween(tabBtn, { BackgroundColor3 = Theme.TabActive, BackgroundTransparency = 0 }, 0.2)
            tween(tabAccent, { BackgroundTransparency = 0 }, 0.2)
            tween(tabIconImg, { ImageColor3 = Theme.Accent }, 0.2)
            tween(tabText, { TextColor3 = Theme.Text }, 0.2)
            tabContent.Visible = true
            Window._activeTab = Tab
        end

        local function deactivate()
            tween(tabBtn, { BackgroundColor3 = Theme.TabInactive, BackgroundTransparency = 0.5 }, 0.2)
            tween(tabAccent, { BackgroundTransparency = 1 }, 0.2)
            tween(tabIconImg, { ImageColor3 = Theme.TextDark }, 0.2)
            tween(tabText, { TextColor3 = Theme.TextDark }, 0.2)
            tabContent.Visible = false
        end

        Tab._deactivate = deactivate
        tabBtn.MouseEnter:Connect(function() if Window._activeTab ~= Tab then tween(tabBtn, { BackgroundTransparency = 0.2 }, 0.15) end end)
        tabBtn.MouseLeave:Connect(function() if Window._activeTab ~= Tab then tween(tabBtn, { BackgroundTransparency = 0.5 }, 0.15) end end)
        tabBtn.MouseButton1Click:Connect(activate)
        if #Window._tabs == 0 then task.defer(activate) end
        table.insert(Window._tabs, Tab)

        function Tab:CreateSection(name)
            local f = Instance.new("Frame") f.Size = UDim2.new(1, 0, 0, 30) f.BackgroundTransparency = 1 f.ZIndex = 3 f.Parent = tabContent
            local l = Instance.new("TextLabel") l.Size = UDim2.new(1, -10, 1, 0) l.Position = UDim2.new(0, 5, 0, 0) l.BackgroundTransparency = 1 l.Text = name or "Section" l.TextColor3 = Theme.TextDarker l.TextSize = 12 l.Font = Enum.Font.GothamBold l.TextXAlignment = Enum.TextXAlignment.Left l.ZIndex = 4 l.Parent = f
            local ln = Instance.new("Frame") ln.Size = UDim2.new(1, -10, 0, 1) ln.Position = UDim2.new(0, 5, 1, -1) ln.BackgroundColor3 = Theme.Divider ln.BorderSizePixel = 0 ln.ZIndex = 4 ln.Parent = f
        end

        function Tab:CreateDivider()
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, -10, 0, 1)
            div.BackgroundColor3 = Theme.Divider
            div.BorderSizePixel = 0
            div.ZIndex = 3
            div.Parent = tabContent
        end

        function Tab:CreateSpacer(height)
            local sp = Instance.new("Frame")
            sp.Size = UDim2.new(1, 0, 0, height or 10)
            sp.BackgroundTransparency = 1
            sp.Parent = tabContent
        end

        function Tab:CreateButton(c)
            c = c or {}
            local h = c.Description and 52 or 38
            local btn = Instance.new("TextButton") btn.Size = UDim2.new(1, 0, 0, h) btn.BackgroundColor3 = Theme.Element btn.Text = "" btn.AutoButtonColor = false btn.ClipsDescendants = true btn.ZIndex = 3 btn.Parent = tabContent
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, -20, 0, 20) lbl.Position = UDim2.new(0, 15, 0, c.Description and 8 or 9) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Button" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = btn
            if c.Description then
                local d = Instance.new("TextLabel") d.Size = UDim2.new(1, -20, 0, 16) d.Position = UDim2.new(0, 15, 0, 28) d.BackgroundTransparency = 1 d.Text = c.Description d.TextColor3 = Theme.TextDarker d.TextSize = 11 d.Font = Enum.Font.Gotham d.TextXAlignment = Enum.TextXAlignment.Left d.ZIndex = 4 d.Parent = btn
            end
            local arrow = Instance.new("TextLabel")
            arrow.Size = UDim2.new(0, 20, 0, 20)
            arrow.Position = UDim2.new(1, -30, 0.5, -10)
            arrow.BackgroundTransparency = 1
            arrow.Text = ">"
            arrow.TextColor3 = Theme.TextDarker
            arrow.TextSize = 14
            arrow.Font = Enum.Font.GothamBold
            arrow.ZIndex = 4
            arrow.Parent = btn
            btn.MouseEnter:Connect(function()
                tween(btn, { BackgroundColor3 = Theme.ElementHover }, 0.15)
                tween(arrow, { TextColor3 = Theme.Accent }, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                tween(btn, { BackgroundColor3 = Theme.Element }, 0.15)
                tween(arrow, { TextColor3 = Theme.TextDarker }, 0.15)
            end)
            btn.MouseButton1Click:Connect(function() rippleEffect(btn, Mouse.X, Mouse.Y) pcall(c.Callback or function() end) end)
        end

        function Tab:CreateToggle(c)
            c = c or {}
            local id = c.Flag or (tabName .. "_" .. (c.Name or "toggle") .. "_" .. #Tab._elements)
            local toggled = c.Default or false
            local h = c.Description and 52 or 38
            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, h) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(1, -70, 0, 20) lbl.Position = UDim2.new(0, 15, 0, c.Description and 8 or 9) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Toggle" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = frame
            if c.Description then
                local d = Instance.new("TextLabel") d.Size = UDim2.new(1, -70, 0, 16) d.Position = UDim2.new(0, 15, 0, 28) d.BackgroundTransparency = 1 d.Text = c.Description d.TextColor3 = Theme.TextDarker d.TextSize = 11 d.Font = Enum.Font.Gotham d.TextXAlignment = Enum.TextXAlignment.Left d.ZIndex = 4 d.Parent = frame
            end
            local bg = Instance.new("Frame") bg.Size = UDim2.new(0, 44, 0, 24) bg.Position = UDim2.new(1, -55, 0.5, -12) bg.BackgroundColor3 = toggled and Theme.Toggle_On or Theme.Toggle_Off bg.ZIndex = 5 bg.Parent = frame
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)
            local circle = Instance.new("Frame") circle.Size = UDim2.new(0, 18, 0, 18) circle.Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) circle.BackgroundColor3 = Theme.Text circle.ZIndex = 6 circle.Parent = bg
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

            local function upd()
                tween(bg, { BackgroundColor3 = toggled and Theme.Toggle_On or Theme.Toggle_Off }, 0.2)
                tween(circle, { Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
            end

            local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 1, 0) b.BackgroundTransparency = 1 b.Text = "" b.ZIndex = 7 b.Parent = frame
            b.MouseButton1Click:Connect(function()
                toggled = not toggled
                upd()
                configData[id] = toggled
                pcall(c.Callback or function() end, toggled)
            end)

            local obj = {}
            function obj:Set(v) toggled = v upd() configData[id] = v pcall(c.Callback or function() end, v) end
            function obj:Get() return toggled end

            allElements[id] = obj
            table.insert(Tab._elements, obj)
            return obj
        end

        function Tab:CreateSlider(c)
            c = c or {}
            local id = c.Flag or (tabName .. "_" .. (c.Name or "slider") .. "_" .. #Tab._elements)
            local min, max, inc = c.Min or 0, c.Max or 100, c.Increment or 1
            local value = c.Default or min
            local suffix = c.Suffix or ""

            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 55) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(0.6, 0, 0, 20) lbl.Position = UDim2.new(0, 15, 0, 8) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Slider" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = frame
            local valLbl = Instance.new("TextLabel") valLbl.Size = UDim2.new(0.35, 0, 0, 20) valLbl.Position = UDim2.new(0.65, -15, 0, 8) valLbl.BackgroundTransparency = 1 valLbl.Text = tostring(value) .. suffix valLbl.TextColor3 = Theme.Accent valLbl.TextSize = 14 valLbl.Font = Enum.Font.GothamBold valLbl.TextXAlignment = Enum.TextXAlignment.Right valLbl.ZIndex = 4 valLbl.Parent = frame

            local sBg = Instance.new("Frame") sBg.Size = UDim2.new(1, -30, 0, 6) sBg.Position = UDim2.new(0, 15, 0, 38) sBg.BackgroundColor3 = Theme.Slider_Bg sBg.ZIndex = 4 sBg.Parent = frame
            Instance.new("UICorner", sBg).CornerRadius = UDim.new(1, 0)
            local p = (value - min) / (max - min)
            local sFill = Instance.new("Frame") sFill.Size = UDim2.new(p, 0, 1, 0) sFill.BackgroundColor3 = Theme.Slider_Fill sFill.ZIndex = 5 sFill.Parent = sBg
            Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)
            local knob = Instance.new("Frame") knob.Size = UDim2.new(0, 16, 0, 16) knob.Position = UDim2.new(p, -8, 0.5, -8) knob.BackgroundColor3 = Theme.Text knob.ZIndex = 6 knob.Parent = sBg
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            local ks = Instance.new("UIStroke") ks.Color = Theme.Accent ks.Thickness = 2 ks.Parent = knob

            local function upd(pp)
                pp = math.clamp(pp, 0, 1)
                value = math.clamp(math.floor((min + (max - min) * pp) / inc + 0.5) * inc, min, max)
                local rp = (value - min) / (max - min)
                tween(sFill, { Size = UDim2.new(rp, 0, 1, 0) }, 0.08)
                tween(knob, { Position = UDim2.new(rp, -8, 0.5, -8) }, 0.08)
                valLbl.Text = tostring(value) .. suffix
                configData[id] = value
                pcall(c.Callback or function() end, value)
            end

            local sliding = false
            local sInput = Instance.new("TextButton") sInput.Size = UDim2.new(1, 0, 0, 20) sInput.Position = UDim2.new(0, 0, 0, -7) sInput.BackgroundTransparency = 1 sInput.Text = "" sInput.ZIndex = 7 sInput.Parent = sBg
            sInput.MouseButton1Down:Connect(function() sliding = true upd((Mouse.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X) end)
            UIS.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end end)
            RunService.RenderStepped:Connect(function() if sliding then upd((Mouse.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X) end end)

            local obj = {}
            function obj:Set(v) upd((v - min) / (max - min)) end
            function obj:Get() return value end

            allElements[id] = obj
            table.insert(Tab._elements, obj)
            return obj
        end

        function Tab:CreateDropdown(c)
            c = c or {}
            local id = c.Flag or (tabName .. "_" .. (c.Name or "dropdown") .. "_" .. #Tab._elements)
            local options = c.Options or {}
            local selected = c.Default or (options[1] or "")
            local opened = false
            local multi = c.Multi or false

            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 38) frame.BackgroundColor3 = Theme.Element frame.ClipsDescendants = true frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(0.5, 0, 0, 38) lbl.Position = UDim2.new(0, 15, 0, 0) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Dropdown" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = frame

            local sel = Instance.new("TextLabel") sel.Size = UDim2.new(0.45, -15, 0, 38) sel.Position = UDim2.new(0.55, 0, 0, 0) sel.BackgroundTransparency = 1 sel.Text = selected .. " >" sel.TextColor3 = Theme.Accent sel.TextSize = 13 sel.Font = Enum.Font.GothamMedium sel.TextXAlignment = Enum.TextXAlignment.Right sel.ZIndex = 4 sel.Parent = frame

            local optC = Instance.new("Frame") optC.Size = UDim2.new(1, -10, 0, 0) optC.Position = UDim2.new(0, 5, 0, 42) optC.BackgroundTransparency = 1 optC.ZIndex = 4 optC.Parent = frame
            Instance.new("UIListLayout", optC).Padding = UDim.new(0, 3)

            local function createOpt(text)
                local ob = Instance.new("TextButton") ob.Size = UDim2.new(1, 0, 0, 30) ob.BackgroundColor3 = Theme.Dropdown_Bg ob.Text = text ob.TextColor3 = Theme.TextDark ob.TextSize = 13 ob.Font = Enum.Font.Gotham ob.AutoButtonColor = false ob.ZIndex = 5 ob.Parent = optC
                Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)
                ob.MouseEnter:Connect(function() tween(ob, { BackgroundColor3 = Theme.ElementHover, TextColor3 = Theme.Text }, 0.1) end)
                ob.MouseLeave:Connect(function() tween(ob, { BackgroundColor3 = Theme.Dropdown_Bg, TextColor3 = Theme.TextDark }, 0.1) end)
                ob.MouseButton1Click:Connect(function()
                    selected = text
                    sel.Text = text .. " >"
                    opened = false
                    tween(frame, { Size = UDim2.new(1, 0, 0, 38) }, 0.25)
                    configData[id] = selected
                    pcall(c.Callback or function() end, text)
                end)
            end

            for _, o in ipairs(options) do createOpt(o) end

            local db = Instance.new("TextButton") db.Size = UDim2.new(1, 0, 0, 38) db.BackgroundTransparency = 1 db.Text = "" db.ZIndex = 6 db.Parent = frame
            db.MouseButton1Click:Connect(function()
                opened = not opened
                sel.Text = selected .. (opened and " ^" or " >")
                tween(frame, { Size = UDim2.new(1, 0, 0, opened and (48 + #options * 33) or 38) }, 0.25)
            end)

            local obj = {}
            function obj:Set(v) selected = v sel.Text = v .. " >" configData[id] = v pcall(c.Callback or function() end, v) end
            function obj:Get() return selected end
            function obj:Refresh(new)
                for _, ch in ipairs(optC:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
                options = new
                for _, o in ipairs(options) do createOpt(o) end
            end

            allElements[id] = obj
            table.insert(Tab._elements, obj)
            return obj
        end

        function Tab:CreateInput(c)
            c = c or {}
            local id = c.Flag or (tabName .. "_" .. (c.Name or "input") .. "_" .. #Tab._elements)
            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 38) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(0.4, 0, 1, 0) lbl.Position = UDim2.new(0, 15, 0, 0) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Input" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = frame
            local tb = Instance.new("TextBox") tb.Size = UDim2.new(0.55, -15, 0, 26) tb.Position = UDim2.new(0.45, 0, 0.5, -13) tb.BackgroundColor3 = Theme.Input_Bg tb.Text = c.Default or "" tb.PlaceholderText = c.PlaceholderText or "Type..." tb.PlaceholderColor3 = Theme.TextDarker tb.TextColor3 = Theme.Text tb.TextSize = 13 tb.Font = Enum.Font.Gotham tb.ClearTextOnFocus = false tb.ZIndex = 5 tb.Parent = frame
            Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
            Instance.new("UIPadding", tb).PaddingLeft = UDim.new(0, 8)
            local s = Instance.new("UIStroke") s.Color = Theme.Divider s.Thickness = 1 s.Parent = tb
            tb.Focused:Connect(function() tween(s, { Color = Theme.Accent }, 0.2) end)
            tb.FocusLost:Connect(function(enter)
                tween(s, { Color = Theme.Divider }, 0.2)
                if enter then
                    configData[id] = tb.Text
                    pcall(c.Callback or function() end, tb.Text)
                end
            end)

            local obj = {}
            function obj:Set(v) tb.Text = v configData[id] = v end
            function obj:Get() return tb.Text end

            allElements[id] = obj
            table.insert(Tab._elements, obj)
            return obj
        end

        function Tab:CreateKeybind(c)
            c = c or {}
            local id = c.Flag or (tabName .. "_" .. (c.Name or "keybind") .. "_" .. #Tab._elements)
            local currentKey = c.Default or Enum.KeyCode.Unknown
            local listening = false

            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 38) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(0.6, 0, 1, 0) lbl.Position = UDim2.new(0, 15, 0, 0) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Keybind" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = frame

            local keyBtn = Instance.new("TextButton")
            keyBtn.Size = UDim2.new(0, 80, 0, 26)
            keyBtn.Position = UDim2.new(1, -95, 0.5, -13)
            keyBtn.BackgroundColor3 = Theme.Input_Bg
            keyBtn.Text = currentKey ~= Enum.KeyCode.Unknown and currentKey.Name or "None"
            keyBtn.TextColor3 = Theme.Accent
            keyBtn.TextSize = 12
            keyBtn.Font = Enum.Font.GothamBold
            keyBtn.AutoButtonColor = false
            keyBtn.ZIndex = 5
            keyBtn.Parent = frame
            Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", keyBtn).Color = Theme.Divider

            keyBtn.MouseButton1Click:Connect(function()
                listening = true
                keyBtn.Text = "..."
                keyBtn.TextColor3 = Theme.Warning
            end)

            UIS.InputBegan:Connect(function(input, gpe)
                if not listening then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    if input.KeyCode == Enum.KeyCode.Escape then
                        currentKey = Enum.KeyCode.Unknown
                        keyBtn.Text = "None"
                    else
                        currentKey = input.KeyCode
                        keyBtn.Text = input.KeyCode.Name
                    end
                    keyBtn.TextColor3 = Theme.Accent
                    listening = false
                    configData[id] = currentKey.Name
                    pcall(c.Callback or function() end, currentKey)
                end
            end)

            local obj = {}
            function obj:Set(v)
                if type(v) == "string" then v = Enum.KeyCode[v] end
                currentKey = v
                keyBtn.Text = v ~= Enum.KeyCode.Unknown and v.Name or "None"
                configData[id] = v.Name
            end
            function obj:Get() return currentKey end

            allElements[id] = obj
            table.insert(Tab._elements, obj)
            return obj
        end

        function Tab:CreateColorPicker(c)
            c = c or {}
            local id = c.Flag or (tabName .. "_" .. (c.Name or "color") .. "_" .. #Tab._elements)
            local currentColor = c.Default or Color3.fromRGB(255, 255, 255)

            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 38) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(0.6, 0, 1, 0) lbl.Position = UDim2.new(0, 15, 0, 0) lbl.BackgroundTransparency = 1 lbl.Text = c.Name or "Color" lbl.TextColor3 = Theme.Text lbl.TextSize = 14 lbl.Font = Enum.Font.GothamMedium lbl.TextXAlignment = Enum.TextXAlignment.Left lbl.ZIndex = 4 lbl.Parent = frame

            local colorPreview = Instance.new("Frame")
            colorPreview.Size = UDim2.new(0, 26, 0, 26)
            colorPreview.Position = UDim2.new(1, -40, 0.5, -13)
            colorPreview.BackgroundColor3 = currentColor
            colorPreview.ZIndex = 5
            colorPreview.Parent = frame
            Instance.new("UICorner", colorPreview).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", colorPreview).Color = Theme.Divider

            local obj = {}
            function obj:Set(v) currentColor = v colorPreview.BackgroundColor3 = v pcall(c.Callback or function() end, v) end
            function obj:Get() return currentColor end

            table.insert(Tab._elements, obj)
            return obj
        end

        function Tab:CreateLabel(text)
            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, 30) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
            local l = Instance.new("TextLabel") l.Size = UDim2.new(1, -20, 1, 0) l.Position = UDim2.new(0, 10, 0, 0) l.BackgroundTransparency = 1 l.Text = text or "Label" l.TextColor3 = Theme.TextDark l.TextSize = 13 l.Font = Enum.Font.Gotham l.TextXAlignment = Enum.TextXAlignment.Left l.ZIndex = 4 l.Parent = frame
            local obj = {} function obj:Set(t) l.Text = t end return obj
        end

        function Tab:CreateParagraph(c)
            c = c or {}
            local contentText = c.Content or ""
            local lines = 1
            for _ in contentText:gmatch("\n") do lines = lines + 1 end
            local totalH = 30 + math.max(20, lines * 16)

            local frame = Instance.new("Frame") frame.Size = UDim2.new(1, 0, 0, totalH) frame.BackgroundColor3 = Theme.Element frame.ZIndex = 3 frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local bar = Instance.new("Frame") bar.Size = UDim2.new(0, 3, 0.7, 0) bar.Position = UDim2.new(0, 6, 0.15, 0) bar.BackgroundColor3 = Theme.Accent bar.BorderSizePixel = 0 bar.ZIndex = 4 bar.Parent = frame
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

            local t = Instance.new("TextLabel") t.Size = UDim2.new(1, -25, 0, 20) t.Position = UDim2.new(0, 18, 0, 8) t.BackgroundTransparency = 1 t.Text = c.Title or "Info" t.TextColor3 = Theme.Text t.TextSize = 14 t.Font = Enum.Font.GothamBold t.TextXAlignment = Enum.TextXAlignment.Left t.ZIndex = 4 t.Parent = frame

            local ct = Instance.new("TextLabel") ct.Size = UDim2.new(1, -25, 0, totalH - 35) ct.Position = UDim2.new(0, 18, 0, 28) ct.BackgroundTransparency = 1 ct.Text = contentText ct.TextColor3 = Theme.TextDark ct.TextSize = 12 ct.Font = Enum.Font.Gotham ct.TextXAlignment = Enum.TextXAlignment.Left ct.TextYAlignment = Enum.TextYAlignment.Top ct.TextWrapped = true ct.ZIndex = 4 ct.Parent = frame

            local obj = {}
            function obj:Set(title, content)
                if title then t.Text = title end
                if content then ct.Text = content end
            end
            return obj
        end

        return Tab
    end

    return Window
end

return NexusLib
