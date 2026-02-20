-- ===================================================
-- 🎨 NEXUS UI LIBRARY v1.1 (XENO FIX)
-- ===================================================

local NexusLib = {}

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- 🔧 ФИКС: Выбираем куда ставить GUI
local function getGuiParent()
    -- Способ 1: gethui (Xeno/Synapse)
    local ok1, result1 = pcall(function()
        return gethui()
    end)
    if ok1 and result1 then return result1 end

    -- Способ 2: CoreGui
    local ok2, result2 = pcall(function()
        local test = Instance.new("ScreenGui")
        test.Parent = game:GetService("CoreGui")
        test:Destroy()
        return game:GetService("CoreGui")
    end)
    if ok2 and result2 then return result2 end

    -- Способ 3: PlayerGui
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = getGuiParent()

-- ============================================
--              🎨 ТЕМА
-- ============================================
local Theme = {
    Background      = Color3.fromRGB(12, 12, 18),
    SideBar         = Color3.fromRGB(16, 16, 24),
    TopBar          = Color3.fromRGB(18, 18, 28),
    TabActive       = Color3.fromRGB(25, 25, 40),
    TabInactive     = Color3.fromRGB(16, 16, 24),
    Section         = Color3.fromRGB(20, 20, 32),
    Element         = Color3.fromRGB(25, 25, 38),
    ElementHover    = Color3.fromRGB(30, 30, 48),
    Accent          = Color3.fromRGB(88, 101, 242),
    AccentDark      = Color3.fromRGB(68, 81, 222),
    AccentLight     = Color3.fromRGB(108, 121, 255),
    Text            = Color3.fromRGB(240, 240, 245),
    TextDark        = Color3.fromRGB(150, 150, 170),
    TextDarker      = Color3.fromRGB(100, 100, 120),
    Toggle_On       = Color3.fromRGB(88, 101, 242),
    Toggle_Off      = Color3.fromRGB(55, 55, 75),
    Slider_Fill     = Color3.fromRGB(88, 101, 242),
    Slider_Bg       = Color3.fromRGB(35, 35, 50),
    Dropdown_Bg     = Color3.fromRGB(18, 18, 28),
    Input_Bg        = Color3.fromRGB(18, 18, 28),
    Divider         = Color3.fromRGB(35, 35, 50),
    Shadow          = Color3.fromRGB(0, 0, 0),
    Success         = Color3.fromRGB(67, 181, 129),
    Warning         = Color3.fromRGB(250, 166, 26),
    Error           = Color3.fromRGB(237, 66, 69),
}

-- ============================================
--              🔧 УТИЛИТЫ
-- ============================================
local function tween(obj, props, duration, style, dir)
    if not obj or not obj.Parent then return end
    local info = TweenInfo.new(
        duration or 0.2,
        style or Enum.EasingStyle.Quad,
        dir or Enum.EasingDirection.Out
    )
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
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

    local absPos = button.AbsolutePosition
    local px = x - absPos.X
    local py = y - absPos.Y

    ripple.Position = UDim2.new(0, px, 0, py)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)

    local maxSize = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2.5

    tween(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1,
    }, 0.6)

    task.delay(0.6, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

local function makeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
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

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ============================================
--          🏗️ ГЛАВНОЕ ОКНО
-- ============================================
function NexusLib:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Nexus Hub"
    local windowSize = config.Size or UDim2.new(0, 580, 0, 420)
    local introText = config.IntroText or "Nexus Hub"
    local introIcon = config.IntroIcon or "rbxassetid://10734950309"
    local toggleKey = config.ToggleKey or Enum.KeyCode.RightControl

    local Window = {}
    Window._tabs = {}
    Window._activeTab = nil

    -- Удаляем старый
    for _, v in ipairs(GuiParent:GetChildren()) do
        if v.Name == "NexusLib" then
            v:Destroy()
        end
    end

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexusLib"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false

    -- 🔧 ФИКС: protect_gui если доступен (Xeno)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(screenGui)
        end
    end)

    screenGui.Parent = GuiParent

    -- ========== INTRO SCREEN ==========
    local introScreen = Instance.new("Frame")
    introScreen.Size = UDim2.new(1, 0, 1, 0)
    introScreen.BackgroundColor3 = Theme.Background
    introScreen.BackgroundTransparency = 0
    introScreen.ZIndex = 100
    introScreen.Parent = screenGui

    local introContainer = Instance.new("Frame")
    introContainer.Size = UDim2.new(0, 300, 0, 200)
    introContainer.Position = UDim2.new(0.5, -150, 0.5, -100)
    introContainer.BackgroundTransparency = 1
    introContainer.ZIndex = 101
    introContainer.Parent = introScreen

    local introImg = Instance.new("ImageLabel")
    introImg.Size = UDim2.new(0, 70, 0, 70)
    introImg.Position = UDim2.new(0.5, -35, 0, 10)
    introImg.BackgroundTransparency = 1
    introImg.Image = introIcon
    introImg.ImageColor3 = Theme.Accent
    introImg.ImageTransparency = 1
    introImg.ZIndex = 102
    introImg.Parent = introContainer

    local introTitle = Instance.new("TextLabel")
    introTitle.Size = UDim2.new(1, 0, 0, 40)
    introTitle.Position = UDim2.new(0, 0, 0, 90)
    introTitle.BackgroundTransparency = 1
    introTitle.Text = introText
    introTitle.TextColor3 = Theme.Text
    introTitle.TextScaled = true
    introTitle.Font = Enum.Font.GothamBold
    introTitle.TextTransparency = 1
    introTitle.ZIndex = 102
    introTitle.Parent = introContainer

    local introSub = Instance.new("TextLabel")
    introSub.Size = UDim2.new(1, 0, 0, 20)
    introSub.Position = UDim2.new(0, 0, 0, 135)
    introSub.BackgroundTransparency = 1
    introSub.Text = "Loading..."
    introSub.TextColor3 = Theme.TextDark
    introSub.TextScaled = true
    introSub.Font = Enum.Font.Gotham
    introSub.TextTransparency = 1
    introSub.ZIndex = 102
    introSub.Parent = introContainer

    local loadBarBg = Instance.new("Frame")
    loadBarBg.Size = UDim2.new(0.6, 0, 0, 4)
    loadBarBg.Position = UDim2.new(0.2, 0, 0, 170)
    loadBarBg.BackgroundColor3 = Theme.Divider
    loadBarBg.BorderSizePixel = 0
    loadBarBg.ZIndex = 102
    loadBarBg.Parent = introContainer
    Instance.new("UICorner", loadBarBg).CornerRadius = UDim.new(1, 0)

    local loadBarFill = Instance.new("Frame")
    loadBarFill.Size = UDim2.new(0, 0, 1, 0)
    loadBarFill.BackgroundColor3 = Theme.Accent
    loadBarFill.BorderSizePixel = 0
    loadBarFill.ZIndex = 103
    loadBarFill.Parent = loadBarBg
    Instance.new("UICorner", loadBarFill).CornerRadius = UDim.new(1, 0)

    -- Анимация intro
    task.spawn(function()
        task.wait(0.3)
        tween(introImg, { ImageTransparency = 0 }, 0.5)
        task.wait(0.3)
        tween(introTitle, { TextTransparency = 0 }, 0.4)
        task.wait(0.2)
        tween(introSub, { TextTransparency = 0 }, 0.3)
        task.wait(0.2)
        tween(loadBarFill, { Size = UDim2.new(1, 0, 1, 0) }, 1.5, Enum.EasingStyle.Quad)
        task.wait(2)
        tween(introScreen, { BackgroundTransparency = 1 }, 0.5)
        tween(introImg, { ImageTransparency = 1 }, 0.3)
        tween(introTitle, { TextTransparency = 1 }, 0.3)
        tween(introSub, { TextTransparency = 1 }, 0.3)
        tween(loadBarBg, { BackgroundTransparency = 1 }, 0.3)
        tween(loadBarFill, { BackgroundTransparency = 1 }, 0.3)
        task.wait(0.5)
        if introScreen and introScreen.Parent then introScreen:Destroy() end
    end)

    -- ========== ГЛАВНЫЙ ФРЕЙМ ==========
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = windowSize
    mainFrame.Position = UDim2.new(0.5, -(windowSize.X.Offset/2), 0.5, -(windowSize.Y.Offset/2))
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Theme.Divider
    mainStroke.Thickness = 1
    mainStroke.Parent = mainFrame

    -- ========== TOP BAR ==========
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
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
    topTitle.Size = UDim2.new(0, 200, 1, 0)
    topTitle.Position = UDim2.new(0, 42, 0, 0)
    topTitle.BackgroundTransparency = 1
    topTitle.Text = windowName
    topTitle.TextColor3 = Theme.Text
    topTitle.TextSize = 15
    topTitle.Font = Enum.Font.GothamBold
    topTitle.TextXAlignment = Enum.TextXAlignment.Left
    topTitle.ZIndex = 6
    topTitle.Parent = topBar

    local function createWindowBtn(icon, pos, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 30, 0, 30)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = icon
        btn.TextColor3 = Theme.TextDark
        btn.TextSize = 16
        btn.Font = Enum.Font.GothamBold
        btn.ZIndex = 6
        btn.Parent = topBar

        btn.MouseEnter:Connect(function()
            tween(btn, { TextColor3 = color or Theme.Text }, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, { TextColor3 = Theme.TextDark }, 0.15)
        end)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    createWindowBtn("✕", UDim2.new(1, -35, 0.5, -15), Theme.Error, function()
        tween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
        }, 0.3)
        task.delay(0.35, function()
            if screenGui and screenGui.Parent then screenGui:Destroy() end
        end)
    end)

    createWindowBtn("─", UDim2.new(1, -65, 0.5, -15), Theme.Warning, function()
        mainFrame.Visible = not mainFrame.Visible
    end)

    -- ========== SIDEBAR ==========
    local sideBar = Instance.new("Frame")
    sideBar.Name = "SideBar"
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
    tabContainer.Name = "TabContainer"
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

    -- ========== CONTENT AREA ==========
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Size = UDim2.new(1, -151, 1, -40)
    contentArea.Position = UDim2.new(0, 151, 0, 40)
    contentArea.BackgroundColor3 = Theme.Background
    contentArea.BorderSizePixel = 0
    contentArea.ZIndex = 2
    contentArea.Parent = mainFrame

    -- ========== TOGGLE ==========
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == toggleKey then
            mainFrame.Visible = not mainFrame.Visible
        end
    end)

    -- Анимация открытия
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.BackgroundTransparency = 1

    task.delay(3, function()
        tween(mainFrame, {
            Size = windowSize,
            Position = UDim2.new(0.5, -(windowSize.X.Offset/2), 0.5, -(windowSize.Y.Offset/2)),
            BackgroundTransparency = 0,
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    -- ============================================
    --              📑 TAB
    -- ============================================
    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local tabName = tabConfig.Name or "Tab"
        local tabIcon = tabConfig.Icon or "rbxassetid://10734950309"

        local Tab = {}

        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName
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
        tabContent.Name = tabName .. "_Content"
        tabContent.Size = UDim2.new(1, -20, 1, -20)
        tabContent.Position = UDim2.new(0, 10, 0, 10)
        tabContent.BackgroundTransparency = 1
        tabContent.ScrollBarThickness = 3
        tabContent.ScrollBarImageColor3 = Theme.Accent
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.ZIndex = 3
        tabContent.Parent = contentArea

        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 8)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent

        contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 20)
        end)

        local function activate()
            for _, t in ipairs(Window._tabs) do
                t._deactivate()
            end
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

        tabBtn.MouseEnter:Connect(function()
            if Window._activeTab ~= Tab then
                tween(tabBtn, { BackgroundTransparency = 0.2 }, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if Window._activeTab ~= Tab then
                tween(tabBtn, { BackgroundTransparency = 0.5 }, 0.15)
            end
        end)

        tabBtn.MouseButton1Click:Connect(activate)

        if #Window._tabs == 0 then
            task.defer(activate)
        end

        table.insert(Window._tabs, Tab)

        -- SECTION
        function Tab:CreateSection(name)
            local f = Instance.new("Frame")
            f.Size = UDim2.new(1, 0, 0, 30)
            f.BackgroundTransparency = 1
            f.ZIndex = 3
            f.Parent = tabContent

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -10, 1, 0)
            l.Position = UDim2.new(0, 5, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = name or "Section"
            l.TextColor3 = Theme.TextDarker
            l.TextSize = 12
            l.Font = Enum.Font.GothamBold
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 4
            l.Parent = f

            local ln = Instance.new("Frame")
            ln.Size = UDim2.new(1, -10, 0, 1)
            ln.Position = UDim2.new(0, 5, 1, -1)
            ln.BackgroundColor3 = Theme.Divider
            ln.BorderSizePixel = 0
            ln.ZIndex = 4
            ln.Parent = f
        end

        -- BUTTON
        function Tab:CreateButton(config)
            config = config or {}
            local height = config.Description and 52 or 38

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, height)
            btn.BackgroundColor3 = Theme.Element
            btn.Text = ""
            btn.AutoButtonColor = false
            btn.ClipsDescendants = true
            btn.ZIndex = 3
            btn.Parent = tabContent
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -20, 0, 20)
            lbl.Position = UDim2.new(0, 15, 0, config.Description and 8 or 9)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Name or "Button"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = btn

            if config.Description then
                local d = Instance.new("TextLabel")
                d.Size = UDim2.new(1, -20, 0, 16)
                d.Position = UDim2.new(0, 15, 0, 28)
                d.BackgroundTransparency = 1
                d.Text = config.Description
                d.TextColor3 = Theme.TextDarker
                d.TextSize = 11
                d.Font = Enum.Font.Gotham
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.ZIndex = 4
                d.Parent = btn
            end

            btn.MouseEnter:Connect(function() tween(btn, { BackgroundColor3 = Theme.ElementHover }, 0.15) end)
            btn.MouseLeave:Connect(function() tween(btn, { BackgroundColor3 = Theme.Element }, 0.15) end)
            btn.MouseButton1Click:Connect(function()
                rippleEffect(btn, Mouse.X, Mouse.Y)
                pcall(config.Callback or function() end)
            end)
        end

        -- TOGGLE
        function Tab:CreateToggle(config)
            config = config or {}
            local toggled = config.Default or false
            local height = config.Description and 52 or 38

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, height)
            frame.BackgroundColor3 = Theme.Element
            frame.ZIndex = 3
            frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -70, 0, 20)
            lbl.Position = UDim2.new(0, 15, 0, config.Description and 8 or 9)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Name or "Toggle"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = frame

            if config.Description then
                local d = Instance.new("TextLabel")
                d.Size = UDim2.new(1, -70, 0, 16)
                d.Position = UDim2.new(0, 15, 0, 28)
                d.BackgroundTransparency = 1
                d.Text = config.Description
                d.TextColor3 = Theme.TextDarker
                d.TextSize = 11
                d.Font = Enum.Font.Gotham
                d.TextXAlignment = Enum.TextXAlignment.Left
                d.ZIndex = 4
                d.Parent = frame
            end

            local bg = Instance.new("Frame")
            bg.Size = UDim2.new(0, 44, 0, 24)
            bg.Position = UDim2.new(1, -55, 0.5, -12)
            bg.BackgroundColor3 = toggled and Theme.Toggle_On or Theme.Toggle_Off
            bg.ZIndex = 5
            bg.Parent = frame
            Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

            local circle = Instance.new("Frame")
            circle.Size = UDim2.new(0, 18, 0, 18)
            circle.Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            circle.BackgroundColor3 = Theme.Text
            circle.ZIndex = 6
            circle.Parent = bg
            Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

            local function upd()
                tween(bg, { BackgroundColor3 = toggled and Theme.Toggle_On or Theme.Toggle_Off }, 0.2)
                tween(circle, { Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9) }, 0.2)
            end

            local b = Instance.new("TextButton")
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.ZIndex = 7
            b.Parent = frame
            b.MouseButton1Click:Connect(function()
                toggled = not toggled
                upd()
                pcall(config.Callback or function() end, toggled)
            end)

            local obj = {}
            function obj:Set(v) toggled = v upd() pcall(config.Callback or function() end, v) end
            return obj
        end

        -- SLIDER
        function Tab:CreateSlider(config)
            config = config or {}
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local value = default

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 55)
            frame.BackgroundColor3 = Theme.Element
            frame.ZIndex = 3
            frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.6, 0, 0, 20)
            lbl.Position = UDim2.new(0, 15, 0, 8)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Name or "Slider"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = frame

            local valLbl = Instance.new("TextLabel")
            valLbl.Size = UDim2.new(0.35, 0, 0, 20)
            valLbl.Position = UDim2.new(0.65, -15, 0, 8)
            valLbl.BackgroundTransparency = 1
            valLbl.Text = tostring(value)
            valLbl.TextColor3 = Theme.Accent
            valLbl.TextSize = 14
            valLbl.Font = Enum.Font.GothamBold
            valLbl.TextXAlignment = Enum.TextXAlignment.Right
            valLbl.ZIndex = 4
            valLbl.Parent = frame

            local sBg = Instance.new("Frame")
            sBg.Size = UDim2.new(1, -30, 0, 6)
            sBg.Position = UDim2.new(0, 15, 0, 38)
            sBg.BackgroundColor3 = Theme.Slider_Bg
            sBg.ZIndex = 4
            sBg.Parent = frame
            Instance.new("UICorner", sBg).CornerRadius = UDim.new(1, 0)

            local pct = (value - min) / (max - min)

            local sFill = Instance.new("Frame")
            sFill.Size = UDim2.new(pct, 0, 1, 0)
            sFill.BackgroundColor3 = Theme.Slider_Fill
            sFill.ZIndex = 5
            sFill.Parent = sBg
            Instance.new("UICorner", sFill).CornerRadius = UDim.new(1, 0)

            local knob = Instance.new("Frame")
            knob.Size = UDim2.new(0, 16, 0, 16)
            knob.Position = UDim2.new(pct, -8, 0.5, -8)
            knob.BackgroundColor3 = Theme.Text
            knob.ZIndex = 6
            knob.Parent = sBg
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
            local ks = Instance.new("UIStroke")
            ks.Color = Theme.Accent
            ks.Thickness = 2
            ks.Parent = knob

            local function upd(p)
                p = math.clamp(p, 0, 1)
                local raw = min + (max - min) * p
                value = math.floor(raw / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                local rp = (value - min) / (max - min)
                tween(sFill, { Size = UDim2.new(rp, 0, 1, 0) }, 0.08)
                tween(knob, { Position = UDim2.new(rp, -8, 0.5, -8) }, 0.08)
                valLbl.Text = tostring(value)
                pcall(config.Callback or function() end, value)
            end

            local sliding = false

            local sInput = Instance.new("TextButton")
            sInput.Size = UDim2.new(1, 0, 0, 20)
            sInput.Position = UDim2.new(0, 0, 0, -7)
            sInput.BackgroundTransparency = 1
            sInput.Text = ""
            sInput.ZIndex = 7
            sInput.Parent = sBg

            sInput.MouseButton1Down:Connect(function()
                sliding = true
                upd((Mouse.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X)
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)

            RunService.RenderStepped:Connect(function()
                if sliding then
                    upd((Mouse.X - sBg.AbsolutePosition.X) / sBg.AbsoluteSize.X)
                end
            end)

            local obj = {}
            function obj:Set(v) upd((v - min) / (max - min)) end
            return obj
        end

        -- DROPDOWN
        function Tab:CreateDropdown(config)
            config = config or {}
            local options = config.Options or {}
            local selected = config.Default or (options[1] or "")
            local opened = false

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 38)
            frame.BackgroundColor3 = Theme.Element
            frame.ClipsDescendants = true
            frame.ZIndex = 3
            frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.5, 0, 0, 38)
            lbl.Position = UDim2.new(0, 15, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Name or "Dropdown"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = frame

            local sel = Instance.new("TextLabel")
            sel.Size = UDim2.new(0.45, -15, 0, 38)
            sel.Position = UDim2.new(0.55, 0, 0, 0)
            sel.BackgroundTransparency = 1
            sel.Text = selected .. " ▾"
            sel.TextColor3 = Theme.Accent
            sel.TextSize = 13
            sel.Font = Enum.Font.GothamMedium
            sel.TextXAlignment = Enum.TextXAlignment.Right
            sel.ZIndex = 4
            sel.Parent = frame

            local optC = Instance.new("Frame")
            optC.Size = UDim2.new(1, -10, 0, 0)
            optC.Position = UDim2.new(0, 5, 0, 42)
            optC.BackgroundTransparency = 1
            optC.ZIndex = 4
            optC.Parent = frame

            Instance.new("UIListLayout", optC).Padding = UDim.new(0, 3)

            local function createOpt(text)
                local ob = Instance.new("TextButton")
                ob.Size = UDim2.new(1, 0, 0, 30)
                ob.BackgroundColor3 = Theme.Dropdown_Bg
                ob.Text = text
                ob.TextColor3 = Theme.TextDark
                ob.TextSize = 13
                ob.Font = Enum.Font.Gotham
                ob.AutoButtonColor = false
                ob.ZIndex = 5
                ob.Parent = optC
                Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 6)

                ob.MouseEnter:Connect(function() tween(ob, { BackgroundColor3 = Theme.ElementHover, TextColor3 = Theme.Text }, 0.1) end)
                ob.MouseLeave:Connect(function() tween(ob, { BackgroundColor3 = Theme.Dropdown_Bg, TextColor3 = Theme.TextDark }, 0.1) end)
                ob.MouseButton1Click:Connect(function()
                    selected = text
                    sel.Text = text .. " ▾"
                    opened = false
                    tween(frame, { Size = UDim2.new(1, 0, 0, 38) }, 0.25)
                    pcall(config.Callback or function() end, text)
                end)
            end

            for _, o in ipairs(options) do createOpt(o) end

            local db = Instance.new("TextButton")
            db.Size = UDim2.new(1, 0, 0, 38)
            db.BackgroundTransparency = 1
            db.Text = ""
            db.ZIndex = 6
            db.Parent = frame
            db.MouseButton1Click:Connect(function()
                opened = not opened
                tween(frame, { Size = UDim2.new(1, 0, 0, opened and (48 + #options * 33) or 38) }, 0.25)
            end)

            local obj = {}
            function obj:Set(v) selected = v sel.Text = v .. " ▾" pcall(config.Callback or function() end, v) end
            function obj:Refresh(new)
                for _, c in ipairs(optC:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
                options = new
                for _, o in ipairs(options) do createOpt(o) end
            end
            return obj
        end

        -- INPUT
        function Tab:CreateInput(config)
            config = config or {}

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 38)
            frame.BackgroundColor3 = Theme.Element
            frame.ZIndex = 3
            frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(0.4, 0, 1, 0)
            lbl.Position = UDim2.new(0, 15, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = config.Name or "Input"
            lbl.TextColor3 = Theme.Text
            lbl.TextSize = 14
            lbl.Font = Enum.Font.GothamMedium
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.ZIndex = 4
            lbl.Parent = frame

            local tb = Instance.new("TextBox")
            tb.Size = UDim2.new(0.55, -15, 0, 26)
            tb.Position = UDim2.new(0.45, 0, 0.5, -13)
            tb.BackgroundColor3 = Theme.Input_Bg
            tb.Text = ""
            tb.PlaceholderText = config.PlaceholderText or "Type..."
            tb.PlaceholderColor3 = Theme.TextDarker
            tb.TextColor3 = Theme.Text
            tb.TextSize = 13
            tb.Font = Enum.Font.Gotham
            tb.ClearTextOnFocus = false
            tb.ZIndex = 5
            tb.Parent = frame
            Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
            Instance.new("UIPadding", tb).PaddingLeft = UDim.new(0, 8)

            local s = Instance.new("UIStroke")
            s.Color = Theme.Divider
            s.Thickness = 1
            s.Parent = tb

            tb.Focused:Connect(function() tween(s, { Color = Theme.Accent }, 0.2) end)
            tb.FocusLost:Connect(function(enter)
                tween(s, { Color = Theme.Divider }, 0.2)
                if enter then pcall(config.Callback or function() end, tb.Text) end
            end)
        end

        -- LABEL
        function Tab:CreateLabel(text)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 30)
            frame.BackgroundColor3 = Theme.Element
            frame.ZIndex = 3
            frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local l = Instance.new("TextLabel")
            l.Size = UDim2.new(1, -20, 1, 0)
            l.Position = UDim2.new(0, 10, 0, 0)
            l.BackgroundTransparency = 1
            l.Text = text or "Label"
            l.TextColor3 = Theme.TextDark
            l.TextSize = 13
            l.Font = Enum.Font.Gotham
            l.TextXAlignment = Enum.TextXAlignment.Left
            l.ZIndex = 4
            l.Parent = frame

            local obj = {}
            function obj:Set(t) l.Text = t end
            return obj
        end

        -- PARAGRAPH
        function Tab:CreateParagraph(config)
            config = config or {}

            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, 0, 0, 60)
            frame.BackgroundColor3 = Theme.Element
            frame.ZIndex = 3
            frame.Parent = tabContent
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(0, 3, 0.7, 0)
            bar.Position = UDim2.new(0, 6, 0.15, 0)
            bar.BackgroundColor3 = Theme.Accent
            bar.BorderSizePixel = 0
            bar.ZIndex = 4
            bar.Parent = frame
            Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 2)

            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(1, -25, 0, 20)
            t.Position = UDim2.new(0, 18, 0, 8)
            t.BackgroundTransparency = 1
            t.Text = config.Title or "Info"
            t.TextColor3 = Theme.Text
            t.TextSize = 14
            t.Font = Enum.Font.GothamBold
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.ZIndex = 4
            t.Parent = frame

            local c = Instance.new("TextLabel")
            c.Size = UDim2.new(1, -25, 0, 20)
            c.Position = UDim2.new(0, 18, 0, 30)
            c.BackgroundTransparency = 1
            c.Text = config.Content or ""
            c.TextColor3 = Theme.TextDark
            c.TextSize = 12
            c.Font = Enum.Font.Gotham
            c.TextXAlignment = Enum.TextXAlignment.Left
            c.TextWrapped = true
            c.ZIndex = 4
            c.Parent = frame
        end

        return Tab
    end

    -- NOTIFY
    function Window:Notify(config)
        config = config or {}
        local nColor = ({
            Info = Theme.Accent,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error,
        })[config.Type or "Info"] or Theme.Accent

        local dur = config.Duration or 4

        local nf = Instance.new("Frame")
        nf.Size = UDim2.new(0, 280, 0, 70)
        nf.Position = UDim2.new(1, 10, 1, -80)
        nf.BackgroundColor3 = Theme.SideBar
        nf.ZIndex = 50
        nf.Parent = screenGui
        Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 10)

        local ns = Instance.new("UIStroke")
        ns.Color = nColor
        ns.Thickness = 1
        ns.Transparency = 0.5
        ns.Parent = nf

        local na = Instance.new("Frame")
        na.Size = UDim2.new(0, 3, 0.7, 0)
        na.Position = UDim2.new(0, 8, 0.15, 0)
        na.BackgroundColor3 = nColor
        na.BorderSizePixel = 0
        na.ZIndex = 51
        na.Parent = nf
        Instance.new("UICorner", na).CornerRadius = UDim.new(0, 2)

        local nt = Instance.new("TextLabel")
        nt.Size = UDim2.new(1, -25, 0, 22)
        nt.Position = UDim2.new(0, 20, 0, 10)
        nt.BackgroundTransparency = 1
        nt.Text = config.Title or "Notification"
        nt.TextColor3 = Theme.Text
        nt.TextSize = 14
        nt.Font = Enum.Font.GothamBold
        nt.TextXAlignment = Enum.TextXAlignment.Left
        nt.ZIndex = 51
        nt.Parent = nf

        local nc = Instance.new("TextLabel")
        nc.Size = UDim2.new(1, -25, 0, 20)
        nc.Position = UDim2.new(0, 20, 0, 34)
        nc.BackgroundTransparency = 1
        nc.Text = config.Content or ""
        nc.TextColor3 = Theme.TextDark
        nc.TextSize = 12
        nc.Font = Enum.Font.Gotham
        nc.TextXAlignment = Enum.TextXAlignment.Left
        nc.TextWrapped = true
        nc.ZIndex = 51
        nc.Parent = nf

        local np = Instance.new("Frame")
        np.Size = UDim2.new(1, 0, 0, 2)
        np.Position = UDim2.new(0, 0, 1, -2)
        np.BackgroundColor3 = nColor
        np.BorderSizePixel = 0
        np.ZIndex = 51
        np.Parent = nf

        tween(nf, { Position = UDim2.new(1, -290, 1, -80) }, 0.4, Enum.EasingStyle.Back)
        tween(np, { Size = UDim2.new(0, 0, 0, 2) }, dur)

        task.delay(dur, function()
            tween(nf, { Position = UDim2.new(1, 10, 1, -80) }, 0.3)
            task.delay(0.35, function() if nf and nf.Parent then nf:Destroy() end end)
        end)
    end

    return Window
end

return NexusLib
