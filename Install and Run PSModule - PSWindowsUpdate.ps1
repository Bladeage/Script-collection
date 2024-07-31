# Setzt die Ausführungsrichtlinie so, dass das aktuelle Skript ausgeführt werden kann.
# Achtung: 'Unrestricted' kann Sicherheitsrisiken mit sich bringen, daher sollte diese Einstellung nur vorübergehend gesetzt werden.
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process -Force

# Installiert den NuGet Paket-Provider, falls noch nicht vorhanden.
# NuGet ist erforderlich, um das PSWindowsUpdate-Modul zu installieren.
if (-not (Get-PackageProvider -Name NuGet -ErrorAction SilentlyContinue)) {
    Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
}

# Installiert das PSWindowsUpdate-Modul, falls noch nicht vorhanden.
# Dieses Modul ermöglicht die Verwaltung von Windows-Updates über PowerShell.
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Install-Module -Name PSWindowsUpdate -Force
}

# Importiert das PSWindowsUpdate-Modul in die aktuelle Sitzung.
Import-Module PSWindowsUpdate

# Ruft verfügbare Windows-Updates ab und installiert diese.
# Der Parameter -AutoReboot sorgt dafür, dass der Computer bei Bedarf automatisch neu gestartet wird.
Get-WindowsUpdate -Install -AutoReboot

# Setzt die Ausführungsrichtlinie auf den ursprünglichen Wert zurück.
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope Process -Force
