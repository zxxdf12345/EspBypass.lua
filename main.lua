local NexusLib = {}

-- Сервисы
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

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
    }, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    task.delay(0.6, function()
        ripple:Destroy()
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
            tween(frame, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }, 0.08)
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

    -- Удаляем старый если есть
    local old = CoreGui:FindFirstChild("NexusLib")
    if old then old:Destroy() end

    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "NexusLib"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

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

    -- Иконка
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

    -- Полоска загрузки
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
        introScreen:Destroy()
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

    -- Тень
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://6014261993"
    shadow.ImageColor3 = Color3.new(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.ZIndex = 0
    shadow.Parent = mainFrame

    -- ========== TOP BAR ==========
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Theme.TopBar
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 5
    topBar.Parent = mainFrame

    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 10)

    -- Фикс нижних углов topbar
    local topBarFix = Instance.new("Frame")
    topBarFix.Size = UDim2.new(1, 0, 0, 15)
    topBarFix.Position = UDim2.new(0, 0, 1, -15)
    topBarFix.BackgroundColor3 = Theme.TopBar
    topBarFix.BorderSizePixel = 0
    topBarFix.ZIndex = 5
    topBarFix.Parent = topBar

    makeDraggable(mainFrame, topBar)

    -- Иконка в topbar
    local topIcon = Instance.new("ImageLabel")
    topIcon.Size = UDim2.new(0, 22, 0, 22)
    topIcon.Position = UDim2.new(0, 12, 0.5, -11)
    topIcon.BackgroundTransparency = 1
    topIcon.Image = introIcon
    topIcon.ImageColor3 = Theme.Accent
    topIcon.ZIndex = 6
    topIcon.Parent = topBar

    -- Название
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

    -- Кнопки управления
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

    -- Закрыть
    createWindowBtn("✕", UDim2.new(1, -35, 0.5, -15), Theme.Error, function()
        tween(mainFrame, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
        }, 0.3)
        task.delay(0.35, function() screenGui:Destroy() end)
    end)

    -- Свернуть
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

    -- Разделитель
    local sideDiv = Instance.new("Frame")
    sideDiv.Size = UDim2.new(0, 1, 1, 0)
    sideDiv.Position = UDim2.new(1, 0, 0, 0)
    sideDiv.BackgroundColor3 = Theme.Divider
    sideDiv.BorderSizePixel = 0
    sideDiv.ZIndex = 4
    sideDiv.Parent = sideBar

    -- Контейнер табов
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

    -- ========== TOGGLE VISIBILITY ==========
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
        Tab._sections = {}

        -- Кнопка таба в sidebar
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

        -- Акцентная полоска слева
        local tabAccent = Instance.new("Frame")
        tabAccent.Name = "Accent"
        tabAccent.Size = UDim2.new(0, 3, 0.6, 0)
        tabAccent.Position = UDim2.new(0, 0, 0.2, 0)
        tabAccent.BackgroundColor3 = Theme.Accent
        tabAccent.BackgroundTransparency = 1
        tabAccent.BorderSizePixel = 0
        tabAccent.ZIndex = 6
        tabAccent.Parent = tabBtn
        Instance.new("UICorner", tabAccent).CornerRadius = UDim.new(0, 2)

        -- Иконка
        local tabIconImg = Instance.new("ImageLabel")
        tabIconImg.Size = UDim2.new(0, 18, 0, 18)
        tabIconImg.Position = UDim2.new(0, 12, 0.5, -9)
        tabIconImg.BackgroundTransparency = 1
        tabIconImg.Image = tabIcon
        tabIconImg.ImageColor3 = Theme.TextDark
        tabIconImg.ZIndex = 6
        tabIconImg.Parent = tabBtn

        -- Текст
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

        -- Контент для этого таба
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

        -- Функции активации
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
        Tab._content = tabContent
        Tab._btn = tabBtn

        -- Hover
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

        -- Первый таб активен
        if #Window._tabs == 0 then
            task.defer(activate)
        end

        table.insert(Window._tabs, Tab)

        -- ============================================
        --              📦 SECTION
        -- ============================================
        function Tab:CreateSection(sectionName)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.BackgroundTransparency = 1
            sectionFrame.ZIndex = 3
            sectionFrame.Parent = tabContent

            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Size = UDim2.new(1, -10, 1, 0)
            sectionLabel.Position = UDim2.new(0, 5, 0, 0)
            sectionLabel.BackgroundTransparency = 1
            sectionLabel.Text = sectionName or "Section"
            sectionLabel.TextColor3 = Theme.TextDarker
            sectionLabel.TextSize = 12
            sectionLabel.Font = Enum.Font.GothamBold
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.ZIndex = 4
            sectionLabel.Parent = sectionFrame

            local sectionLine = Instance.new("Frame")
            sectionLine.Size = UDim2.new(1, -10, 0, 1)
            sectionLine.Position = UDim2.new(0, 5, 1, -1)
            sectionLine.BackgroundColor3 = Theme.Divider
            sectionLine.BorderSizePixel = 0
            sectionLine.ZIndex = 4
            sectionLine.Parent = sectionFrame
        end

        -- ============================================
        --              🔘 BUTTON
        -- ============================================
        function Tab:CreateButton(config)
            config = config or {}
            local btnName = config.Name or "Button"
            local btnDesc = config.Description or nil
            local callback = config.Callback or function() end

            local height = btnDesc and 52 or 38

            local btnFrame = Instance.new("TextButton")
            btnFrame.Size = UDim2.new(1, 0, 0, height)
            btnFrame.BackgroundColor3 = Theme.Element
            btnFrame.Text = ""
            btnFrame.AutoButtonColor = false
            btnFrame.ClipsDescendants = true
            btnFrame.ZIndex = 3
            btnFrame.Parent = tabContent

            Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 8)

            local btnLabel = Instance.new("TextLabel")
            btnLabel.Size = UDim2.new(1, -20, 0, 20)
            btnLabel.Position = UDim2.new(0, 15, 0, btnDesc and 8 or 9)
            btnLabel.BackgroundTransparency = 1
            btnLabel.Text = btnName
            btnLabel.TextColor3 = Theme.Text
            btnLabel.TextSize = 14
            btnLabel.Font = Enum.Font.GothamMedium
            btnLabel.TextXAlignment = Enum.TextXAlignment.Left
            btnLabel.ZIndex = 4
            btnLabel.Parent = btnFrame

            if btnDesc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(1, -20, 0, 16)
                descLabel.Position = UDim2.new(0, 15, 0, 28)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = btnDesc
                descLabel.TextColor3 = Theme.TextDarker
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.ZIndex = 4
                descLabel.Parent = btnFrame
            end

            btnFrame.MouseEnter:Connect(function()
                tween(btnFrame, { BackgroundColor3 = Theme.ElementHover }, 0.15)
            end)
            btnFrame.MouseLeave:Connect(function()
                tween(btnFrame, { BackgroundColor3 = Theme.Element }, 0.15)
            end)
            btnFrame.MouseButton1Click:Connect(function()
                rippleEffect(btnFrame, Mouse.X, Mouse.Y)
                callback()
            end)
        end

        -- ============================================
        --              🔄 TOGGLE
        -- ============================================
        function Tab:CreateToggle(config)
            config = config or {}
            local toggleName = config.Name or "Toggle"
            local toggleDesc = config.Description or nil
            local default = config.Default or false
            local callback = config.Callback or function() end

            local toggled = default
            local height = toggleDesc and 52 or 38

            local toggleFrame = Instance.new("Frame")
            toggleFrame.Size = UDim2.new(1, 0, 0, height)
            toggleFrame.BackgroundColor3 = Theme.Element
            toggleFrame.ZIndex = 3
            toggleFrame.Parent = tabContent

            Instance.new("UICorner", toggleFrame).CornerRadius = UDim.new(0, 8)

            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -70, 0, 20)
            toggleLabel.Position = UDim2.new(0, 15, 0, toggleDesc and 8 or 9)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = toggleName
            toggleLabel.TextColor3 = Theme.Text
            toggleLabel.TextSize = 14
            toggleLabel.Font = Enum.Font.GothamMedium
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.ZIndex = 4
            toggleLabel.Parent = toggleFrame

            if toggleDesc then
                local descLabel = Instance.new("TextLabel")
                descLabel.Size = UDim2.new(1, -70, 0, 16)
                descLabel.Position = UDim2.new(0, 15, 0, 28)
                descLabel.BackgroundTransparency = 1
                descLabel.Text = toggleDesc
                descLabel.TextColor3 = Theme.TextDarker
                descLabel.TextSize = 11
                descLabel.Font = Enum.Font.Gotham
                descLabel.TextXAlignment = Enum.TextXAlignment.Left
                descLabel.ZIndex = 4
                descLabel.Parent = toggleFrame
            end

            -- Переключатель
            local toggleBg = Instance.new("Frame")
            toggleBg.Size = UDim2.new(0, 44, 0, 24)
            toggleBg.Position = UDim2.new(1, -55, 0.5, -12)
            toggleBg.BackgroundColor3 = toggled and Theme.Toggle_On or Theme.Toggle_Off
            toggleBg.ZIndex = 5
            toggleBg.Parent = toggleFrame

            Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

            local toggleCircle = Instance.new("Frame")
            toggleCircle.Size = UDim2.new(0, 18, 0, 18)
            toggleCircle.Position = toggled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
            toggleCircle.BackgroundColor3 = Theme.Text
            toggleCircle.ZIndex = 6
            toggleCircle.Parent = toggleBg

            Instance.new("UICorner", toggleCircle).CornerRadius = UDim.new(1, 0)

            local function updateToggle()
                if toggled then
                    tween(toggleBg, { BackgroundColor3 = Theme.Toggle_On }, 0.2)
                    tween(toggleCircle, { Position = UDim2.new(1, -21, 0.5, -9) }, 0.2)
                else
                    tween(toggleBg, { BackgroundColor3 = Theme.Toggle_Off }, 0.2)
                    tween(toggleCircle, { Position = UDim2.new(0, 3, 0.5, -9) }, 0.2)
                end
            end

            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Size = UDim2.new(1, 0, 1, 0)
            toggleBtn.BackgroundTransparency = 1
            toggleBtn.Text = ""
            toggleBtn.ZIndex = 7
            toggleBtn.Parent = toggleFrame

            toggleBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggle()
                callback(toggled)
            end)

            local ToggleObj = {}
            function ToggleObj:Set(value)
                toggled = value
                updateToggle()
                callback(toggled)
            end
            return ToggleObj
        end

        -- ============================================
        --              📊 SLIDER
        -- ============================================
        function Tab:CreateSlider(config)
            config = config or {}
            local sliderName = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local callback = config.Callback or function() end

            local value = default

            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 55)
            sliderFrame.BackgroundColor3 = Theme.Element
            sliderFrame.ZIndex = 3
            sliderFrame.Parent = tabContent

            Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)

            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(0.6, 0, 0, 20)
            sliderLabel.Position = UDim2.new(0, 15, 0, 8)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = sliderName
            sliderLabel.TextColor3 = Theme.Text
            sliderLabel.TextSize = 14
            sliderLabel.Font = Enum.Font.GothamMedium
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.ZIndex = 4
            sliderLabel.Parent = sliderFrame

            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.35, 0, 0, 20)
            valueLabel.Position = UDim2.new(0.65, -15, 0, 8)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Text = tostring(value)
            valueLabel.TextColor3 = Theme.Accent
            valueLabel.TextSize = 14
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.ZIndex = 4
            valueLabel.Parent = sliderFrame

            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -30, 0, 6)
            sliderBg.Position = UDim2.new(0, 15, 0, 38)
            sliderBg.BackgroundColor3 = Theme.Slider_Bg
            sliderBg.ZIndex = 4
            sliderBg.Parent = sliderFrame

            Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)

            local pct = (value - min) / (max - min)

            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(pct, 0, 1, 0)
            sliderFill.BackgroundColor3 = Theme.Slider_Fill
            sliderFill.ZIndex = 5
            sliderFill.Parent = sliderBg

            Instance.new("UICorner", sliderFill).CornerRadius = UDim.new(1, 0)

            local sliderKnob = Instance.new("Frame")
            sliderKnob.Size = UDim2.new(0, 16, 0, 16)
            sliderKnob.Position = UDim2.new(pct, -8, 0.5, -8)
            sliderKnob.BackgroundColor3 = Theme.Text
            sliderKnob.ZIndex = 6
            sliderKnob.Parent = sliderBg

            Instance.new("UICorner", sliderKnob).CornerRadius = UDim.new(1, 0)

            local knobStroke = Instance.new("UIStroke")
            knobStroke.Color = Theme.Accent
            knobStroke.Thickness = 2
            knobStroke.Parent = sliderKnob

            local function update(p)
                p = math.clamp(p, 0, 1)
                local raw = min + (max - min) * p
                value = math.floor(raw / increment + 0.5) * increment
                value = math.clamp(value, min, max)

                local realPct = (value - min) / (max - min)
                tween(sliderFill, { Size = UDim2.new(realPct, 0, 1, 0) }, 0.08)
                tween(sliderKnob, { Position = UDim2.new(realPct, -8, 0.5, -8) }, 0.08)
                valueLabel.Text = tostring(value)
                callback(value)
            end

            local sliding = false

            local sliderInput = Instance.new("TextButton")
            sliderInput.Size = UDim2.new(1, 0, 0, 20)
            sliderInput.Position = UDim2.new(0, 0, 0, -7)
            sliderInput.BackgroundTransparency = 1
            sliderInput.Text = ""
            sliderInput.ZIndex = 7
            sliderInput.Parent = sliderBg

            sliderInput.MouseButton1Down:Connect(function()
                sliding = true
                local p = (Mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                update(p)
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sliding = false
                end
            end)

            RunService.RenderStepped:Connect(function()
                if sliding then
                    local p = (Mouse.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X
                    update(p)
                end
            end)

            local SliderObj = {}
            function SliderObj:Set(val)
                local p = (val - min) / (max - min)
                update(p)
            end
            return SliderObj
        end

        -- ============================================
        --              📝 DROPDOWN
        -- ============================================
        function Tab:CreateDropdown(config)
            config = config or {}
            local ddName = config.Name or "Dropdown"
            local options = config.Options or {}
            local default = config.Default or (options[1] or "")
            local callback = config.Callback or function() end

            local selected = default
            local opened = false

            local ddFrame = Instance.new("Frame")
            ddFrame.Size = UDim2.new(1, 0, 0, 38)
            ddFrame.BackgroundColor3 = Theme.Element
            ddFrame.ClipsDescendants = true
            ddFrame.ZIndex = 3
            ddFrame.Parent = tabContent

            Instance.new("UICorner", ddFrame).CornerRadius = UDim.new(0, 8)

            local ddLabel = Instance.new("TextLabel")
            ddLabel.Size = UDim2.new(0.5, 0, 0, 38)
            ddLabel.Position = UDim2.new(0, 15, 0, 0)
            ddLabel.BackgroundTransparency = 1
            ddLabel.Text = ddName
            ddLabel.TextColor3 = Theme.Text
            ddLabel.TextSize = 14
            ddLabel.Font = Enum.Font.GothamMedium
            ddLabel.TextXAlignment = Enum.TextXAlignment.Left
            ddLabel.ZIndex = 4
            ddLabel.Parent = ddFrame

            local ddSelected = Instance.new("TextLabel")
            ddSelected.Size = UDim2.new(0.45, -15, 0, 38)
            ddSelected.Position = UDim2.new(0.55, 0, 0, 0)
            ddSelected.BackgroundTransparency = 1
            ddSelected.Text = selected .. " ▾"
            ddSelected.TextColor3 = Theme.Accent
            ddSelected.TextSize = 13
            ddSelected.Font = Enum.Font.GothamMedium
            ddSelected.TextXAlignment = Enum.TextXAlignment.Right
            ddSelected.ZIndex = 4
            ddSelected.Parent = ddFrame

            local optionsContainer = Instance.new("Frame")
            optionsContainer.Size = UDim2.new(1, -10, 0, 0)
            optionsContainer.Position = UDim2.new(0, 5, 0, 42)
            optionsContainer.BackgroundTransparency = 1
            optionsContainer.ZIndex = 4
            optionsContainer.Parent = ddFrame

            local optLayout = Instance.new("UIListLayout")
            optLayout.Padding = UDim.new(0, 3)
            optLayout.Parent = optionsContainer

            local function createOption(text)
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 30)
                optBtn.BackgroundColor3 = Theme.Dropdown_Bg
                optBtn.Text = text
                optBtn.TextColor3 = Theme.TextDark
                optBtn.TextSize = 13
                optBtn.Font = Enum.Font.Gotham
                optBtn.AutoButtonColor = false
                optBtn.ZIndex = 5
                optBtn.Parent = optionsContainer

                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 6)

                optBtn.MouseEnter:Connect(function()
                    tween(optBtn, { BackgroundColor3 = Theme.ElementHover, TextColor3 = Theme.Text }, 0.1)
                end)
                optBtn.MouseLeave:Connect(function()
                    tween(optBtn, { BackgroundColor3 = Theme.Dropdown_Bg, TextColor3 = Theme.TextDark }, 0.1)
                end)

                optBtn.MouseButton1Click:Connect(function()
                    selected = text
                    ddSelected.Text = text .. " ▾"
                    opened = false
                    tween(ddFrame, { Size = UDim2.new(1, 0, 0, 38) }, 0.25)
                    callback(text)
                end)
            end

            for _, opt in ipairs(options) do
                createOption(opt)
            end

            local ddBtn = Instance.new("TextButton")
            ddBtn.Size = UDim2.new(1, 0, 0, 38)
            ddBtn.BackgroundTransparency = 1
            ddBtn.Text = ""
            ddBtn.ZIndex = 6
            ddBtn.Parent = ddFrame

            ddBtn.MouseButton1Click:Connect(function()
                opened = not opened
                local totalH = 38
                if opened then
                    totalH = 48 + (#options * 33)
                end
                tween(ddFrame, { Size = UDim2.new(1, 0, 0, totalH) }, 0.25)
            end)

            local DropObj = {}
            function DropObj:Set(val)
                selected = val
                ddSelected.Text = val .. " ▾"
                callback(val)
            end
            function DropObj:Refresh(newOptions)
                for _, c in ipairs(optionsContainer:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                options = newOptions
                for _, opt in ipairs(options) do
                    createOption(opt)
                end
            end
            return DropObj
        end

        -- ============================================
        --              📝 INPUT (TextBox)
        -- ============================================
        function Tab:CreateInput(config)
            config = config or {}
            local inputName = config.Name or "Input"
            local placeholder = config.PlaceholderText or "Type here..."
            local callback = config.Callback or function() end

            local inputFrame = Instance.new("Frame")
            inputFrame.Size = UDim2.new(1, 0, 0, 38)
            inputFrame.BackgroundColor3 = Theme.Element
            inputFrame.ZIndex = 3
            inputFrame.Parent = tabContent

            Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 8)

            local inputLabel = Instance.new("TextLabel")
            inputLabel.Size = UDim2.new(0.4, 0, 1, 0)
            inputLabel.Position = UDim2.new(0, 15, 0, 0)
            inputLabel.BackgroundTransparency = 1
            inputLabel.Text = inputName
            inputLabel.TextColor3 = Theme.Text
            inputLabel.TextSize = 14
            inputLabel.Font = Enum.Font.GothamMedium
            inputLabel.TextXAlignment = Enum.TextXAlignment.Left
            inputLabel.ZIndex = 4
            inputLabel.Parent = inputFrame

            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(0.55, -15, 0, 26)
            textBox.Position = UDim2.new(0.45, 0, 0.5, -13)
            textBox.BackgroundColor3 = Theme.Input_Bg
            textBox.Text = ""
            textBox.PlaceholderText = placeholder
            textBox.PlaceholderColor3 = Theme.TextDarker
            textBox.TextColor3 = Theme.Text
            textBox.TextSize = 13
            textBox.Font = Enum.Font.Gotham
            textBox.ClearTextOnFocus = false
            textBox.ZIndex = 5
            textBox.Parent = inputFrame

            Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)
            Instance.new("UIPadding", textBox).PaddingLeft = UDim.new(0, 8)

            local tbStroke = Instance.new("UIStroke")
            tbStroke.Color = Theme.Divider
            tbStroke.Thickness = 1
            tbStroke.Parent = textBox

            textBox.Focused:Connect(function()
                tween(tbStroke, { Color = Theme.Accent }, 0.2)
            end)
            textBox.FocusLost:Connect(function(enter)
                tween(tbStroke, { Color = Theme.Divider }, 0.2)
                if enter then callback(textBox.Text) end
            end)
        end

        -- ============================================
        --              📢 LABEL
        -- ============================================
        function Tab:CreateLabel(text)
            local labelFrame = Instance.new("Frame")
            labelFrame.Size = UDim2.new(1, 0, 0, 30)
            labelFrame.BackgroundColor3 = Theme.Element
            labelFrame.ZIndex = 3
            labelFrame.Parent = tabContent

            Instance.new("UICorner", labelFrame).CornerRadius = UDim.new(0, 8)

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -20, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text or "Label"
            label.TextColor3 = Theme.TextDark
            label.TextSize = 13
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.ZIndex = 4
            label.Parent = labelFrame

            local LabelObj = {}
            function LabelObj:Set(newText)
                label.Text = newText
            end
            return LabelObj
        end

        -- ============================================
        --              🔔 NOTIFY
        -- ============================================
        function Tab:CreateParagraph(config)
            config = config or {}
            local pTitle = config.Title or "Info"
            local pContent = config.Content or ""

            local pFrame = Instance.new("Frame")
            pFrame.Size = UDim2.new(1, 0, 0, 60)
            pFrame.BackgroundColor3 = Theme.Element
            pFrame.ZIndex = 3
            pFrame.Parent = tabContent

            Instance.new("UICorner", pFrame).CornerRadius = UDim.new(0, 8)

            local accentBar = Instance.new("Frame")
            accentBar.Size = UDim2.new(0, 3, 0.7, 0)
            accentBar.Position = UDim2.new(0, 6, 0.15, 0)
            accentBar.BackgroundColor3 = Theme.Accent
            accentBar.BorderSizePixel = 0
            accentBar.ZIndex = 4
            accentBar.Parent = pFrame
            Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 2)

            local pTitleLabel = Instance.new("TextLabel")
            pTitleLabel.Size = UDim2.new(1, -25, 0, 20)
            pTitleLabel.Position = UDim2.new(0, 18, 0, 8)
            pTitleLabel.BackgroundTransparency = 1
            pTitleLabel.Text = pTitle
            pTitleLabel.TextColor3 = Theme.Text
            pTitleLabel.TextSize = 14
            pTitleLabel.Font = Enum.Font.GothamBold
            pTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
            pTitleLabel.ZIndex = 4
            pTitleLabel.Parent = pFrame

            local pContentLabel = Instance.new("TextLabel")
            pContentLabel.Size = UDim2.new(1, -25, 0, 20)
            pContentLabel.Position = UDim2.new(0, 18, 0, 30)
            pContentLabel.BackgroundTransparency = 1
            pContentLabel.Text = pContent
            pContentLabel.TextColor3 = Theme.TextDark
            pContentLabel.TextSize = 12
            pContentLabel.Font = Enum.Font.Gotham
            pContentLabel.TextXAlignment = Enum.TextXAlignment.Left
            pContentLabel.TextWrapped = true
            pContentLabel.ZIndex = 4
            pContentLabel.Parent = pFrame
        end

        return Tab
    end

    -- ============================================
    --         🔔 УВЕДОМЛЕНИЯ
    -- ============================================
    function Window:Notify(config)
        config = config or {}
        local nTitle = config.Title or "Notification"
        local nContent = config.Content or ""
        local nDuration = config.Duration or 4
        local nType = config.Type or "Info"

        local typeColors = {
            Info = Theme.Accent,
            Success = Theme.Success,
            Warning = Theme.Warning,
            Error = Theme.Error,
        }
        local nColor = typeColors[nType] or Theme.Accent

        local notifFrame = Instance.new("Frame")
        notifFrame.Size = UDim2.new(0, 280, 0, 70)
        notifFrame.Position = UDim2.new(1, 10, 1, -80)
        notifFrame.BackgroundColor3 = Theme.SideBar
        notifFrame.ZIndex = 50
        notifFrame.Parent = screenGui

        Instance.new("UICorner", notifFrame).CornerRadius = UDim.new(0, 10)
        local nStroke = Instance.new("UIStroke")
        nStroke.Color = nColor
        nStroke.Thickness = 1
        nStroke.Transparency = 0.5
        nStroke.Parent = notifFrame

        local nAccent = Instance.new("Frame")
        nAccent.Size = UDim2.new(0, 3, 0.7, 0)
        nAccent.Position = UDim2.new(0, 8, 0.15, 0)
        nAccent.BackgroundColor3 = nColor
        nAccent.BorderSizePixel = 0
        nAccent.ZIndex = 51
        nAccent.Parent = notifFrame
        Instance.new("UICorner", nAccent).CornerRadius = UDim.new(0, 2)

        local nTitleL = Instance.new("TextLabel")
        nTitleL.Size = UDim2.new(1, -25, 0, 22)
        nTitleL.Position = UDim2.new(0, 20, 0, 10)
        nTitleL.BackgroundTransparency = 1
        nTitleL.Text = nTitle
        nTitleL.TextColor3 = Theme.Text
        nTitleL.TextSize = 14
        nTitleL.Font = Enum.Font.GothamBold
        nTitleL.TextXAlignment = Enum.TextXAlignment.Left
        nTitleL.ZIndex = 51
        nTitleL.Parent = notifFrame

        local nContentL = Instance.new("TextLabel")
        nContentL.Size = UDim2.new(1, -25, 0, 20)
        nContentL.Position = UDim2.new(0, 20, 0, 34)
        nContentL.BackgroundTransparency = 1
        nContentL.Text = nContent
        nContentL.TextColor3 = Theme.TextDark
        nContentL.TextSize = 12
        nContentL.Font = Enum.Font.Gotham
        nContentL.TextXAlignment = Enum.TextXAlignment.Left
        nContentL.TextWrapped = true
        nContentL.ZIndex = 51
        nContentL.Parent = notifFrame

        -- Прогресс бар
        local nProgress = Instance.new("Frame")
        nProgress.Size = UDim2.new(1, 0, 0, 2)
        nProgress.Position = UDim2.new(0, 0, 1, -2)
        nProgress.BackgroundColor3 = nColor
        nProgress.BorderSizePixel = 0
        nProgress.ZIndex = 51
        nProgress.Parent = notifFrame

        -- Анимация
        tween(notifFrame, { Position = UDim2.new(1, -290, 1, -80) }, 0.4, Enum.EasingStyle.Back)
        tween(nProgress, { Size = UDim2.new(0, 0, 0, 2) }, nDuration)

        task.delay(nDuration, function()
            tween(notifFrame, { Position = UDim2.new(1, 10, 1, -80) }, 0.3)
            task.delay(0.35, function() notifFrame:Destroy() end)
        end)
    end

    return Window
end

return NexusLib
