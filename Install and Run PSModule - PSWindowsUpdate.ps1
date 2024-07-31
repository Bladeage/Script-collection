# Funktion zur Ermittlung der Betriebssystemsprache / Function to determine the OS language
function Get-OSLanguage {
    $locale = Get-WinSystemLocale
    return $locale.Name
}

# Ermittelt die Sprache des Betriebssystems / Determine the OS language
$osLanguage = Get-OSLanguage

# Definiert Nachrichten in verschiedenen Sprachen / Define messages in different languages
$messages = @{
    "de-DE" = @{
        SetExecutionPolicy = "Setze die Ausführungsrichtlinie auf 'Unrestricted'..."
        CheckNuGet = "Überprüfe, ob der NuGet Paket-Provider installiert ist..."
        InstallNuGet = "Installiere NuGet Paket-Provider..."
        NuGetInstalled = "NuGet Paket-Provider ist bereits installiert."
        CheckPSWindowsUpdate = "Überprüfe, ob das PSWindowsUpdate-Modul installiert ist..."
        InstallPSWindowsUpdate = "Installiere PSWindowsUpdate-Modul..."
        PSWindowsUpdateInstalled = "PSWindowsUpdate-Modul ist bereits installiert."
        ImportPSWindowsUpdate = "Importiere PSWindowsUpdate-Modul..."
        GetWindowsUpdate = "Suche und installiere verfügbare Windows-Updates..."
        ResetExecutionPolicy = "Setze die Ausführungsrichtlinie zurück auf 'Restricted'..."
        ScriptComplete = "Das Skript wurde erfolgreich ausgeführt. Drücken Sie eine beliebige Taste, um das Fenster zu schließen."
    }
    "en-US" = @{
        SetExecutionPolicy = "Setting execution policy to 'Unrestricted'..."
        CheckNuGet = "Checking if NuGet Package Provider is installed..."
        InstallNuGet = "Installing NuGet Package Provider..."
        NuGetInstalled = "NuGet Package Provider is already installed."
        CheckPSWindowsUpdate = "Checking if PSWindowsUpdate module is installed..."
        InstallPSWindowsUpdate = "Installing PSWindowsUpdate module..."
        PSWindowsUpdateInstalled = "PSWindowsUpdate module is already installed."
        ImportPSWindowsUpdate = "Importing PSWindowsUpdate module..."
        GetWindowsUpdate = "Searching and installing available Windows updates..."
        ResetExecutionPolicy = "Resetting execution policy to 'Restricted'..."
        ScriptComplete = "The script has been successfully executed. Press any key to close the window."
    }
}

# Setzt die Sprache auf Englisch als Standard, wenn die Sprache nicht Deutsch ist / Set language to English if not German
if ($osLanguage -ne "de-DE") {
    $osLanguage = "en-US"
}

# Ändert den Fenstertitel / Change the window title
$host.UI.RawUI.WindowTitle = "PSWindowsUpdate - update.geyer.zone"

# Array der Aufgaben / Array of tasks
$tasks = @(
    "SetExecutionPolicy",
    "CheckNuGet",
    "InstallNuGet",
    "NuGetInstalled",
    "CheckPSWindowsUpdate",
    "InstallPSWindowsUpdate",
    "PSWindowsUpdateInstalled",
    "ImportPSWindowsUpdate",
    "GetWindowsUpdate",
    "ResetExecutionPolicy",
    "ScriptComplete"
)

# Initialisiert den Fortschrittsbalken / Initialize the progress bar
$totalTasks = $tasks.Count
$currentTask = 0

# Funktion zur Anzeige des Fortschrittsbalkens / Function to display the progress bar
function Show-ProgressBar {
    param (
        [string]$activity,
        [int]$percentComplete
    )
    Write-Progress -Activity $activity -Status "$percentComplete% Complete" -PercentComplete $percentComplete
}

# Führt die Schritte aus und aktualisiert den Fortschrittsbalken / Execute steps and update progress bar
foreach ($task in $tasks) {
    $currentTask++
    $percentComplete = [math]::Round(($currentTask / $totalTasks) * 100)
    
    Show-ProgressBar -activity $messages[$osLanguage].$task -percentComplete $percentComplete
    
    Write-Host $messages[$osLanguage].$task
    Start-Sleep -Seconds 1
    
    switch ($task) {
        "SetExecutionPolicy" {
            Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force
        }
        "CheckNuGet" {
            # Überprüfe, ob der NuGet Paket-Provider installiert ist / Check if NuGet Package Provider is installed
        }
        "InstallNuGet" {
            if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
                Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
            }
        }
        "NuGetInstalled" {
            # Keine Aktion erforderlich, Nachricht wird nur angezeigt / No action needed, just display message
        }
        "CheckPSWindowsUpdate" {
            # Überprüfe, ob das PSWindowsUpdate-Modul installiert ist / Check if PSWindowsUpdate module is installed
        }
        "InstallPSWindowsUpdate" {
            if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
                Install-Module -Name PSWindowsUpdate -Force
            }
        }
        "PSWindowsUpdateInstalled" {
            # Keine Aktion erforderlich, Nachricht wird nur angezeigt / No action needed, just display message
        }
        "ImportPSWindowsUpdate" {
            Import-Module PSWindowsUpdate
        }
        "GetWindowsUpdate" {
            Get-WindowsUpdate -Install -AutoReboot
        }
        "ResetExecutionPolicy" {
            Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process -Force
        }
        "ScriptComplete" {
            # Das Skript ist abgeschlossen / Script is complete
        }
    }
}

# Abschließende Meldung / Final message
Write-Host $messages[$osLanguage].ScriptComplete

# Wartet auf eine Benutzereingabe bevor das Fenster geschlossen wird / Wait for user input before closing the window
Read-Host -Prompt "Press Enter to exit / Drücken Sie die Eingabetaste zum Beenden"
