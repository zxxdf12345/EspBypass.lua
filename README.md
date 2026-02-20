How to use NexusLib in your scripts
   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
NexusLib — Modern Roblox UI Library

-- Load the library
local NexusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxxdf12345/EspBypass.lua/main/main.lua"))()

-- Creating a Window

local Window = NexusLib:CreateWindow({
    Name = "My Hub",                          -- Window title
    IntroText = "Welcome!",                   -- Intro screen text
    IntroIcon = "rbxassetid://10734950309",   -- Intro icon (optional)
    ToggleKey = Enum.KeyCode.RightControl,    -- Key to show/hide UI
    Theme = "Default",                        -- Theme name (optional)
    Intro = true,                             -- Show intro animation (optional)
    IntroDuration = 2.5,                      -- Intro duration in seconds (optional)
    Size = UDim2.new(0, 580, 0, 420),         -- Window size (optional)
    AccentColor = Color3.fromRGB(88,101,242), -- Custom accent color (optional)
    ConfigName = "myconfig",                  -- Config save name (optional)
})

-- Available Themes Default, Ocean, Rose, Emerald, Sunset, Purple, Midnight, Snow

-- Change Theme
NexusLib:SetTheme("Ocean")

-- Get All Themes
local themes = NexusLib:GetThemes()
-- Returns: {"Default", "Emerald", "Midnight", "Ocean", ...}

-- Add Custom Theme
NexusLib:AddTheme("MyTheme", {
    Background = Color3.fromRGB(12, 12, 18),
    SideBar = Color3.fromRGB(16, 16, 24),
    TopBar = Color3.fromRGB(18, 18, 28),
    TabActive = Color3.fromRGB(25, 25, 40),
    TabInactive = Color3.fromRGB(16, 16, 24),
    Element = Color3.fromRGB(25, 25, 38),
    ElementHover = Color3.fromRGB(30, 30, 48),
    Accent = Color3.fromRGB(255, 100, 100),
    Text = Color3.fromRGB(240, 240, 245),
    TextDark = Color3.fromRGB(150, 150, 170),
    TextDarker = Color3.fromRGB(100, 100, 120),
    Toggle_On = Color3.fromRGB(255, 100, 100),
    Toggle_Off = Color3.fromRGB(55, 55, 75),
    Slider_Fill = Color3.fromRGB(255, 100, 100),
    Slider_Bg = Color3.fromRGB(35, 35, 50),
    Dropdown_Bg = Color3.fromRGB(18, 18, 28),
    Input_Bg = Color3.fromRGB(18, 18, 28),
    Divider = Color3.fromRGB(35, 35, 50),
    Success = Color3.fromRGB(67, 181, 129),
    Warning = Color3.fromRGB(250, 166, 26),
    Error = Color3.fromRGB(237, 66, 69),
})


-- Creating Tabs
local MainTab = Window:CreateTab({
    Name = "Main",                          -- Tab name
    Icon = "rbxassetid://7733960981",       -- Tab icon
})

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "rbxassetid://7734053495",
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://10734950309",
})

-- Working Icon IDs
local Icons = {
    Home         = "rbxassetid://128588179228440",   --  House
    Cat          = "rbxassetid://136950552123022",   --  Cat
    CircleCheck  = "rbxassetid://114625528286597",   --  Circle with checkmark
    Ghost        = "rbxassetid://116866851632001",   --  Ghost
    ShieldCheck  = "rbxassetid://127538584008424",   --  Shield with checkmark
    Skull        = "rbxassetid://117321420269565",   --  Skull
}

-- Usage Example Icons
local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "rbxassetid://128588179228440",  -- Home
})

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "rbxassetid://117321420269565",  -- Skull
})

local SafetyTab = Window:CreateTab({
    Name = "Safety",
    Icon = "rbxassetid://127538584008424",  -- Shield Check
})

local FunTab = Window:CreateTab({
    Name = "Fun",
    Icon = "rbxassetid://116866851632001",  -- Ghost
})

local StatusTab = Window:CreateTab({
    Name = "Status",
    Icon = "rbxassetid://114625528286597",  -- Circle Check
})

local PetsTab = Window:CreateTab({
    Name = "Pets",
    Icon = "rbxassetid://136950552123022",  -- Cat
})

-- Sections
-- Creates a section header to organize elements
MainTab:CreateSection("Combat Features")

-- Another section
MainTab:CreateSection("Movement")

-- Button
-- Simple button
MainTab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

-- Button with description
MainTab:CreateButton({
    Name = "Kill All Enemies",
    Description = "Eliminates all nearby enemies instantly",
    Callback = function()
        -- your code here
        print("Enemies eliminated!")
    end
})

-- Toggle
-- Simple toggle
local myToggle = MainTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm:", value) -- true or false
    end
})

-- Toggle with description and flag
local godMode = MainTab:CreateToggle({
    Name = "God Mode",
    Description = "Makes you invincible",
    Default = false,
    Flag = "GodModeToggle",  -- Used for config saving
    Callback = function(value)
        if value then
            print("God mode ON")
        else
            print("God mode OFF")
        end
    end
})

-- Control toggle from code
myToggle:Set(true)           -- Turn on
myToggle:Set(false)          -- Turn off
local state = myToggle:Get() -- Get current state

-- Simple slider
local speedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
})

-- Slider with suffix and flag
local fovSlider = MainTab:CreateSlider({
    Name = "Field of View",
    Min = 30,
    Max = 120,
    Default = 70,
    Increment = 1,
    Suffix = "°",              -- Shows after the number (e.g. "70°")
    Flag = "FOVSlider",
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end
})

-- Slider with decimal increments
MainTab:CreateSlider({
    Name = "Multiplier",
    Min = 0.5,
    Max = 5,
    Default = 1,
    Increment = 0.1,
    Suffix = "x",
    Callback = function(value)
        print("Multiplier:", value)
    end
})

-- Control slider from code
speedSlider:Set(100)           -- Set value to 100
local val = speedSlider:Get()  -- Get current value

-- Simple dropdown
local modeDropdown = MainTab:CreateDropdown({
    Name = "Game Mode",
    Options = {"Easy", "Medium", "Hard", "Extreme"},
    Default = "Easy",
    Callback = function(option)
        print("Selected mode:", option)
    end
})

-- Dropdown with flag
MainTab:CreateDropdown({
    Name = "Target Type",
    Options = {"Nearest", "Lowest HP", "Random"},
    Default = "Nearest",
    Flag = "TargetType",
    Callback = function(option)
        print("Target:", option)
    end
})

-- Control dropdown from code
modeDropdown:Set("Hard")              -- Change selection
local selected = modeDropdown:Get()   -- Get current selection

-- Update options dynamically
modeDropdown:Refresh({"Option1", "Option2", "Option3"})

-- Example: Player list dropdown
local function getPlayers()
    local names = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= game.Players.LocalPlayer then
            table.insert(names, p.Name)
        end
    end
    return names
end

local playerDD = MainTab:CreateDropdown({
    Name = "Select Player",
    Options = getPlayers(),
    Callback = function(name)
        print("Selected player:", name)
    end
})

-- Refresh button for player list
MainTab:CreateButton({
    Name = "Refresh Players",
    Callback = function()
        playerDD:Refresh(getPlayers())
    end
})

-- Simple input
local nameInput = MainTab:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter username...",
    Callback = function(text)
        print("Entered:", text)
    end
})

-- Input with default value
MainTab:CreateInput({
    Name = "Chat Message",
    Default = "Hello!",
    PlaceholderText = "Type message...",
    Flag = "ChatMessage",
    Callback = function(text)
        print("Message:", text)
    end
})

-- Control input from code
nameInput:Set("NewText")         -- Set text
local text = nameInput:Get()     -- Get current text

-- Simple keybind
local flyKey = MainTab:CreateKeybind({
    Name = "Fly Toggle",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("Fly key set to:", key.Name)
    end
})

-- Keybind with flag
MainTab:CreateKeybind({
    Name = "ESP Toggle",
    Default = Enum.KeyCode.E,
    Flag = "ESPKeybind",
    Callback = function(key)
        print("ESP key:", key.Name)
    end
})

-- Control keybind from code
flyKey:Set(Enum.KeyCode.G)       -- Change to G key
local key = flyKey:Get()         -- Get current key

-- Use keybind in your code
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == flyKey:Get() then
        -- Toggle fly
    end
end)

-- Color Picker
local espColor = MainTab:CreateColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(color)
        print("Color:", color)
    end
})

-- Control from code
espColor:Set(Color3.fromRGB(0, 255, 0))
local color = espColor:Get()

-- 📝 Simple label
local statusLabel = MainTab:CreateLabel("Status: Idle")

-- Update label text
statusLabel:Set("Status: Running")
statusLabel:Set("Players killed: 15")

-- 📄 Info paragraph
MainTab:CreateParagraph({
    Title = "About",
    Content = "This script was made by You\nVersion 1.0\nEnjoy!"
})

-- Multi-line paragraph
local infoBox = MainTab:CreateParagraph({
    Title = "Game Info",
    Content = "Game: " .. game.Name .. "\nPlayers: " .. #game.Players:GetPlayers()
})

-- Update paragraph
infoBox:Set("Updated Title", "New content here\nLine 2")

-- ➖ Divider & Spacer
-- Horizontal line divider
MainTab:CreateDivider()

-- Empty space (height in pixels)
MainTab:CreateSpacer(15)
MainTab:CreateSpacer(30)

-- 🔔 Notifications
-- Success notification
Window:Notify({
    Title = "Success!",
    Content = "Script loaded successfully",
    Duration = 4,           -- seconds
    Type = "Success",       -- Success, Info, Warning, Error
})

-- Error notification
Window:Notify({
    Title = "Error",
    Content = "Player not found",
    Duration = 3,
    Type = "Error",
})

-- Warning notification
Window:Notify({
    Title = "Warning",
    Content = "Low health detected",
    Duration = 5,
    Type = "Warning",
})

-- Info notification
Window:Notify({
    Title = "Info",
    Content = "Press F to toggle fly",
    Duration = 3,
    Type = "Info",
})

-- 💾 Config System
-- Save current settings
Window:SaveConfig("myconfig")

-- Load saved settings
Window:LoadConfig("myconfig")

-- Auto-save button example
SettingsTab:CreateButton({
    Name = "Save Settings",
    Callback = function()
        Window:SaveConfig("myconfig")
    end
})

SettingsTab:CreateButton({
    Name = "Load Settings",
    Callback = function()
        Window:LoadConfig("myconfig")
    end
})

-- Window Controls
-- Toggle window visibility
Window:Toggle()            -- Toggle
Window:Toggle(true)        -- Show
Window:Toggle(false)       -- Hide

-- Destroy window completely
Window:Destroy()

-- 📋 Complete Example Script
local NexusLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/zxxdf12345/EspBypass.lua/main/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

local Window = NexusLib:CreateWindow({
    Name = "My Script Hub v1.0",
    IntroText = "My Script Hub",
    IntroIcon = "rbxassetid://10734950309",
    ToggleKey = Enum.KeyCode.RightControl,
    Theme = "Default",
    Intro = true,
    IntroDuration = 2,
    Size = UDim2.new(0, 600, 0, 440),
})

local PlayerTab = Window:CreateTab({
    Name = "Player",
    Icon = "rbxassetid://7733960981",
})

PlayerTab:CreateSection("Movement")

PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Min = 16, Max = 500, Default = 16, Increment = 1,
    Callback = function(v)
        pcall(function()
            LP.Character.Humanoid.WalkSpeed = v
        end)
    end
})

PlayerTab:CreateSlider({
    Name = "Jump Power",
    Min = 50, Max = 500, Default = 50, Increment = 1,
    Callback = function(v)
        pcall(function()
            LP.Character.Humanoid.JumpPower = v
        end)
    end
})

local infJump = false
PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    Description = "Jump in the air infinitely",
    Default = false,
    Callback = function(v)
        infJump = v
    end
})

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump then
        pcall(function()
            LP.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end)

PlayerTab:CreateSection("Actions")

PlayerTab:CreateButton({
    Name = "Reset Character",
    Description = "Kill your character",
    Callback = function()
        pcall(function()
            LP.Character.Humanoid.Health = 0
        end)
    end
})

local CombatTab = Window:CreateTab({
    Name = "Combat",
    Icon = "rbxassetid://7734053495",
})

CombatTab:CreateSection("Auto")

local autoFarm = false
CombatTab:CreateToggle({
    Name = "Auto Farm",
    Description = "Automatically farms enemies",
    Default = false,
    Callback = function(v)
        autoFarm = v
    end
})

CombatTab:CreateDropdown({
    Name = "Farm Mode",
    Options = {"Nearest", "Strongest", "Weakest"},
    Default = "Nearest",
    Callback = function(v)
        print("Farm mode:", v)
    end
})

CombatTab:CreateSlider({
    Name = "Farm Range",
    Min = 10, Max = 200, Default = 50, Increment = 5, Suffix = " studs",
    Callback = function(v)
        print("Farm range:", v)
    end
})

CombatTab:CreateSection("Keybinds")

CombatTab:CreateKeybind({
    Name = "Farm Toggle Key",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        print("Farm key:", key.Name)
    end
})

local SettingsTab = Window:CreateTab({
    Name = "Settings",
    Icon = "rbxassetid://10734950309",
})

SettingsTab:CreateSection("UI")

SettingsTab:CreateDropdown({
    Name = "Theme",
    Options = NexusLib:GetThemes(),
    Default = "Default",
    Callback = function(v)
        print("Theme:", v)
    end
})

SettingsTab:CreateSection("Info")

SettingsTab:CreateParagraph({
    Title = "My Script Hub",
    Content = "Version: 1.0\nMade with NexusLib\nPress RightCtrl to toggle"
})

local gameName = "Unknown"
pcall(function()
    gameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
end)

SettingsTab:CreateLabel("Game: " .. gameName)
SettingsTab:CreateLabel("Players: " .. #Players:GetPlayers())

Window:Notify({
    Title = "Loaded!",
    Content = "My Script Hub loaded successfully",
    Duration = 4,
    Type = "Success",
})

-- You can test it work but so bad
