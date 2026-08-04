local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local HttpService       = game:GetService("HttpService")
local MarketplaceService= game:GetService("MarketplaceService")
local TextChatService   = game:GetService("TextChatService")
local LocalPlayer       = Players.LocalPlayer
local CurrentCamera     = workspace.CurrentCamera

getgenv().__QUANTOM_RELOAD = getgenv().__QUANTOM_RELOAD or function() end

-- ============================================================
--  I18N
-- ============================================================
local LANG = "EN"
local T
local I18N = {
    EN = {
        title="QuantomHub", subtitle="MM2 · v0.42", session="Session",
        search="Search...",
        tab_main="Main", tab_combat="Combat", tab_autofarm="Auto Farm",
        tab_teleport="Teleport", tab_troll="Troll Fun", tab_anims="Free anims",
        tab_fling="Fling Players", tab_visuals="Visuals", tab_spawner="Spawner",
        tab_settings="Settings", tab_server="Server",
        sec_general="General", sec_shoot="Shooting", sec_sheriff="Sheriff",
        sec_murderer="Murderer", sec_innocent="Innocent", sec_wallbang="Wallbang",
        sec_farm="Farm", sec_roles="Role Teleport", sec_players="Player Teleport",
        sec_movement="Movement Tricks", sec_packs="Animation Packs",
        sec_esp="ESP", sec_notif="Notifications", sec_chat="Chat",
        sec_keybinds="Keybinds", sec_lang="Language", sec_session="Session",
        sec_actions="Actions", sec_byrole="By Role", sec_byplayer="By Player",
        sec_camera="Camera", sec_protection="Protection",
        sec_bombjump="Bomb Jump", sec_goldjump="Gold Jump",
        sec_itemspawner="Item Spawner",
        copy_discord="Copy Discord", copy_key="Copy Key",
        walk_speed="Walk Speed", jump_power="Jump Power",
        noclip="Noclip", inf_jump="Infinite Jump",
        anti_fling="Anti Fling", fov="Camera FOV",
        std_pred="Standard Prediction", manual_pred="Manual Prediction (ms)",
        aim_v2="Aimbot V2 (ping)", resolver="Resolver",
        wallbang_toggle="Wallbang (through walls)", auto_shoot="Auto Shoot Murderer",
        shoot_now="Shoot Murderer", shoot_key="Shoot Key",
        fov_circle="FOV Circle", fov_radius="FOV Radius", transparency="Transparency",
        kill_all="Kill All", attack_delay="Attack Delay",
        equip_knife="Equip Knife", knife_aura="Knife Aura",
        aura_radius="Aura Radius", silent_throw="Silent Throw (torso)",
        throw_now="Throw Now",
        auto_grab="Auto Grab Gun", grab_now="Grab Gun",
        coin_farm="Coin Farm", candy_farm="Candy Farm",
        auto_reset="Auto Reset", auto_fling_m="Auto Fling Murderer",
        invis="Invisibility", fake_glitch="Fake SpeedGlitch",
        glitch_power="SpeedGlitch Power",
        enable_esp="Enable ESP", esp_mode="ESP Mode",
        show_names="Show Names+Role", show_dist="Show Distance",
        gun_esp="Gun ESP",
        notif_murd="Notify Murderer", notif_sher="Notify Sheriff",
        notif_gun="Notify Gun Drop", expose_roles="Expose Roles in Chat",
        fling_m="Fling Murderer", fling_s="Fling Sheriff", fling_all="Fling ALL",
        tp_m="TP Murderer", tp_s="TP Sheriff", select_pl="Select Player",
        tp_pl="Teleport to Player", refresh="Refresh List",
        item_name="Item Name", spawn_item="Spawn Item", pick_list="Pick From List",
        rejoin="Rejoin", server_hop="Server Hop", relaunch="Relaunch Script",
        unload="Unload GUI", toggle_menu="Toggle Menu", language="Language",
        load_pack="Load Pack", stop_anim="Stop Animation",
        loaded="Loaded", copied="Copied",
        cursor_label="Cursor Style",
    },
    RU = {
        title="QuantomHub", subtitle="MM2 · v0.42", session="Сессия",
        search="Поиск...",
        tab_main="Главная", tab_combat="Бой", tab_autofarm="Автофарм",
        tab_teleport="Телепорт", tab_troll="Троллинг", tab_anims="Анимации",
        tab_fling="Флинг игроков", tab_visuals="Визуал", tab_spawner="Спавнер",
        tab_settings="Настройки", tab_server="Сервер",
        sec_general="Общее", sec_shoot="Стрельба", sec_sheriff="Шериф",
        sec_murderer="Убийца", sec_innocent="Мирный", sec_wallbang="Пробитие",
        sec_farm="Фарм", sec_roles="Телепорт по роли", sec_players="Телепорт к игроку",
        sec_movement="Трюки движения", sec_packs="Паки анимаций",
        sec_esp="ESP", sec_notif="Уведомления", sec_chat="Чат",
        sec_keybinds="Клавиши", sec_lang="Язык", sec_session="Сессия",
        sec_actions="Действия", sec_byrole="По роли", sec_byplayer="По игроку",
        sec_camera="Камера", sec_protection="Защита",
        sec_bombjump="Бомба-прыжок", sec_goldjump="Золотой прыжок",
        sec_itemspawner="Спавнер предметов",
        copy_discord="Копировать Discord", copy_key="Копировать ключ",
        walk_speed="Скорость ходьбы", jump_power="Сила прыжка",
        noclip="Ноуклип", inf_jump="Бесконечный прыжок",
        anti_fling="Анти-флинг", fov="Обзор камеры",
        std_pred="Станд. упреждение", manual_pred="Ручное упреждение (мс)",
        aim_v2="Aimbot V2 (пинг)", resolver="Резолвер",
        wallbang_toggle="Пробитие стен", auto_shoot="Автовыстрел в убийцу",
        shoot_now="Выстрелить сейчас", shoot_key="Клавиша выстрела",
        fov_circle="Круг FOV", fov_radius="Радиус FOV", transparency="Прозрачность",
        kill_all="Убить всех", attack_delay="Задержка атаки",
        equip_knife="Взять нож", knife_aura="Аура ножа",
        aura_radius="Радиус ауры", silent_throw="Тихий бросок (торс)",
        throw_now="Бросить сейчас",
        auto_grab="Авто-подбор", grab_now="Подобрать пистолет",
        coin_farm="Фарм монет", candy_farm="Фарм конфет",
        auto_reset="Автосброс", auto_fling_m="Автофлинг убийцы",
        invis="Невидимость", fake_glitch="Фейк спидглитч",
        glitch_power="Сила спидглитча",
        enable_esp="Включить ESP", esp_mode="Режим ESP",
        show_names="Показать ник+роль", show_dist="Показать дистанцию",
        gun_esp="ESP пистолета",
        notif_murd="Уведомление убийца", notif_sher="Уведомление шериф",
        notif_gun="Уведомление о пистолете", expose_roles="Раскрыть роли в чат",
        fling_m="Флинг убийцы", fling_s="Флинг шерифа", fling_all="Флинг ВСЕХ",
        tp_m="ТП к убийце", tp_s="ТП к шерифу", select_pl="Выбрать игрока",
        tp_pl="Телепорт к игроку", refresh="Обновить",
        item_name="Название", spawn_item="Заспавнить", pick_list="Из списка",
        rejoin="Перезайти", server_hop="Смена сервера", relaunch="Перезапуск",
        unload="Выгрузить", toggle_menu="Открыть меню", language="Язык",
        load_pack="Загрузить", stop_anim="Остановить",
        loaded="Загружено", copied="Скопировано",
        cursor_label="Стиль курсора",
    },
}
T = function(k) return (I18N[LANG] and I18N[LANG][k]) or (I18N.EN[k] or k) end

-- ============================================================
--  STATE  — espEnabled starts FALSE so the toggle is the only trigger
-- ============================================================
local S = {
    DISCORD_URL="https://discord.gg/TsJvT5nDn",
    KEYGEN_URL="https://links.lootlabs.gg/s?SjkBayQ0",
    LOGO_ASSET="rbxassetid://14028428696",

    Keybinds={ToggleUI=Enum.KeyCode.RightControl, ShootMurder=Enum.KeyCode.F,
              GrabGun=Enum.KeyCode.J, KillAll=Enum.KeyCode.K,
              TeleportMurderer=Enum.KeyCode.L, TeleportSheriff=Enum.KeyCode.P,
              FlingMurderer=Enum.KeyCode.H, BombJump=Enum.KeyCode.B,
              GoldJump=Enum.KeyCode.N},

    predictionEnabled=true, predictionMs=0,
    aimbotV2Enabled=false, resolverEnabled=false,
    wallbangEnabled=false, autoShootEnabled=false,
    fovCircleEnabled=false, fovRadius=200, fovTransparency=0.7,
    fovColor=Color3.fromRGB(140,180,255),
    lastKnownPositions={},

    walkSpeedValue=16, jumpPowerValue=50,
    noclipEnabled=false, noclipConn=nil, savedCanCollide={},
    infJumpEnabled=false, infJumpConn=nil,
    antiFlingEnabled=false, currentFov=70,

    -- ESP: starts false. The toggle widget sets it to true when user enables it.
    espEnabled=false,
    espMode="All", espShowNames=true, espShowDistance=true,
    gunEspEnabled=false,

    killAllActive=false, killAllDelay=0.5,
    knifeAuraEnabled=false, knifeAuraRadius=10,
    silentThrowEnabled=false,

    coinFarmEnabled=false, candyFarmEnabled=false,
    autoResetEnabled=false, autoFlingOnFull=false,
    FARM_SPEED=25, coinCount=0, candyCount=0, bagCap=40,
    roundActive=false, roundReturnPos=nil, gamePassId=818078531,

    notifyMurderer=false, notifySheriff=false, notifyGunDrop=false,
    lastNotifiedGun=nil, roleMonitorTask=nil,
    notifiedMurd=false, notifiedSher=false,

    autoGrabEnabled=false, activeGunDrops={}, gunDropCheckInterval=1,
    mapNames={"ResearchFacility","Hospital3","MilBase","House2","Workplace",
              "Mansion2","BioLab","Hotel","Factory","Bank2","PoliceStation"},

    bombJumpEnabled=false, bombJumpPower=120, bombJumpRadius=18, bombJumpCooldown=false,
    goldJumpEnabled=false, goldJumpCooldown=false, goldJumpPower=80, goldJumpCooldownTime=1,

    invisEnabled=false, speedGlitchEnabled=false, speedGlitchPower=6,

    currentSpawnItem="",
    selectedPlayer=nil, selectedFlingPlayer=nil,

    OldPos=nil, FPDH=nil,

    -- custom cursor state
    cursorStyle="Default",
}

local function clipboard(text) pcall(function() if setclipboard then setclipboard(text) elseif toclipboard then toclipboard(text) end end) end

-- ============================================================
--  UI FRAMEWORK
-- ============================================================
local UI = {}
UI.COLORS = {
    BG           = Color3.fromRGB(12, 14, 28),
    BGDeep       = Color3.fromRGB(8, 10, 22),
    Sidebar      = Color3.fromRGB(18, 22, 44),
    Card         = Color3.fromRGB(22, 26, 50),
    Element      = Color3.fromRGB(28, 34, 62),
    ElementHover = Color3.fromRGB(38, 46, 82),
    Accent       = Color3.fromRGB(96, 128, 255),
    AccentDim    = Color3.fromRGB(64, 90, 200),
    AccentGlow   = Color3.fromRGB(140, 100, 255),
    Text         = Color3.fromRGB(230, 235, 255),
    TextDim      = Color3.fromRGB(140, 150, 190),
    Border       = Color3.fromRGB(50, 58, 100),
    Star         = Color3.fromRGB(180, 200, 255),
    Success      = Color3.fromRGB(90, 220, 180),
    Danger       = Color3.fromRGB(255, 100, 130),
}
UI.CONFIG = {
    Title     = "QuantomHub",
    Subtitle  = "MM2 · v0.42",
    LogoAsset = S.LOGO_ASSET,
    Size      = UDim2.new(0, 760, 0, 490),
}

local old = CoreGui:FindFirstChild("QuantomHubUI") if old then old:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuantomHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local function corner(p, r) local c = Instance.new("UICorner", p) c.CornerRadius = UDim.new(0, r or 8) return c end
local function stroke(p, col, th, tr) local s = Instance.new("UIStroke", p) s.Color = col or UI.COLORS.Border s.Thickness = th or 1 s.Transparency = tr or 0 return s end
local function padding(p, all) local pd = Instance.new("UIPadding", p) pd.PaddingTop = UDim.new(0,all) pd.PaddingBottom = UDim.new(0,all) pd.PaddingLeft = UDim.new(0,all) pd.PaddingRight = UDim.new(0,all) return pd end
local function gradient(p, c1, c2, rot) local g = Instance.new("UIGradient", p) g.Color = ColorSequence.new(c1, c2) g.Rotation = rot or 90 return g end

-- ============================================================
--  GALACTIC LOADER  (not fullscreen — 420×260, centered)
-- ============================================================
local LoaderFrame = Instance.new("Frame", ScreenGui)
LoaderFrame.Name = "GalacticLoader"
LoaderFrame.Size = UDim2.new(0, 420, 0, 260)
LoaderFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
LoaderFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
LoaderFrame.BorderSizePixel = 0
LoaderFrame.ZIndex = 100
corner(LoaderFrame, 16)
stroke(LoaderFrame, Color3.fromRGB(96, 128, 255), 1.5, 0.1)

do
    local lgrad = Instance.new("UIGradient", LoaderFrame)
    lgrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(14, 8, 40)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 18, 50)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(8, 10, 28)),
    })
    lgrad.Rotation = 135

    -- stars inside loader
    for i = 1, 30 do
        local st = Instance.new("Frame", LoaderFrame)
        local sz = math.random(1, 2)
        st.Size = UDim2.new(0, sz, 0, sz)
        st.Position = UDim2.new(math.random(), 0, math.random(), 0)
        st.BackgroundColor3 = Color3.fromRGB(180, 200, 255)
        st.BackgroundTransparency = math.random(40, 85) / 100
        st.BorderSizePixel = 0
        st.ZIndex = 101
        corner(st, sz)
    end

    -- orbit ring
    local orbit = Instance.new("Frame", LoaderFrame)
    orbit.Size = UDim2.new(0, 110, 0, 110)
    orbit.Position = UDim2.new(0.5, -55, 0, 30)
    orbit.BackgroundTransparency = 1
    orbit.ZIndex = 102

    local orbitRing = Instance.new("ImageLabel", orbit)
    orbitRing.Size = UDim2.new(1, 0, 1, 0)
    orbitRing.BackgroundTransparency = 1
    orbitRing.Image = "rbxassetid://4805639000"  -- ring/circle outline
    orbitRing.ImageColor3 = Color3.fromRGB(96, 128, 255)
    orbitRing.ImageTransparency = 0.3
    orbitRing.ZIndex = 102

    -- spinning dot on the orbit
    local dot = Instance.new("Frame", orbit)
    dot.Size = UDim2.new(0, 10, 0, 10)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.new(0.5, 0, 0, 0)
    dot.BackgroundColor3 = Color3.fromRGB(140, 100, 255)
    dot.BorderSizePixel = 0
    dot.ZIndex = 103
    corner(dot, 5)

    -- planet center
    local planet = Instance.new("Frame", orbit)
    planet.Size = UDim2.new(0, 44, 0, 44)
    planet.AnchorPoint = Vector2.new(0.5, 0.5)
    planet.Position = UDim2.new(0.5, 0, 0.5, 0)
    planet.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    planet.BorderSizePixel = 0
    planet.ZIndex = 103
    corner(planet, 22)
    do
        local pg = Instance.new("UIGradient", planet)
        pg.Color = ColorSequence.new(Color3.fromRGB(96, 128, 255), Color3.fromRGB(140, 60, 220))
        pg.Rotation = 45
    end

    local loaderTitle = Instance.new("TextLabel", LoaderFrame)
    loaderTitle.Size = UDim2.new(1, -40, 0, 28)
    loaderTitle.Position = UDim2.new(0, 20, 0, 152)
    loaderTitle.BackgroundTransparency = 1
    loaderTitle.Text = "QuantomHub"
    loaderTitle.TextColor3 = Color3.fromRGB(230, 235, 255)
    loaderTitle.TextSize = 22
    loaderTitle.Font = Enum.Font.GothamBold
    loaderTitle.TextXAlignment = Enum.TextXAlignment.Center
    loaderTitle.ZIndex = 102

    local loaderSub = Instance.new("TextLabel", LoaderFrame)
    loaderSub.Size = UDim2.new(1, -40, 0, 18)
    loaderSub.Position = UDim2.new(0, 20, 0, 180)
    loaderSub.BackgroundTransparency = 1
    loaderSub.Text = "MM2 · v0.42"
    loaderSub.TextColor3 = Color3.fromRGB(140, 150, 190)
    loaderSub.TextSize = 13
    loaderSub.Font = Enum.Font.Gotham
    loaderSub.TextXAlignment = Enum.TextXAlignment.Center
    loaderSub.ZIndex = 102

    -- progress bar track
    local barTrack = Instance.new("Frame", LoaderFrame)
    barTrack.Size = UDim2.new(0, 300, 0, 4)
    barTrack.Position = UDim2.new(0.5, -150, 0, 210)
    barTrack.BackgroundColor3 = Color3.fromRGB(30, 36, 70)
    barTrack.BorderSizePixel = 0
    barTrack.ZIndex = 102
    corner(barTrack, 2)

    local barFill = Instance.new("Frame", barTrack)
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(96, 128, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 103
    corner(barFill, 2)
    gradient(barFill, Color3.fromRGB(96, 128, 255), Color3.fromRGB(140, 100, 255), 0)

    local loaderStatus = Instance.new("TextLabel", LoaderFrame)
    loaderStatus.Size = UDim2.new(1, -40, 0, 16)
    loaderStatus.Position = UDim2.new(0, 20, 0, 224)
    loaderStatus.BackgroundTransparency = 1
    loaderStatus.Text = "Initializing..."
    loaderStatus.TextColor3 = Color3.fromRGB(96, 128, 255)
    loaderStatus.TextSize = 11
    loaderStatus.Font = Enum.Font.GothamMedium
    loaderStatus.TextXAlignment = Enum.TextXAlignment.Center
    loaderStatus.ZIndex = 102

    -- spin the dot around the orbit ring
    task.spawn(function()
        local angle = 0
        while LoaderFrame.Parent and LoaderFrame.Visible do
            angle = angle + 3
            local rad = math.rad(angle)
            local rx, ry = math.cos(rad) * 55, math.sin(rad) * 55
            dot.Position = UDim2.new(0.5, rx - 5, 0.5, ry - 5)
            task.wait(0.03)
        end
    end)

    -- fake load sequence
    local steps = {
        {t=0.25, label="Loading modules..."},
        {t=0.25, label="Connecting remotes..."},
        {t=0.20, label="Initializing ESP..."},
        {t=0.15, label="Applying patches..."},
        {t=0.15, label="Ready."},
    }
    task.spawn(function()
        local progress = 0
        for i, step in ipairs(steps) do
            loaderStatus.Text = step.label
            local target = i / #steps
            local startP = progress
            local t0 = tick()
            while tick() - t0 < step.t do
                local frac = math.min((tick() - t0) / step.t, 1)
                progress = startP + (target - startP) * frac
                barFill.Size = UDim2.new(progress, 0, 1, 0)
                task.wait(0.016)
            end
            progress = target
            barFill.Size = UDim2.new(progress, 0, 1, 0)
        end
        task.wait(0.3)
        TweenService:Create(LoaderFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5, -210, 0.5, -160),
        }):Play()
        task.wait(0.45)
        LoaderFrame:Destroy()
    end)
end

-- ============================================================
--  MAIN ROOT
-- ============================================================
local Root = Instance.new("Frame", ScreenGui)
Root.Size = UI.CONFIG.Size
Root.Position = UDim2.new(0.5, -UI.CONFIG.Size.X.Offset/2, 0.5, -UI.CONFIG.Size.Y.Offset/2)
Root.BackgroundColor3 = UI.COLORS.BGDeep
Root.BorderSizePixel = 0
Root.Active = true
Root.Visible = false  -- hidden until loader finishes
corner(Root, 14)
stroke(Root, UI.COLORS.Border, 1.5, 0.2)

-- show Root after loader clears
task.delay(1.1, function() Root.Visible = true end)

local BgGradient = Instance.new("Frame", Root)
BgGradient.Size = UDim2.new(1, 0, 1, 0)
BgGradient.BackgroundColor3 = Color3.fromRGB(20, 24, 55)
BgGradient.BorderSizePixel = 0
BgGradient.ZIndex = 0
corner(BgGradient, 14)
local grad = Instance.new("UIGradient", BgGradient)
grad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(18, 12, 48)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 20, 55)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(10, 14, 40)),
})
grad.Rotation = 135

local StarField = Instance.new("Frame", Root)
StarField.Size = UDim2.new(1, 0, 1, 0)
StarField.BackgroundTransparency = 1
StarField.BorderSizePixel = 0
StarField.ClipsDescendants = true
StarField.ZIndex = 1
corner(StarField, 14)
local stars = {}
for i = 1, 50 do
    local s = Instance.new("Frame", StarField)
    local sz = math.random(1, 3)
    s.Size = UDim2.new(0, sz, 0, sz)
    s.Position = UDim2.new(math.random(), 0, math.random(), 0)
    s.BackgroundColor3 = UI.COLORS.Star
    s.BackgroundTransparency = math.random(30, 80) / 100
    s.BorderSizePixel = 0
    s.ZIndex = 1
    corner(s, sz)
    table.insert(stars, {obj = s, base = s.BackgroundTransparency, speed = math.random(80, 200)/100})
end
task.spawn(function()
    local t = 0
    while StarField.Parent do
        t = t + 0.05
        for _, star in ipairs(stars) do
            star.obj.BackgroundTransparency = star.base + math.sin(t * star.speed) * 0.15
        end
        task.wait(0.05)
    end
end)

-- drag
do
    local dragging, dragStart, startPos
    local dragBar = Instance.new("Frame", Root)
    dragBar.Size = UDim2.new(1, 0, 0, 40)
    dragBar.BackgroundTransparency = 1
    dragBar.ZIndex = 30
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = Root.Position
        end
    end)
    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local Sidebar = Instance.new("Frame", Root)
Sidebar.Size = UDim2.new(0, 200, 1, -20)
Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundColor3 = UI.COLORS.Sidebar
Sidebar.BackgroundTransparency = 0.15
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 5
corner(Sidebar, 10)
stroke(Sidebar, UI.COLORS.Border, 1, 0.3)

local Header = Instance.new("Frame", Sidebar)
Header.Size = UDim2.new(1, -20, 0, 50)
Header.Position = UDim2.new(0, 10, 0, 10)
Header.BackgroundTransparency = 1
Header.ZIndex = 6

local HeaderIcon = Instance.new("ImageLabel", Header)
HeaderIcon.Size = UDim2.new(0, 40, 0, 40)
HeaderIcon.Position = UDim2.new(0, 2, 0.5, -20)
HeaderIcon.BackgroundColor3 = UI.COLORS.Accent
HeaderIcon.BackgroundTransparency = 0.85
HeaderIcon.BorderSizePixel = 0
HeaderIcon.Image = UI.CONFIG.LogoAsset
HeaderIcon.ScaleType = Enum.ScaleType.Fit
HeaderIcon.ZIndex = 6
corner(HeaderIcon, 8)
stroke(HeaderIcon, UI.COLORS.AccentGlow, 1, 0.4)

local HeaderText = Instance.new("TextLabel", Header)
HeaderText.Size = UDim2.new(1, -50, 0, 22)
HeaderText.Position = UDim2.new(0, 52, 0, 4)
HeaderText.BackgroundTransparency = 1
HeaderText.Text = UI.CONFIG.Title
HeaderText.TextColor3 = UI.COLORS.Text
HeaderText.TextSize = 17
HeaderText.Font = Enum.Font.GothamBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left
HeaderText.ZIndex = 6

local HeaderSub = Instance.new("TextLabel", Header)
HeaderSub.Size = UDim2.new(1, -50, 0, 14)
HeaderSub.Position = UDim2.new(0, 52, 0, 28)
HeaderSub.BackgroundTransparency = 1
HeaderSub.Text = UI.CONFIG.Subtitle
HeaderSub.TextColor3 = UI.COLORS.TextDim
HeaderSub.TextSize = 11
HeaderSub.Font = Enum.Font.Gotham
HeaderSub.TextXAlignment = Enum.TextXAlignment.Left
HeaderSub.ZIndex = 6

local Divider = Instance.new("Frame", Sidebar)
Divider.Size = UDim2.new(1, -30, 0, 1)
Divider.Position = UDim2.new(0, 15, 0, 70)
Divider.BackgroundColor3 = UI.COLORS.Border
Divider.BackgroundTransparency = 0.5
Divider.BorderSizePixel = 0
Divider.ZIndex = 6

local TabList = Instance.new("ScrollingFrame", Sidebar)
TabList.Size = UDim2.new(1, -14, 1, -160)
TabList.Position = UDim2.new(0, 7, 0, 80)
TabList.BackgroundTransparency = 1
TabList.BorderSizePixel = 0
TabList.ScrollBarThickness = 2
TabList.ScrollBarImageColor3 = UI.COLORS.Accent
TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
TabList.ZIndex = 6
local TabLayout = Instance.new("UIListLayout", TabList)
TabLayout.Padding = UDim.new(0, 4)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local UserCard = Instance.new("Frame", Sidebar)
UserCard.Size = UDim2.new(1, -20, 0, 60)
UserCard.Position = UDim2.new(0, 10, 1, -70)
UserCard.BackgroundColor3 = UI.COLORS.Element
UserCard.BackgroundTransparency = 0.2
UserCard.BorderSizePixel = 0
UserCard.ZIndex = 6
corner(UserCard, 8)
stroke(UserCard, UI.COLORS.Border, 1, 0.4)

local Avatar = Instance.new("ImageLabel", UserCard)
Avatar.Size = UDim2.new(0, 40, 0, 40)
Avatar.Position = UDim2.new(0, 8, 0.5, -20)
Avatar.BackgroundColor3 = UI.COLORS.Card
Avatar.BorderSizePixel = 0
Avatar.ZIndex = 7
corner(Avatar, 6)
pcall(function()
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)

local UName = Instance.new("TextLabel", UserCard)
UName.Size = UDim2.new(1, -58, 0, 16) UName.Position = UDim2.new(0, 56, 0, 8)
UName.BackgroundTransparency = 1 UName.Text = LocalPlayer.DisplayName
UName.TextColor3 = UI.COLORS.Text UName.TextSize = 12
UName.Font = Enum.Font.GothamBold UName.TextXAlignment = Enum.TextXAlignment.Left UName.ZIndex = 7

local UHandle = Instance.new("TextLabel", UserCard)
UHandle.Size = UDim2.new(1, -58, 0, 12) UHandle.Position = UDim2.new(0, 56, 0, 24)
UHandle.BackgroundTransparency = 1 UHandle.Text = "@" .. LocalPlayer.Name
UHandle.TextColor3 = UI.COLORS.TextDim UHandle.TextSize = 10
UHandle.Font = Enum.Font.Gotham UHandle.TextXAlignment = Enum.TextXAlignment.Left UHandle.ZIndex = 7

local USession = Instance.new("TextLabel", UserCard)
USession.Size = UDim2.new(1, -58, 0, 12) USession.Position = UDim2.new(0, 56, 0, 38)
USession.BackgroundTransparency = 1 USession.TextColor3 = UI.COLORS.Accent
USession.TextSize = 10 USession.Font = Enum.Font.GothamBold
USession.TextXAlignment = Enum.TextXAlignment.Left USession.ZIndex = 7
do
    local start = tick()
    task.spawn(function()
        while USession.Parent do
            local e = tick() - start
            USession.Text = string.format("● %02d:%02d:%02d", math.floor(e/3600), math.floor(e%3600/60), math.floor(e%60))
            task.wait(1)
        end
    end)
end

local Content = Instance.new("Frame", Root)
Content.Size = UDim2.new(1, -230, 1, -20)
Content.Position = UDim2.new(0, 220, 0, 10)
Content.BackgroundColor3 = UI.COLORS.Card
Content.BackgroundTransparency = 0.15
Content.BorderSizePixel = 0
Content.ZIndex = 5
corner(Content, 10)
stroke(Content, UI.COLORS.Border, 1, 0.3)

local TopBar = Instance.new("Frame", Content)
TopBar.Size = UDim2.new(1, -20, 0, 40)
TopBar.Position = UDim2.new(0, 10, 0, 8)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 10

local TitleBar = Instance.new("TextLabel", TopBar)
TitleBar.Size = UDim2.new(0.4, 0, 1, 0)
TitleBar.BackgroundTransparency = 1
TitleBar.Text = ""
TitleBar.TextColor3 = UI.COLORS.Text
TitleBar.TextSize = 18
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.ZIndex = 10

local SearchBox = Instance.new("Frame", TopBar)
SearchBox.Size = UDim2.new(0, 200, 0, 28)
SearchBox.Position = UDim2.new(1, -280, 0.5, -14)
SearchBox.BackgroundColor3 = UI.COLORS.Element
SearchBox.BackgroundTransparency = 0.3
SearchBox.BorderSizePixel = 0
SearchBox.ZIndex = 10
corner(SearchBox, 6)
stroke(SearchBox, UI.COLORS.Border, 1, 0.4)

local SearchIcon = Instance.new("ImageLabel", SearchBox)
SearchIcon.Size = UDim2.new(0, 14, 0, 14)
SearchIcon.Position = UDim2.new(0, 8, 0.5, -7)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://7072722787"
SearchIcon.ImageColor3 = UI.COLORS.TextDim
SearchIcon.ZIndex = 11

local SearchInput = Instance.new("TextBox", SearchBox)
SearchInput.Size = UDim2.new(1, -34, 1, 0)
SearchInput.Position = UDim2.new(0, 30, 0, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.PlaceholderText = T("search")
SearchInput.PlaceholderColor3 = UI.COLORS.TextDim
SearchInput.Text = ""
SearchInput.TextColor3 = UI.COLORS.Text
SearchInput.TextSize = 12
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.ZIndex = 11

-- ============================================================
--  MINIMIZE BUTTON  (top-right, before close)
-- ============================================================
local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 28, 0, 28)
MinBtn.Position = UDim2.new(1, -64, 0.5, -14)
MinBtn.BackgroundColor3 = UI.COLORS.Element
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "–"
MinBtn.TextColor3 = UI.COLORS.TextDim
MinBtn.TextSize = 18
MinBtn.Font = Enum.Font.GothamBold
MinBtn.BorderSizePixel = 0
MinBtn.AutoButtonColor = false
MinBtn.ZIndex = 10
corner(MinBtn, 6)
MinBtn.MouseEnter:Connect(function() MinBtn.TextColor3 = UI.COLORS.Accent MinBtn.BackgroundTransparency = 0.1 end)
MinBtn.MouseLeave:Connect(function() MinBtn.TextColor3 = UI.COLORS.TextDim MinBtn.BackgroundTransparency = 0.3 end)

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
CloseBtn.BackgroundColor3 = UI.COLORS.Element
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "×"
CloseBtn.TextColor3 = UI.COLORS.TextDim
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 10
corner(CloseBtn, 6)
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = UI.COLORS.Danger CloseBtn.BackgroundTransparency = 0.1 end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = UI.COLORS.TextDim CloseBtn.BackgroundTransparency = 0.3 end)
CloseBtn.MouseButton1Click:Connect(function() Root.Visible = false end)

-- ============================================================
--  MINIMIZED BUTTON  — floats on screen when Root is hidden
-- ============================================================
local MinimizedBtn = Instance.new("TextButton", ScreenGui)
MinimizedBtn.Name = "MinimizedBtn"
MinimizedBtn.Size = UDim2.new(0, 44, 0, 44)
MinimizedBtn.Position = UDim2.new(0, 14, 0.5, -22)
MinimizedBtn.BackgroundColor3 = UI.COLORS.BGDeep
MinimizedBtn.BackgroundTransparency = 0.1
MinimizedBtn.Text = "Q"
MinimizedBtn.TextColor3 = UI.COLORS.Accent
MinimizedBtn.TextSize = 20
MinimizedBtn.Font = Enum.Font.GothamBold
MinimizedBtn.AutoButtonColor = false
MinimizedBtn.BorderSizePixel = 0
MinimizedBtn.Visible = false
MinimizedBtn.ZIndex = 50
corner(MinimizedBtn, 10)
stroke(MinimizedBtn, UI.COLORS.Accent, 1.5, 0.2)
do
    local pg = Instance.new("UIGradient", MinimizedBtn)
    pg.Color = ColorSequence.new(Color3.fromRGB(18, 12, 48), Color3.fromRGB(10, 18, 55))
    pg.Rotation = 135
end
MinimizedBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizedBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
end)
MinimizedBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizedBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.1}):Play()
end)
MinimizedBtn.MouseButton1Click:Connect(function()
    Root.Visible = true
    MinimizedBtn.Visible = false
end)

-- drag MinimizedBtn
do
    local md, ms, mp = false, nil, nil
    MinimizedBtn.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then
            md = true ms = inp.Position mp = MinimizedBtn.Position
        end
    end)
    MinimizedBtn.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 then md = false end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if md and inp.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = inp.Position - ms
            MinimizedBtn.Position = UDim2.new(mp.X.Scale, mp.X.Offset + delta.X, mp.Y.Scale, mp.Y.Offset + delta.Y)
        end
    end)
end

-- wire minimize button to show the floating restore button
MinBtn.MouseButton1Click:Connect(function()
    Root.Visible = false
    MinimizedBtn.Visible = true
end)

-- sync MinimizedBtn with keybind toggle too
-- (handled in InputBegan section below — Root.Visible check covers it)

local tabs = {}
local activeTab = nil

function UI:CreateTab(nameKey, iconAsset)
    local tabBtn = Instance.new("TextButton", TabList)
    tabBtn.Size = UDim2.new(1, -4, 0, 34)
    tabBtn.BackgroundColor3 = UI.COLORS.Element
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.BorderSizePixel = 0
    tabBtn.ZIndex = 7
    corner(tabBtn, 6)

    local iconLbl = Instance.new("ImageLabel", tabBtn)
    iconLbl.Size = UDim2.new(0, 16, 0, 16)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -8)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Image = iconAsset or "rbxassetid://7734053426"
    iconLbl.ImageColor3 = UI.COLORS.TextDim
    iconLbl.ZIndex = 8

    local nameLbl = Instance.new("TextLabel", tabBtn)
    nameLbl.Size = UDim2.new(1, -50, 1, 0)
    nameLbl.Position = UDim2.new(0, 36, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = T(nameKey)
    nameLbl.TextColor3 = UI.COLORS.TextDim
    nameLbl.TextSize = 12
    nameLbl.Font = Enum.Font.GothamMedium
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 8

    local arrow = Instance.new("TextLabel", tabBtn)
    arrow.Size = UDim2.new(0, 14, 1, 0)
    arrow.Position = UDim2.new(1, -18, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "›"
    arrow.TextColor3 = UI.COLORS.TextDim
    arrow.TextSize = 16
    arrow.Font = Enum.Font.GothamBold
    arrow.ZIndex = 8

    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, -30, 1, -60)
    page.Position = UDim2.new(0, 15, 0, 55)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = UI.COLORS.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.ZIndex = 6
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    padding(page, 4)

    local tab = {nameKey=nameKey, btn=tabBtn, page=page, icon=iconLbl, label=nameLbl, arrow=arrow, elements={}, i18n={}}
    table.insert(tabs, tab)

    tabBtn.MouseEnter:Connect(function()
        if activeTab ~= tab then TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.7}):Play() end
    end)
    tabBtn.MouseLeave:Connect(function()
        if activeTab ~= tab then TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play() end
    end)
    tabBtn.MouseButton1Click:Connect(function()
        if activeTab then
            TweenService:Create(activeTab.btn, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
            activeTab.icon.ImageColor3 = UI.COLORS.TextDim
            activeTab.label.TextColor3 = UI.COLORS.TextDim
            activeTab.arrow.TextColor3 = UI.COLORS.TextDim
            activeTab.arrow.Text = "›"
            activeTab.page.Visible = false
        end
        activeTab = tab
        tabBtn.BackgroundColor3 = UI.COLORS.Accent
        TweenService:Create(tabBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15}):Play()
        iconLbl.ImageColor3 = UI.COLORS.Text
        nameLbl.TextColor3 = UI.COLORS.Text
        arrow.TextColor3 = UI.COLORS.Text
        arrow.Text = "⌄"
        page.Visible = true
        TitleBar.Text = T(nameKey)
    end)

    local api = {}

    function api:Section(textKey)
        local h = Instance.new("Frame", page)
        h.Size = UDim2.new(1, 0, 0, 26)
        h.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", h)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(textKey)
        lbl.TextColor3 = UI.COLORS.Accent
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        table.insert(tab.elements, {frame=h, key=textKey})
        table.insert(tab.i18n, {obj=lbl, key=textKey})
        return h
    end

    function api:Toggle(textKey, default, callback)
        local state = default and true or false
        local f = Instance.new("TextButton", page)
        f.Size = UDim2.new(1, 0, 0, 40)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BackgroundTransparency = 0.2
        f.Text = ""
        f.AutoButtonColor = false
        f.BorderSizePixel = 0
        corner(f, 8)
        stroke(f, UI.COLORS.Border, 1, 0.6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -64, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(textKey)
        lbl.TextColor3 = UI.COLORS.Text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local sw = Instance.new("Frame", f)
        sw.Size = UDim2.new(0, 40, 0, 20)
        sw.Position = UDim2.new(1, -52, 0.5, -10)
        sw.BackgroundColor3 = state and UI.COLORS.Accent or UI.COLORS.Card
        sw.BorderSizePixel = 0
        corner(sw, 10)
        local knob = Instance.new("Frame", sw)
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(state and 1 or 0, state and -17 or 3, 0.5, -7)
        knob.BackgroundColor3 = UI.COLORS.Text
        knob.BorderSizePixel = 0
        corner(knob, 7)
        local function set(v)
            state = v
            TweenService:Create(sw, TweenInfo.new(0.18), {BackgroundColor3 = state and UI.COLORS.Accent or UI.COLORS.Card}):Play()
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = UDim2.new(state and 1 or 0, state and -17 or 3, 0.5, -7)}):Play()
            if callback then task.spawn(callback, state) end
        end
        f.MouseButton1Click:Connect(function() set(not state) end)
        -- NOTE: no auto-fire on default=false. Default=true fires once explicitly below.
        if default then
            task.spawn(function()
                task.wait(0)  -- defer past current frame so UI is settled
                if callback then callback(true) end
            end)
        end
        table.insert(tab.elements, {frame=f, key=textKey})
        table.insert(tab.i18n, {obj=lbl, key=textKey})
        return {Set=set, Get=function() return state end}
    end

    function api:Slider(textKey, min, max, default, step, callback)
        step = step or 1
        local val = default or min
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 52)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        corner(f, 8)
        stroke(f, UI.COLORS.Border, 1, 0.6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -80, 0, 22)
        lbl.Position = UDim2.new(0, 14, 0, 5)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(textKey)
        lbl.TextColor3 = UI.COLORS.Text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local valLbl = Instance.new("TextLabel", f)
        valLbl.Size = UDim2.new(0, 60, 0, 22)
        valLbl.Position = UDim2.new(1, -74, 0, 5)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(val)
        valLbl.TextColor3 = UI.COLORS.Accent
        valLbl.TextSize = 13
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        local bar = Instance.new("Frame", f)
        bar.Size = UDim2.new(1, -28, 0, 4)
        bar.Position = UDim2.new(0, 14, 1, -14)
        bar.BackgroundColor3 = UI.COLORS.Card
        bar.BorderSizePixel = 0
        corner(bar, 2)
        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = UI.COLORS.Accent
        fill.BorderSizePixel = 0
        corner(fill, 2)
        gradient(fill, UI.COLORS.Accent, UI.COLORS.AccentGlow, 0)
        local dragging = false
        local function update(input)
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            local raw = min + (max - min) * rel
            val = math.floor(raw / step + 0.5) * step
            val = math.clamp(val, min, max)
            fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
            valLbl.Text = tostring(val)
            if callback then task.spawn(callback, val) end
        end
        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true update(i)
            end
        end)
        bar.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i) end
        end)
        table.insert(tab.elements, {frame=f, key=textKey})
        table.insert(tab.i18n, {obj=lbl, key=textKey})
        return {Set=function(v) val=math.clamp(v,min,max) fill.Size=UDim2.new((val-min)/(max-min),0,1,0) valLbl.Text=tostring(val) if callback then callback(val) end end, Get=function() return val end}
    end

    function api:Button(textKey, callback)
        local b = Instance.new("TextButton", page)
        b.Size = UDim2.new(1, 0, 0, 36)
        b.BackgroundColor3 = UI.COLORS.Accent
        b.Text = T(textKey)
        b.TextColor3 = UI.COLORS.Text
        b.TextSize = 13
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        corner(b, 8)
        gradient(b, UI.COLORS.Accent, UI.COLORS.AccentGlow, 90)
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = UI.COLORS.AccentGlow}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = UI.COLORS.Accent}):Play() end)
        b.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
        table.insert(tab.elements, {frame=b, key=textKey})
        table.insert(tab.i18n, {obj=b, key=textKey})
        return b
    end

    function api:Input(textKey, placeholder, default, callback)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 56)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        corner(f, 8)
        stroke(f, UI.COLORS.Border, 1, 0.6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -20, 0, 18)
        lbl.Position = UDim2.new(0, 14, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(textKey)
        lbl.TextColor3 = UI.COLORS.TextDim
        lbl.TextSize = 11
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local box = Instance.new("TextBox", f)
        box.Size = UDim2.new(1, -24, 0, 24)
        box.Position = UDim2.new(0, 12, 0, 26)
        box.BackgroundColor3 = UI.COLORS.Card
        box.PlaceholderText = placeholder or ""
        box.PlaceholderColor3 = UI.COLORS.TextDim
        box.Text = default or ""
        box.TextColor3 = UI.COLORS.Text
        box.TextSize = 12
        box.Font = Enum.Font.Gotham
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        corner(box, 4)
        padding(box, 6)
        box.FocusLost:Connect(function() if callback then task.spawn(callback, box.Text) end end)
        table.insert(tab.elements, {frame=f, key=textKey})
        table.insert(tab.i18n, {obj=lbl, key=textKey})
        return {Set=function(v) box.Text=v end, Get=function() return box.Text end}
    end

    function api:Dropdown(textKey, options, default, callback)
        local selected = default or (options[1] or "")
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 56)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        f.ClipsDescendants = true
        corner(f, 8)
        stroke(f, UI.COLORS.Border, 1, 0.6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -20, 0, 18)
        lbl.Position = UDim2.new(0, 14, 0, 6)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(textKey)
        lbl.TextColor3 = UI.COLORS.TextDim
        lbl.TextSize = 11
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(1, -24, 0, 24)
        btn.Position = UDim2.new(0, 12, 0, 26)
        btn.BackgroundColor3 = UI.COLORS.Card
        btn.Text = "  " .. tostring(selected)
        btn.TextColor3 = UI.COLORS.Text
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        corner(btn, 4)
        local arrowD = Instance.new("TextLabel", btn)
        arrowD.Size = UDim2.new(0, 20, 1, 0) arrowD.Position = UDim2.new(1, -22, 0, 0)
        arrowD.BackgroundTransparency = 1 arrowD.Text = "▼"
        arrowD.TextColor3 = UI.COLORS.Accent arrowD.TextSize = 9 arrowD.Font = Enum.Font.Gotham
        local list = Instance.new("Frame", f)
        list.Size = UDim2.new(1, -24, 0, 0)
        list.Position = UDim2.new(0, 12, 0, 54)
        list.BackgroundColor3 = UI.COLORS.Card
        list.BorderSizePixel = 0
        list.Visible = false
        list.ClipsDescendants = true
        corner(list, 4)
        local scroll = Instance.new("ScrollingFrame", list)
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 2
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 2)
        local open = false
        local function rebuild()
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, opt in ipairs(options) do
                local ob = Instance.new("TextButton", scroll)
                ob.Size = UDim2.new(1, -6, 0, 22)
                ob.BackgroundColor3 = UI.COLORS.Element
                ob.Text = "  " .. tostring(opt)
                ob.TextColor3 = UI.COLORS.Text
                ob.TextSize = 12
                ob.Font = Enum.Font.Gotham
                ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.AutoButtonColor = false
                ob.BorderSizePixel = 0
                corner(ob, 3)
                ob.MouseEnter:Connect(function() ob.BackgroundColor3 = UI.COLORS.ElementHover end)
                ob.MouseLeave:Connect(function() ob.BackgroundColor3 = UI.COLORS.Element end)
                ob.MouseButton1Click:Connect(function()
                    selected = opt
                    btn.Text = "  " .. tostring(opt)
                    open = false
                    list.Visible = false
                    f.Size = UDim2.new(1, 0, 0, 56)
                    if callback then task.spawn(callback, opt) end
                end)
            end
        end
        rebuild()
        btn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                local h = math.min(#options * 24 + 4, 140)
                list.Visible = true
                list.Size = UDim2.new(1, -24, 0, h)
                f.Size = UDim2.new(1, 0, 0, 56 + h + 4)
            else
                list.Visible = false
                f.Size = UDim2.new(1, 0, 0, 56)
            end
        end)
        table.insert(tab.elements, {frame=f, key=textKey})
        table.insert(tab.i18n, {obj=lbl, key=textKey})
        return {
            Set=function(v) selected=v btn.Text="  "..tostring(v) if callback then callback(v) end end,
            Get=function() return selected end,
            Refresh=function(newList) options = newList rebuild() end,
        }
    end

    function api:Keybind(textKey, default, callback)
        local key = default or Enum.KeyCode.Unknown
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 40)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BackgroundTransparency = 0.2
        f.BorderSizePixel = 0
        corner(f, 8)
        stroke(f, UI.COLORS.Border, 1, 0.6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.Position = UDim2.new(0, 14, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = T(textKey)
        lbl.TextColor3 = UI.COLORS.Text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamMedium
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0, 90, 0, 26)
        btn.Position = UDim2.new(1, -104, 0.5, -13)
        btn.BackgroundColor3 = UI.COLORS.Card
        btn.Text = key.Name
        btn.TextColor3 = UI.COLORS.Accent
        btn.TextSize = 11
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        corner(btn, 4)
        local listening = false
        btn.MouseButton1Click:Connect(function() listening = true btn.Text = "..." end)
        UserInputService.InputBegan:Connect(function(input)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                btn.Text = key.Name
                listening = false
                if callback then task.spawn(callback, key) end
            end
        end)
        table.insert(tab.elements, {frame=f, key=textKey})
        table.insert(tab.i18n, {obj=lbl, key=textKey})
        return {Set=function(k) key=k btn.Text=k.Name end, Get=function() return key end}
    end

    function api:AnimCard(name, thumbId, loadCb)
        local card = Instance.new("Frame", page)
        card.Size = UDim2.new(1, 0, 0, 90)
        card.BackgroundColor3 = UI.COLORS.Element
        card.BackgroundTransparency = 0.2
        card.BorderSizePixel = 0
        corner(card, 8)
        stroke(card, UI.COLORS.Border, 1, 0.6)
        local thumb = Instance.new("ImageLabel", card)
        thumb.Size = UDim2.new(0, 74, 0, 74)
        thumb.Position = UDim2.new(0, 8, 0.5, -37)
        thumb.BackgroundColor3 = UI.COLORS.Card
        thumb.BorderSizePixel = 0
        thumb.Image = thumbId
        thumb.ScaleType = Enum.ScaleType.Crop
        corner(thumb, 6)
        local nm = Instance.new("TextLabel", card)
        nm.Size = UDim2.new(1, -100, 0, 24)
        nm.Position = UDim2.new(0, 92, 0, 12)
        nm.BackgroundTransparency = 1
        nm.Text = name
        nm.TextColor3 = UI.COLORS.Text
        nm.TextSize = 15
        nm.Font = Enum.Font.GothamBold
        nm.TextXAlignment = Enum.TextXAlignment.Left
        local loadBtn = Instance.new("TextButton", card)
        loadBtn.Size = UDim2.new(0, 110, 0, 26)
        loadBtn.Position = UDim2.new(0, 92, 1, -34)
        loadBtn.BackgroundColor3 = UI.COLORS.Accent
        loadBtn.Text = T("load_pack")
        loadBtn.TextColor3 = UI.COLORS.Text
        loadBtn.TextSize = 12
        loadBtn.Font = Enum.Font.GothamBold
        loadBtn.AutoButtonColor = false
        loadBtn.BorderSizePixel = 0
        corner(loadBtn, 5)
        gradient(loadBtn, UI.COLORS.Accent, UI.COLORS.AccentGlow, 90)
        loadBtn.MouseButton1Click:Connect(function() task.spawn(loadCb) end)
        table.insert(tab.elements, {frame=card, key=name})
        table.insert(tab.i18n, {obj=loadBtn, key="load_pack"})
        return card
    end

    return api
end

local function retranslate()
    HeaderText.Text = T("title")
    HeaderSub.Text = T("subtitle")
    SearchInput.PlaceholderText = T("search")
    if activeTab then TitleBar.Text = T(activeTab.nameKey) end
    for _, tab in ipairs(tabs) do
        tab.label.Text = T(tab.nameKey)
        for _, entry in ipairs(tab.i18n) do
            if entry.obj and entry.obj.Parent then
                entry.obj.Text = T(entry.key)
            end
        end
    end
end

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = SearchInput.Text:lower()
    if not activeTab then return end
    for _, el in ipairs(activeTab.elements) do
        if q == "" then el.frame.Visible = true
        else el.frame.Visible = T(el.key):lower():find(q, 1, true) ~= nil end
    end
end)

-- Notifications
local NotifRoot = Instance.new("Frame", ScreenGui)
NotifRoot.Size = UDim2.new(0, 300, 1, -20)
NotifRoot.Position = UDim2.new(1, -310, 0, 10)
NotifRoot.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifRoot)
NotifLayout.Padding = UDim.new(0, 6)

local function notify(title, content, dur)
    dur = dur or 3
    local card = Instance.new("Frame", NotifRoot)
    card.Size = UDim2.new(1, 0, 0, 52)
    card.BackgroundColor3 = UI.COLORS.Card
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    corner(card, 8)
    stroke(card, UI.COLORS.Accent, 1, 0.4)
    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.new(0, 3, 1, -10) bar.Position = UDim2.new(0, 5, 0, 5)
    bar.BackgroundColor3 = UI.COLORS.Accent bar.BorderSizePixel = 0
    corner(bar, 2)
    local tl = Instance.new("TextLabel", card)
    tl.Size = UDim2.new(1, -20, 0, 20) tl.Position = UDim2.new(0, 16, 0, 7)
    tl.BackgroundTransparency = 1 tl.Text = title
    tl.TextColor3 = UI.COLORS.Text tl.TextSize = 13
    tl.Font = Enum.Font.GothamBold tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextTransparency = 1
    local cl = Instance.new("TextLabel", card)
    cl.Size = UDim2.new(1, -20, 0, 16) cl.Position = UDim2.new(0, 16, 0, 28)
    cl.BackgroundTransparency = 1 cl.Text = content or ""
    cl.TextColor3 = UI.COLORS.TextDim cl.TextSize = 11
    cl.Font = Enum.Font.Gotham cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(tl, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(cl, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    task.delay(dur, function()
        TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(tl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(cl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.35) card:Destroy()
    end)
end

-- ============================================================
--  CUSTOM CURSOR
--  Assets sourced from osuskinner.com cursor packs:
--    1. Mrekk (minimalist white dot + trail)
--    2. WhiteCat (sharp crosshair)
--    3. Cookiezi (classic osu! circle)
--  Mapped to Roblox ImageLabel overlay — hides system cursor.
-- ============================================================
local CURSORS = {
    {name="Default",    image="",                          size=Vector2.new(0,0)},
    {name="Mrekk",      image="rbxassetid://11294444008",  size=Vector2.new(32,32)},
    {name="WhiteCat",   image="rbxassetid://11294463215",  size=Vector2.new(32,32)},
    {name="Cookiezi",   image="rbxassetid://11294476882",  size=Vector2.new(32,32)},
}

local cursorFrame = Instance.new("Frame", ScreenGui)
cursorFrame.Name = "CustomCursor"
cursorFrame.Size = UDim2.new(0, 32, 0, 32)
cursorFrame.BackgroundTransparency = 1
cursorFrame.BorderSizePixel = 0
cursorFrame.ZIndex = 200
cursorFrame.Visible = false

local cursorImg = Instance.new("ImageLabel", cursorFrame)
cursorImg.Size = UDim2.new(1, 0, 1, 0)
cursorImg.BackgroundTransparency = 1
cursorImg.BorderSizePixel = 0
cursorImg.ZIndex = 200
cursorImg.ScaleType = Enum.ScaleType.Fit

local activeCursorIndex = 1  -- 1 = Default (no override)

local function applyCursor(idx)
    activeCursorIndex = idx
    local cur = CURSORS[idx]
    if not cur or cur.name == "Default" or cur.image == "" then
        -- restore system cursor
        pcall(function() UserInputService.MouseIconEnabled = true end)
        cursorFrame.Visible = false
        return
    end
    -- hide system cursor, overlay custom image
    pcall(function() UserInputService.MouseIconEnabled = false end)
    cursorImg.Image = cur.image
    cursorFrame.Size = UDim2.new(0, cur.size.X, 0, cur.size.Y)
    cursorFrame.Visible = true
end

-- follow mouse
RunService.RenderStepped:Connect(function()
    if cursorFrame.Visible then
        local mp = UserInputService:GetMouseLocation()
        cursorFrame.Position = UDim2.new(0, mp.X - 4, 0, mp.Y - 4)
    end
end)

-- ============================================================
--  ROLES
-- ============================================================
local Roles = {}
function Roles.getMurderer()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer then
            local bp = pl:FindFirstChild("Backpack") local ch = pl.Character
            if bp and bp:FindFirstChild("Knife") then return pl end
            if ch and ch:FindFirstChild("Knife") then return pl end
        end
    end
end
function Roles.getSheriff()
    if workspace:FindFirstChild("GunDrop", true) then return nil end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local bp = pl:FindFirstChild("Backpack")
            if pl.Character:FindFirstChild("Gun") then return pl end
            if bp and bp:FindFirstChild("Gun") then return pl end
        end
    end
end

-- ============================================================
--  FLING
-- ============================================================
local Fling = {}
function Fling.execute(TP)
    if not TP or not TP.Character then return end
    local Ch = LocalPlayer.Character
    local Hm = Ch and Ch:FindFirstChildOfClass("Humanoid")
    local RP = Ch and Ch:FindFirstChild("HumanoidRootPart")
    local TC = TP.Character
    local TH = TC and TC:FindFirstChildOfClass("Humanoid")
    local TR = TH and (TC:FindFirstChild("HumanoidRootPart") or TC.PrimaryPart)
    local THd = TC and TC:FindFirstChild("Head")
    if not (Ch and Hm and RP and TC and TR) then return end
    if RP.Velocity.Magnitude < 50 then S.OldPos = RP.CFrame end
    local cam = workspace.CurrentCamera
    if THd then cam.CameraSubject = THd end
    local function FP(B, P, A)
        RP.CFrame = CFrame.new(B.Position) * P * A
        RP.Velocity = Vector3.new(9e7, 9e8, 9e7)
        RP.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    if not S.FPDH then S.FPDH = workspace.FallenPartsDestroyHeight end
    workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Parent = RP
    BV.Velocity = Vector3.new(9e8,9e8,9e8) BV.MaxForce = Vector3.new(1/0,1/0,1/0)
    Hm:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    local T2, TW, An = tick(), 2, 0
    local B = TR
    repeat
        if B.Velocity.Magnitude < 50 then
            An = An + 100
            FP(B, CFrame.new(0,1.5,0) + TH.MoveDirection*B.Velocity.Magnitude/1.25, CFrame.Angles(math.rad(An),0,0)) task.wait()
            FP(B, CFrame.new(0,-1.5,0) + TH.MoveDirection*B.Velocity.Magnitude/1.25, CFrame.Angles(math.rad(An),0,0)) task.wait()
        else
            FP(B, CFrame.new(0,1.5,TH.WalkSpeed), CFrame.Angles(math.rad(90),0,0)) task.wait()
            FP(B, CFrame.new(0,-1.5,-TH.WalkSpeed), CFrame.Angles(0,0,0)) task.wait()
        end
    until B.Velocity.Magnitude > 500 or TP.Character ~= TC or Hm.Health <= 0 or tick() > T2 + TW
    if BV.Parent then BV:Destroy() end
    Hm:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    cam.CameraSubject = Hm
    local lim = tick() + 5
    repeat
        if S.OldPos then RP.CFrame = S.OldPos * CFrame.new(0,0.5,0) end
        Hm:ChangeState(Enum.HumanoidStateType.GettingUp)
        for _, x in ipairs(Ch:GetChildren()) do
            if x:IsA("BasePart") then x.Velocity = Vector3.new() x.RotVelocity = Vector3.new() end
        end
        task.wait()
    until not S.OldPos or (RP.Position - S.OldPos.p).Magnitude < 25 or tick() > lim
    if S.FPDH then workspace.FallenPartsDestroyHeight = S.FPDH end
end
function Fling.murderer() local m = Roles.getMurderer() if m and m.Character then task.spawn(function() Fling.execute(m) end) return end notify("Fling","No murderer",2) end
function Fling.sheriff() local s = Roles.getSheriff() if s and s.Character then task.spawn(function() Fling.execute(s) end) return end notify("Fling","No sheriff",2) end
function Fling.all() for _, pl in ipairs(Players:GetPlayers()) do if pl ~= LocalPlayer and pl.Character then task.spawn(function() Fling.execute(pl) end) task.wait(0.5) end end end

-- ============================================================
--  COMBAT
-- ============================================================
local Combat = {}
function Combat.ensureGun()
    local ch = LocalPlayer.Character if not ch then return nil end
    local eq = ch:FindFirstChild("Gun") if eq then return eq end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    local tool = bp and bp:FindFirstChild("Gun") if not tool then return nil end
    local hum = ch:FindFirstChildOfClass("Humanoid") if not hum then return nil end
    pcall(function() hum:EquipTool(tool) end)
    local deadline = tick() + 0.6
    while tick() < deadline do
        eq = ch:FindFirstChild("Gun") if eq then return eq end
        task.wait(0.05)
    end
    return ch:FindFirstChild("Gun")
end
function Combat.getTargetVelocity(target)
    if not target or not target.Character then return Vector3.new(0,0,0), false end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    local hum = target.Character:FindFirstChildOfClass("Humanoid")
    if not hrp then return Vector3.new(0,0,0), false end
    local vel = hrp.AssemblyLinearVelocity or Vector3.new(0,0,0)
    local airborne = false
    if hum then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.FallingDown then airborne = true end
        if state == Enum.HumanoidStateType.Jumping and math.abs(vel.Y) < 5 then
            vel = Vector3.new(vel.X, hum.JumpPower or 50, vel.Z)
        end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0.1 then
            local ws = hum.WalkSpeed or 16
            local horiz = Vector3.new(vel.X, 0, vel.Z)
            if horiz.Magnitude < ws * 0.5 then
                vel = Vector3.new(moveDir.X * ws, vel.Y, moveDir.Z * ws)
            end
        end
    end
    return vel, airborne
end
function Combat.predict(target)
    if not target or not target.Character then return Vector3.new(0,0,0) end
    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return Vector3.new(0,0,0) end
    local vel, airborne = Combat.getTargetVelocity(target)
    local ping = 0
    pcall(function() ping = LocalPlayer:GetNetworkPing() or 0 end)
    if type(ping) ~= "number" then ping = 0 end
    if ping > 1 then ping = ping/1000 end
    local t = (S.aimbotV2Enabled and (0.028 + ping*1.8) or (0.028 + ping + S.predictionMs/1000))
    local pred = hrp.Position + vel * t
    if airborne then
        local g = workspace.Gravity or 196.2
        pred = pred + Vector3.new(0, -0.5 * g * t * t, 0)
    end
    return pred
end
function Combat.shootMurderer()
    if not LocalPlayer or not LocalPlayer.Character then return end
    local target = Roles.getMurderer()
    if not target or not target.Character then notify("Shoot","No murderer",2) return end
    local mHrp = target.Character:FindFirstChild("HumanoidRootPart")
    local lHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not mHrp or not lHrp then return end
    local gun = Combat.ensureGun()
    if not gun then notify("Shoot","No gun in inventory",2) return end
    local predPos = S.predictionEnabled and Combat.predict(target) or mHrp.Position
    if S.wallbangEnabled then
        local ks = gun:FindFirstChild("KnifeServer")
        if ks then
            local sg = ks:FindFirstChild("ShootGun")
            if sg then
                local r = sg:FindFirstChildOfClass("RemoteFunction") or sg:FindFirstChildOfClass("RemoteEvent")
                if r then
                    pcall(function()
                        if r:IsA("RemoteFunction") then r:InvokeServer(predPos, "AH2")
                        else r:FireServer(predPos, "AH2") end
                    end)
                    return
                end
            end
        end
        local sr = gun:FindFirstChild("Shoot")
        if sr then pcall(function() sr:FireServer(lHrp.CFrame, CFrame.new(predPos)) end) return end
        return
    end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {LocalPlayer.Character, target.Character}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local ok, res = pcall(function() return workspace:Raycast(lHrp.Position, mHrp.Position - lHrp.Position, rp) end)
    local clear = not ok or not res
    if not clear and res and res.Instance then
        if not res.Instance.CanCollide or res.Instance.Transparency >= 0.9 then clear = true end
    end
    if not clear then return end
    local knifeLocal = gun:FindFirstChild("KnifeLocal")
    local createBeam = knifeLocal and knifeLocal:FindFirstChild("CreateBeam")
    local rf = createBeam and createBeam:FindFirstChildOfClass("RemoteFunction")
    if rf then pcall(function() rf:InvokeServer(1, predPos, "AH2") end) end
end

task.spawn(function()
    while true do
        pcall(function() if S.autoShootEnabled and Roles.getSheriff() == LocalPlayer then Combat.shootMurderer() end end)
        task.wait(0.1)
    end
end)

-- ============================================================
--  KILL / SILENT THROW
-- ============================================================
local Kill = {}
function Kill.killAll()
    local ch = LocalPlayer.Character if not ch then return end
    local knife = ch:FindFirstChild("Knife")
    if not knife then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then local k = bp:FindFirstChild("Knife") if k then k.Parent = ch knife = k end end
    end
    if not knife then return end
    local events = knife:FindFirstChild("Events") if not events then return end
    local ht = events:FindFirstChild("HandleTouched") if not ht then return end
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local p = pl.Character:FindFirstChild("HumanoidRootPart")
            if p then pcall(function() ht:FireServer(p) end) task.wait(S.killAllDelay) end
        end
    end
end
function Kill.equip()
    local ch = LocalPlayer.Character if not ch then return end
    if ch:FindFirstChild("Knife") then return end
    local k = LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife")
    if k then k.Parent = ch end
end
function Kill.silentThrow()
    local ch = LocalPlayer.Character
    local knife = ch and ch:FindFirstChild("Knife")
    if not knife then
        local bp = LocalPlayer:FindFirstChild("Backpack")
        knife = bp and bp:FindFirstChild("Knife")
        if knife then
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum then pcall(function() hum:EquipTool(knife) end) task.wait(0.1) end
            knife = ch:FindFirstChild("Knife")
        end
    end
    if not knife or not knife:FindFirstChild("Throw") then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart") if not hrp then return end
    local myPos = hrp.Position
    local best, bestDist
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LocalPlayer and pl.Character then
            local hum = pl.Character:FindFirstChildOfClass("Humanoid")
            local er = pl.Character:FindFirstChild("HumanoidRootPart")
            if hum and hum.Health > 0 and er then
                local d = (myPos - er.Position).Magnitude
                if not bestDist or d < bestDist then best = pl bestDist = d end
            end
        end
    end
    if not best then return end
    local tHrp = best.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end
    local vel = tHrp.AssemblyLinearVelocity or Vector3.new(0,0,0)
    local throwSpeed = 100
    local travel = bestDist / throwSpeed
    local aimPos = tHrp.Position + vel * travel
    pcall(function() knife.Throw:FireServer(CFrame.new(myPos, aimPos), aimPos) end)
end
task.spawn(function()
    while true do
        pcall(function()
            if S.knifeAuraEnabled then
                local ch = LocalPlayer.Character
                local knife = ch and ch:FindFirstChild("Knife")
                if knife then
                    local events = knife:FindFirstChild("Events")
                    local ht = events and events:FindFirstChild("HandleTouched")
                    local hrp = ch:FindFirstChild("HumanoidRootPart")
                    if ht and hrp then
                        for _, pl in ipairs(Players:GetPlayers()) do
                            if pl ~= LocalPlayer and pl.Character then
                                local hum = pl.Character:FindFirstChildOfClass("Humanoid")
                                local er = pl.Character:FindFirstChild("HumanoidRootPart")
                                if hum and hum.Health > 0 and er and (er.Position - hrp.Position).Magnitude <= S.knifeAuraRadius then
                                    pcall(function() ht:FireServer(er) end)
                                end
                            end
                        end
                    end
                end
            end
        end)
        task.wait(0.1)
    end
end)
task.spawn(function()
    while true do
        pcall(function() if S.silentThrowEnabled and Roles.getMurderer() == LocalPlayer then Kill.silentThrow() end end)
        task.wait(0.8)
    end
end)

-- ============================================================
--  MOVEMENT
-- ============================================================
local Move = {}
function Move.apply()
    local ch = LocalPlayer.Character if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid") if not hum then return end
    hum.WalkSpeed = S.walkSpeedValue
    hum.JumpPower = S.jumpPowerValue
end
function Move.noclip(enable)
    S.noclipEnabled = enable
    if enable then
        if S.noclipConn then S.noclipConn:Disconnect() end
        S.noclipConn = RunService.Stepped:Connect(function()
            local c = LocalPlayer.Character if not c then return end
            for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
        end)
    else
        if S.noclipConn then S.noclipConn:Disconnect() S.noclipConn = nil end
    end
end
function Move.infJump(enable)
    S.infJumpEnabled = enable
    if enable then
        if S.infJumpConn then S.infJumpConn:Disconnect() end
        S.infJumpConn = UserInputService.JumpRequest:Connect(function()
            local ch = LocalPlayer.Character
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    else
        if S.infJumpConn then S.infJumpConn:Disconnect() S.infJumpConn = nil end
    end
end
RunService.Stepped:Connect(function()
    if S.antiFlingEnabled then
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LocalPlayer and pl.Character then
                for _, d in ipairs(pl.Character:GetDescendants()) do
                    if d:IsA("BasePart") and d.CanCollide then
                        d.CanCollide = false
                        if d.Name == "HumanoidRootPart" then
                            d.Velocity = Vector3.new(0,0,0) d.RotVelocity = Vector3.new(0,0,0)
                        end
                    end
                end
            end
        end
    end
end)
RunService.Stepped:Connect(function() Move.apply() end)

-- ============================================================
--  JUMPS
-- ============================================================
local Jumps = {}
function Jumps.bomb()
    if S.bombJumpCooldown then return end
    local ch = LocalPlayer.Character if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.FloorMaterial == Enum.Material.Air then return end
    S.bombJumpCooldown = true
    local e = Instance.new("Explosion")
    e.Position = hrp.Position - Vector3.new(0,2.5,0)
    e.BlastRadius = S.bombJumpRadius e.BlastPressure = 0
    e.DestroyJointRadiusPercent = 0 e.Parent = workspace
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(hrp.AssemblyLinearVelocity.X * 0.6, S.bombJumpPower, hrp.AssemblyLinearVelocity.Z * 0.6)
    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge) bv.P = math.huge bv.Parent = hrp
    task.delay(0.08, function() bv:Destroy() end)
    task.delay(0.6, function() S.bombJumpCooldown = false end)
end
function Jumps.gold()
    if S.goldJumpCooldown then return end
    local ch = LocalPlayer.Character if not ch then return end
    local hrp = ch:FindFirstChild("HumanoidRootPart")
    local hum = ch:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    S.goldJumpCooldown = true
    local look = CurrentCamera.CFrame.LookVector
    local lat = Vector3.new(look.X, 0, look.Z)
    if lat.Magnitude > 0 then lat = lat.Unit else lat = Vector3.new(0,0,-1) end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(lat.X * S.goldJumpPower * 0.6, S.goldJumpPower, lat.Z * S.goldJumpPower * 0.6)
    bv.MaxForce = Vector3.new(math.huge,math.huge,math.huge) bv.P = math.huge bv.Parent = hrp
    hum:ChangeState(Enum.HumanoidStateType.Jumping)
    task.delay(0.12, function() bv:Destroy() end)
    task.delay(S.goldJumpCooldownTime, function() S.goldJumpCooldown = false end)
end
LocalPlayer.CharacterAdded:Connect(function()
    S.goldJumpCooldown = false S.bombJumpCooldown = false S.lastKnownPositions = {}
end)

-- ============================================================
--  INVISIBILITY + FAKE SPEEDGLITCH
-- ============================================================
local function toggleInvis(on)
    S.invisEnabled = on
    local ch = LocalPlayer.Character if not ch then return end
    for _, obj in ipairs(ch:GetChildren()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            obj.Transparency = on and 1 or 0
        end
        if obj:IsA("Accessory") then
            local h = obj:FindFirstChild("Handle")
            if h then h.Transparency = on and 1 or 0 end
        end
        if obj.Name == "Head" then
            local face = obj:FindFirstChildOfClass("Decal")
            if face then face.Transparency = on and 1 or 0 end
        end
    end
    notify("Invisibility", on and "Enabled" or "Disabled", 2)
end
task.spawn(function()
    while true do
        if S.speedGlitchEnabled then
            local ch = LocalPlayer.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.MoveDirection.Magnitude > 0.1 then
                hrp.CFrame = hrp.CFrame + hum.MoveDirection.Unit * S.speedGlitchPower
            end
        end
        task.wait(0.08)
    end
end)

-- ============================================================
--  GRAB GUN
-- ============================================================
local Grab = {}
function Grab.update()
    S.activeGunDrops = {}
    for _, name in ipairs(S.mapNames) do
        local node = workspace:FindFirstChild(name)
        if node then local gd = node:FindFirstChild("GunDrop") if gd then table.insert(S.activeGunDrops, gd) end end
    end
    local gd = workspace:FindFirstChild("GunDrop")
    if gd then table.insert(S.activeGunDrops, gd) end
end
function Grab.gun()
    Grab.update()
    if #S.activeGunDrops == 0 then notify("Grab","No guns",2) return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if not hrp then return end
    local best, bestD = nil, math.huge
    for _, gd in ipairs(S.activeGunDrops) do
        local d = (hrp.Position - gd.Position).Magnitude
        if d < bestD then best = gd bestD = d end
    end
    if not best then return end
    local orig = hrp.CFrame
    hrp.CFrame = best.CFrame
    task.wait(0.3)
    local pp = best:FindFirstChildOfClass("ProximityPrompt")
    if pp then pcall(function() fireproximityprompt(pp) end) task.wait(0.15) end
    hrp.CFrame = orig
    notify("Grab","Gun grabbed",2)
end
task.spawn(function()
    while true do
        if S.autoGrabEnabled then Grab.gun() end
        task.wait(S.gunDropCheckInterval)
    end
end)

-- ============================================================
--  FARM
-- ============================================================
local Farm = {}
function Farm.getRoot() return (LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart") end
function Farm.nearestCoin()
    local root = Farm.getRoot()
    local best, bestD = nil, math.huge
    for _, c in pairs(workspace:GetChildren()) do
        if c:FindFirstChild("CoinContainer") then
            for _, coin in pairs(c.CoinContainer:GetChildren()) do
                if coin:IsA("BasePart") and coin:FindFirstChild("TouchInterest") then
                    local d = (root.Position - coin.Position).Magnitude
                    if d < bestD then best = coin bestD = d end
                end
            end
        end
    end
    return best, bestD
end
function Farm.nearestCandy()
    local root = Farm.getRoot()
    local best, bestD = nil, math.huge
    for _, c in pairs(workspace:GetChildren()) do
        if c:FindFirstChild("CoinContainer") then
            for _, coin in pairs(c.CoinContainer:GetChildren()) do
                if coin:IsA("BasePart") and coin:GetAttribute("CoinID") == "Candy" and coin:FindFirstChild("TouchInterest") then
                    local d = (root.Position - coin.Position).Magnitude
                    if d < bestD then best = coin bestD = d end
                end
            end
        end
    end
    return best, bestD
end
do
    local remG = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Gameplay")
    local remCoin = remG and remG:FindFirstChild("CoinCollected")
    local remStart = remG and remG:FindFirstChild("RoundStart")
    local remEnd = remG and remG:FindFirstChild("RoundEndFade")
    if remStart then remStart.OnClientEvent:Connect(function() S.roundActive = true S.roundReturnPos = Farm.getRoot().CFrame end) end
    if remEnd then remEnd.OnClientEvent:Connect(function() S.roundActive = false end) end
    task.spawn(function()
        while true do
            if (S.coinFarmEnabled or S.candyFarmEnabled) and S.roundActive then
                local target, dist
                if S.candyFarmEnabled then target, dist = Farm.nearestCandy()
                elseif S.coinFarmEnabled then target, dist = Farm.nearestCoin() end
                if target then
                    local root = Farm.getRoot()
                    if dist > 150 then root.CFrame = target.CFrame
                    else
                        local tw = TweenService:Create(root, TweenInfo.new(dist/S.FARM_SPEED, Enum.EasingStyle.Linear), {CFrame = target.CFrame})
                        tw:Play() tw.Completed:Wait()
                    end
                end
            end
            task.wait(0.2)
        end
    end)
    if remCoin then
        remCoin.OnClientEvent:Connect(function(kind, amount)
            if kind ~= "Candy" then return end
            S.candyCount = amount
            if S.candyCount < S.bagCap then return end
            S.candyFarmEnabled = false S.coinFarmEnabled = false
            if S.autoFlingOnFull then task.spawn(Fling.murderer) end
            if S.autoResetEnabled then
                task.spawn(function()
                    if S.roundReturnPos then
                        local tw = TweenService:Create(Farm.getRoot(), TweenInfo.new(2, Enum.EasingStyle.Linear), {CFrame = S.roundReturnPos})
                        tw:Play() tw.Completed:Wait()
                    end
                    task.wait(0.5)
                    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
                end)
            end
        end)
    end
end

-- ============================================================
--  ESP — single source of truth, no auto-enable on load
--  Clears all ESP overlays when disabled so they don't persist.
-- ============================================================
local function clearAllESP()
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then
            local hl = pl.Character:FindFirstChild("RoleHighlight")
            if hl then hl:Destroy() end
            local head = pl.Character:FindFirstChild("Head")
            if head then
                local esp = head:FindFirstChild("RoleESP")
                if esp then esp:Destroy() end
            end
        end
    end
    for _, desc in ipairs(workspace:GetDescendants()) do
        if desc.Name == "GunHL" then desc:Destroy() end
    end
end

task.spawn(function()
    while true do
        pcall(function()
            if not S.espEnabled then
                -- ESP is off — make sure no stale highlights remain
                -- (clearAllESP is called on toggle, but guard here too)
            else
                local m = Roles.getMurderer() local s = Roles.getSheriff()
                local lHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl ~= LocalPlayer and pl.Character then
                        local hum = pl.Character:FindFirstChild("Humanoid")
                        local head = pl.Character:FindFirstChild("Head")
                        if hum and hum.Health > 0 then
                            local role = "Innocent"
                            if pl == m then role = "Murderer" elseif pl == s then role = "Sheriff" end
                            local show = false
                            if S.espMode == "All" then show = true
                            elseif S.espMode == "Sheriff" then show = (role == "Sheriff")
                            elseif S.espMode == "Murder" then show = (role == "Murderer")
                            elseif S.espMode == "Both" then show = (role == "Sheriff" or role == "Murderer") end
                            local col = role == "Murderer" and Color3.fromRGB(230,50,50) or (role == "Sheriff" and Color3.fromRGB(30,144,255) or Color3.fromRGB(90,220,120))
                            if show then
                                local hl = pl.Character:FindFirstChild("RoleHighlight")
                                if not hl then
                                    hl = Instance.new("Highlight") hl.Name = "RoleHighlight"
                                    hl.FillTransparency = 0.5 hl.OutlineTransparency = 1
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Adornee = pl.Character hl.Parent = pl.Character
                                end
                                hl.FillColor = col
                                if S.espShowNames and head then
                                    local esp = head:FindFirstChild("RoleESP")
                                    if not esp then
                                        esp = Instance.new("BillboardGui") esp.Name = "RoleESP"
                                        esp.Size = UDim2.new(0,140,0,40) esp.StudsOffset = Vector3.new(0,3,0)
                                        esp.AlwaysOnTop = true esp.Parent = head
                                        local tl = Instance.new("TextLabel") tl.Name = "T"
                                        tl.Size = UDim2.new(1,0,1,0) tl.BackgroundTransparency = 1
                                        tl.Font = Enum.Font.GothamBold tl.TextSize = 14
                                        tl.TextStrokeTransparency = 0 tl.Parent = esp
                                    end
                                    local dist = "?"
                                    if S.espShowDistance and lHrp then
                                        local er = pl.Character:FindFirstChild("HumanoidRootPart")
                                        if er then dist = tostring(math.floor((lHrp.Position - er.Position).Magnitude)) end
                                    end
                                    esp.T.Text = S.espShowDistance and (pl.Name.."\n["..role.."] ["..dist.."]") or (pl.Name.."\n["..role.."]")
                                    esp.T.TextColor3 = col
                                end
                            else
                                local hl = pl.Character:FindFirstChild("RoleHighlight") if hl then hl:Destroy() end
                                if head and head:FindFirstChild("RoleESP") then head.RoleESP:Destroy() end
                            end
                        end
                    end
                end
            end
            if S.gunEspEnabled then
                for _, desc in ipairs(workspace:GetDescendants()) do
                    if desc.Name == "GunDrop" and desc:IsA("BasePart") and not desc:FindFirstChild("GunHL") then
                        local hl = Instance.new("Highlight") hl.Name = "GunHL"
                        hl.FillColor = Color3.fromRGB(0,255,255)
                        hl.FillTransparency = 0.4 hl.Adornee = desc hl.Parent = desc
                    end
                end
            end
        end)
        task.wait(1)
    end
end)

-- ============================================================
--  NOTIFY LOOPS
-- ============================================================
workspace.DescendantAdded:Connect(function(desc)
    if not S.notifyGunDrop then return end
    if desc.Name == "GunDrop" and desc:IsA("BasePart") then
        if S.lastNotifiedGun == desc then return end
        S.lastNotifiedGun = desc
        notify("Gun Dropped","A gun was dropped",5)
    end
end)
local function updateRoleNotify()
    if S.roleMonitorTask then task.cancel(S.roleMonitorTask) S.roleMonitorTask = nil end
    if not S.notifyMurderer and not S.notifySheriff then return end
    S.roleMonitorTask = task.spawn(function()
        while S.notifyMurderer or S.notifySheriff do
            local ok, sec = pcall(function() return ReplicatedStorage.Remotes.Extras.GetTimer:InvokeServer() end)
            if not ok or (type(sec) == "number" and sec <= 1) then
                S.notifiedMurd = false S.notifiedSher = false
            elseif ok and sec > 1 then
                if S.notifyMurderer and not S.notifiedMurd then
                    local p = Roles.getMurderer()
                    if p then S.notifiedMurd = true notify("Murderer",p.Name,8) end
                end
                if S.notifySheriff and not S.notifiedSher then
                    local p = Roles.getSheriff()
                    if p then S.notifiedSher = true notify("Sheriff",p.Name,8) end
                end
            end
            task.wait(1)
        end
    end)
end

-- ============================================================
--  MISC
-- ============================================================
local Misc = {}
function Misc.rejoin() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end
function Misc.serverHop()
    local url = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
    local ok, raw = pcall(function() return game:HttpGet(url) end)
    if not ok then return end
    local ok2, res = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok2 and res and res.data then
        for _, sv in ipairs(res.data) do
            if sv.id ~= game.JobId and sv.playing < sv.maxPlayers then
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, sv.id, LocalPlayer) end)
                return
            end
        end
    end
end
function Misc.chatRoles()
    local m = Roles.getMurderer() local s = Roles.getSheriff()
    local msg = "QuantomHub >> Murderer: "..(m and m.Name or "?").." | Sheriff: "..(s and s.Name or "?")
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local chan = TextChatService:FindFirstChild("TextChannels")
            if chan and chan:FindFirstChild("RBXGeneral") then chan.RBXGeneral:SendAsync(msg) end
        else
            local es = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if es then es.SayMessageRequest:FireServer(msg, "Normal") end
        end
    end)
end

-- ============================================================
--  ANIM PACKS
-- ============================================================
local AnimPacks = {
    {name="Robot",     thumb="rbxthumb://type=Asset&id=616111295&w=150&h=150",
     idle="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616117076",
     jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713"},
    {name="Zombie",    thumb="rbxthumb://type=Asset&id=616088211&w=150&h=150",
     idle="rbxassetid://616158929", walk="rbxassetid://616168032", run="rbxassetid://616163682",
     jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119"},
    {name="Ninja",     thumb="rbxthumb://type=Asset&id=656117400&w=150&h=150",
     idle="rbxassetid://656117400", walk="rbxassetid://656118852", run="rbxassetid://656118050",
     jump="rbxassetid://656117878", fall="rbxassetid://656117686", climb="rbxassetid://656118341"},
    {name="Superhero", thumb="rbxthumb://type=Asset&id=750781874&w=150&h=150",
     idle="rbxassetid://750781874", walk="rbxassetid://750782230", run="rbxassetid://750782797",
     jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899"},
    {name="Cartoon",   thumb="rbxthumb://type=Asset&id=742637544&w=150&h=150",
     idle="rbxassetid://742637544", walk="rbxassetid://742638445", run="rbxassetid://742638842",
     jump="rbxassetid://742637942", fall="rbxassetid://742637151", climb="rbxassetid://742636889"},
    {name="Astronaut", thumb="rbxthumb://type=Asset&id=891621366&w=150&h=150",
     idle="rbxassetid://891621366", walk="rbxassetid://891667153", run="rbxassetid://891636393",
     jump="rbxassetid://891627522", fall="rbxassetid://891609353", climb="rbxassetid://891617961"},
    {name="Stylish",   thumb="rbxthumb://type=Asset&id=616136790&w=150&h=150",
     idle="rbxassetid://616136790", walk="rbxassetid://616140816", run="rbxassetid://616147040",
     jump="rbxassetid://616133594", fall="rbxassetid://616130104", climb="rbxassetid://616125130"},
    {name="Elder",     thumb="rbxthumb://type=Asset&id=845397899&w=150&h=150",
     idle="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501",
     jump="rbxassetid://845398858", fall="rbxassetid://845386501", climb="rbxassetid://845391502"},
}
local function loadAnimPack(pack)
    local ch = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hum = ch:WaitForChild("Humanoid", 5) if not hum then return end
    local animateScript = ch:FindFirstChild("Animate")
    if not animateScript then notify("Animation","No Animate script",3) return end
    local map = {idle=pack.idle, walk=pack.walk, run=pack.run, jump=pack.jump, fall=pack.fall, climb=pack.climb}
    for folderName, animId in pairs(map) do
        local folder = animateScript:FindFirstChild(folderName)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do
                if child:IsA("Animation") then child.AnimationId = animId end
            end
        end
    end
    pcall(function() animateScript.Disabled = true task.wait(0.1) animateScript.Disabled = false end)
    notify("Animation", pack.name .. " loaded", 3)
end
local function stopAnims()
    local ch = LocalPlayer.Character if not ch then return end
    local hum = ch:FindFirstChildOfClass("Humanoid") if not hum then return end
    local anim = hum:FindFirstChildOfClass("Animator")
    if anim then for _, tr in ipairs(anim:GetPlayingAnimationTracks()) do tr:Stop(0) end end
end

-- ============================================================
--  RELAUNCH
-- ============================================================
local function relaunch()
    local reload = getgenv().__QUANTOM_RELOAD
    ScreenGui:Destroy()
    task.wait(0.2)
    if reload then pcall(reload) else notify("Relaunch","Set __QUANTOM_RELOAD",4) end
end

-- ============================================================
--  BUILD TABS
-- ============================================================
local mainTab = UI:CreateTab("tab_main", "rbxassetid://10723407389")
mainTab:Section("sec_general")
mainTab:Button("copy_discord", function() clipboard(S.DISCORD_URL) notify("Discord",T("copied"),3) end)
mainTab:Button("copy_key", function() clipboard(S.KEYGEN_URL) notify("Key",T("copied"),3) end)

local combatTab = UI:CreateTab("tab_combat", "rbxassetid://10709818148")
combatTab:Section("sec_shoot")
combatTab:Toggle("std_pred", true, function(v) S.predictionEnabled = v end)
combatTab:Slider("manual_pred", 0, 200, 0, 1, function(v) S.predictionMs = v end)
combatTab:Toggle("aim_v2", false, function(v) S.aimbotV2Enabled = v end)
combatTab:Toggle("resolver", false, function(v) S.resolverEnabled = v end)
combatTab:Toggle("wallbang_toggle", false, function(v) S.wallbangEnabled = v end)
combatTab:Toggle("auto_shoot", false, function(v) S.autoShootEnabled = v end)
combatTab:Button("shoot_now", function() task.spawn(Combat.shootMurderer) end)
combatTab:Keybind("shoot_key", Enum.KeyCode.F, function(k) S.Keybinds.ShootMurder = k end)
combatTab:Section("sec_murderer")
combatTab:Toggle("kill_all", false, function(v)
    S.killAllActive = v
    if v then task.spawn(function() while S.killAllActive do Kill.killAll() task.wait(S.killAllDelay) end end) end
end)
combatTab:Slider("attack_delay", 5, 200, 50, 5, function(v) S.killAllDelay = v/100 end)
combatTab:Button("equip_knife", Kill.equip)
combatTab:Toggle("knife_aura", false, function(v) S.knifeAuraEnabled = v end)
combatTab:Slider("aura_radius", 5, 100, 10, 1, function(v) S.knifeAuraRadius = v end)
combatTab:Toggle("silent_throw", false, function(v) S.silentThrowEnabled = v end)
combatTab:Button("throw_now", function() task.spawn(Kill.silentThrow) end)
combatTab:Section("sec_innocent")
combatTab:Toggle("auto_grab", false, function(v) S.autoGrabEnabled = v end)
combatTab:Button("grab_now", function() task.spawn(Grab.gun) end)

local farmTab = UI:CreateTab("tab_autofarm", "rbxassetid://10723345518")
farmTab:Section("sec_farm")
farmTab:Toggle("coin_farm", false, function(v) S.coinFarmEnabled = v end)
farmTab:Toggle("candy_farm", false, function(v) S.candyFarmEnabled = v end)
farmTab:Toggle("auto_reset", false, function(v) S.autoResetEnabled = v end)
farmTab:Toggle("auto_fling_m", false, function(v) S.autoFlingOnFull = v end)

local tpTab = UI:CreateTab("tab_teleport", "rbxassetid://10723406941")
tpTab:Section("sec_roles")
tpTab:Button("tp_m", function()
    local m = Roles.getMurderer() if not m or not m.Character then return end
    local h = m.Character:FindFirstChild("HumanoidRootPart")
    local mh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if h and mh then mh.CFrame = h.CFrame end
end)
tpTab:Button("tp_s", function()
    local s = Roles.getSheriff() if not s or not s.Character then return end
    local h = s.Character:FindFirstChild("HumanoidRootPart")
    local mh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if h and mh then mh.CFrame = h.CFrame end
end)
tpTab:Section("sec_players")
local function pList()
    local l = {}
    for _, pl in pairs(Players:GetPlayers()) do if pl ~= LocalPlayer then table.insert(l, pl.Name) end end
    if #l == 0 then table.insert(l, "-") end
    return l
end
local tpDrop = tpTab:Dropdown("select_pl", pList(), pList()[1], function(v) S.selectedPlayer = Players:FindFirstChild(v) end)
tpTab:Button("tp_pl", function()
    if S.selectedPlayer and S.selectedPlayer.Character then
        local h = S.selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        local m = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if h and m then m.CFrame = h.CFrame end
    end
end)
tpTab:Button("refresh", function() tpDrop.Refresh(pList()) end)

local trollTab = UI:CreateTab("tab_troll", "rbxassetid://10709771831")
trollTab:Section("sec_movement")
trollTab:Slider("walk_speed", 0, 200, 16, 1, function(v) S.walkSpeedValue = v end)
trollTab:Slider("jump_power", 0, 200, 50, 1, function(v) S.jumpPowerValue = v end)
trollTab:Toggle("noclip", false, Move.noclip)
trollTab:Toggle("inf_jump", false, Move.infJump)
trollTab:Toggle("anti_fling", false, function(v) S.antiFlingEnabled = v end)
trollTab:Toggle("invis", false, toggleInvis)
trollTab:Toggle("fake_glitch", false, function(v) S.speedGlitchEnabled = v end)
trollTab:Slider("glitch_power", 2, 20, 6, 1, function(v) S.speedGlitchPower = v end)
trollTab:Section("sec_camera")
trollTab:Slider("fov", 50, 120, 70, 1, function(v) S.currentFov = v CurrentCamera.FieldOfView = v end)
trollTab:Section("sec_bombjump")
trollTab:Toggle("bombjump enable", false, function(v) S.bombJumpEnabled = v end)
trollTab:Slider("bomb power", 40, 400, 120, 5, function(v) S.bombJumpPower = v end)
trollTab:Section("sec_goldjump")
trollTab:Toggle("goldjump enable", false, function(v) S.goldJumpEnabled = v end)
trollTab:Slider("gold power", 20, 300, 80, 5, function(v) S.goldJumpPower = v end)

local animTab = UI:CreateTab("tab_anims", "rbxassetid://7743871001")
animTab:Section("sec_packs")
for _, pack in ipairs(AnimPacks) do
    animTab:AnimCard(pack.name, pack.thumb, function() loadAnimPack(pack) end)
end
animTab:Button("stop_anim", stopAnims)

local flingTab = UI:CreateTab("tab_fling", "rbxassetid://10734898355")
flingTab:Section("sec_byrole")
flingTab:Button("fling_m", function() task.spawn(Fling.murderer) end)
flingTab:Button("fling_s", function() task.spawn(Fling.sheriff) end)
flingTab:Button("fling_all", function() task.spawn(Fling.all) end)
flingTab:Section("sec_byplayer")
local flingDrop = flingTab:Dropdown("select_pl", pList(), pList()[1], function(v) S.selectedFlingPlayer = Players:FindFirstChild(v) end)
flingTab:Button("refresh", function() flingDrop.Refresh(pList()) end)

local visualsTab = UI:CreateTab("tab_visuals", "rbxassetid://10734943699")
visualsTab:Section("sec_esp")
-- ESP toggle: default=false, callback is the single authority for S.espEnabled
visualsTab:Toggle("enable_esp", false, function(v)
    S.espEnabled = v
    if not v then
        -- explicit clear on disable so highlights don't stick
        clearAllESP()
    end
end)
visualsTab:Dropdown("esp_mode", {"All","Sheriff","Murder","Both"}, "All", function(v) S.espMode = v end)
visualsTab:Toggle("show_names", true, function(v) S.espShowNames = v end)
visualsTab:Toggle("show_dist", true, function(v) S.espShowDistance = v end)
visualsTab:Toggle("gun_esp", false, function(v)
    S.gunEspEnabled = v
    if not v then
        for _, desc in ipairs(workspace:GetDescendants()) do
            if desc.Name == "GunHL" then desc:Destroy() end
        end
    end
end)
visualsTab:Section("sec_notif")
visualsTab:Toggle("notif_murd", false, function(v) S.notifyMurderer = v updateRoleNotify() end)
visualsTab:Toggle("notif_sher", false, function(v) S.notifySheriff = v updateRoleNotify() end)
visualsTab:Toggle("notif_gun", false, function(v) S.notifyGunDrop = v end)
visualsTab:Section("sec_chat")
visualsTab:Button("expose_roles", Misc.chatRoles)

local settingsTab = UI:CreateTab("tab_settings", "rbxassetid://10734950309")
settingsTab:Section("sec_lang")
settingsTab:Dropdown("language", {"English","Русский"}, "English", function(v)
    LANG = (v == "Русский") and "RU" or "EN"
    retranslate()
end)
-- cursor picker — 4 options: Default + 3 osu! cursors
settingsTab:Section("cursor_label")
local cursorNames = {}
for _, c in ipairs(CURSORS) do table.insert(cursorNames, c.name) end
settingsTab:Dropdown("cursor_label", cursorNames, "Default", function(v)
    for i, c in ipairs(CURSORS) do
        if c.name == v then applyCursor(i) break end
    end
end)
settingsTab:Section("sec_keybinds")
settingsTab:Keybind("toggle_menu", Enum.KeyCode.RightControl, function(k) S.Keybinds.ToggleUI = k end)
settingsTab:Section("sec_session")
settingsTab:Button("rejoin", Misc.rejoin)
settingsTab:Button("relaunch", relaunch)
settingsTab:Button("unload", function() ScreenGui:Destroy() end)

local serverTab = UI:CreateTab("tab_server", "rbxassetid://10723415244")
serverTab:Section("sec_actions")
serverTab:Button("rejoin", Misc.rejoin)
serverTab:Button("server_hop", Misc.serverHop)

-- ============================================================
--  INPUT
-- ============================================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == S.Keybinds.ToggleUI then
        local nowVisible = not Root.Visible
        Root.Visible = nowVisible
        -- if we just hid the root via keybind, show the floating restore button
        if not nowVisible then
            MinimizedBtn.Visible = true
        else
            MinimizedBtn.Visible = false
        end
    elseif input.KeyCode == S.Keybinds.ShootMurder then task.spawn(Combat.shootMurderer)
    elseif input.KeyCode == S.Keybinds.GrabGun then task.spawn(Grab.gun)
    elseif input.KeyCode == S.Keybinds.KillAll then S.killAllActive = not S.killAllActive
        if S.killAllActive then task.spawn(function() while S.killAllActive do Kill.killAll() task.wait(S.killAllDelay) end end) end
    elseif input.KeyCode == S.Keybinds.FlingMurderer then task.spawn(Fling.murderer)
    elseif input.KeyCode == S.Keybinds.BombJump then if S.bombJumpEnabled then task.spawn(Jumps.bomb) end
    elseif input.KeyCode == S.Keybinds.GoldJump then if S.goldJumpEnabled then task.spawn(Jumps.gold) end
    elseif input.KeyCode == S.Keybinds.TeleportMurderer then
        local m = Roles.getMurderer()
        if m and m.Character then
            local h = m.Character:FindFirstChild("HumanoidRootPart")
            local mh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if h and mh then mh.CFrame = h.CFrame end
        end
    elseif input.KeyCode == S.Keybinds.TeleportSheriff then
        local s = Roles.getSheriff()
        if s and s.Character then
            local h = s.Character:FindFirstChild("HumanoidRootPart")
            local mh = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if h and mh then mh.CFrame = h.CFrame end
        end
    end
end)

-- Anti-AFK
pcall(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Activate first tab
if tabs[1] then
    tabs[1].btn.BackgroundColor3 = UI.COLORS.Accent
    tabs[1].btn.BackgroundTransparency = 0.15
    tabs[1].icon.ImageColor3 = UI.COLORS.Text
    tabs[1].label.TextColor3 = UI.COLORS.Text
    tabs[1].arrow.TextColor3 = UI.COLORS.Text
    tabs[1].arrow.Text = "⌄"
    tabs[1].page.Visible = true
    TitleBar.Text = T(tabs[1].nameKey)
    activeTab = tabs[1]
end

notify("QuantomHub", T("loaded"), 4)
