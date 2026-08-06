Set-ExecutionPolicy -ExecutionPolicy bypass
(Get-Content script.ps1) | Set-Content script_utf8.ps1 -Encoding UTF8
Invoke-ps2exe .\master.ps1 -outputFile .\master.exe


powershell.exe -ExecutionPolicy Bypass -File "C:\Temp\createUserByEmail_Agents_noAdmin.ps1"

IHS: https://cs.shopee.com.br/portal/inhouse/workstation/items
17:56
CS Portal: https://dms.cs.shopee.com.br/portal/info/search
17:56
Vision: https://shopee-vision.shps-br-services.com/login

