# Install NuGet and Install PSWindowsUpdate Module
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force
Import-Module PSWindowsUpdate
Get-WindowsUpdate -Install -AutoReboot