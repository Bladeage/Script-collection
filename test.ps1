function Ensure-Admin {
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
}

function Set-ExecutionPolicy-Unrestricted {
    Set-ExecutionPolicy Unrestricted -Scope Process -Force
}

function Set-ExecutionPolicy-Restricted {
    Set-ExecutionPolicy Restricted -Scope Process -Force
}

function Execute-RemoteScript {
    param (
        [string]$url,
        [string]$taskName
    )
    Write-Host "Executing script from $url..." -ForegroundColor Cyan
    Show-ProgressBar -activity $taskName -percentComplete 0
    iex (irm $url)
    Show-ProgressBar -activity $taskName -percentComplete 100
}

function Show-ProgressBar {
    param (
        [string]$activity,
        [int]$percentComplete
    )
    Write-Progress -Activity $activity -Status "$percentComplete% Complete" -PercentComplete $percentComplete
}

function Install-DotNetAndLibraries {
    Write-Host "Installing .NET and other libraries..." -ForegroundColor Cyan

    $packages = winget search dotnet | Select-String "Microsoft.DotNet" | ForEach-Object { $_.Line.Split()[0] }
    $packages += winget search Microsoft.VC | Select-String "Microsoft.VC" | ForEach-Object { $_.Line.Split()[0] }
    $packages += @("Microsoft.DirectX", "Microsoft.XNARedist")

    $totalPackages = $packages.Count
    $currentPackage = 0

    foreach ($package in $packages) {
        $currentPackage++
        $percentComplete = [math]::Round(($currentPackage / $totalPackages) * 100)
        Show-ProgressBar -activity "Installing $package" -percentComplete $percentComplete

        winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
    }

    # Java installations
    $javaPackages = @("Oracle.JavaRuntimeEnvironment", "Oracle.JDK.22")
    $totalPackages += $javaPackages.Count

    foreach ($package in $javaPackages) {
        $currentPackage++
        $percentComplete = [math]::Round(($currentPackage / $totalPackages) * 100)
        Show-ProgressBar -activity "Installing $package" -percentComplete $percentComplete

        winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
    }

    Show-ProgressBar -activity "Installation Complete" -percentComplete 100
    Write-Host "Done installing libraries." -ForegroundColor Green
}

function Install-GeneralTools {
    Write-Host "Installing general tools..." -ForegroundColor Cyan

    $packages = @("7zip.7zip", "Microsoft.PowerShell", "Microsoft.WindowsTerminal")
    $totalPackages = $packages.Count
    $currentPackage = 0

    foreach ($package in $packages) {
        $currentPackage++
        $percentComplete = [math]::Round(($currentPackage / $totalPackages) * 100)
        Show-ProgressBar -activity "Installing $package" -percentComplete $percentComplete

        winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
    }

    Show-ProgressBar -activity "Installation Complete" -percentComplete 100
    Write-Host "Done installing general tools." -ForegroundColor Green
}

function Install-DeveloperTools {
    Write-Host "Installing developer tools..." -ForegroundColor Cyan

    $packages = @("Microsoft.VisualStudioCode", "Git.Git", "Python.Python.3", "Docker.DockerDesktop", "Notepad++.Notepad++")
    $totalPackages = $packages.Count
    $currentPackage = 0

    foreach ($package in $packages) {
        $currentPackage++
        $percentComplete = [math]::Round(($currentPackage / $totalPackages) * 100)
        Show-ProgressBar -activity "Installing $package" -percentComplete $percentComplete

        winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
    }

    Show-ProgressBar -activity "Installation Complete" -percentComplete 100
    Write-Host "Done installing developer tools." -ForegroundColor Green
}

function Update-System {
    Write-Host "Updating system..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://update.geyer.zone" -taskName "Updating System"
    Write-Host "System update completed." -ForegroundColor Green
}

function Install-Winget {
    Write-Host "Installing winget..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://winget.geyer.zone" -taskName "Installing Winget"
    Write-Host "Winget installation completed." -ForegroundColor Green
}

function Install-Office {
    Write-Host "Installing Office..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://office.geyer.zone" -taskName "Installing Office"
    Write-Host "Office installation completed." -ForegroundColor Green
}

function Install-ChrisTitusScript {
    Write-Host "Running Chris Titus script..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://winutil.geyer.zone" -taskName "Running Chris Titus Script"
    Write-Host "Chris Titus script completed." -ForegroundColor Green
}

function Activate-System {
    Write-Host "Activating system..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://activate.geyer.zone" -taskName "Activating System"
    Write-Host "System activation completed." -ForegroundColor Green
}

function Show-Menu {
    cls
    Write-Host "=========================="
    Write-Host "  Installation Menu"
    Write-Host "=========================="
    Write-Host "1. System Update via PowerShell (!!! CAUTION: Auto-Restart)"
    Write-Host "2. Install WinGet/ AppInstaller"
    Write-Host "3. Install .Net and Libraries"
    Write-Host "4. Install Generic Tools"
    Write-Host "5. Install Developer Tools"
    Write-Host "6. Install Office Tool"
    Write-Host "7. Run ChrisTitus' WinUtil Script"
    Write-Host "8. Activate Windows via Massgraves' Script"
    Write-Host "9. Exit"
    Write-Host "=========================="
    $choice = Read-Host "Enter your choice (1-9)"
    return $choice
}

# Change background to black and text color to green
$host.ui.RawUI.BackgroundColor = "Black"
$host.ui.RawUI.ForegroundColor = "Green"
cls

Ensure-Admin

do {
    $choice = Show-Menu

    switch ($choice) {
        1 {
            Set-ExecutionPolicy-Unrestricted
            Update-System
            Set-ExecutionPolicy-Restricted
        }
        2 {
            Set-ExecutionPolicy-Unrestricted
            Install-Winget
            Set-ExecutionPolicy-Restricted
        }
        3 {
            Set-ExecutionPolicy-Unrestricted
            Install-DotNetAndLibraries
            Set-ExecutionPolicy-Restricted
        }
        4 {
            Set-ExecutionPolicy-Unrestricted
            Install-GeneralTools
            Set-ExecutionPolicy-Restricted
        }
        5 {
            Set-ExecutionPolicy-Unrestricted
            Install-DeveloperTools
            Set-ExecutionPolicy-Restricted
        }
        6 {
            Set-ExecutionPolicy-Unrestricted
            Install-Office
            Set-ExecutionPolicy-Restricted
        }
        7 {
            Set-ExecutionPolicy-Unrestricted
            Install-ChrisTitusScript
            Set-ExecutionPolicy-Restricted
        }
        8 {
            Set-ExecutionPolicy-Unrestricted
            Activate-System
            Set-ExecutionPolicy-Restricted
        }
        9 {
            Write-Host "Exiting..." -ForegroundColor Yellow
        }
        default {
            Write-Host "Invalid choice. Please select a valid option." -ForegroundColor Red
        }
    }
    if ($choice -ne 9) {
        pause
    }
} while ($choice -ne 9)
