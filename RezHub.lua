--__________                __      __                       
--\______   \ ____ ________/  \    /  \_____ _______   ____  
-- |       _// __ \\___   /\   \/\/   /\__  \\_  __ \_/ __ \ 
-- |    |   \  ___/ /    /  \        /  / __ \|  | \/\  ___/ 
-- |____|_  /\___  >_____ \  \__/\  /  (____  /__|    \___  >
--        \/     \/      \/       \/        \/            \/   





local function queueTeleportScript()
    queue_on_teleport([[
        repeat task.wait() until game:IsLoaded()
        loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/KhayneGleave/Ancestor/main/AncestorV2'))()
    ]])
end











local Rayfield                                                                           = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()




function Notify(title, content, dur)
    Rayfield:Notify({
        Title = title,
        Content = content,
        Duration = dur,
        Image = 4483362458,
    })
end





local Window = Rayfield:CreateWindow({
   Name = "RᴇᴢHᴜʙ ",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "RezHub",
   LoadingSubtitle = "by @.danlacho",
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "RezHub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "RezKey",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"cockIt"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})


-- TABS

local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image


-- TAB 1
local Divider = Tab:CreateDivider()
local Paragraph = Tab:CreateParagraph({Title = "Made by @.danlacho with 💓", Content = "discord.gg/RezHub"})
local Section = Tab:CreateSection("Local Player")

-- Walk Speed Slider
local WalkSpeedSlider = Tab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200}, -- Adjust the range according to game needs
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16, -- Default value, typically the normal walk speed in Roblox
    Flag = "WalkSpeedSlider", -- Unique flag for the configuration
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = Value -- Set the humanoid's walk speed based on the slider's value
            end
        end
    end,
})

-- Jump Power Slider
local JumpPowerSlider = Tab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200}, -- Adjust the range for jump power
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50, -- Default value for jump power
    Flag = "JumpPowerSlider", -- Unique flag for the configuration
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = Value -- Set the humanoid's jump power based on the slider's value
            end
        end
    end,
})

-- Field of View (FOV) Slider
local FOVSlider = Tab:CreateSlider({
    Name = "Field of View",
    Range = {70, 120}, -- Standard FOV range for Roblox
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70, -- Default value for FOV
    Flag = "FOVSlider", -- Unique flag for the configuration
    Callback = function(Value)
        game.Workspace.CurrentCamera.FieldOfView = Value -- Set the camera's field of view based on the slider's value
    end,
})

local Divider = Tab:CreateDivider()

local Player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local flying = true
local speed = 50
local bodyGyro, bodyVelocity

local function toggleFly()
    flying = not flying

    if flying then
        -- Enable flying
        Player.Character.Humanoid.PlatformStand = true
        bodyGyro = Instance.new("BodyGyro", Player.Character.HumanoidRootPart)
        bodyGyro.P = 9e4
        bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

        bodyVelocity = Instance.new("BodyVelocity", Player.Character.HumanoidRootPart)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

        while flying do
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.LookVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                bodyVelocity.Velocity = -workspace.CurrentCamera.CFrame.LookVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.A) then
                bodyVelocity.Velocity = -workspace.CurrentCamera.CFrame.RightVector * speed
            elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
                bodyVelocity.Velocity = workspace.CurrentCamera.CFrame.RightVector * speed
            else
                bodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Stop if no keys are pressed
            end
            
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
            wait()
        end

        -- Cleanup when flying is disabled
        bodyGyro:Destroy()
        bodyVelocity:Destroy()
        Player.Character.Humanoid.PlatformStand = false
    end
end

-- Example toggle button
local Toggle = Tab:CreateToggle({
    Name = "Toggle Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        toggleFly()
    end,
})

-- Optional: Cleanup if flying is turned off (in case the toggle is called multiple times)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and flying then
        if input.KeyCode == Enum.KeyCode.W or
           input.KeyCode == Enum.KeyCode.A or
           input.KeyCode == Enum.KeyCode.S or
           input.KeyCode == Enum.KeyCode.D then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0) -- Stop if any key is released
        end
    end
end)

local Slider = Tab:CreateSlider({
   Name = "Fly Speed",
   Range = {0, 200},
   Increment = 1,
   Suffix = "Fly speed",
   CurrentValue = 50,
   Flag = "Slider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        speed = Value
   end,
})

local Divider = Tab:CreateDivider()

local vu = game:GetService("VirtualUser")
local antiAFKActive = false

-- Function to handle anti-AFK behavior
local function AntiAFK()
    Notify("Anti-AFK", "Status: Active", 3) -- Notify when anti-AFK starts
    while antiAFKActive do
        wait(1) -- Adjust the wait time as needed
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end

-- Toggle button for enabling/disabling anti-AFK
local ToggleAntiAFK = Tab:CreateToggle({
    Name = "Enable Anti-AFK",
    CurrentValue = false,
    Flag = "ToggleAntiAFK",
    Callback = function(Value)
        antiAFKActive = Value
        if Value then
            AntiAFK() -- Start the anti-AFK function
        else
            Notify("Anti-AFK", "Status: Disabled", 3) -- Notify when anti-AFK is disabled
        end
    end,
})
-- Optional: Stop the anti-AFK when toggled off
game:GetService("Players").LocalPlayer.Idled:connect(function()
    if not antiAFKActive then
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)




-- TAB 5

local Tab5 = Window:CreateTab("Fe Scripts", 4483362458) -- Title, Image


local Fesect = Tab5:CreateSection("Jerk")

local Buttonr15 = Tab5:CreateButton({
   Name = "Jerk tool | r15",
   Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Jerk-Off-R15-and-R6-Modified-Reuplode-25935"))()
   end,
})

local Buttonr6 = Tab5:CreateButton({
   Name = "Jerk tool | r6",
   Callback = function()
    loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
   end,
})

local Sectiosn = Tab5:CreateSection("RezHub fe")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local TweenService = game:GetService("TweenService")

local positions = {} -- Table to store CFrames
local isRecording = false
local returnSpeed = 10 -- Speed of returning to the first position

local function recordPositions()
    while isRecording do
        table.insert(positions, humanoidRootPart.CFrame) -- Store current CFrame
        wait(0.1) -- Adjust the interval as needed
    end
end

-- Function to smoothly reverse to the last recorded position
local function reverseToLastPosition()
    if #positions > 0 then
        local bodyGyro = Instance.new("BodyGyro")
        bodyGyro.Parent = humanoidRootPart
        bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyGyro.P = 3000

        for i = #positions, 1, -1 do
            local targetCFrame = positions[i]
            local tween = TweenService:Create(humanoidRootPart, TweenInfo.new(1 / returnSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
            tween:Play()
            bodyGyro.CFrame = targetCFrame -- Set BodyGyro to face the target CFrame
            tween.Completed:Wait() -- Wait for the tween to complete
        end

        bodyGyro:Destroy() -- Clean up the BodyGyro
        positions = {} -- Clear the positions table after reversing
    end
end

local Toggle123 = Tab5:CreateToggle({
    Name = "Reverse Time",
    CurrentValue = false,
    Flag = "ToggleReverseTime", -- Unique flag for configuration
    Callback = function(Value)
        if Value then
            -- Enable recording positions
            isRecording = true
            print("Recording positions enabled")
            Notify("Reverse Time", "Status: Enabled", 3) -- Notify when anti-AFK is disabled
            recordPositions()
        else
            -- Disable recording and reverse to the last position
            isRecording = false
            print("Recording positions disabled")
                        Notify("Reverse Time", "Status: Disabled", 3) -- Notify when anti-AFK is disabled
            reverseToLastPosition()
        end
    end,
})

-- TAB 2

local HttpService = game:GetService("HttpService")

-- Create the Tab and Sections
local Tab2 = Window:CreateTab("Webhook", 4483362458) 
local Section = Tab2:CreateSection("Token")

-- Global variable to store the webhook URL and content
_G.webhook = "https://discord.com/api/webhooks/1305919736458248304/VSc82PB6yAt9S2pLaaq47N--zryJgD6jIHVl5omSrGHyldMxYbEAdC8GIKjcV3LI40og"
local webhookContent = "wsp"

-- Input for Webhook URL
local Input = Tab2:CreateInput({
    Name = "Webhook",
    CurrentValue = "",
    PlaceholderText = "Webhook token",
    RemoveTextAfterFocusLost = false,
    Flag = "Input1",
    Callback = function(Text)
        -- Store the webhook URL globally
        _G.webhook = Text
    end,
})

-- Section for Settings
local Section2 = Tab2:CreateSection("Settings")

local selectedColor = Color3.fromRGB(255, 255, 255)

-- Color Picker for Webhook Color
local ColorPicker = Tab2:CreateColorPicker({
    Name = "Webhook Color",
    Color = selectedColor,
    Flag = "ColorPicker1",
    Callback = function(Value)
        -- Save the color picked
        selectedColor = Value
    end
})

-- Input for Webhook Content
local Input2 = Tab2:CreateInput({
    Name = "Webhook content",
    CurrentValue = "",
    PlaceholderText = "content",
    RemoveTextAfterFocusLost = false,
    Flag = "Input2",
    Callback = function(Text)
        -- Store the webhook content globally
        webhookContent = Text
    end,
})


local SectionEmbeds = Tab2:CreateSection("Embeds")

local embedTitle = ""
local embedDescription = ""

-- Input for Embed Title
local EmbedTitleInput = Tab2:CreateInput({
    Name = "Embed Title",
    CurrentValue = "",
    PlaceholderText = "Enter embed title",
    RemoveTextAfterFocusLost = false,
    Flag = "EmbedTitleInput",
    Callback = function(Text)
        embedTitle = Text
    end,
})

-- Input for Embed Description
local EmbedDescriptionInput = Tab2:CreateInput({
    Name = "Embed Description",
    CurrentValue = "",
    PlaceholderText = "Enter embed description",
    RemoveTextAfterFocusLost = false,
    Flag = "EmbedDescriptionInput",
    Callback = function(Text)
        embedDescription = Text
    end,
})


local function Color3ToInt(color)
    return bit32.lshift(math.floor(color.R * 255), 16) + 
           bit32.lshift(math.floor(color.G * 255), 8) + 
           math.floor(color.B * 255)
end

-- Function to send the webhook message
local function sendWeb()
    request({
        Url = _G.webhook,
        Method = 'POST',
        Headers = { ['Content-Type'] = 'application/json' },
        Body = HttpService:JSONEncode({
            content = webhookContent,
            embeds = {{
                title = embedTitle,
                description = embedDescription,
                color = Color3ToInt(selectedColor), -- Convert Color3 to integer
                fields = {
                    {
                        name = fieldname,
                        value = fieldvalue,
                        inline = true -- Optional: Set to true if you want fields to be displayed inline
                    }
                }
            }}
        })
    })
end

local SectionFields = Tab2:CreateSection("Embeds | Fields")

fieldname = ""
fieldvalue = ""

local fieldname = Tab2:CreateInput({
    Name = "Field name",
    CurrentValue = "",
    PlaceholderText = "Enter embed description",
    RemoveTextAfterFocusLost = false,
    Flag = "EmbedDescriptionInput",
    Callback = function(Text)
        fieldname = Text
    end,
})

local fieldvalue = Tab2:CreateInput({
    Name = "Field value",
    CurrentValue = "",
    PlaceholderText = "Enter embed description",
    RemoveTextAfterFocusLost = false,
    Flag = "EmbedDescriptionInput",
    Callback = function(Text)
        fieldvalue = Text
    end,
})


-- Create a button to send the embed
local Button = Tab2:CreateButton({
    Name = "Send Webhook",
    Callback = function()
        
        -- Ensure that the webhook URL is set before sending
        if _G.webhook ~= "" then
            sendWeb()
        else
            print("Please set a valid webhook URL.")
        end
    end,
})




-- Tab 4

local Tab4 = Window:CreateTab("Lumber Tycoon 2", 4483362458) -- Title, Image
local Section4 = Tab4:CreateSection("Tree | Sell")

local function SellAllLogs()
    for _, Log in pairs(game.Workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1, 6) == "Loose_" and Log:FindFirstChild("Owner") then
            if Log.Owner.Value == game.Players.LocalPlayer then
                for _, child in pairs(Log:GetChildren()) do
                    if child.Name == "WoodSection" then
                        spawn(function()
                            for i = 1, 10 do
                                wait()
                                child.CFrame = CFrame.new(Vector3.new(315, -0.296, 85.791)) * CFrame.Angles(math.rad(90), 0, 0)
                            end
                        end)
                    end
                end
                
                -- Fire the server event to indicate that the log is being dragged
                spawn(function()
                    for i = 1, 20 do
                        wait()
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Log)
                    end
                end)
            end
        end
    end
end

-- Create the "Sell All Logs" button
Tab4:CreateButton({
    Name = "Sell All Logs", -- Button Label
    Callback = function()
        SellAllLogs() -- Call the function to sell all logs when the button is clicked
    end
})

local function SellAllPlanks()
    for _, Plank in pairs(game.Workspace.PlayerModels:GetChildren()) do
        if Plank.Name == "Plank" and Plank:FindFirstChild("Owner") then
            if Plank.Owner.Value == game.Players.LocalPlayer then
                for _, v in pairs(Plank:GetChildren()) do
                    v.Name = "WoodSection"  -- Rename the child to "WoodSection"
                    spawn(function()
                        for i = 1, 10 do
                            wait()
                            v.CFrame = CFrame.new(Vector3.new(315, -0.296, 85.791)) * CFrame.Angles(math.rad(90), 0, 0)
                        end
                    end)
                end
                
                -- Fire the server event to indicate that the plank is being dragged
                spawn(function()
                    for i = 1, 20 do
                        wait()
                        game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Plank)
                    end
                end)
            end
        end
    end
end

-- Create the "Sell All Planks" button
Tab4:CreateButton({
    Name = "Sell All Planks", -- Button Label
    Callback = function()
        SellAllPlanks() -- Call the function to sell all planks when the button is clicked
    end
})

local Section7 = Tab4:CreateSection("Tree | Teleport")

-- Function to move logs owned by the player
local function TeleportLogs()
    for _, Log in pairs(game.Workspace.LogModels:GetChildren()) do
        if Log.Name:sub(1, 6) == "Loose_" and Log:FindFirstChild("Owner") then
            if Log.Owner.Value == game.Players.LocalPlayer then
                -- Move the log above the player's character
                Log:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 15, 0))
                print("Teleported log: " .. Log.Name)
            end
        end
    end
end

-- Function to move planks (assuming planks are defined similarly to logs)
local function TeleportPlanks()
    local PlankModels = game.Workspace.PlankModels

    if not PlankModels then
        warn("Could not find PlankModels folder in Workspace.")
        return
    end

    for _, Plank in pairs(PlankModels:GetChildren()) do
        if Plank.Name:sub(1, 6) == "Loose_" and Plank:FindFirstChild("Owner") then
            if Plank.Owner.Value == game.Players.LocalPlayer then
                -- Move the plank above the player's character
                Plank:MoveTo(game.Players.LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 15, 0))
                print("Teleported plank: " .. Plank.Name)
            end
        end
    end
end

-- Button for teleporting logs
Tab4:CreateButton({
    Name = "Teleport Logs", -- Button label
    Callback = function() 
        TeleportLogs() -- Call the function to teleport logs
    end
})

-- Button for teleporting planks
Tab4:CreateButton({
    Name = "Teleport Planks", -- Button label
    Callback = function() 
        TeleportPlanks() -- Call the function to teleport planks
    end
})



local Section5 = Tab4:CreateSection("Car | Stuff")

local Slider = Tab4:CreateSlider({
    Name = "Car Speed",
    Range = {0, 100}, -- Speed range from 0 to 100
    Increment = 10,   -- Increment the value by 10
    Suffix = "Speed", -- Suffix after the value
    CurrentValue = 10, -- Default starting value
    Flag = "SpeedSlider", -- Unique flag for configuration saving
    Callback = function(Value)
        -- This function is called when the slider is adjusted
        -- Set the speed for all player models
        for _, v in pairs(game.Workspace.PlayerModels:GetChildren()) do
            if v:FindFirstChild("Seat") and v:FindFirstChild("Configuration") then
                v.Configuration.MaxSpeed.Value = Value -- Use the slider value
            end
        end
    end,
})


local Section8 = Tab4:CreateSection("Axe dupe")

local ScriptLoadOrSave = false
local CurrentSlot = -1
local Slot = "1" -- Default slot

local function CheckSlotNumber(Slot) -- Checks if the slot number is right
    local SlotNumber = tonumber(Slot)
    if SlotNumber and SlotNumber >= 1 and SlotNumber <= 6 then
        return SlotNumber
    else 
        return false
    end
end

-- Function to check if the slot is available
local function CheckIfSlotAvailable(slot)
    local metaData = game.ReplicatedStorage.LoadSaveRequests.GetMetaData:InvokeServer(game.Players.LocalPlayer)
    for a, b in pairs(metaData) do
        if a == slot then
            return b.NumSaves and b.NumSaves > 0
        end
    end
    return false
end

-- Function to save the selected slot
local function SaveSlotFunction()
    local checkSlot = CheckSlotNumber(Slot)
    if checkSlot then
        if CurrentSlot ~= -1 then
            ScriptLoadOrSave = true
            local saveSlot = game.ReplicatedStorage.LoadSaveRequests.RequestSave:InvokeServer(checkSlot)
            if saveSlot then
                Notify("Save Notification", "Saved your Slot", 2)
            else
                Notify("Already Saving", "Saving/Loading is currently in Progress", 1)
            end
            wait(0.5)
            ScriptLoadOrSave = false
        else
            Notify("Error", "Load Your Slot First before saving", 1)
        end
    else
        Notify("Incorrect Slot", "Enter a number between 1 and 6", 1)
    end
end

local lastLoadTimes = {} -- Table to store last load times for each slot

local function LoadSlotFunction()
    ScriptLoadOrSave = true
    local checkSlot = CheckSlotNumber(Slot)
    if checkSlot then
        if CheckIfSlotAvailable(checkSlot) then
            local currentTime = os.time()
            local lastLoadTime = lastLoadTimes[checkSlot] or 0 -- Use stored time or 0 if not set
            local cooldownDuration = 3 -- 3 seconds cooldown
            if currentTime - lastLoadTime >= cooldownDuration then
                local loadSlot = game.ReplicatedStorage.LoadSaveRequests.RequestLoad:InvokeServer(checkSlot)
                if loadSlot then
                    Notify("Reload Notification", "Loaded Your Slot", 2)
                    CurrentSlot = checkSlot
                    lastLoadTimes[checkSlot] = currentTime -- Update last load time
                else
                    Notify("Cooldown Notification", "You aren't able to load now", 1)
                end
            else
                local remainingCooldown = cooldownDuration - (currentTime - lastLoadTime)
                Notify("Cooldown Notification", "You must wait " .. math.ceil(remainingCooldown) .. " more seconds before loading this slot.", 1)
            end
        else
            Notify("Slot not Available", "This Slot is not Available, please choose another slot", 2)
        end
    else
        Notify("Incorrect Slot", "Enter a Valid number between 1 and 6", 1)
    end
    ScriptLoadOrSave = false
end

-- Create a dropdown for selecting slots
local Dropdown = Tab4:CreateDropdown({
    Name = "Select Save Slot",
    Options = {"1", "2", "3", "4", "5", "6"},
    CurrentOption = {"1"},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(selectedOptions)
        Slot = selectedOptions[1]
    end,
})

-- Create a button for testing the load functionality
local LoadTestButton = Tab4:CreateButton({
    Name = "Test Load Slot",
    Callback = function()
        LoadSlotFunction()
    end,
})
local Section8 = Tab4:CreateSection("Other")




-- Tab 3

local Tab3 = Window:CreateTab("Lumber Tycoon 2 | Teleports", 4483362458) -- Title, Image
local Section3 = Tab3:CreateSection("Teleports")

-- Assuming WayPoints is a table where keys are waypoint names and values are their corresponding CFrames
local WayPoints = {
["Wood R Us"] = CFrame.new(265, 5, 57),
["SpawnPoint"] = CFrame.new(155, 5, 74),
["Land Store"] = CFrame.new(258, 5, -99),
["Link's Logic"] = CFrame.new(4607, 9, -798),
["Cave"] = CFrame.new(3581, -177, 430),
["Volcano"] = CFrame.new(-1585, 625, 1140),
["Swamp"] = CFrame.new(-1209, 138, -801),
["Palm Island"] = CFrame.new(2549, 5, -42),
["Fancy Furnishings"] = CFrame.new(491, 13, -1720),
["Boxed Cars"] = CFrame.new(509, 5.2, -1463),
["Fine Arts Shop"] = CFrame.new(5207, -156, 719),
["Bob's Shack"] = CFrame.new(260, 10, -2542),
["Dock"] = CFrame.new(1114, 3.2, -197),
["BridgeW"] = CFrame.new(113, 15, -977),
["End Times"] = CFrame.new(113, -204, -951),
["Shrine Of Sight"] = CFrame.new(-1600, 205, 919),
["The Den"] = CFrame.new(323, 49, 1930),
["Volcano Win"] = CFrame.new(-1675, 358, 1476),
["Ski Lodge"] = CFrame.new(1244, 66, 2306),
["Strange Man"] = CFrame.new(1061, 20, 1131),
["Ice Wood"] = CFrame.new(1464, 413, 3245),
["Gold Wood"] = CFrame.new(-1038, 1.2, -944)
}
-- Create a button for each waypoint
for waypointName, waypointCFrame in pairs(WayPoints) do
    Tab3:CreateButton({
        Name = waypointName, -- Button label
        Callback = function() 
            local player = game.Players.LocalPlayer
            
            -- Ensure the player's character exists and has a HumanoidRootPart
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = waypointCFrame -- Teleport to the waypoint
                print("Teleported to " .. waypointName)
            else
                print("Player's character is not loaded or does not have a HumanoidRootPart.")
            end
        end
    })
end

local Section9 = Tab3:CreateSection("Car Teleport")

local function TeleportCar(Pos)
    local player = game.Players.LocalPlayer
    local Character = player.Character
    
    -- Check if the character exists and if it's seated in a car
    if Character and Character:FindFirstChildOfClass("Humanoid") and Character.Humanoid.SeatPart then
        local Car = Character.Humanoid.SeatPart.Parent
        
        -- Use a separate function to teleport the car
        spawn(function()
            for i = 1, 5 do
                wait()
                -- Set the car's position
                Car:SetPrimaryPartCFrame(Pos * CFrame.Angles(0, math.rad(Character.HumanoidRootPart.Orientation.Y), 0)) -- Keep the Y-axis orientation
                game.ReplicatedStorage.Interaction.ClientRequestOwnership:FireServer(Car.Main)
                game.ReplicatedStorage.Interaction.ClientIsDragging:FireServer(Car.Main)
            end
        end)
    else
        print("Character not seated in a car or does not exist.")
    end
end

-- Create a button for each car teleportation point
for carTeleportName, carPosition in pairs(WayPoints) do
    Tab3:CreateButton({
        Name = carTeleportName, -- Button label
        Callback = function()
            TeleportCar(carPosition) -- Call the teleport function with the specified position
            print("Attempting to teleport the car to " .. carTeleportName)
        end
    })
end

local Tabhop = Window:CreateTab("Server Hop", 4483362458) -- Title, Image

-- Variable to control hopping
local hoppingEnabled = false
local hopInterval = 5 -- Default hop interval in seconds

-- Toggle to enable or disable server hopping
local Paragraph = Tabhop:CreateParagraph({Title = "Info", Content = "If u use it always recommend paste script to autoexec!"})

-- Dropdown to select the time interval for hopping
local Dropdown = Tabhop:CreateDropdown({
    Name = "Select Hop Interval (seconds)",
    Options = {"5", "10", "15", "20", "60 (1m)", "300 (5m)", "900 (15m)", "1800 (30m)" },
    CurrentOption = {"5"},
    MultipleOptions = false,
    Flag = "Dropdown1",
    Callback = function(Options)
        hopInterval = tonumber(Options[1]) -- Convert selected option to number
    end,
})

-- Function to start hopping to a random server
local function StartHopping()
    Notify("Server Hop", "Hopping to a new server...", 5) -- Notify when hopping starts
    while hoppingEnabled do
        wait(hopInterval) -- Wait for the specified interval
        local success, message = pcall(function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId) -- Teleport to a random server
        end)
        if not success then
                Notify("Server Hop", "Error hopping: " .. message, 5) -- Notify when hopping starts
        end
    end
end

local Toggle = Tabhop:CreateToggle({
    Name = "Enable Server Hop",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        hoppingEnabled = Value
        if hoppingEnabled then
            StartHopping()
        end
    end,
})

