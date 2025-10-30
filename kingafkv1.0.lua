-- King AFK v2 - Compatível (sem emojis)
local players = game:GetService("Players")
local player = players.LocalPlayer
local virtualUser = game:GetService("VirtualUser")
local userInputService = game:GetService("UserInputService")

-- Limpar GUI antiga
if player:FindFirstChild("PlayerGui") then
    local oldGui = player.PlayerGui:FindFirstChild("KingAFK_GUI")
    if oldGui then oldGui:Destroy() end
end

-- Criar GUI no PlayerGui
local gui = Instance.new("ScreenGui")
gui.Name = "KingAFK_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Botão flutuante
local openButton = Instance.new("TextButton")
openButton.Parent = gui
openButton.Size = UDim2.new(0, 150, 0, 40)
openButton.Position = UDim2.new(1, -170, 0, 100)
openButton.Text = "Abrir Hub"
openButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
openButton.TextColor3 = Color3.fromRGB(255,255,255)
openButton.Font = Enum.Font.GothamBold
openButton.TextSize = 16
openButton.BorderSizePixel = 2
openButton.BorderColor3 = Color3.fromRGB(255,0,255)

-- Função para tornar o botão arrastável
local dragging
local dragInput
local dragStart
local startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    openButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                    startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

openButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = openButton.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

openButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateInput(input)
    end
end)

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Parent = gui
mainFrame.Size = UDim2.new(0, 320, 0, 180)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BackgroundTransparency = 0.25
mainFrame.Visible = false

-- Título
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "KING AFK HUB"
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255,255,255)
title.TextSize = 20

-- Status
local statusText = Instance.new("TextLabel")
statusText.Parent = mainFrame
statusText.Size = UDim2.new(1,0,0,30)
statusText.Position = UDim2.new(0,0,0,45)
statusText.BackgroundTransparency = 1
statusText.Text = "Deseja ativar o Anti-AFK?"
statusText.TextColor3 = Color3.fromRGB(200,200,200)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 16

-- Função para criar botões
local function criarBotao(parent, texto, cor, posX)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.Size = UDim2.new(0,100,0,35)
    btn.Position = UDim2.new(posX, -50,1,-60)
    btn.Text = texto
    btn.BackgroundColor3 = cor
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    local uic = Instance.new("UICorner", btn)
    return btn
end

local yesButton = criarBotao(mainFrame,"Sim",Color3.fromRGB(0,200,0),0.25)
local noButton = criarBotao(mainFrame,"Não",Color3.fromRGB(200,0,0),0.75)

-- Créditos
local credits = Instance.new("TextLabel")
credits.Parent = mainFrame
credits.Size = UDim2.new(1,0,0,20)
credits.Position = UDim2.new(0,0,1,-25)
credits.BackgroundTransparency = 1
credits.Text = "by King"
credits.TextColor3 = Color3.fromRGB(255,255,255)
credits.Font = Enum.Font.Gotham
credits.TextSize = 14

-- Funções Anti-AFK
local antiAFK_ativo = false
local countdownLabel

local function ativarAntiAFK()
    if countdownLabel then countdownLabel:Destroy() end
    countdownLabel = Instance.new("TextLabel", mainFrame)
    countdownLabel.Size = UDim2.new(1,0,0,30)
    countdownLabel.Position = UDim2.new(0,0,0,90)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Font = Enum.Font.GothamBold
    countdownLabel.TextSize = 18
    countdownLabel.TextColor3 = Color3.fromRGB(255,255,0)
    for i = 10,1,-1 do
        countdownLabel.Text = "Ativando em "..i.." segundos..."
        task.wait(1)
    end
    countdownLabel.Text = "Anti-AFK ativado!"
    antiAFK_ativo = true
    player.Idled:Connect(function()
        virtualUser:CaptureController()
        virtualUser:ClickButton2(Vector2.new())
    end)
    task.wait(2)
    statusText.Text = "Deseja desativar o Anti-AFK?"
end

local function desativarAntiAFK()
    if countdownLabel then countdownLabel:Destroy() end
    countdownLabel = Instance.new("TextLabel", mainFrame)
    countdownLabel.Size = UDim2.new(1,0,0,30)
    countdownLabel.Position = UDim2.new(0,0,0,90)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Font = Enum.Font.GothamBold
    countdownLabel.TextSize = 18
    countdownLabel.TextColor3 = Color3.fromRGB(255,100,100)
    for i = 10,1,-1 do
        countdownLabel.Text = "Desativando em "..i.." segundos..."
        task.wait(1)
    end
    countdownLabel.Text = "Anti-AFK desativado!"
    antiAFK_ativo = false
    task.wait(2)
    statusText.Text = "Deseja ativar o Anti-AFK?"
end

yesButton.MouseButton1Click:Connect(function()
    if antiAFK_ativo then desativarAntiAFK() else ativarAntiAFK() end
end)

noButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    openButton.Text = "Abrir Hub"
end)

-- Abrir/Fechar Hub
local function toggleHub()
    mainFrame.Visible = not mainFrame.Visible
    openButton.Text = mainFrame.Visible and "Fechar Hub" or "Abrir Hub"
end

openButton.MouseButton1Click:Connect(toggleHub)
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.G then
        toggleHub()
    end
end)
