# Create local directory 
$appName = 'onedrive'
$drive = 'C:\'
New-Item -Path $drive -Name $appName  -ItemType Directory -ErrorAction SilentlyContinue
$LocalPath = $drive + '\' + $appName 
set-Location $LocalPath

# Download OneDriveSetup.exe from https://go.microsoft.com/fwlink/?linkid=844652
$onedriveURL = "https://go.microsoft.com/fwlink/?linkid=844652"
$onedriveEXE = 'OneDriveSetup.exe'
$outputPath = $LocalPath + '\' + $onedriveEXE
Invoke-WebRequest -Uri $onedriveURL -OutFile $outputPath

# Uninstall any previous version of OneDrive
write-host 'AIB Customization: Uninstalling OneDrive'
& $localPath\OneDriveSetup.exe /uninstall
write-host 'AIB Customization: Finished OneDrive uninstall'

# set OneDrive regKey
 write-host 'AIB Customization: Set OneDrive AllUsersInstall regKey'
 New-Item -Path HKLM:\SOFTWARE\Microsoft -Name "OneDrive" 
 New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\OneDrive -Name "AllUsersInstall" -Type "Dword" -Value "1"
 write-host 'AIB Customization: Finished Set OneDrive AllUsersInstall regKey'

# Install OneDrive
write-host 'AIB Customization: Installing OneDrive'
& $localPath\OneDriveSetup.exe /allusers
write-host 'AIB Customization: Finished Installing OneDrive'

# Silently configure user account
Write-Host 'AIB Customization: Configuring OneDrive for all users'
New-Item -Path HKLM:\SOFTWARE\Policies\Microsoft -Name "OneDrive" 
New-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\OneDrive -Name "SilentAccountConfig" -Type "Dword" -Value "1"
Write-Host 'AIB Customization: Finished Configuring OneDrive for all users'