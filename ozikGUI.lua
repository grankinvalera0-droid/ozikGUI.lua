
--[[
    ozikGUI v3.0
    Universal Client Utility Hub
    Black / Red Theme
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("ozikGUI")
if old then old:Destroy() end

local Theme = {
    BG = Color3.fromRGB(12,12,15),
    Panel = Color3.fromRGB(23,23,28),
    Red = Color3.fromRGB(215,25,45),
    DarkRed = Color3.fromRGB(105,10,20),
    White = Color3.fromRGB(245,245,245),
    Grey = Color3.fromRGB(150,150,160),
    Green = Color3.fromRGB(70,210,120)
}

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local Screen = New("ScreenGui", {
    Name = "ozikGUI",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, PlayerGui)

local Main = New("Frame", {
    Size = UDim2.fromOffset(620,430),
    Position = UDim2.new(.5,-310,.5,-215),
    BackgroundColor3 = Theme.BG,
    BorderSizePixel = 0
}, Screen)

New("UICorner",{CornerRadius=UDim.new(0,10)},Main)
New("UIStroke",{Color=Theme.Red,Thickness=2},Main)

-- HEADER

local Header = New("Frame", {
    Size = UDim2.new(1,0,0,45),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0
},Main)

New("UICorner",{CornerRadius=UDim.new(0,10)},Header)

New("TextLabel",{
    Size=UDim2.new(1,-100,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="ozikGUI  v3.0",
    TextColor3=Theme.Red,
    Font=Enum.Font.GothamBold,
    TextSize=18,
    TextXAlignment=Enum.TextXAlignment.Left
},Header)

local Min = New("TextButton",{
    Size=UDim2.fromOffset(35,30),
    Position=UDim2.new(1,-43,0,7),
    BackgroundColor3=Theme.DarkRed,
    Text="-",
    TextColor3=Theme.White,
    Font=Enum.Font.GothamBold,
    TextSize=22,
    BorderSizePixel=0
},Header)

New("UICorner",{CornerRadius=UDim.new(0,6)},Min)

local Restore = New("TextButton",{
    Size=UDim2.fromOffset(115,38),
    Position=UDim2.fromOffset(15,15),
    BackgroundColor3=Theme.BG,
    Text="ozikGUI +",
    TextColor3=Theme.Red,
    Font=Enum.Font.GothamBold,
    TextSize=14,
    Visible=false,
    BorderSizePixel=0
},Screen)

New("UICorner",{CornerRadius=UDim.new(0,8)},Restore)

Min.MouseButton1Click:Connect(function()
    Main.Visible=false
    Restore.Visible=true
end)

Restore.MouseButton1Click:Connect(function()
    Main.Visible=true
    Restore.Visible=false
end)

-- DRAG

local dragging=false
local dragStart
local startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        dragStart=input.Position
        startPos=Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch
    ) then
        local delta=input.Position-dragStart
        Main.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+delta.X,
            startPos.Y.Scale,startPos.Y.Offset+delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
    or input.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)

-- SIDEBAR

local Sidebar=New("Frame",{
    Size=UDim2.new(0,145,1,-55),
    Position=UDim2.fromOffset(0,50),
    BackgroundColor3=Theme.Panel,
    BorderSizePixel=0
},Main)

local Search=New("TextBox",{
    Size=UDim2.new(1,-170,0,32),
    Position=UDim2.fromOffset(160,52),
    BackgroundColor3=Theme.Panel,
    PlaceholderText="Search functions...",
    Text="",
    TextColor3=Theme.White,
    PlaceholderColor3=Theme.Grey,
    Font=Enum.Font.Gotham,
    TextSize=13,
    ClearTextOnFocus=false,
    BorderSizePixel=0
},Main)

New("UICorner",{CornerRadius=UDim.new(0,6)},Search)

local Area=New("ScrollingFrame",{
    Size=UDim2.new(1,-160,1,-125),
    Position=UDim2.fromOffset(155,95),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    CanvasSize=UDim2.new()
},Main)

local AreaLayout=New("UIListLayout",{
    Padding=UDim.new(0,7),
    SortOrder=Enum.SortOrder.LayoutOrder
},Area)

AreaLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Area.CanvasSize=UDim2.fromOffset(0,AreaLayout.AbsoluteContentSize.Y+10)
end)

local Status=New("TextLabel",{
    Size=UDim2.new(1,-160,0,22),
    Position=UDim2.new(0,155,1,-27),
    BackgroundTransparency=1,
    Text="FPS: -- | Ping: --",
    TextColor3=Theme.Grey,
    Font=Enum.Font.Gotham,
    TextSize=12,
    TextXAlignment=Enum.TextXAlignment.Left
},Main)

-- STATE

local State={
    FPS=true,
    Ping=true,
    Stamina=true,
    StaminaWarning=true,
    Cooldown=false,
    Notifications=true
}

local Pages={
    Home={
        "Welcome to ozikGUI",
        "RightShift - hide/show menu",
        "Universal utility client"
    },
    Player={
        "Player Information",
        "Character Information",
        "Health Monitor"
    },
    Visuals={
        "FPS Monitor",
        "Ping Monitor"
    },
    Forsaken={
        "Stamina Monitor",
        "Stamina Warning",
        "Block Cooldown Timer",
        "Attack Warning (manual)",
        "Attack Distance (manual)",
        "Animation Detection (manual)",
        "Auto Block (test project)",
        "Auto Generator (test project)",
        "Killer ESP (test project)"
    },
    Misc={
        "Notification Test",
        "Reset UI Position",
        "Reset Settings"
    }
}

local currentPage="Home"
local buttons={}

local function Notify(message)
    if not State.Notifications then return end
    pcall(function()
        StarterGui:SetCore("SendNotification",{
            Title="ozikGUI",
            Text=message,
            Duration=3
        })
    end)
end

local function Clear()
    for _,v in ipairs(Area:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
    table.clear(buttons)
end

local function AddButton(name,callback)
    local b=New("TextButton",{
        Size=UDim2.new(1,-8,0,39),
        BackgroundColor3=Theme.Panel,
        Text=name,
        TextColor3=Theme.White,
        Font=Enum.Font.Gotham,
        TextSize=13,
        BorderSizePixel=0
    },Area)

    New("UICorner",{CornerRadius=UDim.new(0,6)},b)
    b.MouseButton1Click:Connect(callback)
    table.insert(buttons,b)
    return b
end

local function Draw(page)
    currentPage=page
    Clear()

    for _,name in ipairs(Pages[page] or {}) do
        local b=AddButton(name,function()
            if name=="Notification Test" then
                Notify("ozikGUI is working!")
            elseif name=="Reset UI Position" then
                Main.Position=UDim2.new(.5,-310,.5,-215)
                Notify("Position reset")
            elseif name=="Reset Settings" then
                for k in pairs(State) do
                    State[k]=false
                end
                Notify("Settings reset")
                Draw(currentPage)
            elseif name=="Block Cooldown Timer" then
                State.Cooldown=not State.Cooldown
                Notify("Cooldown timer: "..tostring(State.Cooldown))
                Draw(currentPage)
            else
                Notify(name.." is an informational/test feature")
            end
        end)

        if State[name]~=nil then
            b.Text=name.."  ["..(State[name] and "ON" or "OFF").."]"
        end
    end
end

local tabs={"Home","Player","Visuals","Forsaken","Misc"}

for i,name in ipairs(tabs) do
    local tab=New("TextButton",{
        Size=UDim2.new(1,-12,0,36),
        Position=UDim2.fromOffset(6,8+(i-1)*43),
        BackgroundColor3=Theme.BG,
        Text=name,
        TextColor3=Theme.White,
        Font=Enum.Font.GothamBold,
        TextSize=13,
        BorderSizePixel=0
    },Sidebar)

    New("UICorner",{CornerRadius=UDim.new(0,6)},tab)
    tab.MouseButton1Click:Connect(function()
        Draw(name)
    end)
end

-- SEARCH

Search:GetPropertyChangedSignal("Text"):Connect(function()
    local q=string.lower(Search.Text)
    for _,b in ipairs(buttons) do
        b.Visible=(q=="") or string.find(
            string.lower(b.Text),q,1,true)~=nil
    end
end)

-- FPS / PING

local frames=0
local elapsed=0
local fps=0

RunService.RenderStepped:Connect(function(dt)
    frames+=1
    elapsed+=dt

    if elapsed>=1 then
        fps=frames
        frames=0
        elapsed=0

        local ping="--"
        pcall(function()
            ping=tostring(math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            )).." ms"
        end)

        local f=State.FPS and tostring(fps) or "OFF"
        local p=State.Ping and ping or "OFF"

        Status.Text="FPS: "..f.." | Ping: "..p
    end
end)

-- STAMINA MONITOR
-- Reads a stamina value only if the game exposes it
-- through the player's own attributes.

local staminaLabel=New("TextLabel",{
    Size=UDim2.new(1,-160,0,18),
    Position=UDim2.new(0,155,1,-48),
    BackgroundTransparency=1,
    Text="Stamina: unavailable",
    TextColor3=Theme.Grey,
    Font=Enum.Font.Gotham,
    TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left
},Main)

RunService.Heartbeat:Connect(function()
    if not State.Stamina then
        staminaLabel.Text="Stamina Monitor: OFF"
        return
    end

    local stamina=Player:GetAttribute("Stamina")

    if typeof(stamina)=="number" then
        staminaLabel.Text="Stamina: "..math.floor(stamina)
        if State.StaminaWarning and stamina<=20 then
            staminaLabel.TextColor3=Theme.Red
        else
            staminaLabel.TextColor3=Theme.Grey
        end
    else
        staminaLabel.Text="Stamina: unavailable"
        staminaLabel.TextColor3=Theme.Grey
    end
end)

-- RIGHT SHIFT

UserInputService.InputBegan:Connect(function(input,processed)
    if processed then return end

    if input.KeyCode==Enum.KeyCode.RightShift then
        Main.Visible=not Main.Visible
        Restore.Visible=not Main.Visible
    end
end)

Draw("Home")
Notify("ozikGUI v3.0 loaded")
print("ozikGUI v3.0 loaded")
