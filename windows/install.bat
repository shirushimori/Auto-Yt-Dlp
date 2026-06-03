$InstallDir = "$HOME\Applications\AutoScripts-Mori"
$ScriptPath = "$InstallDir\Auto-Dlp.ps1"
$RawUrl = "https://raw.githubusercontent.com/shirushimori/Auto-Yt-Dlp/refs/heads/main/windows/Auto-Dlp.ps1"

Write-Host "Installing Auto-Yt-Dlp..."

# Check curl

if (!(Get-Command curl.exe -ErrorAction SilentlyContinue)) {
Write-Host "curl not found."

```
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {

    Set-ExecutionPolicy Bypass -Scope Process -Force

    [System.Net.ServicePointManager]::SecurityProtocol =
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

    Invoke-Expression (
        (New-Object System.Net.WebClient).DownloadString(
            'https://community.chocolatey.org/install.ps1'
        )
    )
}

choco install curl -y
```

}

New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

curl.exe -L $RawUrl -o $ScriptPath

$Desktop = [Environment]::GetFolderPath("Desktop")
$StartMenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs"

$WshShell = New-Object -ComObject WScript.Shell

# Desktop Shortcut

$Shortcut = $WshShell.CreateShortcut("$Desktop\Auto-Yt-Dlp.lnk")
$Shortcut.TargetPath = "powershell.exe"
$Shortcut.Arguments = "-ExecutionPolicy Bypass -File `"$ScriptPath`""
$Shortcut.Save()

# Start Menu Shortcut

$Shortcut2 = $WshShell.CreateShortcut("$StartMenu\Auto-Yt-Dlp.lnk")
$Shortcut2.TargetPath = "powershell.exe"
$Shortcut2.Arguments = "-ExecutionPolicy Bypass -File `"$ScriptPath`""
$Shortcut2.Save()

Write-Host ""
Write-Host "Installed successfully."
Write-Host "Location: $ScriptPath"
Write-Host "Desktop and Start Menu shortcuts created."
