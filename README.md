Assetto Server Manager
======================

[![Build Status](https://travis-ci.org/JustaPenguin/assetto-server-manager.svg?branch=master)](https://travis-ci.org/JustaPenguin/assetto-server-manager) [![Discord](https://img.shields.io/discord/557940238991753223.svg)](https://discordapp.com/invite/6DGKJzB)

A web interface to manage an Assetto Corsa Server.

**This is a fork maintained by RodrigoAngeloni**, based on the excellent work of the original authors.

## Features

* Quick Race Mode
* Custom Race Mode with saved presets
* Live Timings for current sessions
* Results pages for all previous sessions, with the ability to apply penalties
* Content Management - Upload tracks, weather and cars
* Sol Integration - Sol weather is compatible, including 24 hour time cycles (session start may advance/reverse time really fast before it syncs up - requires drivers to launch from content manager)
* Championship mode - configure multiple race events and keep track of driver, class and team points
* Race Weekends - a group of sequential sessions that can be run at any time. For example, you could set up a Qualifying session to run on a Saturday, then the Race to follow it on a Sunday. Server Manager handles the starting grid for you, and lets you organise Entrants into splits based on their results and other factors!
* Integration with [Assetto Corsa Skill Ratings](https://acsr.assettocorsaservers.com)!
* Automatic event looping
* Server Logs / Options Editing
* Accounts system with different permissions levels
* Linux and Windows Support!

**If you like Assetto Server Manager, please consider supporting us with a [donation](https://www.paypal.com/biz/fund?id=9LE45G9P3KPQW)!**

## Installation


### Manual

1. Download the latest release from the [releases page](https://github.com/JustaPenguin/assetto-server-manager/releases)
2. Extract the release
3. Edit the config.yml to suit your preferences
4. Either:
   - Copy the server folder from your Assetto Corsa install into the directory you configured in config.yml, or
   - Make sure that you have [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) installed and in your $PATH 
     and have configured the steam username and password in the config.yml file.
5. Start the server using `./server-manager` (on Linux) or by running `server-manager.exe` (on Windows)


### Docker

A docker image is available under the name `seejy/assetto-server-manager`. We recommend using docker-compose
to set up a docker environment for the server manager. This docker image has steamcmd pre-installed.

See [Manual](#Manual) to set up server manager without Docker.

**Note**: if you are using a directory volume for the server install (as is shown below), be sure to make 
the directory before running `docker-compose up` - otherwise its permissions may be incorrect. 

You will need a [config.yml](https://github.com/JustaPenguin/assetto-server-manager/blob/master/cmd/server-manager/config.example.yml) file to mount into the docker container.

An example docker-compose.yml looks like this:

```yaml
version: "3"

services:
  server-manager:
    image: seejy/assetto-server-manager:latest
    ports:
    # the port that the server manager runs on
    - "8772:8772"
    # the port that the assetto server runs on (may vary depending on your configuration inside server manager)
    - "9600:9600"
    - "9600:9600/udp"
    # the port that the assetto server HTTP API runs on.
    - "8081:8081"
    # you may also wish to bind your configured UDP plugin ports here. 
    volumes: 
    # volume mount the entire server install so that 
    # content etc persists across restarts
    - ./server-install:/home/assetto/server-manager/assetto
    
    # volume mount the config
    - ./config.yml:/home/assetto/server-manager/config.yml
```

### Post Installation

We recommend uploading your entire Assetto Corsa `content/tracks` folder to get the full features of Server Manager. 
This includes things like track images, all the correct layouts and any mod tracks you may have installed.

Also, we recommend installing Sol locally and uploading your Sol weather files to Server Manager as well so you can try out Day/Night cycles and cool weather!

### Updating

Follow the steps below to update Server Manager:

1. Back up your current Server Manager database and config.yml.
2. Download the [latest version of Server Manager](https://github.com/JustaPenguin/assetto-server-manager/releases)
3. Extract the zip file.
4. Open the Changelog, read the entries between your current version and the new version. 
   There may be configuration changes that you need to make!
5. Make any necessary configuration changes.
6. Find the Server Manager executable for your operating system. Replace your current Server Manager
   executable with it.
7. Start the new Server Manager executable.

## Build From Source Process

### Prerequisites

**Required Software:**
- **Go 1.20+** (tested with Go 1.24.3) - [Download here](https://golang.org/doc/install)
- **Node.js 18+** (tested with Node.js 22.x) - [Download here](https://nodejs.org/)
- **Make** (build tool)
- **Git** (version control)

### Platform-Specific Setup

#### Linux/macOS

1. **Install Go and Node.js** following the official installation guides
2. **Install make** (usually pre-installed or available via package manager)
3. **Clone the repository:**
   ```bash
   git clone https://github.com/JustaPenguin/assetto-server-manager.git
   cd assetto-server-manager
   ```

#### Windows

1. **Install Go:**
   ```powershell
   winget install GoLang.Go
   ```

2. **Install Node.js:**
   ```powershell
   winget install OpenJS.NodeJS
   ```

3. **Install Make for Windows:**
   ```powershell
   # Install Chocolatey first (if not already installed)
   Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
   
   # Install make
   choco install make
   ```

4. **Clone the repository:**
   ```powershell
   git clone https://github.com/JustaPenguin/assetto-server-manager.git
   cd assetto-server-manager
   ```

### Build Instructions

#### Step 1: Install Go Dependencies

```bash
# Linux/macOS
export GO111MODULE=on
go mod tidy

# Windows PowerShell
$env:GO111MODULE = 'on'
go mod tidy
```

#### Step 2: Install esc tool (for embedding assets)

```bash
go install github.com/mjibson/esc@latest
```

#### Step 3: Build Frontend Assets

Navigate to the frontend directory and install dependencies:

```bash
# Linux/macOS
cd cmd/server-manager/typescript
npm install --legacy-peer-deps
npx gulp build

# Windows PowerShell
cd cmd\server-manager\typescript
npm install --legacy-peer-deps
npx gulp build
```

**Note:** We use `--legacy-peer-deps` to resolve dependency conflicts with older packages.

#### Step 4: Embed Assets

```bash
# Return to project root
cd ../../..  # Linux/macOS
cd ..\..\..  # Windows

# Embed frontend assets into Go binary
cd cmd/server-manager
make asset-embed
```

#### Step 5: Build the Application

```bash
# Build for current platform
go build -o server-manager

# Cross-compile for different platforms
# For Linux (from any platform):
$env:GOOS="linux"; $env:GOARCH="amd64"; go build -o server-manager-linux

# For Windows (from any platform):
$env:GOOS="windows"; $env:GOARCH="amd64"; go build -o server-manager.exe
```

#### Step 6: Configuration

1. **Create configuration file:**
   ```bash
   cp config.example.yml config.yml
   ```

2. **Edit config.yml** - Important settings to configure:
   - Steam credentials (can be left empty for manual server management)
   - Server paths
   - Default admin account
   - Port settings

3. **Create Assetto Corsa directory structure** (if not using Steam auto-install):
   ```bash
   mkdir -p assetto/content/tracks assetto/content/cars assetto/system
   ```

#### Step 7: Run the Application

```bash
# Linux/macOS
./server-manager

# Windows
.\server-manager.exe
```

The web interface will be available at `http://localhost:8772`

### Quick Build Script

For convenience, here's a complete build script:

**Linux/macOS:**
```bash
#!/bin/bash
export GO111MODULE=on
go mod tidy
go install github.com/mjibson/esc@latest
cd cmd/server-manager/typescript
npm install --legacy-peer-deps
npx gulp build
cd ../
make asset-embed
go build -o server-manager
echo "Build complete! Run with: ./server-manager"
```

**Windows PowerShell:**
```powershell
$env:GO111MODULE = 'on'
go mod tidy
go install github.com/mjibson/esc@latest
cd cmd\server-manager\typescript
npm install --legacy-peer-deps
npx gulp build
cd ..\
make asset-embed
go build -o server-manager.exe
Write-Host "Build complete! Run with: .\server-manager.exe"
```

### Troubleshooting

**Common Issues:**

1. **node-sass compilation errors:** 
   - Solution: The project has been updated to use `sass` (Dart Sass) instead of `node-sass`

2. **Missing dependencies:**
   - Solution: Run `npm install --legacy-peer-deps` in the typescript directory

3. **Make command not found (Windows):**
   - Solution: Install make via Chocolatey as shown above

4. **GLIBC version errors (Linux):**
   - Solution: Use `CGO_ENABLED=0` when building: `CGO_ENABLED=0 go build -o server-manager`

5. **Permission errors:**
   - Solution: Ensure you have write permissions in the build directory

6. Server Manager should now be running! You can find the UI in your browser at your 
configured hostname (default 0.0.0.0:8772).

### 🚀 Quick Build Scripts

For convenience, we've included automated build scripts:

**Windows:**
```powershell
.\build.ps1
```

**Linux/macOS:**
```bash
chmod +x build.sh
./build.sh
```

These scripts will handle the entire build process automatically, including dependency checking, frontend compilation, asset embedding, and cross-platform compilation.

### 📖 Detailed Build Guide

For a comprehensive step-by-step guide with troubleshooting, see **[BUILD_GUIDE.md](BUILD_GUIDE.md)**.

## Credits & Thanks

This fork is maintained by **RodrigoAngeloni** (2025+).

Assetto Corsa Server Manager would not have been possible without the following people and their original work:

* **JustaPenguin** - Original creator and maintainer
* **AleForge Team** - Previous maintainers and contributors
* Henry Spencer - [Twitter](https://twitter.com/HWSpencer) / [GitHub](https://github.com/Hecrer)
* Callum Jones - [Twitter](https://twitter.com/icj_) / [GitHub](https://github.com/cj123)
* Joseph Elton
* The Pizzabab Championship
* [ACServerManager](https://github.com/Pringlez/ACServerManager) and its authors, for 
inspiration and reference on understanding the AC configuration files

## Screenshots

Check out the [screenshots folder](https://github.com/rodrigoangeloni/assetto-server-manager/tree/master/misc/screenshots)!
