# ==================================================================
Write-Host "`n# 1. Cek Internet" -ForegroundColor Cyan
Write-Host "[...] Mengecek koneksi internet..." -ForegroundColor Cyan
function Test-Internet {
    try {
        $r = [System.Net.WebRequest]::Create("http://google.com")
        $r.Timeout = 3000
        $res = $r.GetResponse()
        $res.Close()
        return $true
    } catch { return $false }
}

if (Test-Internet) {
    Write-Host "[OK] Koneksi internet tersedia." -ForegroundColor Green
} else {
    Write-Host "[ERROR] Tidak ada koneksi internet." -ForegroundColor Red
    exit
}

# ==================================================================
Write-Host "`n# 2. Stop Windows Update" -ForegroundColor Cyan
Write-Host "[...] Menghentikan Windows Update..." -ForegroundColor Cyan
try {
    Stop-Service wuauserv -Force -ErrorAction SilentlyContinue
    Write-Host "[WARNING] Windows Update dihentikan." -ForegroundColor Yellow
} catch {
    Write-Host "[ERROR] Gagal menghentikan Windows Update." -ForegroundColor Red
}


# ==================================================================
Write-Host "`n# 3. Ambil Serial PC" -ForegroundColor Cyan
Write-Host "[...] Mengambil serial number PC..." -ForegroundColor Cyan
try {
    $serial = (Get-WmiObject win32_bios).SerialNumber
    Write-Host "[OK] Serial Number: $serial" -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengambil serial PC." -ForegroundColor Red
}


# ==================================================================
Write-Host "`n# 4. Ambil Serial Monitor" -ForegroundColor Cyan
Write-Host "[...] Mengambil serial monitor..." -ForegroundColor Cyan
try {
    $monitors = Get-WmiObject -Namespace root\wmi -Class WmiMonitorID
    $serialMonitors = @()
    foreach ($m in $monitors) {
        $s = -join ($m.SerialNumberID | ForEach-Object {[char]$_}) -replace "\0",""
        $serialMonitors += $s
    }
    Write-Host "[OK] Serial monitor berhasil diambil." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengambil serial monitor." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 5. Kirim Data ke Google Sheet & Buat HTML" -ForegroundColor Cyan
# Fungsi untuk sanitize string agar aman jadi ID HTML
function Sanitize-Id {
    param ([string]$input)
    return ($input -replace '[^a-zA-Z0-9]', '_')
}

# Input nomor meja
$nomorMeja = Read-Host "Masukkan Nama Office" 
# Input SA Number / Cubicle Number
$saNumber = Read-Host "Masukkan Nomer Meja"  

# Buat body JSON
$bodyObject = @{
    nomor_meja = $nomorMeja
    sa_number = $saNumber
    serial = $serial
    serial_monitor = $serialMonitors
}
$body = $bodyObject | ConvertTo-Json -Depth 3

# URL Web App Google Sheets
$url = "https://script.google.com/macros/s/AKfycbxEnu000kfysh-f86YYi1EcbWkPdL6ULDzqOiK8oH9oEe6Zr5_33k7Hh0K4-VTAOCQctQ/exec"

try {
    Invoke-RestMethod -Uri $url -Method POST -Body $body -ContentType "application/json"
    Write-Host "[OK] Data berhasil dikirim ke Google Sheet!" -ForegroundColor Green
    # HTML QR Code ...
    $qrCodeDivs = @"
    <div style='display:flex; align-items:center; gap:20px; margin-bottom:20px;'>
        <p style='font-size:20px; font-weight:bold; color:green; width:300px;'>Serial Number PC: $serial</p>
        <div id='qrcode-pc'></div>
    </div>
"@
    foreach ($serialm in $serialMonitors) {
        $safeId = Sanitize-Id $serialm
        $qrCodeDivs += @"
    <div style='display:flex; align-items:center; gap:20px; margin-bottom:20px;'>
        <p style='font-size:20px; font-weight:bold; color:blue; width:300px;'>Serial Number Monitor: $serialm</p>
        <div id='qrcode-monitor-$safeId'></div>
    </div>
"@
    }
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Cek Serial Number Laptop</title>
    <script src="https://cdn.jsdelivr.net/npm/qrcodejs/qrcode.min.js"></script>
</head>
<body style="font-family: Arial; margin: 50px;">
    <h2 style="color: green;">Data berhasil dikirim!</h2>
    <p><strong>Nomor Meja:</strong> $nomorMeja</p>
    <p><strong>SA Number / Cubicle Number:</strong> $saNumber</p>
    $qrCodeDivs
    <script>
        new QRCode(document.getElementById("qrcode-pc"), { text: "$serial", width: 128, height: 128 });
"@
    foreach ($serialm in $serialMonitors) {
        $safeId = Sanitize-Id $serialm
        $html += "        new QRCode(document.getElementById('qrcode-monitor-$safeId'), { text: '$serialm', width: 128, height: 128 });`n"
    }
    $html += "</script></body></html>"
    $output = "C:\Users\Public\serial.html"
    $html | Out-File -FilePath $output -Encoding UTF8
   # Start-Process $output
} catch {
    Write-Host "[ERROR] Gagal mengirim data ke Google Sheet: $_" -ForegroundColor Red
}



if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

function Is-ProgramInstalled {
    param ([string]$ProgramName)
    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )
    foreach ($path in $paths) {
        if (Get-ItemProperty $path -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*$ProgramName*" }) {
            return $true
        }
    }
    return $false
}

Write-Host "`n# 6. Workspace ONE Intelligent Hub" -ForegroundColor Cyan
function Install-WSOneAgent {
    if (Is-ProgramInstalled "Workspace ONE Intelligent Hub") {
        Write-Host "[WS One] Sudah terinstal."
        return
    }

    # Path file MSI lokal (SUDAH ADA)
    $file = "C:\Temp\AirwatchAgent.msi"

    # Validasi file
    if (-not (Test-Path $file)) {
        Write-Host "[WS One] File installer tidak ditemukan di $file" -ForegroundColor Red
        return
    }

    Write-Host "[WS One] Menginstal WS1 dari Temp." -ForegroundColor Cyan

    Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$file`" /q ENROLL=Y SERVER=ds510.awmdm.sg LGName=id_shared USERNAME=id-shared-tgpuser PASSWORD=Riot-Educator-Matador6 ASSIGNTOLOGGEDINUSER=N DOWNLOADWSBUNDLE=FALSE /LOG `"$env:TEMP\WorkspaceONE.log`"" -Wait

    Write-Host "[WS One] Instalasi selesai. Menunggu proses enrollment..." -ForegroundColor Yellow
    Start-Sleep -Seconds 150
    Write-Host "WS One Telah Terinstall" -ForegroundColor Green
    Write-Host "===================================" 
}

Install-WSOneAgent


# ==================================================================
Write-Host "`n# 7. Set Password Administrator" -ForegroundColor Cyan
Write-Host "[...] Mengubah password Administrator..." -ForegroundColor Cyan
try {
    $Password = ConvertTo-SecureString '1q2w3e4r$R#E@W!Q' -AsPlainText -Force
    Set-LocalUser -Name "Administrator" -Password $Password
    Write-Host "[OK] Password Administrator berhasil diubah." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengubah password Administrator: $_" -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 8. Cek Administrator" -ForegroundColor Cyan
Write-Host "[...] Mengecek hak akses Administrator..." -ForegroundColor Cyan
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[WARNING] Script tidak dijalankan sebagai Administrator. Relaunch..." -ForegroundColor Yellow
    Start-Sleep 2
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Exit
} else {
    Write-Host "[OK] Script berjalan sebagai Administrator." -ForegroundColor Green
}


# ==================================================================
Write-Host "`n# 9. Rename & Join Domain" -ForegroundColor Cyan
$pcname = ((Get-WmiObject -Class Win32_BIOS).SerialNumber.Trim()) + "-"
$domain = 'id.corp.seagroup.com'
$username = "$domain\adm.fredy"
$password = 'Shopee@2026123' | ConvertTo-SecureString -AsPlainText -Force
$credUser = New-Object System.Management.Automation.PSCredential($username, $password)

$pcnameNow = $env:COMPUTERNAME
$joinedDomain = (Get-WmiObject -Class Win32_ComputerSystem).PartOfDomain

if (($joinedDomain -ne $true) -and ($pcnameNow -ne $pcname)) {
    Write-Host "[!] Renaming to '$pcname' and joining domain '$domain'..."
    Start-Sleep -Seconds 5
    Add-Computer -DomainName $domain -NewName $pcname -Credential $credUser -Force
    Write-Host "[✓] Renamed and joined to domain." -ForegroundColor Green
} elseif (($joinedDomain -eq $true) -and ($pcnameNow -ne $pcname)) {
    Write-Host "[!] Renaming to '$pcname'..."
    Start-Sleep -Seconds 5
    Rename-Computer -NewName $pcname -DomainCredential $credUser -Force
    Write-Host "[✓] Computer renamed." -ForegroundColor Green
} elseif (($joinedDomain -ne $true) -and ($pcnameNow -eq $pcname)) {
    Write-Host "[!] Joining domain '$domain'..."
    Start-Sleep -Seconds 5
    Add-Computer -DomainName $domain -Credential $credUser -Force
    Write-Host "[✓] Joined to domain." -ForegroundColor Green
} else {
    Write-Host "[✓] Already joined and named correctly." -ForegroundColor Green
}
Start-Sleep -Seconds 3

# ==================================================================
Write-Host "`n# 10. Scheduled Task Bulanan" -ForegroundColor Cyan
Write-Host "[...] Membuat Scheduled Task bulanan..." -ForegroundColor Cyan
try {
    schtasks /create /tn "AutoWakePCMonthly" /tr "powershell.exe -WindowStyle Hidden" /sc monthly /d 1 /st 00:00 /ru SYSTEM /rl HIGHEST /f
    Write-Host "[OK] Scheduled Task bulanan berhasil dibuat." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal membuat Scheduled Task." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 11. Storage Sense" -ForegroundColor Cyan
Write-Host "[...] Mengatur Storage Sense..." -ForegroundColor Cyan
try {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\StorageSense\Parameters\StoragePolicy" -Name "01" -Value 1
    Write-Host "[OK] Storage Sense berhasil diaktifkan." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengatur Storage Sense." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 12. Timezone" -ForegroundColor Cyan
Write-Host "[...] Mengatur zona waktu Jakarta..." -ForegroundColor Cyan
try {
    Set-TimeZone -Id "SE Asia Standard Time"
    Write-Host "[OK] Zona waktu berhasil diatur." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengatur zona waktu." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 13. Power Setting" -ForegroundColor Cyan
Write-Host "[...] Mengatur power setting..." -ForegroundColor Cyan
try {
    powercfg /change monitor-timeout-ac 60
    Write-Host "[OK] Power setting berhasil diubah." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengatur power." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 14. Enable Administrator" -ForegroundColor Cyan
Write-Host "[...] Mengaktifkan Administrator..." -ForegroundColor Cyan
try {
    Enable-LocalUser -Name "Administrator"
    Write-Host "[OK] Administrator berhasil diaktifkan." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal mengaktifkan Administrator." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 15. Update GPO" -ForegroundColor Cyan
Write-Host "[...] Update Group Policy..." -ForegroundColor Cyan
try {
    gpupdate /force
    Write-Host "[OK] GPO berhasil diupdate." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal update GPO." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 16. Cleanup Shortcut" -ForegroundColor Cyan
Write-Host "[...] Menghapus shortcut..." -ForegroundColor Cyan
try {
    Remove-Item "$Env:Public\Desktop\script-nvme - Shortcut.lnk" -ErrorAction SilentlyContinue
    Write-Host "[OK] Shortcut berhasil dibersihkan." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal menghapus shortcut." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 17. Buat Script Cleanup User" -ForegroundColor Cyan
Write-Host "[...] Membuat script cleanup user..." -ForegroundColor Cyan
$cleanupPath = "C:\Users\Public\cleanup_users.ps1"
@'
$excluded = @("Administrator","Default","pctgp","pcsjw","pcsch")
$profiles = Get-CimInstance Win32_UserProfile | Where-Object {$_.Loaded -eq $false}
foreach ($p in $profiles) {
    $name = Split-Path $p.LocalPath -Leaf
    if ($excluded -contains $name) { continue }
    $days = ((Get-Date) - $p.LastUseTime).Days
    if ($days -gt 3) {
        Remove-CimInstance $p
    }
}
'@ | Out-File $cleanupPath -Force
Write-Host "[OK] Script cleanup user berhasil dibuat." -ForegroundColor Green

# ==================================================================
Write-Host "`n# 18. Task Scheduler Cleanup 2 Minggu" -ForegroundColor Cyan
Write-Host "[...] Membuat task cleanup user (2 minggu sekali)..." -ForegroundColor Cyan
try {
    schtasks /create /tn "CleanupUserProfilesBiWeekly" `
     /tr "powershell.exe -ExecutionPolicy Bypass -File `"$cleanupPath`"" `
     /sc weekly /mo 2 /d SUN /st 01:00 `
     /ru SYSTEM /rl HIGHEST /f
    Write-Host "[OK] Task cleanup berhasil dibuat." -ForegroundColor Green
} catch {
    Write-Host "[ERROR] Gagal membuat task cleanup." -ForegroundColor Red
}

# ==================================================================
Write-Host "`n# 19. Restart Dialog" -ForegroundColor Cyan
Write-Host "[...] Pastikan WS1 sudah Enrolled..." -ForegroundColor Cyan

# Start background job untuk restart dalam 3 menit (180 detik)
$job = Start-Job -ScriptBlock {
    Start-Sleep -Seconds 180
    Restart-Computer -Force
}

Add-Type -AssemblyName PresentationFramework
$result = [System.Windows.MessageBox]::Show(
    "(Pastikan WS1 Enrolled !) Semua proses sudah selesai apakah ingin restart sekarang !?`n`n(Sistem akan restart otomatis dalam 3 menit jika tidak ada respon)",
    "Konfirmasi Restart",
    [System.Windows.MessageBoxButton]::YesNo,
    [System.Windows.MessageBoxImage]::Question
)

if ($result -eq "Yes") {
    Write-Host "[WARNING] Sistem akan restart sekarang..." -ForegroundColor Yellow
    
    # Hentikan job supaya tidak double restart
    Stop-Job $job | Out-Null
    Remove-Job $job | Out-Null
    
    Restart-Computer -Force
} else {
    Write-Host "[OK] Restart dibatalkan oleh user." -ForegroundColor Red
    
    # Batalkan auto-restart
    Stop-Job $job | Out-Null
    Remove-Job $job | Out-Null
}
