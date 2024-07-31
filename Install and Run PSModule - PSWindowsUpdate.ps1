# Funktion zur Ermittlung der Betriebssystemsprache
function Get-OSLanguage {
    $locale = Get-WinSystemLocale
    return $locale.Name
}

# Ermittelt die Sprache des Betriebssystems
$osLanguage = Get-OSLanguage

# Definiert Nachrichten in verschiedenen Sprachen
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
        ScriptComplete = "Das Skript wurde erfolgreich ausgeführt."
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
        ScriptComplete = "The script has been successfully executed."
    }
}

# Setzt die Sprache auf Englisch als Standard, wenn die Sprache nicht Deutsch ist
if ($osLanguage -ne "de-DE") {
    $osLanguage = "en-US"
}

# Setzt die Ausführungsrichtlinie so, dass das aktuelle Skript ausgeführt werden kann.
Write-Host $messages[$osLanguage].SetExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

# Installiert den NuGet Paket-Provider, falls noch nicht vorhanden.
Write-Host $messages[$osLanguage].CheckNuGet
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Write-Host $messages[$osLanguage].InstallNuGet
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
} else {
    Write-Host $messages[$osLanguage].NuGetInstalled
}

# Installiert das PSWindowsUpdate-Modul, falls noch nicht vorhanden.
Write-Host $messages[$osLanguage].CheckPSWindowsUpdate
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Host $messages[$osLanguage].InstallPSWindowsUpdate
    Install-Module -Name PSWindowsUpdate -Force
} else {
    Write-Host $messages[$osLanguage].PSWindowsUpdateInstalled
}

# Importiert das PSWindowsUpdate-Modul in die aktuelle Sitzung.
Write-Host $messages[$osLanguage].ImportPSWindowsUpdate
Import-Module PSWindowsUpdate

# Ruft verfügbare Windows-Updates ab und installiert diese.
Write-Host $messages[$osLanguage].GetWindowsUpdate
Get-WindowsUpdate -Install -AutoReboot

# Setzt die Ausführungsrichtlinie auf den ursprünglichen Wert zurück.
Write-Host $messages[$osLanguage].ResetExecutionPolicy
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process -Force

Write-Host $messages[$osLanguage].ScriptComplete
