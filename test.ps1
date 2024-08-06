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
    Show-Progress -TaskName $taskName -Activity {
        iex (irm $url)
    }
}

function Show-Progress {
    param (
        [string]$TaskName,
        [scriptblock]$Activity
    )
    $progress = 0
    $activity = Start-Job -ScriptBlock $Activity
    while (-not $activity.HasExited) {
        $progress = ($progress + 5) % 105
        Write-Progress -Activity $TaskName -Status "In Progress" -PercentComplete $progress
        Start-Sleep -Milliseconds 500
    }
    Write-Progress -Activity $TaskName -Completed -Status "Completed"
    $activity | Receive-Job
}

function Install-DotNetAndLibraries {
    Write-Host "Installing .NET and other libraries..." -ForegroundColor Cyan

    $packages = winget search dotnet | Select-String "Microsoft.DotNet" | ForEach-Object { $_.Line.Split()[0] }
    $packages += winget search Microsoft.VC | Select-String "Microsoft.VC" | ForEach-Object { $_.Line.Split()[0] }
    $packages += @("Microsoft.DirectX", "Microsoft.XNARedist")

    foreach ($package in $packages) {
        Write-Host "Installing $package..."
        Show-Progress -TaskName "Installing $package" -Activity {
            winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
        }
    }

    # Java installations
    $javaPackages = @("Oracle.JavaRuntimeEnvironment", "Oracle.JDK.22")
    foreach ($package in $javaPackages) {
        Write-Host "Installing $package..."
        Show-Progress -TaskName "Installing $package" -Activity {
            winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
        }
    }

    Write-Host "Done installing libraries." -ForegroundColor Green
}

function Install-GeneralTools {
    Write-Host "Installing general tools..." -ForegroundColor Cyan

    $packages = @("7zip.7zip", "Microsoft.PowerShell", "Microsoft.WindowsTerminal")
    foreach ($package in $packages) {
        Write-Host "Installing $package..."
        Show-Progress -TaskName "Installing $package" -Activity {
            winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
        }
    }

    Write-Host "Done installing general tools." -ForegroundColor Green
}

function Install-DeveloperTools {
    Write-Host "Installing developer tools..." -ForegroundColor Cyan

    $packages = @("Microsoft.VisualStudioCode", "Git.Git", "Python.Python.3", "Docker.DockerDesktop", "Notepad++.Notepad++")
    foreach ($package in $packages) {
        Write-Host "Installing $package..."
        Show-Progress -TaskName "Installing $package" -Activity {
            winget install --id $package --accept-package-agreements --accept-source-agreements --force --silent
        }
    }

    Write-Host "Done installing developer tools." -ForegroundColor Green
}

function Update-System {
    Write-Host "Updating system..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://update.geyer.zone" -TaskName "Updating System"
    Write-Host "System update completed." -ForegroundColor Green
}

function Install-Winget {
    Write-Host "Installing winget..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://winget.geyer.zone" -TaskName "Installing Winget"
    Write-Host "Winget installation completed." -ForegroundColor Green
}

function Install-Office {
    Write-Host "Installing Office..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://office.geyer.zone" -TaskName "Installing Office"
    Write-Host "Office installation completed." -ForegroundColor Green
}

function Install-ChrisTitusScript {
    Write-Host "Running Chris Titus script..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://winutil.geyer.zone" -TaskName "Running Chris Titus Script"
    Write-Host "Chris Titus script completed." -ForegroundColor Green
}

function Activate-System {
    Write-Host "Activating system..." -ForegroundColor Cyan
    Execute-RemoteScript -url "https://activate.geyer.zone" -TaskName "Activating System"
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
            Show-Progress -TaskName "Updating System" -Activity {
                iex (irm https://update.geyer.zone)
            }
            Set-ExecutionPolicy-Restricted
        }
        2 {
            Set-ExecutionPolicy-Unrestricted
            Show-Progress -TaskName "Installing Winget" -Activity {
                iex (irm https://winget.geyer.zone)
            }
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
            Show-Progress -TaskName "Installing Office" -Activity {
                iex (irm https://office.geyer.zone)
            }
            Set-ExecutionPolicy-Restricted
        }
        7 {
            Set-ExecutionPolicy-Unrestricted
            Show-Progress -TaskName "Running Chris Titus Script" -Activity {
                iex (irm https://winutil.geyer.zone)
            }
            Set-ExecutionPolicy-Restricted
        }
        8 {
            Set-ExecutionPolicy-Unrestricted
            Show-Progress -TaskName "Activating System" -Activity {
                iex (irm https://activate.geyer.zone)
            }
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
