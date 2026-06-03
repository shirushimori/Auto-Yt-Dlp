#Requires -Version 5.1

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

if (-not (Test-Admin)) {
    Write-Host "Restarting as Administrator..."
    Start-Process powershell -Verb RunAs -ArgumentList "-ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

Write-Host ""
Write-Host "===== yt-dlp Downloader ====="
Write-Host ""

# Chocolatey
if (!(Get-Command choco -ErrorAction SilentlyContinue)) {

    Write-Host "Chocolatey not found."
    Write-Host "Installing Chocolatey..."

    Set-ExecutionPolicy Bypass -Scope Process -Force

    [System.Net.ServicePointManager]::SecurityProtocol =
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

    Invoke-Expression (
        (New-Object System.Net.WebClient).DownloadString(
            'https://community.chocolatey.org/install.ps1'
        )
    )

    refreshenv
}

# yt-dlp
if (!(Get-Command yt-dlp -ErrorAction SilentlyContinue)) {
    choco install yt-dlp -y
}

# ffmpeg
if (!(Get-Command ffmpeg -ErrorAction SilentlyContinue)) {
    choco install ffmpeg -y
}

Write-Host ""
$url = Read-Host "Enter video or playlist URL"

Write-Host ""
Write-Host "1. Video"
Write-Host "2. Audio"
$mode = Read-Host "Choose"

Write-Host ""
Write-Host "1. Default Folder"
Write-Host "2. Custom Folder"
$saveChoice = Read-Host "Choose"

$saveDir = "$HOME\Downloads\yt-dlp"

if ($saveChoice -eq "2") {

    Add-Type -AssemblyName System.Windows.Forms

    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.Description = "Select Download Folder"

    if ($dialog.ShowDialog() -eq "OK") {
        $saveDir = $dialog.SelectedPath
    }
}

New-Item -ItemType Directory -Force -Path $saveDir | Out-Null

$playlistFolder = Read-Host "Create playlist subfolder? (y/n)"

if ($playlistFolder -eq "y") {

    $subFolder = Read-Host "Subfolder name"

    $saveDir = Join-Path $saveDir $subFolder

    New-Item -ItemType Directory -Force -Path $saveDir | Out-Null

    $playlistOpt = "--yes-playlist"
}
else {
    $playlistOpt = "--no-playlist"
}

$metadata = Read-Host "Embed metadata? (y/n)"

if ($metadata -eq "y") {
    $metaOpt = "--embed-metadata"
}
else {
    $metaOpt = ""
}

$output = "$saveDir\%(title)s.%(ext)s"

if ($mode -eq "1") {

    Write-Host ""
    Write-Host "Video Quality"
    Write-Host "1. 480p"
    Write-Host "2. 720p"
    Write-Host "3. 1080p"
    Write-Host "4. 1440p"
    Write-Host "5. 2160p (4K)"

    $vq = Read-Host "Choose"

    switch ($vq) {
        "1" { $height = 480 }
        "2" { $height = 720 }
        "3" { $height = 1080 }
        "4" { $height = 1440 }
        "5" { $height = 2160 }
        default { $height = 1080 }
    }

    yt-dlp `
        $playlistOpt `
        $metaOpt `
        --newline `
        --progress `
        --console-title `
        -f "bestvideo[height<=$height]+bestaudio/best[height<=$height]" `
        -o $output `
        $url
}
else {

    Write-Host ""
    Write-Host "Audio Format"
    Write-Host "1. mp3"
    Write-Host "2. m4a"
    Write-Host "3. opus"
    Write-Host "4. webm"

    $fmt = Read-Host "Choose"

    switch ($fmt) {
        "1" { $format = "mp3" }
        "2" { $format = "m4a" }
        "3" { $format = "opus" }
        "4" { $format = "webm" }
        default { $format = "mp3" }
    }

    Write-Host ""
    Write-Host "Audio Quality"
    Write-Host "1. 320k"
    Write-Host "2. 192k"
    Write-Host "3. 128k"
    Write-Host "4. 64k"

    $aq = Read-Host "Choose"

    switch ($aq) {
        "1" { $quality = "320K" }
        "2" { $quality = "192K" }
        "3" { $quality = "128K" }
        "4" { $quality = "64K" }
        default { $quality = "192K" }
    }

    yt-dlp `
        $playlistOpt `
        $metaOpt `
        --newline `
        --progress `
        --console-title `
        -x `
        --audio-format $format `
        --audio-quality $quality `
        -o $output `
        $url
}

Write-Host ""
Write-Host "Download completed."
Pause
