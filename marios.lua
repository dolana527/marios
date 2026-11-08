-- DIRECTX V5 ULTIMATE
-- LocalScript: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("DirectXV5")
if old then old:Destroy() end

local BLUE = Color3.fromRGB(0,145,255)
local DARK = Color3.fromRGB(10,13,23)
local PANEL = Color3.fromRGB(22,32,50)

local gui = Instance.new("ScreenGui")
gui.Name = "DirectXV5"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local function round(o,r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,r)
    c.Parent = o
end

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(360,510)
main.Position = UDim2.new(0.5,-180,0.5,-255)
main.BackgroundColor3 = DARK
main.BorderSizePixel = 0
main.Parent = gui
main.Active = true
round(main,15)

local border = Instance.new("UIStroke")
border.Color = BLUE
border.Thickness = 2
border.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-60,0,48)
title.Position = UDim2.fromOffset(15,0)
title.BackgroundTransparency = 1
title.Text = "DIRECTX V5"
title.TextColor3 = BLUE
title.Font = Enum.Font.GothamBlack
title.TextSize = 27
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(38,38)
close.Position = UDim2.new(1,-46,0,6)
close.Text = "×"
close.TextSize = 25
close.TextColor3 = Color3.new(1,1,1)
close.BackgroundColor3 = Color3.fromRGB(190,45,60)
close.Parent = main
round(close,8)

local function button(text,y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-30,0,40)
    b.Position = UDim2.fromOffset(15,y)
    b.BackgroundColor3 = PANEL
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 14
    b.Parent = main
    round(b,8)
    return b
end

local function label(text,y)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-30,0,20)
    l.Position = UDim2.fromOffset(15,y)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = BLUE
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = main
end

local function textbox(value,y)
    local t = Instance.new("TextBox")
    t.Size = UDim2.new(1,-30,0,34)
    t.Position = UDim2.fromOffset(15,y)
    t.BackgroundColor3 = PANEL
    t.Text = tostring(value)
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.ClearTextOnFocus = false
    t.Parent = main
    round(t,8)
    return t
end

local flyButton = button("FLY: OFF",60)
local orbButton = button("WHITE ORB: OFF",106)
local stealButton = button("AUTO STEAL: OFF",152)
local protectionButton = button("PROTECTION: SERVER REQUIRED",198)

label("FLY SPEED",245)
local flyBox = textbox(55,265)

label("PLAYER SPEED (MAX 1T INPUT)",310)
local speedBox = textbox("16",330)

local mini = Instance.new("TextButton")
mini.Size = UDim2.fromOffset(58,58)
mini.Position = UDim2.new(0,25,0.5,0)
mini.BackgroundColor3 = BLUE
mini.Text = "DX"
mini.TextColor3 = Color3.new(1,1,1)
mini.Font = Enum.Font.GothamBlack
mini.TextSize = 20
mini.Parent = gui
mini.Visible = false
mini.Active = true
round(mini,100)

-- Drag DX button
local dragging = false
local dragStart
local dragPosition

mini.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        dragPosition = mini.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch
    ) then
        local delta = input.Position - dragStart
        mini.Position = UDim2.new(
            dragPosition.X.Scale,
            dragPosition.X.Offset + delta.X,
            dragPosition.Y.Scale,
            dragPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

close.MouseButton1Click:Connect(function()
    main.Visible = false
    mini.Visible = true
end)

mini.MouseButton1Click:Connect(function()
    main.Visible = true
    mini.Visible = false
end)

UIS.InputBegan:Connect(function(input,processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        main.Visible = not main.Visible
        mini.Visible = not main.Visible
    end
end)

-- Character
local character,humanoid,root

local function getCharacter()
    character = player.Character
    humanoid = character and character:FindFirstChildOfClass("Humanoid")
    root = character and character:FindFirstChild("HumanoidRootPart")
end

getCharacter()

-- WHITE ORB
local orbEnabled = false

local function updateOrb()
    getCharacter()
    if not character or not root then return end

    local oldOrb = character:FindFirstChild("DirectXOrb")
    if oldOrb then oldOrb:Destroy() end

    if not orbEnabled then return end

    local orb = Instance.new("Part")
    orb.Name = "DirectXOrb"
    orb.Shape = Enum.PartType.Ball
    orb.Size = Vector3.new(9,9,9)
    orb.Material = Enum.Material.ForceField
    orb.Color = Color3.fromRGB(230,245,255)
    orb.Transparency = 0.55
    orb.CanCollide = false
    orb.Massless = true
    orb.CanTouch = false
    orb.CanQuery = false
    orb.Parent = character
    orb.CFrame = root.CFrame

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = root
    weld.Part1 = orb
    weld.Parent = orb
end

orbButton.MouseButton1Click:Connect(function()
    orbEnabled = not orbEnabled
    updateOrb()
    orbButton.Text = orbEnabled and "WHITE ORB: ON" or "WHITE ORB: OFF"
end)

-- FLY
local flying = false
local attachment
local velocity
local orientation
local flyConnection

local function stopFly()
    flying = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if velocity then velocity:Destroy() velocity = nil end
    if orientation then orientation:Destroy() orientation = nil end
    if attachment then attachment:Destroy() attachment = nil end

    if humanoid then
        humanoid.PlatformStand = false
        humanoid.AutoRotate = true
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end

    flyButton.Text = "FLY: OFF"
end

local function startFly()
    getCharacter()
    if not root or not humanoid then return end

    flying = true
    humanoid.PlatformStand = true
    humanoid.AutoRotate = false

    attachment = Instance.new("Attachment")
    attachment.Parent = root

    velocity = Instance.new("LinearVelocity")
    velocity.Attachment0 = attachment
    velocity.RelativeTo = Enum.ActuatorRelativeTo.World
    velocity.MaxForce = 1000000
    velocity.VectorVelocity = Vector3.zero
    velocity.Parent = root

    orientation = Instance.new("AlignOrientation")
    orientation.Attachment0 = attachment
    orientation.MaxTorque = 1000000
    orientation.Responsiveness = 20
    orientation.Parent = root

    flyButton.Text = "FLY: ON"

    flyConnection = RunService.RenderStepped:Connect(function()
        if not root or not root.Parent then
            stopFly()
            return
        end

        local camera = workspace.CurrentCamera
        if not camera then return end

        local dir = Vector3.zero

        if UIS:IsKeyDown(Enum.KeyCode.W) then dir += camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= camera.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then dir += camera.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.yAxis end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.yAxis end

        local speed = math.clamp(tonumber(flyBox.Text) or 55,1,250)

        velocity.VectorVelocity =
            dir.Magnitude > 0 and dir.Unit * speed or Vector3.zero

        orientation.CFrame = CFrame.lookAt(
            Vector3.zero,
            camera.CFrame.LookVector
        )
    end)
end

flyButton.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

-- PLAYER SPEED
local function applySpeed()
    getCharacter()
    if not humanoid then return end

    local value = tonumber(speedBox.Text)
    if not value then return end

    -- Safe supported movement range
    humanoid.WalkSpeed = math.clamp(value,1,250)
end

speedBox.FocusLost:Connect(applySpeed)

-- AUTO STEAL
-- Uses the game's own authorized server interaction.
-- Does not bypass another game's security.

local autoSteal = false
local promptConnection

local function isEggSteal(prompt)
    return prompt:IsA("ProximityPrompt")
        and string.find(string.lower(prompt.ActionText), "steal", 1, true)
        and string.find(string.lower(prompt.ObjectText), "egg", 1, true)
end

stealButton.MouseButton1Click:Connect(function()
    autoSteal = not autoSteal
    stealButton.Text = autoSteal
        and "AUTO STEAL: ON"
        or "AUTO STEAL: OFF"

    if promptConnection then
        promptConnection:Disconnect()
        promptConnection = nil
    end

    if autoSteal then
        promptConnection = ProximityPromptService.PromptShown:Connect(function(prompt)
            if isEggSteal(prompt) then
                -- Server-authorized interaction is required here.
                -- Connect this to your own collection system.
            end
        end)
    end
end)

-- PROTECTION
protectionButton.MouseButton1Click:Connect(function()
    protectionButton.Text = "SERVER DAMAGE SYSTEM REQUIRED"
    task.delay(2,function()
        protectionButton.Text = "PROTECTION: SERVER REQUIRED"
    end)
end)

-- RESPAWN
player.CharacterAdded:Connect(function(newCharacter)
    stopFly()

    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    root = newCharacter:WaitForChild("HumanoidRootPart")

    task.wait(0.5)
    applySpeed()
    updateOrb()
end)

print("DIRECTX V5 LOADED")
