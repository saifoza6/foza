-- ServerScriptService/CodesService.server.lua

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

-- Buat folder/struktur RemoteFunction (kalau belum ada)
local RemoteServices = ReplicatedStorage:FindFirstChild("RemoteServices") or Instance.new("Folder")
RemoteServices.Name = "RemoteServices"
RemoteServices.Parent = ReplicatedStorage

local CodesService = RemoteServices:FindFirstChild("CodesService") or Instance.new("Folder")
CodesService.Name = "CodesService"
CodesService.Parent = RemoteServices

local RF = CodesService:FindFirstChild("RF") or Instance.new("Folder")
RF.Name = "RF"
RF.Parent = CodesService

local RedeemCode = RF:FindFirstChild("RedeemCode") or Instance.new("RemoteFunction")
RedeemCode.Name = "RedeemCode"
RedeemCode.Parent = RF

-- Kode & reward (contoh; ganti reward sesuai game kamu)
local VALID_CODES = {
	["40KCCUTHANKS66"] = true,
	["TOTHEMOON"] = true,
	["35KCCUTHANKS33"] = true,
	["LOVETOBRAZIL"] = true,
	["WWWW"] = true,
	["30KCCU"] = true,
	["CLASSREROLL"] = true,
	["RESETMYSTATS"] = true,
	["THANKSFORTHELIKESGUYS"] = true,
	["RELEASE"] = true,
}

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
