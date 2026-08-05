-- ============================================================
--              QuantomHub — Unified MM2 Script
--     VisionHub 1.8.0 + NightHub Spawner + KitagawaHub Wallbang
--              Webhook | Key System | Key Memory
-- ============================================================
local CoreGui           = game:GetService('CoreGui')
local Players           = game:GetService('Players')
local Workspace         = game:GetService('Workspace')
local RunService        = game:GetService('RunService')
local TeleportService   = game:GetService('TeleportService')
local StarterGui        = game:GetService('StarterGui')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local HttpService       = game:GetService('HttpService')
local UserInputService  = game:GetService('UserInputService')
local Lighting          = game:GetService('Lighting')
local SoundService      = game:GetService('SoundService')
local TextChatService   = game:GetService('TextChatService')
local Modules           = {}
local queue_on_teleport = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or function(...) end
local firetouchinterest = firetouchinterest or nil
local writefile         = writefile or nil
local readfile          = readfile or nil
-- ============================================================
--  WEBHOOK CONFIG
-- ============================================================
local WEBHOOK_URL = "https://discord.com/api/webhooks/1534455157381660682/FrSVHDUkLH1tA_uGJL1iRfznnZD3Hb8Q_0aQuory_8vp7XPnrUtnaIdl5ThoihAI03an"
local KEY_FILE    = "QuantomHub_key.txt"
-- ============================================================
--  EXECUTOR DETECTION
-- ============================================================
local function detectExecutor()
    if syn and syn.request then return "Synapse X" end
    if KRNL_LOADED          then return "Krnl"      end
    if fluxus               then return "Fluxus"    end
    if getexecutorname then local ok,n=pcall(getexecutorname); if ok and n then return tostring(n) end end
    if identifyexecutor then local ok,n=pcall(identifyexecutor); if ok and n then return tostring(n) end end
    return "Unknown"
end
local EXECUTOR = detectExecutor()
-- ============================================================
--  WEBHOOK SEND
-- ============================================================
local _webhookEnabled = true
local function sendWebhook(title, desc, color, extra)
    if not _webhookEnabled then return end
    pcall(function()
        local Player = Players.LocalPlayer
        local fields = {
            {name="Player",   value=(Player and Player.Name or "?").." ("..(Player and tostring(Player.UserId) or "?")..")", inline=true},
            {name="Game",     value=tostring(game.PlaceId),  inline=true},
            {name="Executor", value=EXECUTOR,                inline=true},
            {name="Server",   value=game.JobId~="" and game.JobId or "N/A", inline=false},
        }
        if extra then for _,f in ipairs(extra) do table.insert(fields,f) end end
        request({
            Url    = WEBHOOK_URL,
            Method = "POST",
            Headers= {["Content-Type"]="application/json"},
            Body   = HttpService:JSONEncode({embeds={{
                title       = title,
                description = desc,
                color       = color or 0x7B2FBE,
                footer      = {text="QuantomHub • "..os.date("%Y-%m-%d %H:%M:%S")},
                fields      = fields,
            }}}),
        })
    end)
end
-- ============================================================
--  KEY SYSTEM
-- ============================================================
local NOW_EPOCH  = 1748000000
local DAY_SECS   = 86400
local VALID_KEYS = {
    ["Femboy"] = { expires = NOW_EPOCH + (4 * DAY_SECS) },
    ["Quant"]  = { expires = math.huge },
}
local function validateKey(input)
    local t = tostring(input):match("^%s*(.-)%s*$")
    local e = VALID_KEYS[t]
    if not e then return false,"Invalid key." end
    if os.time() > e.expires then return false,"Key expired." end
    return true, t
end
local function keyExpiry(key)
    local e = VALID_KEYS[key]
    if not e then return "unknown" end
    if e.expires == math.huge then return "Never (lifetime)" end
    local r = e.expires - os.time()
    if r <= 0 then return "Expired" end
    return math.floor(r/86400).."d "..math.floor((r%86400)/3600).."h"
end
local validatedKey = ""
local keyValidated = false
local function trySaved()
    local ok,data = pcall(readfile, KEY_FILE)
    if not ok or not data or data=="" then return false end
    local valid,result = validateKey(data)
    if valid then validatedKey=result; keyValidated=true; return true end
    pcall(delfile, KEY_FILE)
    return false
end
local savedOk = trySaved()
-- ============================================================
--  GUI FACTORY
-- ============================================================
local function makeGui(name)
    local sg = Instance.new("ScreenGui")
    sg.Name=name; sg.ResetOnSpawn=false; sg.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local ok=pcall(function() sg.Parent=CoreGui end)
    if not ok then sg.Parent=Players.LocalPlayer:WaitForChild("PlayerGui") end
    return sg
end
-- ============================================================
--  KEY GATE UI
-- ============================================================
if not savedOk then
    local kg = makeGui("QuantomKeyGate")
    local card = Instance.new("Frame", kg)
    card.Size=UDim2.new(0,360,0,200); card.Position=UDim2.new(0.5,-180,0.5,-100)
    card.BackgroundColor3=Color3.fromRGB(10,10,18); card.BorderSizePixel=0
    Instance.new("UICorner",card).CornerRadius=UDim.new(0,14)
    local ks=Instance.new("UIStroke",card)
    ks.Color=Color3.fromRGB(123,47,190); ks.Thickness=1.5; ks.Transparency=0.3
    local kTitle=Instance.new("TextLabel",card)
    kTitle.Size=UDim2.new(1,0,0,32); kTitle.Position=UDim2.new(0,0,0,14)
    kTitle.BackgroundTransparency=1; kTitle.Text="🔑  QuantomHub — Key Required"
    kTitle.Font=Enum.Font.GothamBold; kTitle.TextSize=15
    kTitle.TextColor3=Color3.fromRGB(255,255,255); kTitle.TextXAlignment=Enum.TextXAlignment.Center
    local kSub=Instance.new("TextLabel",card)
    kSub.Size=UDim2.new(1,-20,0,18); kSub.Position=UDim2.new(0,10,0,50)
    kSub.BackgroundTransparency=1; kSub.Text="Enter your key. Saved automatically."
    kSub.Font=Enum.Font.Gotham; kSub.TextSize=11
    kSub.TextColor3=Color3.fromRGB(100,100,160); kSub.TextXAlignment=Enum.TextXAlignment.Center
    local kBox=Instance.new("TextBox",card)
    kBox.Size=UDim2.new(0,300,0,36); kBox.Position=UDim2.new(0.5,-150,0,78)
    kBox.BackgroundColor3=Color3.fromRGB(16,16,26); kBox.BorderSizePixel=0
    kBox.PlaceholderText="Enter key..."; kBox.PlaceholderColor3=Color3.fromRGB(80,80,120)
    kBox.Text=""; kBox.Font=Enum.Font.Gotham; kBox.TextSize=13
    kBox.TextColor3=Color3.fromRGB(220,220,255); kBox.ClearTextOnFocus=false
    Instance.new("UICorner",kBox).CornerRadius=UDim.new(0,8)
    local kBoxStroke=Instance.new("UIStroke",kBox)
    kBoxStroke.Color=Color3.fromRGB(123,47,190); kBoxStroke.Thickness=1; kBoxStroke.Transparency=0.5
    local kBtn=Instance.new("TextButton",card)
    kBtn.Size=UDim2.new(0,130,0,34); kBtn.Position=UDim2.new(0.5,-65,0,128)
    kBtn.BackgroundColor3=Color3.fromRGB(123,47,190); kBtn.BorderSizePixel=0
    kBtn.Text="Confirm"; kBtn.Font=Enum.Font.GothamBold; kBtn.TextSize=13
    kBtn.TextColor3=Color3.fromRGB(255,255,255)
    Instance.new("UICorner",kBtn).CornerRadius=UDim.new(0,8)
    local kStatus=Instance.new("TextLabel",card)
    kStatus.Size=UDim2.new(1,0,0,18); kStatus.Position=UDim2.new(0,0,1,-24)
    kStatus.BackgroundTransparency=1; kStatus.Text=""
    kStatus.Font=Enum.Font.Gotham; kStatus.TextSize=11
    kStatus.TextColor3=Color3.fromRGB(242,87,87); kStatus.TextXAlignment=Enum.TextXAlignment.Center
    local function attempt()
        local ok2,result=validateKey(kBox.Text)
        if ok2 then
            validatedKey=result; keyValidated=true
            pcall(writefile,KEY_FILE,result)
            kStatus.TextColor3=Color3.fromRGB(87,242,135)
            kStatus.Text="✓  Saved & entering..."
            task.wait(0.5); kg:Destroy()
        else
            kStatus.TextColor3=Color3.fromRGB(242,87,87); kStatus.Text="✗  "..result
            kBoxStroke.Color=Color3.fromRGB(242,87,87); task.wait(1.2)
            kBoxStroke.Color=Color3.fromRGB(123,47,190); kStatus.Text=""
        end
    end
    kBtn.MouseButton1Click:Connect(attempt)
    kBox.FocusLost:Connect(function(e) if e then attempt() end end)
    repeat task.wait(0.05) until keyValidated
end
-- ============================================================
--  WIND UI LOAD
-- ============================================================
local WindUI = loadstring(game:HttpGet('https://raw.githubusercontent.com/KevinScripts2024/Gkfkfkdlwsk/refs/heads/main/wind%20(1).txt'))()
-- ============================================================
--  CLEANUP PREVIOUS INSTANCE
-- ============================================================
if getgenv().VisionHub_Connections then
    for i,conn in pairs(getgenv().VisionHub_Connections) do
        if conn then pcall(function() conn:Disconnect() end) end
        getgenv().VisionHub_Connections[i] = nil
    end
end
getgenv().VisionHub_Connections = {}
for _,gui in ipairs(CoreGui:GetChildren()) do
    if gui.Name=='Vision Hub' or gui.Name=='VisionESP' or gui.Name=='QuantomHub'
    or string.match(gui.Name,'^VisionBtn_') or gui.Name=='VisionTimerGUI' then
        gui:Destroy()
    end
end
for _,player in ipairs(Players:GetPlayers()) do
    if player.Character then
        local artifacts = {
            player.Character:FindFirstChild('VisionHighlight'),
            player.Character:FindFirstChild('Head') and player.Character.Head:FindFirstChild('NameESP'),
        }
        for _,artifact in ipairs(artifacts) do
            if artifact then artifact:Destroy() end
        end
    end
end
for _,obj in ipairs(Workspace:GetDescendants()) do
    if obj.Name=='VisionGunHighlight' or obj.Name=='VisionGunLabel' then obj:Destroy() end
end
if Modules and Modules.RootPart then
    local v=Modules.RootPart:FindFirstChild('EpixVel')
    if v then v:Destroy() end
end
if getgenv().FPDH then
    Workspace.FallenPartsDestroyHeight = getgenv().FPDH
end
-- ============================================================
--  CONNECTION MANAGER
-- ============================================================
local function AddConnection(conn)
    local connections = getgenv().VisionHub_Connections
    for i=#connections,1,-1 do
        local c=connections[i]
        if not c or not c.Connected then table.remove(connections,i) end
    end
    table.insert(connections,conn)
    return conn
end
-- ============================================================
--  MODULE SETUP
-- ============================================================
local Player      = Players.LocalPlayer
local GetMouse    = Player:GetMouse()
local PlayerGui   = Player:FindFirstChildWhichIsA('PlayerGui')
local PlaceId, JobId = game.PlaceId, game.JobId
Modules.Player          = Player
Modules.GetMouse        = GetMouse
Modules.PlayerGui       = PlayerGui
Modules.PlaceId         = PlaceId
Modules.JobId           = JobId
Modules.RunService      = RunService
Modules.UserInputService= UserInputService
Modules.Lighting        = Lighting
Modules.SoundService    = SoundService
Modules.Workspace       = Workspace
Modules.ReplicatedStorage=ReplicatedStorage
Modules.HttpService     = HttpService
Modules.StarterGui      = StarterGui
Modules.TextChatService = TextChatService
Modules.Config = {
    GodMode             = false,
    AntiFling           = false,
    AntiAfk             = false,
    EnableWalkSpeed     = false,
    WalkSpeed           = 16,
    EnableJumpPower     = false,
    JumpPower           = 50,
    Noclip              = false,
    InfiniteJump        = false,
    AutoGrabGun         = false,
    AutoKill            = false,
    KnifeAura           = false,
    AuraRadius          = 10,
    EspPlayers          = false,
    ShowNames           = false,
    EspDroppedGun       = false,
    EspTrap             = false,
    RemoveTraps         = false,
    SilentThrow         = false,
    AutoShootMurderer   = false,
    AutoQueue           = true,
    QueueUrl            = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/so1vexis/opn-src/refs/heads/main/quantomhub.lua"))()',
    NotifyMurderer      = false,
    NotifySheriff       = false,
    NotifyGunDropped    = false,
    ButtonsLocked       = false,
    WallbangEnabled     = false,
    SpawnerEnabled      = false,
    SpawnerItem         = "Knife",
    SpawnerInterval     = 1.0,
}
Modules.PlayerData   = {}
Modules.MobileButtons= {}
-- ============================================================
--  CHARACTER REFS
-- ============================================================
local function updateCharacterRefs(character)
    Modules.Character = character
    if character then
        local hum = character:FindFirstChildOfClass('Humanoid')
        if not hum then hum=character:WaitForChild('Humanoid',5) end
        Modules.Humanoid = hum
        Modules.Backpack  = Modules.Player:FindFirstChild('Backpack')
        Modules.RootPart  = character:FindFirstChild('HumanoidRootPart') or character.PrimaryPart
        Modules.Camera    = Workspace.CurrentCamera
    else
        Modules.Humanoid = nil
        Modules.RootPart  = nil
    end
end
if Modules.Player then
    if Modules.Player.Character then updateCharacterRefs(Modules.Player.Character) end
    AddConnection(Modules.Player.CharacterAdded:Connect(function(c) updateCharacterRefs(c) end))
    AddConnection(Modules.Player.CharacterRemoving:Connect(function() updateCharacterRefs(nil) end))
    AddConnection(Players.PlayerRemoving:Connect(function(p)
        if p and p.Name and Modules.PlayerData[p.Name] then Modules.PlayerData[p.Name]=nil end
    end))
end
function Modules.GetService(name)
    local ok,s=pcall(function() return game:GetService(name) end)
    return ok and s or nil
end
-- ============================================================
--  ANTI-FLING
-- ============================================================
do
    local antiFlingConn=nil
    function Modules.ToggleAntiFling(enable)
        Modules.Config.AntiFling=enable
        if antiFlingConn then antiFlingConn:Disconnect(); antiFlingConn=nil end
        if enable then
            antiFlingConn=AddConnection(RunService.Stepped:Connect(function()
                if not Modules.Character then return end
                for _,op in ipairs(Players:GetPlayers()) do
                    if op~=Modules.Player and op.Character then
                        for _,part in ipairs(op.Character:GetChildren()) do
                            if part:IsA('BasePart') and part.CanCollide then
                                part.CanCollide=false
                                if part.Name=='HumanoidRootPart' then
                                    part.Velocity=Vector3.new(0,0,0)
                                    part.RotVelocity=Vector3.new(0,0,0)
                                end
                            end
                        end
                    end
                end
            end))
        end
    end
end
-- ============================================================
--  SERVER UTILS
-- ============================================================
function Modules.HandleQueueTeleport()
    if Modules.Config.AutoQueue and Modules.Config.QueueUrl and Modules.Config.QueueUrl~='' then
        if queue_on_teleport then queue_on_teleport(Modules.Config.QueueUrl) end
    end
end
function Modules.Rejoin()
    if not TeleportService or not Modules.Player then return end
    Modules.HandleQueueTeleport()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,Modules.Player) end)
end
function Modules.ServerHop()
    if not TeleportService or not Modules.Player then return end
    Modules.HandleQueueTeleport()
    local url='https://games.roblox.com/v1/games/'..game.PlaceId..'/servers/Public?sortOrder=Asc&limit=100'
    local success,result=pcall(function() return HttpService:JSONDecode(game:HttpGet(url)) end)
    if success and result and result.data then
        for _,server in ipairs(result.data) do
            if server.id~=game.JobId and server.playing<server.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId,server.id,Modules.Player)
                return
            end
        end
    end
    TeleportService:Teleport(game.PlaceId,Modules.Player)
end
-- ============================================================
--  MAP HELPERS
-- ============================================================
function getMap()
    for _,o in ipairs(Workspace:GetChildren()) do
        if o:FindFirstChild('CoinContainer') and o:FindFirstChild('Spawns') then return o end
    end
    return nil
end
function Modules.TeleportToMap()
    local character=Modules.Character or (Modules.RootPart and Modules.RootPart.Parent)
    if not character then return end
    local map=getMap(); if not map then return end
    local spawns=map:FindFirstChild('Spawns'); if not spawns then return end
    local spawnList={}
    for _,v in ipairs(spawns:GetChildren()) do
        if v:IsA('BasePart') then table.insert(spawnList,v) end
    end
    local spawn
    if #spawnList>0 then spawn=spawnList[math.random(1,#spawnList)] end
    if not spawn then spawn=spawns:FindFirstChild('Spawn') or spawns:FindFirstChild('PlayerSpawn') end
    if spawn and spawn:IsA('BasePart') then character:PivotTo(spawn.CFrame*CFrame.new(0,5,0)) end
end
function getLobby()
    for _,obj in ipairs(Workspace:GetChildren()) do
        if obj:FindFirstChild('Lobby') then return obj.Lobby end
        if obj.Name:lower()=='lobby' then return obj end
    end
    return nil
end
function Modules.TeleportToLobby()
    local character=Modules.Character or (Modules.RootPart and Modules.RootPart.Parent)
    if not character then return end
    local lobby=getLobby(); if not lobby then return end
    local spawns=lobby:FindFirstChild('Spawns'); if not spawns then return end
    local spawnList={}
    for _,v in ipairs(spawns:GetChildren()) do
        if v:IsA('BasePart') then table.insert(spawnList,v) end
    end
    local spawn
    if #spawnList>0 then spawn=spawnList[math.random(1,#spawnList)] end
    if not spawn then spawn=spawns:FindFirstChild('SpawnLocation') end
    if spawn and spawn:IsA('BasePart') then character:PivotTo(spawn.CFrame*CFrame.new(0,5,0)) end
end
function getCoinContainer()
    local map=getMap()
    if map then return map:FindFirstChild('CoinContainer') end
    return nil
end
function Modules.GetPlayerByName(name)
    if not name then return nil end
    for _,p in ipairs(Players:GetPlayers()) do
        if p.Name:lower()==name:lower() then return p end
    end
    return nil
end
-- ============================================================
--  ROLE DETECTION
-- ============================================================
function Modules.FindMurderer()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr:FindFirstChild('Backpack') and plr.Backpack:FindFirstChild('Knife') then return plr end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild('Knife') then return plr end
    end
    if Modules.PlayerData then
        for playerName,data in pairs(Modules.PlayerData) do
            if data and (data.Role=='Murderer' or data.role=='Murderer') then
                local found=Players:FindFirstChild(playerName)
                if found then return found end
            end
        end
    end
    return nil
end
function Modules.FindSheriff()
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr:FindFirstChild('Backpack') and plr.Backpack:FindFirstChild('Gun') then return plr end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild('Gun') then return plr end
    end
    if Modules.PlayerData then
        for playerName,data in pairs(Modules.PlayerData) do
            if data and (data.Role=='Sheriff' or data.role=='Sheriff') then
                local found=Players:FindFirstChild(playerName)
                if found then return found end
            end
        end
    end
    return nil
end
function Modules.FindSheriffThatsNotMe()
    local lp=Players.LocalPlayer
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=lp and plr:FindFirstChild('Backpack') and plr.Backpack:FindFirstChild('Gun') then return plr end
    end
    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=lp and plr.Character and plr.Character:FindFirstChild('Gun') then return plr end
    end
    if Modules.PlayerData then
        for playerName,data in pairs(Modules.PlayerData) do
            if data and (data.Role=='Sheriff' or data.role=='Sheriff') then
                local found=Players:FindFirstChild(playerName)
                if found and found~=lp then return found end
            end
        end
    end
    return nil
end
-- ============================================================
--  PLAYER DATA SYNC
-- ============================================================
do
    local success,remotes=pcall(function()
        return Modules.ReplicatedStorage and Modules.ReplicatedStorage:WaitForChild('Remotes',5)
    end)
    if success and remotes then
        local gameplay=remotes:FindFirstChild('Gameplay') or remotes:FindFirstChild('Gameplay',true)
        if gameplay then
            local pdEvent=gameplay:FindFirstChild('PlayerDataChanged')
            if pdEvent and pdEvent:IsA('RemoteEvent') then
                AddConnection(pdEvent.OnClientEvent:Connect(function(data)
                    if type(data)=='table' then Modules.PlayerData=data end
                end))
            end
        end
    end
    local getPD=nil
    if Modules.ReplicatedStorage then
        getPD=Modules.ReplicatedStorage:FindFirstChild('GetPlayerData',true)
    end
    if getPD and typeof(getPD.InvokeServer)=='function' then
        pcall(function()
            local ok,res=pcall(function() return getPD:InvokeServer() end)
            if ok and type(res)=='table' then Modules.PlayerData=res end
        end)
    end
end
-- ============================================================
--  FLING FUNCTION (SkidFling)
-- ============================================================
local SkidFling=function(TargetPlayer)
    if not TargetPlayer or not TargetPlayer.Character then return end
    local Character=Player and Player.Character
    local Humanoid=Character and (Character:FindFirstChildOfClass('Humanoid') or Character:FindFirstChild('Humanoid'))
    local RootPart=Character and (Character:FindFirstChild('HumanoidRootPart') or Character.PrimaryPart)
    local TCharacter=TargetPlayer and TargetPlayer.Character
    local THumanoid,TRootPart,THead,Accessory,Handle
    if TCharacter and TCharacter:FindFirstChildOfClass('Humanoid') then THumanoid=TCharacter:FindFirstChildOfClass('Humanoid') end
    if THumanoid then TRootPart=TCharacter:FindFirstChild('HumanoidRootPart') or TCharacter.PrimaryPart or THumanoid.RootPart end
    if TCharacter and TCharacter:FindFirstChild('Head') then THead=TCharacter.Head end
    if TCharacter and TCharacter:FindFirstChildOfClass('Accessory') then Accessory=TCharacter:FindFirstChildOfClass('Accessory') end
    if Accessory and Accessory:FindFirstChild('Handle') then Handle=Accessory.Handle end
    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude<50 then getgenv().OldPos=RootPart.CFrame end
        local CurrentCam=Workspace.CurrentCamera
        if THead then CurrentCam.CameraSubject=THead
        elseif not THead and Handle then CurrentCam.CameraSubject=Handle
        elseif THumanoid and TRootPart then CurrentCam.CameraSubject=THumanoid end
        if not (TCharacter and TCharacter:FindFirstChildWhichIsA('BasePart')) then return end
        local FPos=function(BasePart,Pos,Ang)
            RootPart.CFrame=CFrame.new(BasePart.Position)*Pos*Ang
            pcall(function()
                if Character and Character.PrimaryPart then
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position)*Pos*Ang)
                end
            end)
            RootPart.Velocity=Vector3.new(9e7,9E8,9e7)
            RootPart.RotVelocity=Vector3.new(9e8,9e8,9e8)
        end
        local SFBasePart=function(BasePart)
            local TimeToWait=2; local Time=tick(); local Angle=0
            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude<50 then
                        Angle=Angle+100
                        FPos(BasePart,CFrame.new(0,1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,0)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(2.25,1.5,-2.25)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(-2.25,-1.5,2.25)+THumanoid.MoveDirection*BasePart.Velocity.Magnitude/1.25,CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,1.5,0)+THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,0)+THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle),0,0)); task.wait()
                    else
                        FPos(BasePart,CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,-THumanoid.WalkSpeed),CFrame.Angles(0,0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,1.5,THumanoid.WalkSpeed),CFrame.Angles(math.rad(90),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,1.5,TRootPart and TRootPart.Velocity.Magnitude/1.25 or 0),CFrame.Angles(math.rad(90),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,-(TRootPart and TRootPart.Velocity.Magnitude/1.25 or 0)),CFrame.Angles(0,0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,1.5,TRootPart and TRootPart.Velocity.Magnitude/1.25 or 0),CFrame.Angles(math.rad(90),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(90),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(math.rad(-90),0,0)); task.wait()
                        FPos(BasePart,CFrame.new(0,-1.5,0),CFrame.Angles(0,0,0)); task.wait()
                    end
                else break end
            until BasePart.Velocity.Magnitude>500 or BasePart.Parent~=TargetPlayer.Character or TargetPlayer.Parent~=Players or TargetPlayer.Character~=TCharacter or (THumanoid and THumanoid.Sit) or (Humanoid and Humanoid.Health<=0) or tick()>Time+TimeToWait
        end
        if not getgenv().FPDH then getgenv().FPDH=Workspace.FallenPartsDestroyHeight end
        Workspace.FallenPartsDestroyHeight=0/0
        local BV=Instance.new('BodyVelocity')
        BV.Name='EpixVel'; BV.Parent=RootPart
        BV.Velocity=Vector3.new(9e8,9e8,9e8); BV.MaxForce=Vector3.new(1/0,1/0,1/0)
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,false)
        if TRootPart and THead then
            if (TRootPart.CFrame.p-THead.CFrame.p).Magnitude>5 then SFBasePart(THead) else SFBasePart(TRootPart) end
        elseif TRootPart and not THead then SFBasePart(TRootPart)
        elseif not TRootPart and THead then SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then SFBasePart(Handle) end
        if BV and BV.Parent then BV:Destroy() end
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated,true)
        Workspace.CurrentCamera.CameraSubject=Humanoid
        repeat
            if getgenv().OldPos then
                RootPart.CFrame=getgenv().OldPos*CFrame.new(0,0.5,0)
                pcall(function()
                    if Character and Character.PrimaryPart then
                        Character:SetPrimaryPartCFrame(getgenv().OldPos*CFrame.new(0,0.5,0))
                    end
                end)
            end
            Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            for _,x in ipairs(Character:GetChildren()) do
                if x:IsA('BasePart') then x.Velocity,x.RotVelocity=Vector3.new(),Vector3.new() end
            end
            task.wait()
        until not getgenv().OldPos or (RootPart.Position-getgenv().OldPos.p).Magnitude<25
        if getgenv().FPDH then Workspace.FallenPartsDestroyHeight=getgenv().FPDH end
    end
end
-- ============================================================
--  PREDICTED POSITION
-- ============================================================
function Modules.getPredictedPosition(player)
    if not player or not player.Character then return Vector3.new(0,0,0) end
    local hrp=player.Character:FindFirstChild('HumanoidRootPart') or player.Character.PrimaryPart
    if not hrp then return Vector3.new(0,0,0) end
    local vel=hrp.AssemblyLinearVelocity or hrp.Velocity or Vector3.new(0,0,0)
    local ping=0
    pcall(function()
        if Modules.Player and typeof(Modules.Player.GetNetworkPing)=='function' then
            ping=Modules.Player:GetNetworkPing() or 0
        end
    end)
    if type(ping)~='number' then ping=tonumber(ping) or 0 end
    if ping>1 then ping=ping/1000 end
    local offset=2.8
    local leadTime=math.max(0,offset*0.01)+ping
    return hrp.Position+vel*leadTime
end
-- ============================================================
--  SHOOT MURDERER
-- ============================================================
function Modules.ShootMurdererOnce()
    local lp=Modules.Player
    if not lp or not lp.Character then return end
    local target=Modules.FindMurderer() or Modules.FindSheriffThatsNotMe()
    if not target or not target.Character then return end
    local mHRP=target.Character:FindFirstChild('HumanoidRootPart')
    local lHRP=lp.Character:FindFirstChild('HumanoidRootPart')
    if not mHRP or not lHRP then return end
    local rayParams=RaycastParams.new()
    rayParams.FilterType=Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances={lp.Character}
    local direction=(mHRP.Position-lHRP.Position)
    local ok,res=pcall(function() return Workspace:Raycast(lHRP.Position,direction,rayParams) end)
    local clearShot=false
    if not ok or not res then clearShot=true
    else
        if res.Instance and target.Character and res.Instance:IsDescendantOf(target.Character) then clearShot=true end
    end
    if not clearShot then return end
    if not lp.Character:FindFirstChild('Gun') then
        local tool=lp.Backpack and lp.Backpack:FindFirstChild('Gun')
        if tool and lp.Character:FindFirstChildOfClass('Humanoid') then
            pcall(function() lp.Character.Humanoid:EquipTool(tool) end)
        end
    end
    local gun=lp.Character and lp.Character:FindFirstChild('Gun')
    if not gun then return end
    local knifeLocal=gun:FindFirstChild('KnifeLocal')
    local createBeam=knifeLocal and knifeLocal:FindFirstChild('CreateBeam')
    local rf=createBeam and createBeam:FindFirstChild('RemoteFunction')
    if gun and knifeLocal and createBeam and rf and typeof(rf.InvokeServer)=='function' then
        local predPos=Modules.getPredictedPosition(target)
        pcall(function() rf:InvokeServer(1,predPos,'AH2') end)
    end
end
do
    local autoShootConn=nil
    function Modules.ToggleAutoShootMurderer(enable)
        Modules.Config.AutoShootMurderer=enable
        if autoShootConn then autoShootConn:Disconnect(); autoShootConn=nil end
        if not enable then return end
        autoShootConn=AddConnection(Modules.RunService.Heartbeat:Connect(function()
            pcall(function()
                if Modules.Config.AutoShootMurderer and Modules.FindSheriff()==Modules.Player then
                    Modules.ShootMurdererOnce()
                end
            end)
        end))
    end
end
-- ============================================================
--  WALLBANG (from KitagawaHub)
--  Fires gun remote through walls using blind raycast bypass
-- ============================================================
do
    local wallbangConn=nil
    function Modules.ShootWallbang()
        local lp=Modules.Player
        if not lp or not lp.Character then return end
        local target=Modules.FindMurderer()
        if not target or not target.Character then return end
        local mHRP=target.Character:FindFirstChild('HumanoidRootPart')
        local lHRP=lp.Character:FindFirstChild('HumanoidRootPart')
        if not mHRP or not lHRP then return end
        -- No LOS check — wallbang fires regardless of geometry
        if not lp.Character:FindFirstChild('Gun') then
            local tool=lp.Backpack and lp.Backpack:FindFirstChild('Gun')
            if tool and lp.Character:FindFirstChildOfClass('Humanoid') then
                pcall(function() lp.Character.Humanoid:EquipTool(tool) end)
            end
        end
        local gun=lp.Character and lp.Character:FindFirstChild('Gun')
        if not gun then return end
        local knifeLocal=gun:FindFirstChild('KnifeLocal')
        local createBeam=knifeLocal and knifeLocal:FindFirstChild('CreateBeam')
        local rf=createBeam and createBeam:FindFirstChild('RemoteFunction')
        if rf and typeof(rf.InvokeServer)=='function' then
            local predPos=Modules.getPredictedPosition(target)
            pcall(function() rf:InvokeServer(1,predPos,'AH2') end)
        end
        -- Fallback: direct shoot remote scan
        for _,rem in ipairs(gun:GetDescendants()) do
            if rem:IsA('RemoteEvent') and (rem.Name:lower():find('shoot') or rem.Name:lower():find('fire')) then
                pcall(function() rem:FireServer(Modules.getPredictedPosition(target)) end)
            end
            if rem:IsA('RemoteFunction') and (rem.Name:lower():find('shoot') or rem.Name:lower():find('fire')) then
                pcall(function() rem:InvokeServer(1,Modules.getPredictedPosition(target),'AH2') end)
            end
        end
    end
    function Modules.ToggleWallbang(enable)
        Modules.Config.WallbangEnabled=enable
        if wallbangConn then wallbangConn:Disconnect(); wallbangConn=nil end
        if not enable then return end
        wallbangConn=AddConnection(RunService.Heartbeat:Connect(function()
            pcall(function()
                if Modules.Config.WallbangEnabled and Modules.FindSheriff()==Modules.Player then
                    Modules.ShootWallbang()
                end
            end)
        end))
    end
end
-- ============================================================
--  SPAWNER (from NightHub)
--  Spawns items (Knife, Gun, Coin) via touch-trigger on CoinContainer
--  or direct tool clone into character
-- ============================================================
do
    local spawnerTask=nil
    local SPAWNABLE_ITEMS={
        "Knife",
        "Gun",
        "Revolver",
        "Coin",
    }
    local function spawnItem(itemName)
        local lp=Modules.Player
        if not lp or not lp.Character then return end
        local map=getMap()
        if not map then return end
        -- Method 1: find existing tool in map and touch-trigger
        local found=map:FindFirstChild(itemName,true)
        if found and found:IsA('BasePart') and firetouchinterest and Modules.RootPart then
            pcall(function()
                firetouchinterest(found,Modules.RootPart,1)
                task.wait(0.05)
                firetouchinterest(found,Modules.RootPart,0)
            end)
            return
        end
        -- Method 2: find Tool in workspace/storage and clone to backpack
        local tool=Workspace:FindFirstChild(itemName,true)
        if not tool or not tool:IsA('Tool') then
            tool=ReplicatedStorage:FindFirstChild(itemName,true)
        end
        if tool and tool:IsA('Tool') then
            local clone=tool:Clone()
            clone.Parent=lp.Backpack or lp.Character
        end
        -- Method 3: GunDrop touch for gun/revolver
        if itemName:lower():find('gun') or itemName:lower():find('revolver') then
            local gunDrop=map:FindFirstChild('GunDrop')
            if gunDrop and gunDrop:IsA('BasePart') and firetouchinterest and Modules.RootPart then
                pcall(function()
                    firetouchinterest(gunDrop,Modules.RootPart,1)
                    task.wait(0.05)
                    firetouchinterest(gunDrop,Modules.RootPart,0)
                end)
            end
        end
    end
    function Modules.SpawnItemOnce()
        spawnItem(Modules.Config.SpawnerItem or "Knife")
    end
    function Modules.ToggleSpawner(enable)
        Modules.Config.SpawnerEnabled=enable
        if spawnerTask then
            pcall(task.cancel,spawnerTask)
            spawnerTask=nil
        end
        if not enable then return end
        spawnerTask=task.spawn(function()
            while Modules.Config.SpawnerEnabled do
                pcall(Modules.SpawnItemOnce)
                task.wait(math.max(0.3,Modules.Config.SpawnerInterval or 1.0))
            end
        end)
    end
    Modules.SpawnableItems=SPAWNABLE_ITEMS
end
-- ============================================================
--  TELEPORT TO PLAYER
-- ============================================================
do
    function Modules.TeleportToPlayer(targetPlayer)
        if not Modules.RootPart then return false end
        if not (targetPlayer and targetPlayer.Character and targetPlayer.Character.PrimaryPart) then return false end
        local ok=pcall(function()
            local targetCFrame=targetPlayer.Character.PrimaryPart.CFrame
            Modules.Character:SetPrimaryPartCFrame(targetCFrame*CFrame.new(0,3,0))
        end)
        return ok
    end
end
-- ============================================================
--  GOD MODE
-- ============================================================
do
    local _godConn=nil
    function Modules.EnableGodMode(enable)
        Modules.Config.GodMode=enable
        if _godConn then _godConn:Disconnect(); _godConn=nil end
        if not enable then return end
        local function protectHumanoid(h)
            if not h then return end
            local healthConn
            healthConn=h.HealthChanged:Connect(function(newHealth)
                if Modules.Config.GodMode and newHealth<h.MaxHealth then h.Health=h.MaxHealth end
            end)
            task.spawn(function()
                while Modules.Config.GodMode and h and h.Parent do
                    if h.Health<h.MaxHealth then h.Health=h.MaxHealth end
                    if h:GetState()==Enum.HumanoidStateType.Dead then
                        h:ChangeState(Enum.HumanoidStateType.GettingUp)
                        h.Health=h.MaxHealth
                    end
                    task.wait(0.2)
                end
                if healthConn then healthConn:Disconnect() end
            end)
        end
        if Modules.Humanoid then protectHumanoid(Modules.Humanoid) end
        _godConn=AddConnection(Modules.Player.CharacterAdded:Connect(function(character)
            local hum=character:WaitForChild('Humanoid',5)
            if hum then task.wait(0.5); protectHumanoid(hum) end
        end))
    end
end
-- ============================================================
--  WALKSPEED / JUMPPOWER
-- ============================================================
do
    local _speedConnection=nil
    local _originalSpeed=16
    function Modules.EnableWalkSpeed(enable)
        Modules.Config.EnableWalkSpeed=enable
        if enable then
            if _speedConnection then _speedConnection:Disconnect() end
            _speedConnection=AddConnection(RunService.Heartbeat:Connect(function()
                if Modules.Humanoid and Modules.Humanoid.WalkSpeed~=Modules.Config.WalkSpeed then
                    Modules.Humanoid.WalkSpeed=Modules.Config.WalkSpeed
                end
            end))
        else
            if _speedConnection then _speedConnection:Disconnect(); _speedConnection=nil end
            if Modules.Humanoid then Modules.Humanoid.WalkSpeed=_originalSpeed end
        end
    end
    function Modules.SetWalkSpeed(value)
        Modules.Config.WalkSpeed=math.clamp(value,16,200)
        if Modules.Config.EnableWalkSpeed and Modules.Humanoid then
            Modules.Humanoid.WalkSpeed=Modules.Config.WalkSpeed
        end
    end
end
do
    local _jumpConnection=nil
    local _originalJumpPower=50
    function Modules.EnableJumpPower(enable)
        Modules.Config.EnableJumpPower=enable
        if enable then
            if _jumpConnection then _jumpConnection:Disconnect() end
            _jumpConnection=AddConnection(RunService.Heartbeat:Connect(function()
                if Modules.Humanoid and Modules.Humanoid.JumpPower~=Modules.Config.JumpPower then
                    Modules.Humanoid.JumpPower=Modules.Config.JumpPower
                end
            end))
        else
            if _jumpConnection then _jumpConnection:Disconnect(); _jumpConnection=nil end
            if Modules.Humanoid then Modules.Humanoid.JumpPower=_originalJumpPower end
        end
    end
    function Modules.SetJumpPower(value)
        Modules.Config.JumpPower=math.clamp(value,50,300)
        if Modules.Config.EnableJumpPower and Modules.Humanoid then
            Modules.Humanoid.JumpPower=Modules.Config.JumpPower
        end
    end
end
-- ============================================================
--  NOCLIP / INF JUMP
-- ============================================================
do
    local _noclipConn=nil
    local _savedCanCollide={}
    function Modules.EnableNoclip(enable)
        Modules.Config.Noclip=enable
        if enable then
            if Modules.Character then
                for _,part in ipairs(Modules.Character:GetDescendants()) do
                    if part:IsA('BasePart') then _savedCanCollide[part]=part.CanCollide; part.CanCollide=false end
                end
            end
            if _noclipConn then _noclipConn:Disconnect() end
            _noclipConn=AddConnection(RunService.Stepped:Connect(function()
                if not Modules.Character then return end
                for _,part in ipairs(Modules.Character:GetDescendants()) do
                    if part:IsA('BasePart') then part.CanCollide=false end
                end
            end))
        else
            if _noclipConn then _noclipConn:Disconnect(); _noclipConn=nil end
            for part,state in pairs(_savedCanCollide) do
                if part and part.Parent then part.CanCollide=state end
            end
            _savedCanCollide={}
        end
    end
end
do
    local _infJumpConn=nil
    function Modules.InfiniteJump(enabled)
        Modules.Config.InfiniteJump=enabled
        if enabled then
            if _infJumpConn then _infJumpConn:Disconnect() end
            _infJumpConn=AddConnection(UserInputService.JumpRequest:Connect(function()
                if Modules.Humanoid then Modules.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
            end))
        else
            if _infJumpConn then _infJumpConn:Disconnect(); _infJumpConn=nil end
        end
    end
end
-- ============================================================
--  GUN GRAB / AUTO GRAB
-- ============================================================
do
    local grabGunConn=nil
    function Modules.GrabGun()
        local root=Modules.RootPart
        if not root or not root.Parent then return end
        local map=getMap(); if not map then return end
        local gunDrop=map:FindFirstChild('GunDrop')
        if gunDrop and gunDrop:IsA('BasePart') then
            pcall(function()
                firetouchinterest(gunDrop,root,1)
                firetouchinterest(gunDrop,root,0)
            end)
        end
    end
    function Modules.ToggleAutoGrabGun(enable)
        Modules.Config.AutoGrabGun=enable
        if grabGunConn then grabGunConn:Disconnect(); grabGunConn=nil end
        if enable then grabGunConn=AddConnection(RunService.Heartbeat:Connect(Modules.GrabGun)) end
    end
end
-- ============================================================
--  KILL ALL / AUTO KILL / KNIFE AURA
-- ============================================================
do
    function Modules.KillAll()
        if not Modules.Backpack or not Modules.Character or not Modules.Humanoid then return end
        local Knife=Modules.Backpack:FindFirstChild('Knife') or Modules.Character:FindFirstChild('Knife')
        local Humanoid=Modules.Humanoid
        if not Knife then return end
        if Knife.Parent==Modules.Backpack then
            Humanoid:EquipTool(Knife); task.wait(0.1)
            Knife=Modules.Character:FindFirstChild('Knife')
        end
        if not Knife then return end
        local Handle=Knife:FindFirstChild('Handle')
        local Stab=Knife:FindFirstChild('Stab')
        if Knife:IsA('Tool') then
            Knife.Parent=Modules.Character
            for _,v in ipairs(Players:GetPlayers()) do
                local EnemyRoot=v.Character and (v.Character:FindFirstChild('HumanoidRootPart') or v.Character.PrimaryPart)
                if v~=Modules.Player and EnemyRoot and Handle then
                    firetouchinterest(Handle,EnemyRoot,1)
                    firetouchinterest(Handle,EnemyRoot,0)
                    if Stab and typeof(Stab.FireServer)=='function' then Stab:FireServer(EnemyRoot.Position) end
                    task.wait(0.1)
                end
            end
        end
    end
end
do
    local autoKillConn=nil
    function Modules.ToggleAutoKillAll(enable)
        Modules.Config.AutoKill=enable
        if autoKillConn then autoKillConn:Disconnect(); autoKillConn=nil end
        if enable then
            autoKillConn=AddConnection(RunService.Heartbeat:Connect(function()
                if Modules.Config.AutoKill and Modules.Backpack and Modules.Character then
                    local Knife=Modules.Backpack:FindFirstChild('Knife') or Modules.Character:FindFirstChild('Knife')
                    if Knife and Knife:IsA('Tool') then Modules.KillAll() end
                end
            end))
        end
    end
end
do
    local KillAuraConnection=nil
    function Modules.KillAura(enabled)
        Modules.Config.KillAura=enabled
        if KillAuraConnection then KillAuraConnection:Disconnect(); KillAuraConnection=nil end
        if not enabled then return end
        KillAuraConnection=AddConnection(RunService.Heartbeat:Connect(function()
            local Knife=Modules.Character and Modules.Character:FindFirstChild('Knife')
            if not Knife or not Knife:IsA('Tool') then return end
            local Handle=Knife:FindFirstChild('Handle')
            local Stab=Knife:FindFirstChild('Stab')
            local RootPart=Modules.RootPart
            local Character=Modules.Character
            if not Handle or not RootPart or not Character then return end
            if Knife.Parent~=Character then return end
            local range=math.max(1,tonumber(Modules.Config.AuraRadius) or 10)
            for _,v in ipairs(Players:GetPlayers()) do
                if v~=Modules.Player and v.Character and v.Character:FindFirstChildOfClass('Humanoid') and v.Character.Humanoid.Health>0 then
                    local EnemyRoot=v.Character:FindFirstChild('HumanoidRootPart') or v.Character.PrimaryPart
                    if EnemyRoot then
                        local dist=(EnemyRoot.Position-RootPart.Position).Magnitude
                        if dist<=range then
                            firetouchinterest(Handle,EnemyRoot,1)
                            firetouchinterest(Handle,EnemyRoot,0)
                            if Stab and typeof(Stab.FireServer)=='function' then Stab:FireServer(EnemyRoot.Position) end
                            break
                        end
                    end
                end
            end
        end))
    end
end
-- ============================================================
--  NOTIFY GUN DROPPED
-- ============================================================
do
    Modules.Config.NotifyGunDropped=false
    local _notifyConn=nil
    local _lastNotified=nil
    local function notifyGun(gunPart)
        if not gunPart or not gunPart.Parent then return end
        if _lastNotified==gunPart then return end
        _lastNotified=gunPart
        pcall(function()
            if WindUI and typeof(WindUI.Notify)=='function' then
                WindUI:Notify({
                    Title='Gun Dropped',
                    Content='A gun has been dropped in the map.',
                    Icon='crosshair',
                    Duration=5,
                    TitleColor=Color3.fromRGB(123,47,190),
                    ContentColor=Color3.fromRGB(220,200,255),
                    IconColor=Color3.fromRGB(180,100,255),
                    BackgroundColor=Color3.fromHex('#030407'),
                    ProgressBarColor=Color3.fromRGB(123,47,190),
                    CloseButtonColor=Color3.fromRGB(123,47,190),
                })
            end
        end)
    end
    local function findExistingGun()
        local map=getMap(); if not map then return nil end
        local g=map:FindFirstChild('GunDrop',true)
        if g and g:IsA('BasePart') then return g end
        return nil
    end
    function Modules.ToggleNotifyGunDropped(enable)
        Modules.Config.NotifyGunDropped=enable
        if _notifyConn then _notifyConn:Disconnect(); _notifyConn=nil end
        _lastNotified=nil
        if not enable then return end
        pcall(function() local existing=findExistingGun(); if existing then notifyGun(existing) end end)
        _notifyConn=AddConnection(Workspace.DescendantAdded:Connect(function(desc)
            if not Modules.Config.NotifyGunDropped then return end
            if not desc or not desc.Parent then return end
            if desc.Name=='GunDrop' and desc:IsA('BasePart') then notifyGun(desc) end
        end))
        task.spawn(function()
            while Modules.Config.NotifyGunDropped do
                pcall(function()
                    if _lastNotified and (not _lastNotified.Parent) then _lastNotified=nil end
                end)
                task.wait(1)
            end
        end)
    end
end
-- ============================================================
--  EMOTES / CHAT / THROW
-- ============================================================
do
    function Modules.PlayEmote(emoteName)
        local remotes=ReplicatedStorage:FindFirstChild('Remotes')
        if remotes and remotes:FindFirstChild('PlayEmote') then
            remotes.PlayEmote:Fire(emoteName)
        elseif ReplicatedStorage:FindFirstChild('PlayEmote',true) then
            ReplicatedStorage:FindFirstChild('PlayEmote',true):Fire(emoteName)
        end
    end
end
do
    local silentThrowConn=nil
    function Modules.ExecuteThrowAtNearest()
        local knife=Modules.Backpack:FindFirstChild('Knife') or (Modules.Character and Modules.Character:FindFirstChild('Knife'))
        if knife and knife.Parent==Modules.Backpack and Modules.Humanoid then
            Modules.Humanoid:EquipTool(knife); task.wait(0.1)
            knife=Modules.Character:FindFirstChild('Knife')
        end
        if not knife or not knife:FindFirstChild('Throw') then return end
        local myPos=Modules.RootPart.Position
        local target=nil; local dist=1000
        for _,v in ipairs(Players:GetPlayers()) do
            if v~=Modules.Player and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
                local h=v.Character:FindFirstChild('Humanoid')
                if h and h.Health>0 then
                    local root=v.Character.HumanoidRootPart
                    local mag=(myPos-root.Position).Magnitude
                    if mag<dist then dist=mag; target=root end
                end
            end
        end
        if target then
            local prediction=target.Position+(target.AssemblyLinearVelocity*0.05*(dist/100))
            local throwCFrame=CFrame.new(myPos,prediction)
            knife.Throw:FireServer(throwCFrame,prediction)
        end
    end
    function Modules.ToggleSilentThrow(enable)
        Modules.Config.SilentThrow=enable
        if silentThrowConn then pcall(task.cancel,silentThrowConn); silentThrowConn=nil end
        if enable then
            silentThrowConn=task.spawn(function()
                while Modules.Config.SilentThrow do
                    local isMurderer=Modules.FindMurderer()==Modules.Player
                    if isMurderer then Modules.ExecuteThrowAtNearest() end
                    task.wait(0.8)
                end
            end)
        end
    end
end
function Modules.ChatRoles()
    local murderer=Modules.FindMurderer()
    local sheriff=Modules.FindSheriff()
    local mName=murderer and murderer.Name or 'Unknown'
    local sName=sheriff and sheriff.Name or 'Unknown'
    local msg='QuantomHub >> Murderer: '..mName..' | Sheriff: '..sName
    if TextChatService.ChatVersion==Enum.ChatVersion.TextChatService then
        local chan=TextChatService:FindFirstChild('TextChannels')
        if chan and chan:FindFirstChild('RBXGeneral') then chan.RBXGeneral:SendAsync(msg) end
    else
        local es=ReplicatedStorage:FindFirstChild('DefaultChatSystemChatEvents')
        if es and es:FindFirstChild('SayMessageRequest') then es.SayMessageRequest:FireServer(msg,'Normal') end
    end
end
-- ============================================================
--  ROUND TIMER
-- ============================================================
do
    local timerConn=nil; local timerGui=nil
    local function secondsToMinutes(seconds)
        if not seconds or seconds==-1 then return '' end
        local minutes=math.floor(seconds/60)
        local remainingSeconds=seconds%60
        return string.format('%dm %ds',minutes,remainingSeconds)
    end
    function Modules.ToggleRoundTimer(enable)
        Modules.Config.RoundTimer=enable
        if timerGui then timerGui:Destroy(); timerGui=nil end
        if timerConn then pcall(task.cancel,timerConn); timerConn=nil end
        if not enable then return end
        timerGui=Instance.new('ScreenGui')
        timerGui.Name='VisionTimerGUI'; timerGui.ResetOnSpawn=false
        timerGui.IgnoreGuiInset=true; timerGui.Parent=CoreGui
        local label=Instance.new('TextLabel')
        label.Size=UDim2.fromOffset(200,50); label.Position=UDim2.fromScale(0.5,0.15)
        label.AnchorPoint=Vector2.new(0.5,0.5); label.BackgroundTransparency=1
        label.Font=Enum.Font.GothamBold; label.TextScaled=true
        label.TextColor3=Color3.fromRGB(220,200,255)
        label.TextStrokeColor3=Color3.fromHex('#000000'); label.TextStrokeTransparency=0
        label.Text='Loading...'; label.Parent=timerGui
        timerConn=task.spawn(function()
            while timerGui and timerGui.Parent do
                local ok,timeLeft=pcall(function()
                    return game.ReplicatedStorage.Remotes.Extras.GetTimer:InvokeServer()
                end)
                if ok then label.Text=secondsToMinutes(timeLeft)
                else label.Text='—' end
                task.wait(0.5)
            end
        end)
    end
end
-- ============================================================
--  ROLE NOTIFICATIONS
-- ============================================================
do
    local roleMonitorTask=nil
    local notifiedMurd=false; local notifiedSher=false
    local function loopRoleMonitor()
        while true do
            local ok,seconds=pcall(function()
                return game.ReplicatedStorage.Remotes.Extras.GetTimer:InvokeServer()
            end)
            if not ok or (type(seconds)=='number' and seconds<=1) then
                notifiedMurd=false; notifiedSher=false
            elseif ok and type(seconds)=='number' and seconds>1 then
                if Modules.Config.NotifyMurderer and not notifiedMurd then
                    local p=Modules.FindMurderer()
                    if p then
                        notifiedMurd=true
                        pcall(function()
                            WindUI:Notify({
                                Title='Murderer Detected!', Content=p.Name,
                                Icon='rbxthumb://type=AvatarHeadShot&id='..p.UserId..'&w=150&h=150',
                                Duration=8,
                                TitleColor=Color3.fromRGB(255,60,60),
                                IconColor=Color3.fromRGB(255,255,255),
                                BackgroundColor=Color3.fromHex('#030407'),
                                CloseButtonColor=Color3.fromRGB(123,47,190),
                            })
                        end)
                    end
                end
                if Modules.Config.NotifySheriff and not notifiedSher then
                    local p=Modules.FindSheriff()
                    if p then
                        notifiedSher=true
                        pcall(function()
                            WindUI:Notify({
                                Title='Sheriff Detected!', Content=p.Name,
                                Icon='rbxthumb://type=AvatarHeadShot&id='..p.UserId..'&w=150&h=150',
                                Duration=8,
                                TitleColor=Color3.fromRGB(123,47,190),
                                IconColor=Color3.fromRGB(255,255,255),
                                BackgroundColor=Color3.fromHex('#030407'),
                                CloseButtonColor=Color3.fromRGB(123,47,190),
                            })
                        end)
                    end
                end
            end
            task.wait(1)
        end
    end
    function Modules.UpdateRoleNotify()
        if roleMonitorTask then pcall(task.cancel,roleMonitorTask); roleMonitorTask=nil end
        if Modules.Config.NotifyMurderer or Modules.Config.NotifySheriff then
            roleMonitorTask=task.spawn(loopRoleMonitor)
        end
    end
end
-- ============================================================
--  MOBILE BUTTONS
-- ============================================================
do
    function Modules.CreateGuiButton(id,settings,callback)
        if Modules.MobileButtons[id] then
            if Modules.MobileButtons[id].Parent then Modules.MobileButtons[id]:Destroy() end
            Modules.MobileButtons[id]=nil
        end
        if not settings.Enabled then return end
        local screenGui=Instance.new('ScreenGui')
        screenGui.Name='VisionBtn_'..id; screenGui.Parent=CoreGui
        screenGui.ResetOnSpawn=false; screenGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
        Modules.MobileButtons[id]=screenGui
        local buttonCount=0
        for _,gui in pairs(Modules.MobileButtons) do
            if gui and gui.Parent then buttonCount=buttonCount+1 end
        end
        local btn=nil
        if settings.Type=='Text' then
            btn=Instance.new('TextButton')
            btn.Text=settings.Text or id
            btn.TextColor3=settings.TextColor or Color3.new(1,1,1)
            btn.TextScaled=true; btn.Font=Enum.Font.GothamBold
        else
            btn=Instance.new('ImageButton')
            btn.Image=settings.Icon or ''
            btn.ImageColor3=settings.ImageColor or Color3.fromRGB(220,200,255)
        end
        btn.Name='ActionBtn'; btn.Size=UDim2.fromOffset(60,60)
        local initialY=0.45+(buttonCount*0.08)
        if initialY>0.8 then initialY=0.45 end
        btn.Position=UDim2.new(0.9,-20,initialY,0)
        btn.BackgroundColor3=Color3.fromRGB(20,8,35)
        btn.BackgroundTransparency=0.3; btn.AutoButtonColor=true; btn.Parent=screenGui
        local uiCorner=Instance.new('UICorner'); uiCorner.CornerRadius=UDim.new(1,0); uiCorner.Parent=btn
        local stroke=Instance.new('UIStroke')
        stroke.Color=Color3.fromRGB(123,47,190); stroke.Thickness=2.5
        stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; stroke.Parent=btn
        local dragging=false; local dragStart; local startPos; local hasMoved=false
        btn.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; hasMoved=false; dragStart=input.Position; startPos=btn.Position
            end
        end)
        btn.InputChanged:Connect(function(input)
            if (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) and dragging then
                if Modules.Config.ButtonsLocked then return end
                local delta=input.Position-dragStart
                if delta.Magnitude>3 then hasMoved=true end
                btn.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=false
                if not hasMoved or Modules.Config.ButtonsLocked then
                    if callback then
                        local originalColor=stroke.Color
                        stroke.Color=Color3.new(1,1,1)
                        task.spawn(callback)
                        task.delay(0.15,function()
                            if stroke and stroke.Parent then stroke.Color=originalColor end
                        end)
                    end
                end
            end
        end)
    end
end
-- ============================================================
--  WIND UI THEME — PURPLE
-- ============================================================
WindUI:AddTheme({
    Name       = 'QuantomPurple',
    Accent     = Color3.fromRGB(123,47,190),
    Dialog     = Color3.fromRGB(12,5,22),
    Outline    = Color3.fromRGB(180,130,255),
    Text       = Color3.fromRGB(220,200,255),
    Placeholder= Color3.fromRGB(90,70,120),
    Background = Color3.fromRGB(8,4,16),
    Button     = Color3.fromRGB(20,8,35),
    Icon       = Color3.fromRGB(180,100,255),
})
-- ============================================================
--  WINDOW CREATE
-- ============================================================
local Window=WindUI:CreateWindow({
    Title     = 'QuantomHub',
    Author    = 'by QuantomTeam',
    Folder    = 'QuantomHub',
    Theme     = 'QuantomPurple',
    Icon      = 'https://raw.githubusercontent.com/so1vexis/opn-src/refs/heads/main/quantom_logo.png',
    IconSize  = 50,
    NewElements=true,
    OpenButton={
        Title         = 'QuantomHub',
        CornerRadius  = UDim.new(1,0),
        StrokeThickness=3,
        Enabled       = true,
        Draggable     = true,
        OnlyMobile    = true,
        Color         = ColorSequence.new(Color3.fromRGB(123,47,190),Color3.fromRGB(180,100,255)),
    },
})
Window.ConfigManager:CreateConfig('Default')
-- ============================================================
--  TABS — all registered BEFORE Window:Init()
-- ============================================================
local Main      = Window:Tab({Title='Home',      Icon='house'               })
local Movement  = Window:Tab({Title='Movement',  Icon='footprints'          })
local Combat    = Window:Tab({Title='Combat',    Icon='swords'              })
local Visuals   = Window:Tab({Title='Visuals',   Icon='eye'                 })
local Buttons   = Window:Tab({Title='Buttons',   Icon='square-mouse-pointer'})
local Teleports = Window:Tab({Title='Teleports', Icon='map-pin'             })
local Misc      = Window:Tab({Title='Misc',      Icon='box'                 })
local Farming   = Window:Tab({Title='Farming',   Icon='dollar-sign'         })
local Settings  = Window:Tab({Title='Settings',  Icon='settings'            })
-- ============================================================
--  MAIN TAB
-- ============================================================
Main:Paragraph({
    Title     = 'Welcome to QuantomHub!',
    Desc      = 'The unified MM2 script. Key: '..validatedKey..' | Expires: '..keyExpiry(validatedKey),
    Thumbnail = 'https://raw.githubusercontent.com/so1vexis/opn-src/refs/heads/main/quantom_logo.png',
    ThumbnailSize=140,
    Buttons   = {
        {
            Title    = 'Join Discord',
            Icon     = 'geist:logo-discord',
            Callback = function()
                if setclipboard then
                    setclipboard('https://discord.gg/TZHgrMUKGJ')
                    Window:Dialog({
                        Title   = 'Discord Link Copied',
                        Icon    = 'geist:logo-discord',
                        Content = 'Invite link copied to clipboard.',
                        Buttons = {{Title='OK',Icon='check'}},
                    })
                end
            end,
        },
    },
})
Main:Space()
Main:Code({
    Title = 'Changelog v3.0',
    Code  = [[[QuantomHub v3.0]
+ Unified script — VisionHub 1.8.0 + NightHub Spawner + KitagawaHub Wallbang
+ Key system with 4-day Femboy key and lifetime Quant key
+ Key saved to disk — no re-entry needed on next load
+ Purple theme throughout
+ Webhook on launch with executor and key info
+ Wallbang added to Combat > Sheriff section
+ Item Spawner added to Farming section
+ Main tab toggle bug fixed — re-opens correctly
+ All "KitagawaHub" / "VisionHub" → "QuantomHub"
+ Blue accent colors → purple throughout UI
]],
})
Main:Space()
Main:Label({Title='Key Info', Desc='Key: '..validatedKey..' | '..keyExpiry(validatedKey)})
Main:Label({Title='Executor', Desc=EXECUTOR})
-- ============================================================
--  MOVEMENT TAB
-- ============================================================
do
    local CharacterSection=Movement:Section({
        Title='Movement', Desc="Modify your character's movement",
        Icon='footprints', TextXAlignment='Center', Opened=true,
    })
    CharacterSection:Toggle({Title='Enable WalkSpeed', Desc='Allow custom WalkSpeed', Flag='EnableWalkspeedToggle', Callback=Modules.EnableWalkSpeed})
    CharacterSection:Slider({Title='WalkSpeed', Desc='Set your WalkSpeed', Flag='WalkspeedSlider',
        Value={Min=16,Max=200,Default=Modules.Config.WalkSpeed}, Callback=Modules.SetWalkSpeed})
    CharacterSection:Space()
    CharacterSection:Toggle({Title='Enable JumpPower', Desc='Allow custom JumpPower', Flag='EnableJumppowerToggle', Callback=Modules.EnableJumpPower})
    CharacterSection:Slider({Title='Jump Power', Desc='Set your JumpPower', Flag='JumppowerSlider',
        Value={Min=50,Max=300,Default=Modules.Config.JumpPower}, Callback=Modules.SetJumpPower})
    CharacterSection:Space()
    CharacterSection:Toggle({Title='Enable Noclip', Desc='Walk through walls', Flag='NoclipToggle', Callback=Modules.EnableNoclip})
    CharacterSection:Toggle({Title='Infinite Jump', Desc='Jump infinitely', Flag='InfiniteJumpToggle', Callback=Modules.InfiniteJump})
    CharacterSection:Button({
        Title='Reset Character', Desc='Respawn your character', Icon='refresh-cw',
        Callback=function() if Modules.Character then Modules.Character:BreakJoints() end end,
    })
end
-- ============================================================
--  COMBAT TAB
-- ============================================================
do
    local CombatSection=Combat:MultiSection({
        Title='Combat', Subtitle='Enhance your combat abilities',
        TextXAlignment='Center', Icon='swords',
        Sections={{'General','backpack'},{'Murderer','skull'},{'Sheriff','shield'}},
    })
    -- GENERAL
    CombatSection.General:ButtonKeybind({Title='Grab Gun', Desc='Picks up gun from the map', Key='G', Flag='GrabGunKeybind', Icon='hand', Callback=Modules.GrabGun})
    CombatSection.General:Toggle({Title='Auto Grab Gun', Desc='Automatically grab gun', Flag='AutoGrabGunToggle', Callback=Modules.ToggleAutoGrabGun})
    CombatSection.General:Space()
    CombatSection.General:Toggle({Title='God Mode', Desc='Grants an extra life', Flag='GodModeToggle', Callback=function(e) Modules.EnableGodMode(e) end})
    CombatSection.General:Toggle({Title='Anti-Fling', Desc='Prevents players from flinging you', Flag='AntiFlingToggle', Callback=Modules.ToggleAntiFling})
    -- MURDERER
    CombatSection.Murderer:ButtonKeybind({Title='Kill All', Desc='Kill all players', Key='K', Icon='skull', Callback=Modules.KillAll})
    CombatSection.Murderer:Toggle({Title='Auto Kill All', Desc='Automatically kill players', Flag='AutoKillToggle', Callback=function(s) Modules.ToggleAutoKillAll(s) end})
    CombatSection.Murderer:Space()
    CombatSection.Murderer:Toggle({Title='Knife Aura', Desc='Kill players within radius', Flag='KillAuraToggle', Callback=function(e) Modules.KillAura(e) end})
    CombatSection.Murderer:Slider({Title='Knife Aura Radius', Desc='Sets the detection radius', Flag='AuraRadiusSlider',
        Value={Min=5,Max=100,Default=Modules.Config.AuraRadius}, Callback=function(v) Modules.Config.AuraRadius=v end})
    CombatSection.Murderer:Space()
    CombatSection.Murderer:Toggle({Title='Auto Knife Throw', Desc='Automatically throws knife at nearest', Flag='ThrowKnifeFlag', Callback=function(e) Modules.ToggleSilentThrow(e) end})
    CombatSection.Murderer:ButtonKeybind({Title='Throw Knife', Desc='Throws knife at nearest player', Icon='crosshair', Key='Q', Callback=function() Modules.ExecuteThrowAtNearest() end})
    -- SHERIFF
    CombatSection.Sheriff:Toggle({Title='Auto Shoot Murderer', Desc='Automatically shoots the murderer', Flag='AutoShootMurderer', Callback=function(s) Modules.ToggleAutoShootMurderer(s) end})
    CombatSection.Sheriff:ButtonKeybind({Title='Shoot Murderer', Desc='Press to shoot murderer', Icon='crosshair', Key='E', Callback=function() Modules.ShootMurdererOnce() end})
    CombatSection.Sheriff:Space()
    CombatSection.Sheriff:Toggle({
        Title='Wallbang',
        Desc='Shoot through walls — no LOS check (KitagawaHub)',
        Flag='WallbangToggle',
        Callback=function(s) Modules.ToggleWallbang(s) end,
    })
    CombatSection.Sheriff:ButtonKeybind({
        Title='Wallbang Once',
        Desc='Fire wallbang shot once',
        Icon='zap',
        Key='R',
        Callback=function() Modules.ShootWallbang() end,
    })
end
-- ============================================================
--  VISUALS TAB
-- ============================================================
do
    local ESP_Folder=CoreGui:FindFirstChild('VisionESP')
    if not ESP_Folder then
        ESP_Folder=Instance.new('Folder'); ESP_Folder.Name='VisionESP'; ESP_Folder.Parent=CoreGui
    end
    local function CreateBillboard(targetHead)
        local bg=Instance.new('BillboardGui')
        bg.Name='NameESP'; bg.Adornee=targetHead
        bg.Size=UDim2.new(0,200,0,50); bg.StudsOffset=Vector3.new(0,3,0); bg.AlwaysOnTop=true
        local text=Instance.new('TextLabel')
        text.BackgroundTransparency=1; text.Size=UDim2.new(1,0,1,0)
        text.TextSize=16; text.TextScaled=false; text.Font=Enum.Font.SourceSansBold
        text.TextColor3=Color3.new(1,1,1); text.TextStrokeTransparency=0
        text.TextStrokeColor3=Color3.new(0,0,0); text.Parent=bg
        return bg
    end
    local function UpdateESPState()
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=Modules.Player and plr.Character then
                local espColor=Color3.fromRGB(0,255,0); local espRole='Innocent'
                local isMurderer=(Modules.FindMurderer()==plr)
                local isSheriff=(Modules.FindSheriff()==plr)
                if Modules.PlayerData[plr.Name] then
                    local data=Modules.PlayerData[plr.Name]
                    if data.Role=='Hero' then espColor=Color3.fromRGB(255,255,0); espRole='Hero' end
                end
                if isMurderer then espColor=Color3.fromRGB(255,0,0); espRole='Murderer'
                elseif isSheriff then espColor=Color3.fromRGB(123,47,190); espRole='Sheriff' end
                local char=plr.Character
                if Modules.Config.EspPlayers then
                    if not char:FindFirstChild('VisionHighlight') then
                        local hl=Instance.new('Highlight')
                        hl.Name='VisionHighlight'; hl.FillTransparency=0.85; hl.OutlineTransparency=0; hl.Parent=char
                    end
                    local hl=char:FindFirstChild('VisionHighlight')
                    if hl then hl.FillColor=espColor; hl.OutlineColor=espColor; hl.Enabled=true end
                else
                    if char:FindFirstChild('VisionHighlight') then char.VisionHighlight:Destroy() end
                end
                if Modules.Config.ShowNames then
                    local head=char:FindFirstChild('Head')
                    if head then
                        if not head:FindFirstChild('NameESP') then
                            local bg=CreateBillboard(head); bg.Parent=head
                        end
                        local bg=head:FindFirstChild('NameESP')
                        local label=bg and bg:FindFirstChild('TextLabel')
                        local root=Modules.RootPart
                        local enemyRoot=char:FindFirstChild('HumanoidRootPart') or char.PrimaryPart
                        local dist='Unknown'
                        if root and enemyRoot then dist=math.floor((root.Position-enemyRoot.Position).Magnitude) end
                        if label then
                            label.Text=string.format('%s\n[%s] [%s]',plr.Name,espRole,tostring(dist))
                            label.TextColor3=espColor
                        end
                    end
                else
                    if char:FindFirstChild('Head') and char.Head:FindFirstChild('NameESP') then char.Head.NameESP:Destroy() end
                end
            end
        end
    end
    local espLoop=nil
    local function ToggleESP_System(enabled)
        if enabled then
            if not espLoop then espLoop=AddConnection(RunService.RenderStepped:Connect(UpdateESPState)) end
        else
            if not Modules.Config.EspPlayers and not Modules.Config.ShowNames then
                if espLoop then espLoop:Disconnect(); espLoop=nil end
                for _,p in ipairs(Players:GetPlayers()) do
                    if p.Character then
                        if p.Character:FindFirstChild('VisionHighlight') then p.Character.VisionHighlight:Destroy() end
                        if p.Character:FindFirstChild('Head') and p.Character.Head:FindFirstChild('NameESP') then p.Character.Head.NameESP:Destroy() end
                    end
                end
            end
        end
    end
    local gunESPConnection=nil
    local function RemoveGunESP()
        for _,obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name=='GunDrop' then
                if obj:FindFirstChild('VisionGunHighlight') then obj.VisionGunHighlight:Destroy() end
                if obj:FindFirstChild('VisionGunLabel') then obj.VisionGunLabel:Destroy() end
            end
        end
    end
    local function AddGunESP(gun)
        if not gun or not gun:IsA('BasePart') then return end
        if gun:FindFirstChild('VisionGunHighlight') then gun.VisionGunHighlight:Destroy() end
        if gun:FindFirstChild('VisionGunLabel') then gun.VisionGunLabel:Destroy() end
        local hl=Instance.new('Highlight')
        hl.Name='VisionGunHighlight'; hl.Adornee=gun
        hl.FillColor=Color3.fromRGB(180,100,255); hl.OutlineColor=Color3.fromRGB(255,255,255)
        hl.FillTransparency=0.5; hl.OutlineTransparency=0; hl.Parent=gun
        local bg=Instance.new('BillboardGui')
        bg.Name='VisionGunLabel'; bg.Adornee=gun
        bg.Size=UDim2.new(0,150,0,50); bg.StudsOffset=Vector3.new(0,2,0); bg.AlwaysOnTop=true
        local text=Instance.new('TextLabel')
        text.BackgroundTransparency=1; text.Size=UDim2.new(1,0,1,0)
        text.TextSize=14; text.Font=Enum.Font.GothamBold
        text.Text='DROPPED GUN'
        text.TextColor3=Color3.fromRGB(180,100,255)
        text.TextStrokeTransparency=0; text.TextStrokeColor3=Color3.new(0,0,0)
        text.Parent=bg; bg.Parent=gun
    end
    function Modules.ToggleGunESP(enable)
        Modules.Config.EspDroppedGun=enable
        if gunESPConnection then gunESPConnection:Disconnect(); gunESPConnection=nil end
        if enable then
            for _,v in ipairs(Workspace:GetDescendants()) do if v.Name=='GunDrop' then AddGunESP(v) end end
            gunESPConnection=AddConnection(Workspace.DescendantAdded:Connect(function(v)
                if v.Name=='GunDrop' then task.wait(); AddGunESP(v) end
            end))
        else RemoveGunESP() end
    end
    local VisualsSection=Visuals:MultiSection({
        Title='Visuals', Subtitle='Enhance your in-game vision',
        TextXAlignment='Center', Icon='eye',
        Sections={{'ESP','eye'},{'Notify','bell'}},
    })
    VisualsSection.ESP:Toggle({Title='ESP Players', Desc='Highlight players in round', Flag='EspToggle',
        Callback=function(s) Modules.Config.EspPlayers=s; ToggleESP_System(s or Modules.Config.ShowNames) end})
    VisualsSection.ESP:Toggle({Title='Show Informations', Desc='Show name, role and distance', Flag='ShowNamesToggle',
        Callback=function(s) Modules.Config.ShowNames=s; ToggleESP_System(s or Modules.Config.EspPlayers) end})
    VisualsSection.ESP:Toggle({Title='ESP Dropped Gun', Desc='Highlights gun when dropped', Flag='EspGunToggle',
        Callback=function(s) Modules.ToggleGunESP(s) end})
    VisualsSection.ESP:Space()
    VisualsSection.ESP:Toggle({Title='Round Timer', Desc='Displays the round timer', Flag='RoundTimerToggle',
        Callback=function(s) Modules.ToggleRoundTimer(s) end})
    VisualsSection.Notify:Toggle({Title='Notify Gun Dropped', Desc='Get notified when gun drops', Flag='NotifyGunDroppedToggle',
        Callback=function(s) Modules.ToggleNotifyGunDropped(s) end})
    VisualsSection.Notify:Toggle({Title='Notify Murderer', Desc='Alert when Murderer spawns', Flag='NotifyMurdererToggle',
        Callback=function(s) Modules.Config.NotifyMurderer=s; Modules.UpdateRoleNotify() end})
    VisualsSection.Notify:Toggle({Title='Notify Sheriff', Desc='Alert when Sheriff spawns', Flag='NotifySheriffToggle',
        Callback=function(s) Modules.Config.NotifySheriff=s; Modules.UpdateRoleNotify() end})
end
-- ============================================================
--  BUTTONS TAB
-- ============================================================
do
    local buttonsSection=Buttons:Section({Title='Buttons', Subtitle='Customize action buttons', Opened=true, TextXAlignment='Center', Icon='square-mouse-pointer'})
    buttonsSection:Toggle({Title='Lock Buttons', Desc='Lock mobile button positions.', Flag='lock_buttons', Callback=function(l) Modules.Config.ButtonsLocked=l end})
    buttonsSection:Space()
    buttonsSection:Toggle({Title='Show Shoot Button', Desc='Adds shoot image button.', Flag='show_shoot_button',
        Callback=function(e) Modules.CreateGuiButton('Shoot',{Enabled=e,Type='Image',Icon='rbxassetid://139650104834071'},Modules.ShootMurdererOnce) end})
    buttonsSection:Space()
    buttonsSection:Toggle({Title='Fling Murderer Button', Desc='Fling the murderer.', Flag='show_fmurderer_button',
        Callback=function(e) Modules.CreateGuiButton('FlingMurderer',{Enabled=e,Type='Text',Text='Fling Murderer',TextColor=Color3.fromRGB(255,255,255)},function()
            local m=Modules.FindMurderer(); if m and m.Character then SkidFling(m) end
        end) end})
    buttonsSection:Toggle({Title='Fling Sheriff Button', Desc='Fling the sheriff.', Flag='show_fsheriff_button',
        Callback=function(e) Modules.CreateGuiButton('FlingSheriff',{Enabled=e,Type='Text',Text='Fling Sheriff',TextColor=Color3.fromRGB(255,255,255)},function()
            local s=Modules.FindSheriff(); if s and s.Character then SkidFling(s) end
        end) end})
    buttonsSection:Toggle({Title='Fling Hero Button', Desc='Fling the Hero.', Flag='show_fhero_button',
        Callback=function(e) Modules.CreateGuiButton('FlingHero',{Enabled=e,Type='Text',Text='Fling Hero',TextColor=Color3.fromRGB(255,255,255)},function()
            if Modules.PlayerData then
                for name,data in pairs(Modules.PlayerData) do
                    if data and (data.Role=='Hero' or data.role=='Hero') then
                        local pl=Players:FindFirstChild(name); if pl and pl.Character then SkidFling(pl); return end
                    end
                end
            end
        end) end})
    buttonsSection:Space()
    buttonsSection:Toggle({Title='Show Kill Button', Desc='Adds Kill All button.', Flag='show_kill_button',
        Callback=function(e) Modules.CreateGuiButton('Kill',{Enabled=e,Type='Text',Text='Kill All',TextColor=Color3.fromRGB(255,255,255)},Modules.KillAll) end})
    buttonsSection:Toggle({Title='Show Throw Knife Button', Desc='Throw knife at nearest.', Flag='show_throw_knife_button',
        Callback=function(e) Modules.CreateGuiButton('ThrowKnife',{Enabled=e,Type='Text',Text='Throw Knife'},Modules.ExecuteThrowAtNearest) end})
    buttonsSection:Space()
    buttonsSection:Toggle({Title='Show Grab Gun Button', Desc='Grab or pick up a gun.', Flag='show_grab_gun_button',
        Callback=function(e) Modules.CreateGuiButton('GrabGun',{Enabled=e,Type='Text',Text='Grab Gun'},Modules.GrabGun) end})
    buttonsSection:Space()
    buttonsSection:Toggle({Title='Show Teleport Map Button', Desc='Teleport to current map.', Flag='show_teleport_button',
        Callback=function(e) Modules.CreateGuiButton('Teleport',{Enabled=e,Type='Text',Text='Teleport to Map'},Modules.TeleportToMap) end})
    buttonsSection:Toggle({Title='Show Teleport Lobby Button', Desc='Teleport back to lobby.', Flag='show_teleport_lobby_button',
        Callback=function(e) Modules.CreateGuiButton('TeleportLobby',{Enabled=e,Type='Text',Text='Teleport to Lobby'},Modules.TeleportToLobby) end})
    buttonsSection:Space()
    buttonsSection:Toggle({Title='Wallbang Button', Desc='Fire wallbang shot on tap.', Flag='show_wallbang_button',
        Callback=function(e) Modules.CreateGuiButton('Wallbang',{Enabled=e,Type='Text',Text='Wallbang',TextColor=Color3.fromRGB(255,255,255)},function() Modules.ShootWallbang() end) end})
    buttonsSection:Toggle({Title='Spawn Item Button', Desc='Spawn selected item on tap.', Flag='show_spawn_button',
        Callback=function(e) Modules.CreateGuiButton('SpawnItem',{Enabled=e,Type='Text',Text='Spawn '..Modules.Config.SpawnerItem},function() Modules.SpawnItemOnce() end) end})
end
-- ============================================================
--  TELEPORTS TAB
-- ============================================================
do
    local TeleportsSection=Teleports:MultiSection({
        Title='Teleports', Subtitle='Player and world teleports',
        TextXAlignment='Center', Icon='map-pin',
        Sections={{'Players','user'},{'Roles','crown'},{'Locations','map-pin'}},
    })
    local selectedPlayer=nil
    local playerDropdown=TeleportsSection.Players:Dropdown({
        Title='Select Player', Desc='Choose a player to teleport to',
        Callback=function(option) selectedPlayer=Modules.GetPlayerByName(option.Title) end,
    })
    local function refreshPlayerList()
        local items={}
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=Modules.Player then table.insert(items,{Title=p.Name,Icon='rbxthumb://type=AvatarHeadShot&id='..p.UserId..'&w=150&h=150'}) end
        end
        playerDropdown:Refresh(items)
    end
    refreshPlayerList()
    AddConnection(Players.PlayerAdded:Connect(refreshPlayerList))
    AddConnection(Players.PlayerRemoving:Connect(refreshPlayerList))
    TeleportsSection.Players:Button({Title='Teleport to Player', Desc='Teleport to selected player', Icon='arrow-right',
        Callback=function() if selectedPlayer then Modules.TeleportToPlayer(selectedPlayer) end end})
    TeleportsSection.Roles:Button({Title='Teleport to Murderer', Desc='Teleport to the murderer', Icon='skull',
        Callback=function() local m=Modules.FindMurderer(); if m then Modules.TeleportToPlayer(m) end end})
    TeleportsSection.Roles:Button({Title='Teleport to Sheriff', Desc='Teleport to the sheriff', Icon='shield',
        Callback=function() local s=Modules.FindSheriff(); if s then Modules.TeleportToPlayer(s) end end})
    TeleportsSection.Roles:Button({Title='Teleport to Hero', Desc='Teleport to the hero', Icon='star',
        Callback=function()
            if Modules.PlayerData then
                for name,data in pairs(Modules.PlayerData) do
                    if data and (data.Role=='Hero' or data.role=='Hero') then
                        local pl=Players:FindFirstChild(name); if pl then Modules.TeleportToPlayer(pl); return end
                    end
                end
            end
        end})
    TeleportsSection.Locations:Button({Title='Lobby', Desc='Return to main lobby', Icon='house', Callback=Modules.TeleportToLobby})
    TeleportsSection.Locations:Button({Title='Teleport to Map', Desc='Teleports to current map', Icon='map', Callback=Modules.TeleportToMap})
end
-- ============================================================
--  MISC TAB
-- ============================================================
do
    local MiscSection=Misc:MultiSection({
        Title='Miscellaneous', Icon='box', Subtitle='Various fun features',
        TextXAlignment='Center',
        Sections={{'Fling','wind'},{'Emotes','smile'},{'Chat','message-square'}},
    })
    local selectedFlingPlayer=nil
    local flingDropdown=MiscSection.Fling:Dropdown({
        Title='Select Player', Desc='Choose a player',
        Callback=function(option) selectedFlingPlayer=Players:FindFirstChild(option.Title) end,
    })
    local function updateDropdown()
        local items={}
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=Modules.Player then table.insert(items,{Title=p.Name,Icon='rbxthumb://type=AvatarHeadShot&id='..p.UserId..'&w=150&h=150'}) end
        end
        flingDropdown:Refresh(items)
    end
    updateDropdown()
    AddConnection(Players.PlayerAdded:Connect(updateDropdown))
    AddConnection(Players.PlayerRemoving:Connect(updateDropdown))
    MiscSection.Fling:Button({Title='Fling Player', Desc='Fling selected player', Icon='wind',
        Callback=function() if selectedFlingPlayer and selectedFlingPlayer.Character then SkidFling(selectedFlingPlayer) end end})
    MiscSection.Fling:Button({Title='Fling All Players', Desc='Fling all players', Icon='wind',
        Callback=function()
            for _,p in ipairs(Players:GetPlayers()) do if p~=Modules.Player and p.Character then SkidFling(p) end end
        end})
    MiscSection.Fling:Space()
    MiscSection.Fling:Button({Title='Fling Murderer', Desc='Fling the murderer', Icon='skull',
        Callback=function() local m=Modules.FindMurderer(); if m and m.Character then SkidFling(m) end end})
    MiscSection.Fling:Button({Title='Fling Sheriff', Desc='Fling the sheriff', Icon='shield',
        Callback=function() local s=Modules.FindSheriff(); if s and s.Character then SkidFling(s) end end})
    MiscSection.Fling:Button({Title='Fling Hero', Desc='Fling the hero', Icon='star',
        Callback=function()
            if Modules.PlayerData then
                for name,data in pairs(Modules.PlayerData) do
                    if data and (data.Role=='Hero' or data.role=='Hero') then
                        local pl=Players:FindFirstChild(name); if pl and pl.Character then SkidFling(pl); return end
                    end
                end
            end
        end})
    local selectedEmote=nil
    MiscSection.Emotes:Dropdown({Title='Select Emote', Desc='Choose an emote', Flag='EmoteSelectDropdown',
        Values={'sit','zombie','ninja','zen','floss','dab'},
        Callback=function(v) selectedEmote=v end})
    MiscSection.Emotes:Button({Title='Play Emote', Desc='Plays the selected emote', Icon='play',
        Callback=function() if selectedEmote then Modules.PlayEmote(selectedEmote) end end})
    MiscSection.Chat:Button({Title='Expose Roles in Chat', Desc='Says Murderer/Sheriff name in chat', Icon='message-circle', Callback=Modules.ChatRoles})
end
-- ============================================================
--  FARMING TAB  (Coin Farm + Item Spawner from NightHub)
-- ============================================================
do
    local FarmingSection=Farming:Section({
        Title='Farming', Desc='Automate gameplay for rewards',
        Icon='dollar-sign', TextXAlignment='Center',
    })
    -- Coin autofarm
    local coinFarmConn=nil
    FarmingSection:Toggle({
        Title='Coin Autofarm',
        Desc='Teleport to nearest coin each Heartbeat',
        Flag='CoinAutofarmToggle',
        Callback=function(v)
            if coinFarmConn then coinFarmConn:Disconnect(); coinFarmConn=nil end
            if v then
                coinFarmConn=AddConnection(RunService.Heartbeat:Connect(function()
                    local hrp=Modules.RootPart; if not hrp then return end
                    local nearest,nearestDist=nil,math.huge
                    for _,obj in ipairs(Workspace:GetDescendants()) do
                        if obj.Name=='CoinContainer' or obj.Name=='Coin' or obj.Name=='coin' then
                            local pos
                            if obj:IsA('BasePart') then pos=obj.Position
                            elseif obj:IsA('Model') and obj.PrimaryPart then pos=obj.PrimaryPart.Position end
                            if pos then
                                local d=(hrp.Position-pos).Magnitude
                                if d<nearestDist then nearestDist=d; nearest=pos end
                            end
                        end
                    end
                    if nearest and nearestDist>2 then hrp.CFrame=CFrame.new(nearest+Vector3.new(0,2,0)) end
                end))
            end
        end,
    })
    FarmingSection:Space()
    -- Spawner section
    local SpawnerSection=Farming:Section({
        Title='Item Spawner',
        Desc='NightHub — spawn items via touch-trigger or tool clone',
        Icon='plus-circle',
        TextXAlignment='Center',
    })
    SpawnerSection:Dropdown({
        Title='Item to Spawn',
        Desc='Select which item to spawn',
        Flag='SpawnerItemDropdown',
        Values=Modules.SpawnableItems,
        Callback=function(v)
            Modules.Config.SpawnerItem=v
        end,
    })
    SpawnerSection:Slider({
        Title='Spawn Interval (s)',
        Desc='How often to auto-spawn (seconds)',
        Flag='SpawnerIntervalSlider',
        Value={Min=1,Max=10,Default=1},
        Callback=function(v)
            Modules.Config.SpawnerInterval=v
        end,
    })
    SpawnerSection:Toggle({
        Title='Auto Spawner',
        Desc='Continuously spawn selected item',
        Flag='AutoSpawnerToggle',
        Callback=function(v) Modules.ToggleSpawner(v) end,
    })
    SpawnerSection:Button({
        Title='Spawn Once',
        Desc='Spawn selected item once',
        Icon='plus',
        Callback=function() Modules.SpawnItemOnce() end,
    })
    SpawnerSection:Space()
    -- Auto-loot gun
    local autoLootConn=nil
    SpawnerSection:Toggle({
        Title='Auto-Loot Gun',
        Desc='Teleport to nearest dropped gun and collect',
        Flag='AutoLootGunToggle',
        Callback=function(v)
            if autoLootConn then autoLootConn:Disconnect(); autoLootConn=nil end
            if v then
                autoLootConn=AddConnection(RunService.Heartbeat:Connect(function()
                    local hrp=Modules.RootPart; local myChar=Modules.Character
                    if not hrp or not myChar then return end
                    for _,obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA('Tool') then
                            local n=obj.Name:lower()
                            if (n:find('gun') or n:find('revolver')) and obj.Parent~=myChar and obj.Parent~=Modules.Player.Backpack then
                                local handle=obj:FindFirstChild('Handle')
                                if handle and (hrp.Position-handle.Position).Magnitude<80 then
                                    hrp.CFrame=CFrame.new(handle.Position+Vector3.new(0,2,0))
                                end
                            end
                        end
                    end
                end))
            end
        end,
    })
end
-- ============================================================
--  SETTINGS TAB
-- ============================================================
do
    local SettingsSection=Settings:MultiSection({
        Title='Settings', Subtitle='Configure your preferences',
        TextXAlignment='Center', Icon='settings',
        Sections={{'Config','save'},{'Theme','paintbrush'}},
    })
    Settings:Space()
    SettingsSection.Config:Button({Title='Save Config', Desc='Saves your current settings', Icon='save',
        Callback=function()
            Window.CurrentConfig:Save()
            WindUI:Notify({
                Title='Saved', Content='Configuration saved!', Icon='save', Duration=5,
                TitleColor=Color3.fromRGB(123,47,190), ContentColor=Color3.fromRGB(220,200,255),
                IconColor=Color3.fromRGB(180,100,255), BackgroundColor=Color3.fromHex('#030407'),
                ProgressBarColor=Color3.fromRGB(123,47,190), CloseButtonColor=Color3.fromRGB(123,47,190),
            })
        end})
    SettingsSection.Config:Button({Title='Load Config', Desc='Loads saved settings', Icon='folder-open',
        Callback=function()
            Window.CurrentConfig:Load()
            WindUI:Notify({
                Title='Loaded', Content='Configuration loaded!', Icon='loader', Duration=5,
                TitleColor=Color3.fromRGB(123,47,190), ContentColor=Color3.fromRGB(220,200,255),
                IconColor=Color3.fromRGB(180,100,255), BackgroundColor=Color3.fromHex('#030407'),
                ProgressBarColor=Color3.fromRGB(123,47,190), CloseButtonColor=Color3.fromRGB(123,47,190),
            })
        end})
    SettingsSection.Theme:Keybind({Title='Toggle Keybind', Desc='Open/close the UI', Value='RightControl',
        Callback=function(v) Window:SetToggleKey(Enum.KeyCode[v]) end})
    SettingsSection.Theme:Toggle({Title='Transparency', Desc='Semi-transparent interface', Flag='UiTransparencyToggle', Value=false,
        Callback=function(s) Window:ToggleTransparency(s) end})
    local ServerSection=Settings:Section({Title='Server', Desc='Server related actions', Icon='server', TextXAlignment='Center', Opened=true})
    ServerSection:Button({Title='Rejoin Server', Desc='Rejoins the current server', Icon='refresh-cw',
        Callback=function()
            Window:Dialog({Title='Confirm Rejoin', Content='Rejoin this server?',
                Buttons={{Title='Cancel',Variant='Secondary'},{Title='Rejoin',Icon='check',Callback=Modules.Rejoin}}})
        end})
    ServerSection:Button({Title='Server Hop', Desc='Joins a different server', Icon='shuffle',
        Callback=function()
            Window:Dialog({Title='Confirm Server Hop', Content='Server hop?',
                Buttons={{Title='Cancel',Variant='Secondary'},{Title='Server Hop',Icon='check',Callback=Modules.ServerHop}}})
        end})
    ServerSection:Space()
    ServerSection:Toggle({Title='Queue on Teleport', Desc='Executes script automatically when queuing', Flag='AutoQueueToggle',
        Value=Modules.Config.AutoQueue, Callback=function(s) Modules.Config.AutoQueue=s end})
    ServerSection:Space()
    ServerSection:Button({Title='Clear Saved Key', Desc='Remove saved key from disk', Icon='trash',
        Callback=function() pcall(delfile,KEY_FILE) end})
    ServerSection:Toggle({Title='Webhook Logging', Desc='Toggle webhook telemetry', Flag='WebhookToggle',
        Value=true, Callback=function(s) _webhookEnabled=s end})
end
-- ============================================================
--  Window:Init() — MUST be after all tabs
-- ============================================================
Window:SelectTab(1)
Window:Init()
-- ============================================================
--  MAIN TAB OPEN FIX
--  WindUI can permanently hide the Main frame on close.
--  Post-init scan replaces destroy-close with toggle-close.
-- ============================================================
task.spawn(function()
    task.wait(2.5)
    pcall(function()
        for _,gui in ipairs(CoreGui:GetDescendants()) do
            if (gui:IsA("TextButton") or gui:IsA("ImageButton")) then
                local name=gui.Name:lower()
                if name:find("close") or name:find("exit") or name=="x" then
                    local targetFrame=gui.Parent
                    local depth=0
                    while targetFrame and depth<5 do
                        if targetFrame:IsA("Frame") and
                           (targetFrame.Size.X.Offset>300 or targetFrame.Size.X.Scale>0.3) then
                            break
                        end
                        targetFrame=targetFrame.Parent
                        depth=depth+1
                    end
                    if targetFrame and targetFrame:IsA("Frame") then
                        gui.MouseButton1Click:Connect(function()
                            task.wait(0.05)
                            if not targetFrame.Visible then
                                targetFrame.Visible=true
                            end
                        end)
                    end
                end
            end
        end
    end)
end)
-- ============================================================
--  WEBHOOK — LAUNCH
-- ============================================================
sendWebhook("🚀 QuantomHub Launched","Script initialized.",0x7B2FBE,{
    {name="Key",    value=validatedKey,        inline=true},
    {name="Expiry", value=keyExpiry(validatedKey), inline=true},
    {name="Script", value="QuantomHub v3.0 Unified", inline=true},
})
return Modules
