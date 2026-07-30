$pathfile = Get-Location
$user = Import-Csv $pathfile\createUserByEmail_Agents.csv
$tgl = Get-Date -Format "yyyy-MM-dd"
$jam = Get-Date -Format "HH:mm"

$userSuccess = New-Object System.Collections.ArrayList
$userMinPass = New-Object System.Collections.ArrayList
$userExists = New-Object System.Collections.ArrayList
$userTooLong = New-Object System.Collections.ArrayList

Write-Output "`n"

foreach ($a in $user) {
    $email = $a.Email
    $usernameTemp = $email.Split("@")[0]
    $pass = $a.Password
    $fullname = $a.'Full Name'
    $fullnamesplit = $fullname.Split(" ")
    $desc = $a.Description
    $office = $a.Office
    $compname = $a.'Comp Name'
    $ou = $a.Path
    $title = $a.Title
    $dept = $a.Department
    $company = $a.Company
    $memberof = $a.MemberOf
    $mgr = $a.Manager

    # Determine username
    if($usernameTemp.length -le 20){
        $username = $usernameTemp
    } elseif($usernameTemp.length -gt 20){
        $username = $usernameTemp.Substring(0,20)
        $userTooLong.Add($username) > $null
    }

    #Processing Output
    Write-Output "Processing [$username] ..."

    # Checking if the users are already exist
    if (Get-ADUser -Filter ({SamAccountName -eq $username})) {
        $userExists.Add($username) > $null
        continue
    }

    # Checking if users' password has no minimum length
    if ($pass.Length -lt 8) {
        $userMinPass.Add($username) > $null
        continue
    }

    # Determining First Name and Last Name from Full Name
    if ($fullnamesplit.Length -eq 1) {
        $fname = $fullname
        $lname = $fullname
    } elseif ($fullnamesplit.Length -eq 2) {
        $fname = $fullnamesplit[0]
        $lname = $fullnamesplit[1]
    } elseif ($fullnamesplit.Length -eq 3) {
        $fname = $fullnamesplit[0]+" "+$fullnamesplit[1]
        $lname = $fullnamesplit[2]
    } elseif ($fullnamesplit.Length -eq 4) {
        $fname = $fullnamesplit[0]+" "+$fullnamesplit[1]
        $lname = $fullnamesplit[2]+" "+$fullnamesplit[3]
    }

# Create User      
New-ADUser `
    -Name $fullname `
    -DisplayName $fullname `
    -SamAccountName $username `
    -GivenName $fname `
    -Surname $lname `
    -Description $desc `
    -EmailAddress $email `
    -Office $office `
    -HomePage $compname `
    -OfficePhone $pass `
    -Title $title `
    -Department $dept `
    -Company $company `
    -AccountPassword (ConvertTo-SecureString "$pass" -AsPlainText -Force) `
    -Enabled $true `
    -PasswordNeverExpires $false `
    -Path $ou `
    -UserPrincipalName "$username@id.corp.seagroup.com" `
    #-ProfilePath $profile
    #-Manager $mgr

# Add user to security group
Add-ADGroupMember -Identity $memberof -Members $username
$userSuccess.add($username) > $null

sleep 0.5

}

# Output Report
Write-Output "" >> createUserByEmail-$tgl.txt
Write-Output "-----------------------------" >> createUserByEmail-$tgl.txt

Write-Output "Success:" >> createUserByEmail-$tgl.txt
if ($userSuccess) {
foreach ($z in $userSuccess) {
    Write-Output "[+] $z" >> createUserByEmail-$tgl.txt
    }
} else {
    Write-Output "[null]" >> createUserByEmail-$tgl.txt
}

Write-Output " " >> createUserByEmail-$tgl.txt

Write-Output "Success (But Too Long) (>20 Chars):" >> createUserByEmail-$tgl.txt
if ($userTooLong){
    foreach ($z in $userTooLong) {
    Write-Output "[+] $z" >> createUserByEmail-$tgl.txt
    }
} else {
    Write-Output "[null]" >> createUserByEmail-$tgl.txt
}

Write-Output " " >> createUserByEmail-$tgl.txt

Write-Output "No Minimum Password Length:" >> createUserByEmail-$tgl.txt
if ($userMinPass){
    foreach ($z in $userMinPass) {
    Write-Output "[!] $z" >> createUserByEmail-$tgl.txt
    }
} else {
    Write-Output "[null]" >> createUserByEmail-$tgl.txt
}

Write-Output " " >> createUserByEmail-$tgl.txt

Write-Output "Exists:" >> createUserByEmail-$tgl.txt
if ($userExists){
    foreach ($z in $userExists) {
    Write-Output "[-] $z" >> createUserByEmail-$tgl.txt
    }
} else {
    Write-Output "[null]" >> createUserByEmail-$tgl.txt
}

Write-Output "--------------$jam---------------" >> createUserByEmail-$tgl.txt

# DialogBox for Reminder
#Add-Type -AssemblyName System.Windows.Forms
#[System.Windows.Forms.MessageBox]::Show('Do not forget to Re-Sync account on WS One Dasboard!','[ITSJW] Reminder')

Write-Host "Don't forget to sync the accounts and see the log file!"

PAUSE
