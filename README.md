Set-ExecutionPolicy -ExecutionPolicy bypass
(Get-Content script.ps1) | Set-Content script_utf8.ps1 -Encoding UTF8
Invoke-ps2exe .\master.ps1 -outputFile .\master.exe


powershell.exe -ExecutionPolicy Bypass -File "C:\Temp\createUserByEmail_Agents_noAdmin.ps1"
