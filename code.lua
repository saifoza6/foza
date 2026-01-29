-- Solo Hunter Auto Redeem (Fixed & Toggle Version)
-- Tested for Delta Executor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local CODES = {
    "40KCCUTHANKS66",
    "TOTHEMOON",
    "35KCCUTHANKS33",
    "LOVETOBRAZIL",
    "WWWW",
    "30KCCU",
    "CLASSREROLL",
    "RESETMYSTATS",
    "THANKSFORTHELIKESGUYS",
    "RELEASE"
}

-- Variabel kontrol
local isRunning = false
local stopRequest = false

-- --- FUNGSI GUI ---

-- Hapus GUI lama jika ada (biar gak numpuk pas execute ulang)
if CoreGui:FindFirstChild("SoloHunterRedeem") then
    CoreGui.SoloHunterRedeem:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoloHunterRedeem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Frame Utama
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0.5, -100, 0, 50) -- Muncul di tengah atas
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(60, 60, 70)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Judul
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "Auto Redeem"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Status Label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 30)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Idle"
StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = MainFrame

-- Tombol Toggle ON/OFF
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 160, 0, 35)
ToggleButton.Position = UDim2.new(0.5, -80, 0, 55)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 65) -- Warna awal (OFF)
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 14
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Parent = MainFrame

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = ToggleButton

-- Fungsi Notifikasi (Muncul di kanan layar)
local function sendNotification(title, msg, isSuccess)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 250, 0, 60)
    NotifFrame.Position = UDim2.new(1, 260, 0.8, 0) -- Mulai dari luar layar kanan
    NotifFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ScreenGui
    
    local NCorner = Instance.new("UICorner")
    NCorner.CornerRadius = UDim.new(0, 8)
    NCorner.Parent = NotifFrame
    
    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(0, 4, 1, 0)
    Bar.BackgroundColor3 = isSuccess and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    Bar.BorderSizePixel = 0
    Bar.Parent = NotifFrame
    
    local NTitle = Instance.new("TextLabel")
    NTitle.Size = UDim2.new(1, -15, 0, 20)
    NTitle.Position = UDim2.new(0, 12, 0, 8)
    NTitle.BackgroundTransparency = 1
    NTitle.Text = title
    NTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    NTitle.TextSize = 14
    NTitle.Font = Enum.Font.GothamBold
    NTitle.TextXAlignment = Enum.TextXAlignment.Left
    NTitle.Parent = NotifFrame

    local NMsg = Instance.new("TextLabel")
    NMsg.Size = UDim2.new(1, -15, 0, 20)
    NMsg.Position = UDim2.new(0, 12, 0, 30)
    NMsg.BackgroundTransparency = 1
    NMsg.Text = msg
    NMsg.TextColor3 = Color3.fromRGB(200, 200, 200)
    NMsg.TextSize = 12
    NMsg.Font = Enum.Font.Gotham
    NMsg.TextXAlignment = Enum.TextXAlignment.Left
    NMsg.Parent = NotifFrame
    
    -- Animasi Masuk
    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -260, 0.8, 0)}):Play()
    
    -- Animasi Keluar
    task.delay(4, function()
        local out = TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 260, 0.8, 0)})
        out:Play()
        out.Completed:Wait()
        NotifFrame:Destroy()
    end)
end

-- --- LOGIC REDEEM ---

local function startRedeem()
    isRunning = true
    stopRequest = false
    
    -- Ubah tampilan tombol jadi ON
    ToggleButton.Text = "ON"
    TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
    
    local Remote
    
    -- Mencari remote dengan timeout (biar gak stuck loading selamanya)
    local success, _ = pcall(function()
        Remote = ReplicatedStorage:WaitForChild("RemoteServices", 2)
            and ReplicatedStorage.RemoteServices:WaitForChild("CodesService", 2)
            and ReplicatedStorage.RemoteServices.CodesService:WaitForChild("RF", 2)
            and ReplicatedStorage.RemoteServices.CodesService.RF:WaitForChild("RedeemCode", 2)
    end)
    
    if not Remote then
        StatusLabel.Text = "Error: Remote tidak ketemu!"
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        isRunning = false
        return
    end

    local successCount = 0
    
    for i, code in ipairs(CODES) do
        if stopRequest then
            StatusLabel.Text = "Diberhentikan!"
            break 
        end
        
        StatusLabel.Text = "Redeeming: " .. code .. " ("..i.."/"..#CODES..")"
        
        -- Eksekusi Remote
        pcall(function()
            Remote:InvokeServer(code)
        end)
        
        successCount = successCount + 1
        task.wait(0.2) -- Delay sedikit biar halus
    end

    -- Selesai atau Berhenti
    isRunning = false
    ToggleButton.Text = "OFF"
    TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
    
    if stopRequest then
        StatusLabel.Text = "Status: Berhenti"
    else
        StatusLabel.Text = "Status: Selesai!"
        -- Notif hanya muncul jika selesai semua tanpa di-stop
        sendNotification("SUKSES!", "Berhasil redeem " .. successCount .. " kode.", true)
    end
end

-- Event Handler Tombol
ToggleButton.MouseButton1Click:Connect(function()
    if isRunning then
        -- Jika sedang jalan, matikan (OFF)
        stopRequest = true
        ToggleButton.Text = "Stopping..."
        TweenService:Create(ToggleButton, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 150, 50)}):Play()
    else
        -- Jika mati, nyalakan (ON)
        task.spawn(startRedeem)
    end
end)
local RedeemedStore = DataStoreService:GetDataStore("RedeemedCodes_v1")

local function getRedeemed(userId)
	local ok, data = pcall(function()
		return RedeemedStore:GetAsync(tostring(userId))
	end)
	if not ok or type(data) ~= "table" then
		return {}
	end
	return data
end

local function setRedeemed(userId, redeemedTable)
	pcall(function()
		RedeemedStore:SetAsync(tostring(userId), redeemedTable)
	end)
end

RedeemCode.OnServerInvoke = function(player, code)
	if type(code) ~= "string" then
		return false, "Invalid input"
	end

	code = code:gsub("%s+", "") -- trim spasi

	if not VALID_CODES[code] then
		return false, "Code invalid/expired"
	end

	local redeemed = getRedeemed(player.UserId)
	if redeemed[code] then
		return false, "Already redeemed"
	end

	-- TODO: kasih reward di sini
	-- contoh: tambah gold, reroll, reset stats, dll

	redeemed[code] = true
	setRedeemed(player.UserId, redeemed)

	return true, "Redeemed"
end
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = NotifFrame

    local Accent = Instance.new("Frame")
    Accent.Size = UDim2.new(0, 4, 1, 0)
    Accent.BackgroundColor3 = success and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 100, 100)
    Accent.BorderSizePixel = 0
    Accent.Parent = NotifFrame

    local AccentCorner = Instance.new("UICorner")
    AccentCorner.CornerRadius = UDim.new(0, 10)
    AccentCorner.Parent = Accent

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -15, 0, 25)
    Title.Position = UDim2.new(0, 12, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Text = title
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = NotifFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -15, 0, 40)
    TextLabel.Position = UDim2.new(0, 12, 0, 28)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = text
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.TextSize = 12
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Top
    TextLabel.TextWrapped = true
    TextLabel.Parent = NotifFrame

    -- Animasi masuk
    local tweenIn = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 300, 0, 75)
    })
    tweenIn:Play()

    -- Animasi keluar setelah durasi
    task.wait(duration or 3)
    local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 0, 0, 10),
        Size = UDim2.new(0, 300, 0, 0)
    })
    tweenOut:Play()
    tweenOut.Completed:Wait()
    ScreenGui:Destroy()
end

-- Fungsi redeem code
local function redeemCode(code)
    local success, result = pcall(function()
        return ReplicatedStorage.RemoteServices.CodesService.RF.RedeemCode:InvokeServer(code)
    end)
    
    if success then
        createNotification("✓ Redeem Berhasil", "Kode: " .. code, 3, true)
        return true
    else
        createNotification("✗ Redeem Gagal", "Kode: " .. code .. " (Sudah digunakan/Invalid)", 3, false)
        return false
    end
end

-- Buat GUI utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SoloHunterRedeemGui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 120)
MainFrame.Position = UDim2.new(0.5, -110, 0, 10)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 90)
UIStroke.Thickness = 1
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local BottomFix = Instance.new("Frame")
BottomFix.Size = UDim2.new(1, 0, 0, 12)
BottomFix.Position = UDim2.new(0, 0, 1, -12)
BottomFix.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
BottomFix.BorderSizePixel = 0
BottomFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Solo Hunter Redeem"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -33, 0, 2.5)
CloseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
CloseButton.Text = "×"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.Position = UDim2.new(0, 10, 0, 45)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Status: Siap"
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.TextSize = 11
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local RedeemButton = Instance.new("TextButton")
RedeemButton.Size = UDim2.new(1, -20, 0, 35)
RedeemButton.Position = UDim2.new(0, 10, 1, -45)
RedeemButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
RedeemButton.Text = "🎁 Redeem Semua Kode"
RedeemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
RedeemButton.TextSize = 12
RedeemButton.Font = Enum.Font.GothamBold
RedeemButton.BorderSizePixel = 0
RedeemButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 8)
ButtonCorner.Parent = RedeemButton

-- Efek hover
RedeemButton.MouseEnter:Connect(function()
    TweenService:Create(RedeemButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90, 150, 255)}):Play()
end)

RedeemButton.MouseLeave:Connect(function()
    TweenService:Create(RedeemButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}):Play()
end)

-- Fungsi tombol redeem
RedeemButton.MouseButton1Click:Connect(function()
    RedeemButton.Enabled = false
    RedeemButton.Text = "Sedang Redeem..."
    
    local successCount = 0
    local failCount = 0
    
    for i, code in ipairs(codes) do
        StatusLabel.Text = "Status: Redeem " .. i .. "/" .. #codes .. " - " .. code
        wait(0.5)
        
        if redeemCode(code) then
            successCount = successCount + 1
        else
            failCount = failCount + 1
        end
        
        wait(0.3)
    end
    
    StatusLabel.Text = "Status: Selesai! ✓" .. successCount .. " ✗" .. failCount
    RedeemButton.Text = "🎁 Redeem Semua Kode"
    RedeemButton.Enabled = true
    
    createNotification("✓ Proses Selesai", "Berhasil: " .. successCount .. " | Gagal: " .. failCount, 4, true)
end)

-- Notifikasi awal
createNotification("✓ Script Loaded", "Solo Hunter Auto Redeem siap digunakan!", 3, true)
