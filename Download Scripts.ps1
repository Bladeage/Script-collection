# Script to copy all scripts an Links to the desktop

# Set the desktop path for the current user
$desktopPath = [System.IO.Path]::Combine($env:UserProfile, 'Desktop')

# Check if the desktop directory exists, if not, create it
if (-not (Test-Path -Path $desktopPath)) {
    New-Item -Path $desktopPath -ItemType Directory | Out-Null
}

# Define the URLs and the corresponding file names
$scriptLinks = @{
    "Windows Update Script.lnk" = "https://github.com/Bladeage/Script-collection/raw/main/Windows%20Update%20Script.lnk"
    "Activate Windows-Office.lnk" = "https://github.com/Bladeage/Script-collection/raw/main/Massgraves%20Windows%20Activation%20Script.lnk"
    "GamingAIO.lnk" = "https://github.com/Bladeage/Script-collection/raw/main/GamingAIO%20-%20bladeage.lnk"
    "WinUtil.lnk" = "https://github.com/Bladeage/Script-collection/raw/main/ChrisTitus'%20WinUtil%20Script.lnk"
    "Office Plus.lnk" = "https://github.com/Bladeage/Script-collection/raw/main/Office%20Plus%20Script.lnk"
}

# Download each script link and save it to the desktop
foreach ($fileName in $scriptLinks.Keys) {
    $url = $scriptLinks[$fileName]
    $outFile = [System.IO.Path]::Combine($desktopPath, $fileName)
    Invoke-WebRequest -Uri $url -OutFile $outFile
}