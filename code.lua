-- Simple Auto Redeem Solo Hunter (No GUI)
-- Langsung jalan saat di-execute

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

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

-- Mencari RemoteFunction dengan aman
local Remote = ReplicatedStorage:WaitForChild("RemoteServices", 5)
    and ReplicatedStorage.RemoteServices:WaitForChild("CodesService", 5)
    and ReplicatedStorage.RemoteServices.CodesService:WaitForChild("RF", 5)
    and ReplicatedStorage.RemoteServices.CodesService.RF:WaitForChild("RedeemCode", 5)

if Remote then
    -- Loop redeem semua kode
    for _, code in ipairs(CODES) do
        pcall(function()
            Remote:InvokeServer(code)
        end)
        task.wait(0.2) -- Delay kecil agar tidak spam parah
    end

    -- Notifikasi Sukses Selesai (Menggunakan sistem notif bawaan Roblox)
    StarterGui:SetCore("SendNotification", {
        Title = "Auto Redeem Selesai",
        Text = "Semua kode telah berhasil di-redeem!",
        Duration = 5
    })
else
    -- Notif jika remote tidak ketemu (untuk debugging)
    StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Remote tidak ditemukan!",
        Duration = 5
    })
end
