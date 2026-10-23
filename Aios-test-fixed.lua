-- Cinder Hub Independent (original educational UI)
-- Place as a LocalScript in StarterPlayer > StarterPlayerScripts in Roblox Studio.
-- No key, external HTTP, executor APIs, or remote code.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("CinderIndependent")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "CinderIndependent"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Enabled = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = guiParent

local function make(className, props, parent)
    local object = Instance.new(className)
    for k, v in pairs(props) do object[k] = v end
    object.Parent = parent
    return object
end

local background = Color3.fromRGB(17, 21, 29)
local panelColor = Color3.fromRGB(27, 32, 43)
local foreground = Color3.fromRGB(238, 241, 246)
local muted = Color3.fromRGB(156, 164, 177)
local accent = Color3.fromRGB(96, 141, 245)

local toggle = make("TextButton", {
    Name = "OpenButton", Size = UDim2.fromOffset(112, 38), Position = UDim2.new(0, 16, 0.5, -19),
    BackgroundColor3 = accent, Text = "Cinder Hub", TextColor3 = foreground,
    TextSize = 14, Font = Enum.Font.GothamBold, BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, toggle)

local frame = make("Frame", {
    Name = "Window", Size = UDim2.fromOffset(400, 330), Position = UDim2.fromScale(0.5, 0.5), AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = background, BorderSizePixel = 0,
}, gui)
make("UICorner", {CornerRadius = UDim.new(0, 14)}, frame)
local scale = Instance.new("UIScale")
scale.Parent = frame
local camera = workspace.CurrentCamera
local function updateScale()
    camera = workspace.CurrentCamera
    if camera then
        local viewport = camera.ViewportSize
        scale.Scale = math.min(1, (viewport.X - 24) / 400, (viewport.Y - 36) / 330)
    end
end
updateScale()
if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale) end
make("UIStroke", {Color = Color3.fromRGB(60, 69, 87), Thickness = 1}, frame)

make("TextLabel", {
    Size = UDim2.new(1, -78, 0, 44), Position = UDim2.fromOffset(20, 12), BackgroundTransparency = 1,
    Text = "Cinder Hub", TextColor3 = foreground, Font = Enum.Font.GothamBold,
    TextSize = 22, TextXAlignment = Enum.TextXAlignment.Left,
}, frame)

local close = make("TextButton", {
    Size = UDim2.fromOffset(32, 32), Position = UDim2.new(1, -45, 0, 17),
    BackgroundColor3 = panelColor, Text = "×", TextColor3 = foreground,
    Font = Enum.Font.GothamBold, TextSize = 22, BorderSizePixel = 0,
}, frame)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, close)

make("TextLabel", {
    Size = UDim2.new(1, -40, 0, 38), Position = UDim2.fromOffset(20, 64),
    BackgroundTransparency = 1, Text = "Independent UI demo • No key required",
    TextColor3 = muted, Font = Enum.Font.Gotham, TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
}, frame)

local content = make("Frame", {
    Size = UDim2.new(1, -40, 1, -140), Position = UDim2.fromOffset(20, 112),
    BackgroundColor3 = panelColor, BorderSizePixel = 0,
}, frame)
make("UICorner", {CornerRadius = UDim.new(0, 10)}, content)
make("UIPadding", {PaddingTop = UDim.new(0, 14), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14)}, content)
make("UIListLayout", {Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder}, content)

local status = make("TextLabel", {
    Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1,
    Text = "Ready. This is a standalone Studio project.", TextColor3 = foreground,
    Font = Enum.Font.Gotham, TextSize = 13, TextWrapped = true,
    TextXAlignment = Enum.TextXAlignment.Left,
}, content)

local function actionButton(label, callback)
    local button = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = background,
        Text = label, TextColor3 = foreground, Font = Enum.Font.GothamMedium,
        TextSize = 14, BorderSizePixel = 0,
    }, content)
    make("UICorner", {CornerRadius = UDim.new(0, 8)}, button)
    button.MouseButton1Click:Connect(callback)
    return button
end

actionButton("Show player info", function()
    status.Text = "Player: " .. player.DisplayName .. " (@" .. player.Name .. ")"
end)

actionButton("UI animation", function()
    local tween = TweenService:Create(frame, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
        BackgroundColor3 = Color3.fromRGB(37, 45, 62)
    })
    tween:Play()
    tween.Completed:Once(function()
        if frame.Parent then
            TweenService:Create(frame, TweenInfo.new(0.18), {BackgroundColor3 = background}):Play()
        end
    end)
    status.Text = "Animation completed."
end)

actionButton("Reset status", function()
    status.Text = "Ready. This is a standalone Studio project."
end)

local function setOpen(open)
    frame.Visible = open
    toggle.Text = open and "Hide Hub" or "Cinder Hub"
end
close.MouseButton1Click:Connect(function() setOpen(false) end)
toggle.MouseButton1Click:Connect(function() setOpen(not frame.Visible) end)
setOpen(true)
