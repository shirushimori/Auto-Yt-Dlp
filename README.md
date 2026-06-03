# Auto-Yt-Dlp

A simple yt-dlp wrapper script I made because I got tired of typing yt-dlp commands every time I wanted to download something.

Works on:

* Windows
* Linux
* macOS

It can install what it needs, ask you what you want to download, and then handle the rest.

## What it can do

* Download videos
* Download audio only
* Download playlists
* Choose video quality
* Choose audio quality
* Save metadata
* Pick where files get saved
* Create playlist folders automatically
* Installs yt-dlp and ffmpeg if they are missing

Nothing fancy, just meant to make yt-dlp easier to use.

---

# Install

## Linux / macOS

Just run:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/shirushimori/Auto-Yt-Dlp/main/linux-mac/install.sh)"
```

The installer will:

* Check if curl exists
* Download Auto-Yt-Dlp
* Put everything in:

```text
~/Applications/AutoScripts-Mori/
```

* Create shortcuts if supported by your desktop environment

---

## Windows

Open PowerShell as Administrator and run:

```powershell
irm https://raw.githubusercontent.com/shirushimori/Auto-Yt-Dlp/main/windows/install.ps1 | iex
```

or just download and run:

```text
windows/install.bat
```

The installer will automatically:

* Install Chocolatey if needed
* Install curl if needed
* Download Auto-Yt-Dlp
* Create Desktop shortcut
* Create Start Menu shortcut

---

# Running

## Linux / macOS

```bash
~/Applications/AutoScripts-Mori/auto-dlp.sh
```

or launch it from your applications menu if a shortcut was created.

## Windows

Use the Desktop shortcut or search for:

```text
Auto-Yt-Dlp
```

in the Start Menu.

---

# Download Options

### Video

Available qualities depend on the video, but you can choose things like:

* 480p
* 720p
* 1080p
* 1440p
* 4K

### Audio

Formats:

* MP3
* M4A
* Opus
* WebM

You can also choose audio quality before downloading.

---

# Why I made this

I use yt-dlp a lot but I wanted something that was a little more beginner friendly and didn't require remembering a bunch of command line arguments.

So this project basically asks a few questions and then builds the yt-dlp command for you.

---

# Repo

https://github.com/shirushimori/Auto-Yt-Dlp

If something breaks or you have an idea, open an issue.

---

# License

MIT
