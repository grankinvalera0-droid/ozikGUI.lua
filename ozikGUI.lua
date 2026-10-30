
--[[
    ozikGUI 4.0 - Ultimate Edition
    Roblox Local Utility Hub
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local old = PlayerGui:FindFirstChild("ozikGUI")
if old then old:Destroy() end

local Theme = {
    BG = Color3.fromRGB(12,12,15),
    Panel = Color3.fromRGB(24,24,29),
    Red = Color3.fromRGB(220,25,45),
    White = Color3.fromRGB(245,245,245),
    Grey = Color3.fromRGB(150,150,160),
    Green = Color3.fromRGB(50,210,110)
}

local function New(class, props, parent)
    local obj = Instance.new(class)
    for k,v in pairs(props) do obj[k]=v end
    obj.Parent=parent
    return obj
end

local Screen=New("ScreenGui",{
    Name="ozikGUI",
    ResetOnSpawn=false
},PlayerGui)

local Main=New("Frame",{
    Size=UDim2.fromOffset(620,440),
    Position=UDim2.new(.5,-310,.5,-220),
    BackgroundColor3=Theme.BG,
    BorderSizePixel=0
},Screen)

New("UICorner",{CornerRadius=UDim.new(0,10)},Main)
New("UIStroke",{Color=Theme.Red,Thickness=2},Main)

-- HEADER

local Header=New("Frame",{
    Size=UDim2.new(1,0,0,45),
    BackgroundColor3=Theme.Panel,
    BorderSizePixel=0
},Main)

New("UICorner",{CornerRadius=UDim.new(0,10)},Header)

New("TextLabel",{
    Size=UDim2.new(1,-100,1,0),
    Position=UDim2.fromOffset(15,0),
    BackgroundTransparency=1,
    Text="ozikGUI 4.0 | ULTIMATE",
    TextColor3=Theme.Red,
    Font=Enum.Font.GothamBold,
    TextSize=18,
    TextXAlignment=Enum.TextXAlignment.Left
},Header)

local Min=New("TextButton",{
    Size=UDim2.fromOffset(35,30),
    Position=UDim2.new(1,-43,0,7),
    BackgroundColor3=Theme.Red,
    Text="-",
    TextColor3=Theme.White,
    TextSize=22,
    Font=Enum.Font.GothamBold,
    BorderSizePixel=0
},Header)

local Restore=New("TextButton",{
    Size=UDim2.fromOffset(115,38),
    Position=UDim2.fromOffset(15,15),
    BackgroundColor3=Theme.BG,
    Text="ozikGUI +",
    TextColor3=Theme.Red,
    Font=Enum.Font.GothamBold,
    Visible=false,
    BorderSizePixel=0
},Screen)

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
local dragStart,startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging=true
        dragStart=input.Position
        startPos=Main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then
        local d=input.Position-dragStart
        Main.Position=UDim2.new(
            startPos.X.Scale,startPos.X.Offset+d.X,
            startPos.Y.Scale,startPos.Y.Offset+d.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
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
    Position=UDim2.fromOffset(155,52),
    BackgroundColor3=Theme.Panel,
    PlaceholderText="Search...",
    Text="",
    TextColor3=Theme.White,
    Font=Enum.Font.Gotham,
    TextSize=13,
    ClearTextOnFocus=false,
    BorderSizePixel=0
},Main)

local Area=New("ScrollingFrame",{
    Size=UDim2.new(1,-160,1,-125),
    Position=UDim2.fromOffset(155,95),
    BackgroundTransparency=1,
    BorderSizePixel=0,
    ScrollBarThickness=4,
    CanvasSize=UDim2.new()
},Main)

local Layout=New("UIListLayout",{
    Padding=UDim.new(0,7),
    SortOrder=Enum.SortOrder.LayoutOrder
},Area)

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Area.CanvasSize=UDim2.fromOffset(0,Layout.AbsoluteContentSize.Y+10)
end)

-- STATE

local State={
    Speed=false,
    Jump=false,
    Fly=false,
    NoClip=false,
    Highlight=false,
    FPS=true,
    Ping=true
}

local Pages={
    Home={
        "Welcome to ozikGUI 4.0",
        "RightShift - Hide / Show",
        "Ultimate Edition"
    },
    Movement={
        "Fly",
        "Speed",
        "Jump",
        "NoClip"
    },
    Visuals={
        "Highlight",
        "FPS Monitor",
        "Ping Monitor"
    },
    Player={
        "Health Monitor",
        "Stamina Monitor"
    },
    Forsaken={
        "Attack Warning (test)",
        "Block Cooldown (test)",
        "Auto Block (test project)",
        "Auto Generator (test project)",
        "Stamina Monitor"
    },
    Settings={
        "Reset Position",
        "Reset Settings"
    }
}

local buttons={}

local function Clear()
    for _,v in ipairs(Area:GetChildren()) do
        if v:IsA("GuiObject") then v:Destroy() end
    end
    table.clear(buttons)
end

local function Character()
    return Player.Character
end

local function Toggle(name)
    State[name]=not State[name]
    return State[name]
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

-- SAFE LOCAL VISUALS

local function SetHighlight(enabled)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=Player and p.Character then
            local h=p.Character:FindFirstChild("ozikHighlight")
            if enabled and not h then
                h=Instance.new("Highlight")
                h.Name="ozikHighlight"
                h.FillColor=Theme.Red
                h.OutlineColor=Theme.White
                h.Parent=p.Character
            elseif not enabled and h then
                h:Destroy()
            end
        end
    end
end

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if State.Highlight then SetHighlight(true) end
    end)
end)

local function Draw(page)
    Clear()

    for _,name in ipairs(Pages[page] or {}) do
        local b=AddButton(name,function()
            if name=="Reset Position" then
                Main.Position=UDim2.new(.5,-310,.5,-220)

            elseif name=="Reset Settings" then
                for k in pairs(State) do State[k]=false end
                Draw(page)

            elseif name=="Highlight" then
                local enabled=Toggle("Highlight")
                SetHighlight(enabled)
                b.Text=name.." ["..(enabled and "ON" or "OFF").."]"

            elseif name=="Speed" or name=="Jump" then
                local enabled=Toggle(name)
                b.Text=name.." ["..(enabled and "ON" or "OFF").."]"
                local char=Character()
                local hum=char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if name=="Speed" then
                        hum.WalkSpeed=enabled and 24 or 16
                    else
                        hum.UseJumpPower=true
                        hum.JumpPower=enabled and 70 or 50
                    end
                end

            elseif name=="Fly" or name=="NoClip" then
                local enabled=Toggle(name)
                b.Text=name.." ["..(enabled and "ON" or "OFF").."]"
                -- These controls are intentionally limited to UI state.
                -- Implement movement physics in your own Studio test project.

            elseif name=="FPS Monitor" then
                State.FPS=not State.FPS
                b.Text=name.." ["..(State.FPS and "ON" or "OFF").."]"

            elseif name=="Ping Monitor" then
                State.Ping=not State.Ping
                b.Text=name.." ["..(State.Ping and "ON" or "OFF").."]"

            else
                pcall(function()
                    game:GetService("StarterGui"):SetCore(
                        "SendNotification",{
                            Title="ozikGUI 4.0",
                            Text=name.." selected",
                            Duration=3
                        }
                    )
                end)
            end
        end)
    end
end

local tabs={"Home","Movement","Visuals","Player","Forsaken","Settings"}

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
        b.Visible=q=="" or string.find(
            string.lower(b.Text),q,1,true)~=nil
    end
end)

-- FPS / PING

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

local frames,elapsed=0,0
RunService.RenderStepped:Connect(function(dt)
    frames+=1
    elapsed+=dt

    if elapsed>=1 then
        local fps=frames
        frames=0
        elapsed=0

        local ping="--"
        pcall(function()
            ping=math.floor(
                Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            ).." ms"
        end)

        Status.Text="FPS: "..(State.FPS and fps or "OFF")
            .." | Ping: "..(State.Ping and ping or "OFF")
    end
end)

-- RIGHT SHIFT

UIS.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.RightShift then
        Main.Visible=not Main.Visible
        Restore.Visible=not Main.Visible
    end
end)

Draw("Home")
print("ozikGUI 4.0 loaded")
