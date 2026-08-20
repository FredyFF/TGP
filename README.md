
Device	CCTV Name	IP
NVR-01		10.39.4.5
NVR-02		10.39.4.6
CCTV 01	TGP-6F-CORNER_1	10.39.4.26
CCTV 02	TGP-6F-TOILET-UTARA	10.39.4.27
CCTV 03	TGP-6F-CORNER_2	10.39.4.28
CCTV 04	TGP-6F-CENTER_1	10.39.4.29
CCTV 05	TGP-6F-CENTER_2	10.39.4.30
CCTV 06	TGP-6F-CORNER_3	10.39.4.31
CCTV 07	TGP-6F-CENTER_3	10.39.4.32
CCTV 08	TGP-6F-MAIN_ENTRANCE	10.39.4.33
CCTV 09	TGP-6F-TUNNEL	10.39.4.34
CCTV 10	TGP-6F-LOCKER-ROOM1	10.39.4.35
CCTV 11	TGP-6F-LOCKER-ROOM2	10.39.4.36
CCTV 12	TGP-6F-LOCKER-ROOM3	10.39.4.37
CCTV 13	TGP-6F-LOCKER-ROOM4	10.39.4.38
CCTV 14	TGP-6F-LOCKER-ROOM5	10.39.4.39
CCTV 15	TGP-6F-JUNCTION	10.39.4.40
CCTV 16	TGP-6F-ENTRANCE	10.39.4.41
CCTV 17	TGP-6F-RECEPTIONIST-1	10.39.4.42
CCTV 18	TGP-6F-KUALA-LUMPUR	10.39.4.43
CCTV 19	TGP-6F-MUSHOLA1	10.39.4.44
CCTV 20	TGP-6F-MAIN-TUNNEL	10.39.4.45
CCTV 21	TGP-6F-NURSING-ROOM	10.39.4.46
CCTV 22	TGP-6F-MEDICAL-ROOM	10.39.4.47
CCTV 23	TGP-6F-IT_STORAGE-ROOM	10.39.4.48
CCTV 24	TGP-6F-PANTRY-1	10.39.4.49
CCTV 25	TGP-6F-SIDEWALK	10.39.4.50
CCTV 26	TGP-6F-IT-ROOM	10.39.4.51
CCTV 27	TGP-6F-SERVER-ROOM1	10.39.4.52
CCTV 28	TGP-6F-SERVER-ROOM	10.39.4.53
CCTV 29	TGP-6F-CORNER-4	10.39.4.54
CCTV 30	TGP-6F-CENTER-5	10.39.4.55
CCTV 31	TGP-6F-CENTER-6	10.39.4.56
CCTV 32	TGP-6F-SIDE-DOOR	10.39.4.57
CCTV 33	TGP-6F-EMERGENCY-DOOR	10.39.4.58
CCTV 34	TGP-6F-PANTRY-CORNER	10.39.4.59
CCTV 35	TGP-6F-SECURITY-ROOM	10.39.4.60
CCTV 36	TGP-7F-CORNER_1	10.39.4.61
CCTV 37	TGP-7F-CORNER-2	10.39.4.62
CCTV 38	TGP-7F-CORNER-3	10.39.4.63
CCTV 39	TGP-7F-PANTRY_1	10.39.4.64
CCTV 40	TGP-7F-PANTRY_2	10.39.4.65
CCTV 41	TGP-7F-MEDICAL-ROOM	10.39.4.66
CCTV 42	TGP-7F-CENTER_1	10.39.4.67
CCTV 43	TGP-7F-CENTER_2	10.39.4.68
CCTV 44	TGP-7F-NURSERY-ROOM	10.39.4.69
CCTV 45	TGP-7F-TUNNEL_1	10.39.4.70
CCTV 46	TGP-7F-TUNNEL_2	10.39.4.71
CCTV 47	TGP-7F-HO CHI MINH	10.39.4.72
CCTV 48	TGP-7F-MAIN-ENTRANCE	10.39.4.73
CCTV 49	TGP-7F-RECEPTIONIST	10.39.4.74
CCTV 50	TGP-7F-JUNCTION	10.39.4.75
CCTV 51	TGP-7F-LOCKER-ROOM1	10.39.4.76
CCTV 52	TGP-7F-LOCKER-ROOM2	10.39.4.77
CCTV 53	TGP-7F-LOCKER-ROOM3	10.39.4.78
CCTV 54	TGP-7F-LOCKER-ROOM4	10.39.4.79
CCTV 55	TGP-7F-CENTER-2	10.39.4.80
CCTV 56	TGP-7F-RELAX-CORNER	10.39.4.81
CCTV 57	TGP-7F-SERVER-ROOM	10.39.4.82

Set-ExecutionPolicy -ExecutionPolicy bypass
(Get-Content script.ps1) | Set-Content script_utf8.ps1 -Encoding UTF8
Invoke-ps2exe .\master.ps1 -outputFile .\master.exe


powershell.exe -ExecutionPolicy Bypass -File "C:\Temp\createUserByEmail_Agents_noAdmin.ps1"

IHS: https://cs.shopee.com.br/portal/inhouse/workstation/items
17:56
CS Portal: https://dms.cs.shopee.com.br/portal/info/search
17:56
Vision: https://shopee-vision.shps-br-services.com/login

https://tns.sv.shopee.com.br/task/task-list?fromReload=1
https://tns.sv.shopee.com.br/qa/
https://dms.cs.shopee.com.br/dispute/data
https://dms.cs.shopee.com.br/dms/kb-client



# ============================================================
# SERVER CONNECTION MONITORING
# Monitoring:
# Google
# IHS
# CS Portal
# Vision
# Suspected IHS Server: 147.136.168.23
#
# Schedule : Every 30 minutes
# Time     : 18:00 - 03:00
# Period   : 06-Aug-2026 - 14-Aug-2026
# ============================================================

$ErrorActionPreference = "SilentlyContinue"

# ---------------- CONFIGURATION ----------------

$GoogleURL = "https://www.google.com"

$IHSURL = "https://cs.shopee.com.br/portal/inhouse/workstation/items"

$CSURL = "https://dms.cs.shopee.com.br/portal/info/search"

$VisionURL = "https://shopee-vision.shps-br-services.com/login"

$ServerIP = "147.136.168.23"

$IntervalMinutes = 30

$StartDate = Get-Date "2026-08-06 18:00:00"

$EndDate = Get-Date "2026-08-15 03:00:00"

$LogFolder = "$PSScriptRoot\MonitoringLogs"

$CSVFile = "$LogFolder\Server_Connection_Monitoring.csv"

# ------------------------------------------------

# Create folder if not exist

if (!(Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

# ------------------------------------------------
# CSV HEADER

if (!(Test-Path $CSVFile)) {

    $Header = [PSCustomObject]@{

        Timestamp = ""

        "Google Status" = ""
        "Google HTTP/Response (ms)" = ""

        "IHS Status" = ""
        "IHS HTTP/Response (ms)" = ""

        "CS Portal Status" = ""
        "CS Portal Response (ms)" = ""

        "Vision Status" = ""
        "Vision Response (ms)" = ""

        "147.136.168.23 Status" = ""

        "Packet Loss (%)" = ""

        "Latency Avg (ms)" = ""

        "DNS Status" = ""

        "Overall Status" = ""

        "Remark" = ""
    }

    $Header | Export-Csv `
        -Path $CSVFile `
        -NoTypeInformation `
        -Encoding UTF8
}

# ============================================================
# FUNCTION: TEST HTTP
# ============================================================

function Test-WebConnection {

    param(
        [string]$URL
    )

    $Result = [PSCustomObject]@{

        Status = "UNKNOWN"

        ResponseTime = "-"

        HTTPStatus = "-"
    }

    try {

        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        $Response = Invoke-WebRequest `
            -Uri $URL `
            -UseBasicParsing `
            -TimeoutSec 30

        $Stopwatch.Stop()

        $Result.ResponseTime = $Stopwatch.ElapsedMilliseconds

        $Result.HTTPStatus = $Response.StatusCode

        if ($Response.StatusCode -ge 200 -and $Response.StatusCode -lt 400) {

            $Result.Status = "UP"
        }
        else {

            $Result.Status = "DEGRADED"
        }

    }
    catch {

        $Result.Status = "TIMEOUT"

        $Result.ResponseTime = "-"
    }

    return $Result
}

# ============================================================
# FUNCTION: TEST DNS
# ============================================================

function Test-DNS {

    param(
        [string]$Hostname
    )

    try {

        Resolve-DnsName $Hostname `
            -ErrorAction Stop | Out-Null

        return "OK"
    }
    catch {

        return "FAILED"
    }
}

# ============================================================
# FUNCTION: TEST SERVER NETWORK
# ============================================================

function Test-ServerNetwork {

    param(
        [string]$IP
    )

    $Result = [PSCustomObject]@{

        Status = "UNKNOWN"

        PacketLoss = "-"

        Latency = "-"
    }

    try {

        # 20 packets for more reliable measurement

        $PingResult = Test-Connection `
            -ComputerName $IP `
            -Count 20 `
            -ErrorAction SilentlyContinue

        if ($PingResult) {

            $Received = $PingResult.Count

            $Lost = 20 - $Received

            $PacketLoss = [math]::Round(
                ($Lost / 20) * 100,
                0
            )

            $AverageLatency = [math]::Round(
                ($PingResult |
                Measure-Object ResponseTime -Average).Average,
                0
            )

            $Result.PacketLoss = $PacketLoss

            $Result.Latency = $AverageLatency

            # Determine status

            if ($PacketLoss -eq 0) {

                $Result.Status = "UP"
            }

            elseif ($PacketLoss -lt 50) {

                $Result.Status = "DEGRADED"
            }

            else {

                $Result.Status = "DEGRADED"
            }
        }

        else {

            $Result.Status = "UNREACHABLE"

            $Result.PacketLoss = 100

            $Result.Latency = "-"
        }

    }
    catch {

        $Result.Status = "UNREACHABLE"

        $Result.PacketLoss = 100

        $Result.Latency = "-"
    }

    return $Result
}

# ============================================================
# MAIN MONITORING LOOP
# ============================================================

Write-Host ""
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " SERVER CONNECTION MONITORING" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Start : $StartDate"
Write-Host "End   : $EndDate"
Write-Host "Interval : $IntervalMinutes minutes"
Write-Host ""
Write-Host "CSV : $CSVFile"
Write-Host ""

while ((Get-Date) -lt $EndDate) {

    $Now = Get-Date

    # ------------------------------------------------
    # Only monitor 18:00 - 03:00
    # ------------------------------------------------

    $CurrentTime = $Now.TimeOfDay

    $MonitoringStart = New-TimeSpan -Hours 18

    $MonitoringEnd = New-TimeSpan -Hours 3

    $IsMonitoringTime = `
        ($CurrentTime -ge $MonitoringStart) `
        -or `
        ($CurrentTime -le $MonitoringEnd)

    if ($IsMonitoringTime -and $Now -ge $StartDate) {

        Write-Host ""
        Write-Host "========================================" -ForegroundColor Yellow

        Write-Host "Monitoring:"
        Write-Host $Now

        # ------------------------------------------------
        # GOOGLE
        # ------------------------------------------------

        Write-Host "Testing Google..."

        $Google = Test-WebConnection `
            -URL $GoogleURL

        # ------------------------------------------------
        # IHS
        # ------------------------------------------------

        Write-Host "Testing IHS..."

        $IHS = Test-WebConnection `
            -URL $IHSURL

        # ------------------------------------------------
        # CS PORTAL
        # ------------------------------------------------

        Write-Host "Testing CS Portal..."

        $CS = Test-WebConnection `
            -URL $CSURL

        # ------------------------------------------------
        # VISION
        # ------------------------------------------------

        Write-Host "Testing Vision..."

        $Vision = Test-WebConnection `
            -URL $VisionURL

        # ------------------------------------------------
        # SERVER
        # ------------------------------------------------

        Write-Host "Testing $ServerIP..."

        $Server = Test-ServerNetwork `
            -IP $ServerIP

        # ------------------------------------------------
        # DNS
        # ------------------------------------------------

        Write-Host "Testing DNS..."

        $DNS = Test-DNS `
            -Hostname "cs.shopee.com.br"

        # ------------------------------------------------
        # OVERALL STATUS
        # ------------------------------------------------

        $Overall = "NORMAL"

        $Remark = ""

        if (
            $Google.Status -eq "TIMEOUT" -and
            $IHS.Status -eq "TIMEOUT" -and
            $CS.Status -eq "TIMEOUT" -and
            $Vision.Status -eq "TIMEOUT"
        ) {

            $Overall = "INTERNET/NETWORK ISSUE"

            $Remark = "Multiple external services unavailable."
        }

        elseif ($Server.PacketLoss -ne "-" -and
                [int]$Server.PacketLoss -ge 50) {

            $Overall = "SERVER NETWORK ISSUE"

            $Remark = "High packet loss detected toward $ServerIP."
        }

        elseif ($IHS.Status -eq "TIMEOUT") {

            $Overall = "IHS ISSUE"

            $Remark = "IHS timeout detected."
        }

        elseif ($IHS.Status -eq "DEGRADED") {

            $Overall = "IHS DEGRADED"

            $Remark = "IHS response degraded."
        }

        elseif ($DNS -eq "FAILED") {

            $Overall = "DNS ISSUE"

            $Remark = "DNS resolution failed."
        }

        # ------------------------------------------------
        # CREATE CSV RECORD
        # ------------------------------------------------

        $Record = [PSCustomObject]@{

            Timestamp = $Now.ToString("yyyy-MM-dd HH:mm:ss")

            "Google Status" =
                $Google.Status

            "Google HTTP/Response (ms)" =
                $Google.ResponseTime

            "IHS Status" =
                $IHS.Status

            "IHS HTTP/Response (ms)" =
                $IHS.ResponseTime

            "CS Portal Status" =
                $CS.Status

            "CS Portal Response (ms)" =
                $CS.ResponseTime

            "Vision Status" =
                $Vision.Status

            "Vision Response (ms)" =
                $Vision.ResponseTime

            "147.136.168.23 Status" =
                $Server.Status

            "Packet Loss (%)" =
                $Server.PacketLoss

            "Latency Avg (ms)" =
                $Server.Latency

            "DNS Status" =
                $DNS

            "Overall Status" =
                $Overall

            "Remark" =
                $Remark
        }

        # ------------------------------------------------
        # SAVE CSV
        # ------------------------------------------------

        $Record |
            Export-Csv `
            -Path $CSVFile `
            -NoTypeInformation `
            -Append `
            -Encoding UTF8

        # ------------------------------------------------
        # DISPLAY RESULT
        # ------------------------------------------------

        Write-Host ""

        Write-Host "Google : $($Google.Status) / $($Google.ResponseTime) ms"

        Write-Host "IHS    : $($IHS.Status) / $($IHS.ResponseTime) ms"

        Write-Host "CS     : $($CS.Status) / $($CS.ResponseTime) ms"

        Write-Host "Vision : $($Vision.Status) / $($Vision.ResponseTime) ms"

        Write-Host "Server : $($Server.Status)"

        Write-Host "Loss   : $($Server.PacketLoss)%"

        Write-Host "Latency: $($Server.Latency) ms"

        Write-Host "DNS    : $DNS"

        Write-Host "Overall: $Overall"

        Write-Host ""

        # ------------------------------------------------
        # WAIT 30 MINUTES
        # ------------------------------------------------

        Write-Host "Next monitoring in $IntervalMinutes minutes..."

        Start-Sleep `
            -Seconds ($IntervalMinutes * 60)
    }

    else {

        # Outside monitoring window

        Start-Sleep -Seconds 60
    }
}

Write-Host ""
Write-Host "==================================================" -ForegroundColor Green
Write-Host " MONITORING FINISHED" -ForegroundColor Green
Write-Host "==================================================" -ForegroundColor Green
Write-Host ""
Write-Host "CSV saved at:"
Write-Host $CSVFile
