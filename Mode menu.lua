-- Création du menu GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuGUI"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Création du cadre principal du menu
local menuFrame = Instance.new("Frame")
menuFrame.Name = "MenuFrame"
menuFrame.Size = UDim2.new(0, 300, 0, 200)
menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
menuFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
menuFrame.BorderSizePixel = 2
menuFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
menuFrame.Parent = screenGui

-- Création du titre du menu
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0.2, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "Menu de Coupure d'Arbres"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Parent = menuFrame

-- Création du bouton "Activer"
local activateButton = Instance.new("TextButton")
activateButton.Name = "ActivateButton"
activateButton.Size = UDim2.new(0.8, 0, 0.3, 0)
activateButton.Position = UDim2.new(0.1, 0, 0.3, 0)
activateButton.Text = "Activer"
activateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
activateButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
activateButton.Font = Enum.Font.GothamBold
activateButton.TextScaled = true
activateButton.Parent = menuFrame

-- Création du bouton "Désactiver"
local deactivateButton = Instance.new("TextButton")
deactivateButton.Name = "DeactivateButton"
deactivateButton.Size = UDim2.new(0.8, 0, 0.3, 0)
deactivateButton.Position = UDim2.new(0.1, 0, 0.6, 0)
deactivateButton.Text = "Désactiver"
deactivateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
deactivateButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
deactivateButton.Font = Enum.Font.GothamBold
deactivateButton.TextScaled = true
deactivateButton.Parent = menuFrame

-- Variables pour gérer l'état du script
local isActive = false

-- Fonction pour obtenir le terrain du joueur
local function getPlot()
    local plot = nil
    for i, v in next, workspace.Plots:GetChildren() do
        if v:WaitForChild("Owner").Value == game.Players.LocalPlayer or v:WaitForChild("Owner").Value == game.Players.LocalPlayer.Character then
            plot = v
        end
    end
    return plot
end

-- Fonction pour obtenir un arbre aléatoire dans le terrain
local function getRandomTree(plot)
    local randomTree = nil
    local branch = nil
    for a, x in next, plot:GetChildren() do
        if x:IsA("Model") then
            for l, d in next, x:GetChildren() do
                if string.find(d.Name, "Tree") then
                    randomTree = d
                    branch = x
                    break
                end
            end
        end
    end
    return randomTree, branch
end

-- Fonction pour activer le script
local function activateScript()
    isActive = true
    while isActive do
        local plot = getPlot()
        local choice, branch = getRandomTree(plot)
        if choice ~= nil and branch ~= nil then
            local basePosition = choice:WaitForChild("Base").Position
            local moveOffset = Vector3.new(3, 0, 3)
            local targetPosition = basePosition + moveOffset

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)

            -- Simuler un clic gauche pour couper l'arbre
            local mouse = game.Players.LocalPlayer:GetMouse()
            mouse.Button1Down:Fire()  -- Simule un clic gauche
            
            -- Attendre un peu pour assurer que l'arbre est coupé
            wait(3)  -- Réduit le temps d'attente à 3 secondes

            -- Vérifier si l'arbre est toujours là et le couper
            if choice:FindFirstChild("Base") then
                -- Simuler un clic gauche pour couper l'arbre à nouveau
                mouse.Button1Down:Fire()
                wait(1)  -- Attendre pour que la coupe soit effectuée
            end

            -- Déplacer vers un autre arbre
            local newPlot = getPlot()
            local newChoice, _ = getRandomTree(newPlot)
            if newChoice ~= nil then
                local newBasePosition = newChoice:WaitForChild("Base").Position
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(newBasePosition + moveOffset)
            else
                -- Si aucun autre arbre n'est trouvé, expulser le joueur avec un message d'erreur
                game.Players.LocalPlayer:Kick("Le script peut être obsolète ou avoir un bug!")
            end
        else
            -- Si aucun arbre n'est trouvé, expulser le joueur avec un message d'erreur
            game.Players.LocalPlayer:Kick("Le script peut être obsolète ou avoir un bug!")
        end
        wait(1)  -- Attendre avant la prochaine vérification
    end
end

-- Fonction pour désactiver le script
local function deactivateScript()
    isActive = false
end

-- Connecter les boutons aux fonctions
activateButton.MouseButton1Click:Connect(activateScript)
deactivateButton.MouseButton1Click:Connect(deactivateScript)
