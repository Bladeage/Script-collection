# Define the version number
$version = "v1.0"

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

function Install-Packages {
    param (
        [string]$packages,
        [string]$taskName
    )
    Write-Host "Installing $taskName..." -ForegroundColor Cyan

    # Teile die durch Kommata getrennte Liste in ein Array auf
    $packageArray = $packages -split ','

    $totalPackages = $packageArray.Count
    $currentPackage = 0

    foreach ($package in $packageArray) {
        $currentPackage++
        $percentComplete = [math]::Round(($currentPackage / $totalPackages) * 100)
        Show-ProgressBar -activity "Installing $package" -percentComplete $percentComplete

        winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
    }

    Show-ProgressBar -activity "$taskName Complete" -percentComplete 100
    Write-Host "Done installing $taskName." -ForegroundColor Green
}

function Search-Packages {
    param (
        [string]$searchTerm
    )
    # Führe die Suche durch und extrahiere die IDs
    $packages = winget search $searchTerm | ForEach-Object {
        # Extrahiere die Paket-IDs aus der Zeile
        if ($_ -match '^\s*([\w\.\-]+)\s+') {
            $matches[1]
        }
    }
    return $packages -join ','
}

function Install-DotNetPackages {
    Write-Host "Searching for .NET packages..." -ForegroundColor Cyan

    # Definiere die Liste von spezifischen .NET-Paketen
    $specificDotNetPackages = @(
        "Microsoft.dotnetUninstallTool",
        "Microsoft.DotNet.DesktopRuntime",
        "Microsoft.DotNet.Runtime",
        "Microsoft.DotNet.Asp",
        "Microsoft.DotNet.SDK",
        "Microsoft.DotNet.HostingBundle"
    )

    # Füge zusätzliche Pakete hinzu
    $additionalPackages = @(
        "Oracle.JDK.22",
        "Oracle.JavaRuntimeEnvironment",
        "Microsoft.DirectX"
    )

    # Suche nach allen Paketen, die mit Microsoft.DotNet. beginnen und extrahiere die IDs
    $dotNetPackages = Search-Packages -searchTerm "Microsoft.DotNet."

    # Kombiniere die spezifischen .NET-Pakete mit den zusätzlichen Paketen
    $allPackages = $dotNetPackages + "," + ($specificDotNetPackages -join ',') + "," + ($additionalPackages -join ',')

    # Erzeuge eine durch Kommas getrennte Liste der Paket-IDs
    $packagesList = $allPackages -join ","

    # Überprüfe, ob tatsächlich Pakete gefunden wurden
    if ([string]::IsNullOrWhiteSpace($packagesList)) {
        Write-Host "No .NET packages found." -ForegroundColor Red
        return
    }

    # Installiere alle gefundenen Pakete
    Install-Packages -packages $packagesList -taskName ".NET Libraries and Additional Packages"
}

function Update-System {
    Execute-RemoteScript -url "https://update.geyer.zone" -taskName "Updating System"
}

function Install-Winget {
    Execute-RemoteScript -url "https://winget.geyer.zone" -taskName "Installing Winget"
}

function Install-Office {
    Execute-RemoteScript -url "https://office.geyer.zone" -taskName "Installing Office"
}

function Install-ChrisTitusScript {
    Execute-RemoteScript -url "https://winutil.geyer.zone" -taskName "Running Chris Titus Script"
}

function Activate-System {
    Execute-RemoteScript -url "https://activate.geyer.zone" -taskName "Activating System"
}

function Show-Menu {
    cls
    Write-Host "=========================="
    Write-Host "  Installation Menu $version"
    Write-Host "=========================="
    Write-Host "1. System Update via PowerShell (!!! CAUTION: Auto-Restart !!!)" -ForegroundColor Yellow
    Write-Host "2. Install WinGet/ AppInstaller" -ForegroundColor Cyan
    Write-Host "3. Install .Net and Libraries" -ForegroundColor Cyan
    Write-Host "4. Install Generic Tools" -ForegroundColor Cyan
    Write-Host "5. Install Gaming Tools" -ForegroundColor Cyan
    Write-Host "6. Install Developer Tools" -ForegroundColor Cyan
    Write-Host "7. Install Office Tool" -ForegroundColor Cyan
    Write-Host "8. Run ChrisTitus' WinUtil Script" -ForegroundColor Yellow
    Write-Host "9. Activate Windows via Massgraves' Script" -ForegroundColor Yellow
    Write-Host "0. Exit" -ForegroundColor Red
    Write-Host "=========================="
    $choice = Read-Host "Enter your choice (0-9)"
    return $choice
}

# Display version
Write-Host "Version $version" -ForegroundColor Green

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
            Install-DotNetPackages
            Set-ExecutionPolicy-Restricted
        }
        4 {
            Set-ExecutionPolicy-Unrestricted
            Install-Packages -packages @("7zip.7zip", "Microsoft.PowerShell", "Microsoft.WindowsTerminal") -taskName "Generic Tools"
            Set-ExecutionPolicy-Restricted
        }
        5 {
            Set-ExecutionPolicy-Unrestricted
            Install-Packages -packages @("Steam.Steam", "Razer.Synapse", "NVIDIA.GeForceExperience") -taskName "Gaming Tools"
            Set-ExecutionPolicy-Restricted
        }
        6 {
            Set-ExecutionPolicy-Unrestricted
            Install-Packages -packages @("Microsoft.VisualStudioCode", "Git.Git", "Python.Python.3", "Docker.DockerDesktop", "Notepad++.Notepad++") -taskName "Developer Tools"
            Set-ExecutionPolicy-Restricted
        }
        7 {
            Set-ExecutionPolicy-Unrestricted
            Install-Office
            Set-ExecutionPolicy-Restricted
        }
        8 {
            Set-ExecutionPolicy-Unrestricted
            Install-ChrisTitusScript
            Set-ExecutionPolicy-Restricted
        }
        9 {
            Set-ExecutionPolicy-Unrestricted
            Activate-System
            Set-ExecutionPolicy-Restricted
        }
        0 {
            Write-Host "Exiting..." -ForegroundColor Yellow
        }
        default {
            Write-Host "Invalid choice. Please select a valid option." -ForegroundColor Red
        }
    }
    if ($choice -ne 0) {
        pause
    }
} while ($choice -ne 0)
