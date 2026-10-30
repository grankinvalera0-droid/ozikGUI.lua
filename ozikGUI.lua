
--[[
    ozikGUI v1.0
    Black & Red Roblox Hub
    UI and local testing prototype
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local GUI = Instance.new("ScreenGui")
GUI.Name = "ozikGUI"
GUI.ResetOnSpawn = false

local success = pcall(function()
    GUI.Parent = game:GetService("CoreGui")
end)

if not success then
    GUI.Parent = Player:WaitForChild("PlayerGui")
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(620, 420)
Main.Position = UDim2.new(0.5, -310, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = GUI

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Border = Instance.new("UIStroke", Main)
Border.Color = Color3.fromRGB(210, 25, 40)
Border.Thickness = 2

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(115, 15, 25)
Header.Text = "🔥 ozikGUI"
Header.TextColor3 = Color3.new(1, 1, 1)
Header.Font = Enum.Font.GothamBold
Header.TextSize = 24
Header.Parent = Main

local Sidebar = Instance.new("Frame")
Sidebar.Position = UDim2.fromOffset(12, 65)
Sidebar.Size = UDim2.new(0, 145, 1, -78)
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 29)
Sidebar.Parent = Main

Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local SideLayout = Instance.new("UIListLayout")
SideLayout.Padding = UDim.new(0, 6)
SideLayout.Parent = Sidebar

local Content = Instance.new("ScrollingFrame")
Content.Position = UDim2.fromOffset(168, 65)
Content.Size = UDim2.new(1, -180, 1, -78)
Content.BackgroundColor3 = Color3.fromRGB(23, 23, 27)
Content.BorderSizePixel = 0
Content.ScrollBarThickness = 4
Content.Parent = Main

Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 8)

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 8)
ContentLayout.Parent = Content

ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Content.CanvasSize = UDim2.fromOffset(
        0,
        ContentLayout.AbsoluteContentSize.Y + 15
    )
end)

local Search = Instance.new("TextBox")
Search.Size = UDim2.new(1, -12, 0, 34)
Search.Position = UDim2.fromOffset(6, 6)
Search.BackgroundColor3 = Color3.fromRGB(40, 35, 38)
Search.PlaceholderText = "Search functions..."
Search.Text = ""
Search.TextColor3 = Color3.new(1, 1, 1)
Search.PlaceholderColor3 = Color3.fromRGB(160, 150, 150)
Search.Font = Enum.Font.Gotham
Search.TextSize = 13
Search.Parent = Content

Instance.new("UICorner", Search).CornerRadius = UDim.new(0, 6)

local CurrentPage = ""
local Buttons = {}

local function ClearContent()
    for _, object in ipairs(Content:GetChildren()) do
        if object ~= ContentLayout and object ~= Search then
            object:Destroy()
        end
    end
    Buttons = {}
end

local function AddFeature(name, description)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -12, 0, 48)
    Button.BackgroundColor3 = Color3.fromRGB(43, 34, 37)
    Button.Text = ""
    Button.Parent = Content

    Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 7)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -65, 0, 23)
    Label.Position = UDim2.fromOffset(10, 3)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Button

    local Desc = Instance.new("TextLabel")
    Desc.Size = UDim2.new(1, -65, 0, 17)
    Desc.Position = UDim2.fromOffset(10, 25)
    Desc.BackgroundTransparency = 1
    Desc.Text = description or "Local interface option"
    Desc.TextColor3 = Color3.fromRGB(160, 155, 155)
    Desc.Font = Enum.Font.Gotham
    Desc.TextSize = 10
    Desc.TextXAlignment = Enum.TextXAlignment.Left
    Desc.Parent = Button

    local State = Instance.new("TextLabel")
    State.Size = UDim2.fromOffset(42, 24)
    State.Position = UDim2.new(1, -49, 0.5, -12)
    State.BackgroundColor3 = Color3.fromRGB(90, 35, 40)
    State.Text = "OFF"
    State.TextColor3 = Color3.new(1, 1, 1)
    State.Font = Enum.Font.GothamBold
    State.TextSize = 10
    State.Parent = Button

    Instance.new("UICorner", State).CornerRadius = UDim.new(0, 5)

    local active = false

    Button.MouseButton1Click:Connect(function()
        active = not active
        State.Text = active and "ON" or "OFF"
        State.BackgroundColor3 = active
            and Color3.fromRGB(185, 25, 40)
            or Color3.fromRGB(90, 35, 40)
    end)

    table.insert(Buttons, {
        frame = Button,
        name = name
    })
end

local Pages = {
    Movement = {
        {"Fly", "Movement test placeholder"},
        {"Speed", "Movement test placeholder"},
        {"Jump Power", "Movement test placeholder"},
        {"Infinite Jump", "Movement test placeholder"},
        {"Noclip", "Movement test placeholder"}
    },

    Visuals = {
        {"Player ESP", "Visual test placeholder"},
        {"Name Tags", "Player labels"},
        {"Distance ESP", "Distance display"},
        {"Fullbright", "Lighting test"}
    },

    Player = {
        {"Player Information", "Character information"},
        {"Camera Settings", "Camera test"},
        {"Character Information", "Character details"}
    },

    Teleport = {
        {"Save Position", "Position saving placeholder"},
        {"Return Position", "Position return placeholder"}
    },

    Forsaken = {
        {"Auto Block UI", "Block testing interface only"},
        {"Attack Warning", "Attack warning placeholder"},
        {"Killer ESP", "Visual test placeholder"},
        {"Attack Distance", "Distance display"},
        {"Ping Monitor", "Network information"},
        {"Block Cooldown", "Cooldown display"},
        {"Animation Detection", "Animation test placeholder"}
    },

    Misc = {
        {"Anti-AFK", "Placeholder"},
        {"FPS Counter", "Performance display"},
        {"Server Information", "Session information"}
    },

    Config = {
        {"Save Settings", "Configuration placeholder"},
        {"Compact Mode", "Interface option"}
    }
}

local function OpenPage(name)
    CurrentPage = name
    ClearContent()

    Search.Visible = true

    for _, feature in ipairs(Pages[name]) do
        AddFeature(feature[1], feature[2])
    end
end

for name in pairs(Pages) do
    local Tab = Instance.new("TextButton")
    Tab.Size = UDim2.new(1, -10, 0, 38)
    Tab.BackgroundColor3 = Color3.fromRGB(65, 25, 32)
    Tab.Text = name
    Tab.TextColor3 = Color3.new(1, 1, 1)
    Tab.Font = Enum.Font.GothamBold
    Tab.TextSize = 12
    Tab.Parent = Sidebar

    Instance.new("UICorner", Tab).CornerRadius = UDim.new(0, 6)

    Tab.MouseButton1Click:Connect(function()
        OpenPage(name)
    end)
end

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local query = string.lower(Search.Text)

    for _, item in ipairs(Buttons) do
        item.frame.Visible = string.find(
            string.lower(item.name),
            query,
            1,
            true
        ) ~= nil
    end
end)

UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

OpenPage("Movement")

print("ozikGUI loaded successfully!")
