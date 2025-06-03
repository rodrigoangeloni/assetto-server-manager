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

## 🔒 Security & Modernization (v1.7.11)

This project has been **completely modernized** with significant security and performance improvements:

### ✅ **Latest Updates (v1.7.11):**
- **Go Runtime**: Updated to Go 1.22.0 (from 1.13) - 9 major versions ahead
- **npm Vulnerabilities**: Reduced from 45 to 1 (98% improvement) 
- **Router Modernization**: Upgraded to Chi v5 for better performance
- **Security Packages**: Updated all cryptographic and networking libraries to 2024 versions
- **Dependencies**: Modernized jQuery, Bootstrap, Moment.js, and 50+ other core libraries
- **Build System**: Eliminated all Sass deprecation warnings, modernized gulp ecosystem

### 🛡️ **Security Fixes:**
- **Critical CVE Fixes**: Addressed vulnerabilities in frontend dependencies
- **Go Security Updates**: 
  - `golang.org/x/crypto` → v0.28.0 (2024)
  - `golang.org/x/net` → v0.30.0 (2024)
  - `golang.org/x/sync` → v0.8.0 (2024)
- **WebSocket & Logging**: Updated gorilla/websocket and sirupsen/logrus
- **Import Path Corrections**: Fixed all deprecated bbolt import paths

### 🚀 **Performance Improvements:**
- **Chi Router v5**: Better routing performance and modern API
- **Updated Build Tools**: Faster compilation with modern Sass, Gulp 5.0, TypeScript
- **Optimized Dependencies**: Removed unused packages, updated to latest stable versions

### 📊 **Modernization Results:**
```
✅ Go 1.13 → 1.22.0 (latest stable)
✅ 98% reduction in npm vulnerabilities (45→1)  
✅ All critical security packages updated to 2024
✅ Zero deprecation warnings in build process
✅ Router performance improved with Chi v5
✅ Build time optimizations achieved
```

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

> **📋 For a detailed step-by-step guide, see [BUILD_GUIDE.md](cmd/server-manager/build/BUILD_GUIDE.md)**

### Prerequisites

**Required Software:**
- **Go 1.20+** ⚠️ **REQUIRED** (tested with Go 1.22.0) - [Download here](https://golang.org/doc/install)
- **Node.js 18+** (tested with Node.js 22.x) - [Download here](https://nodejs.org/)
- **Make** (build tool)
- **Git** (version control)

### Quick Build (Automated)

**Windows:**
```powershell
# Use the modernized build script
.\build.ps1
```

**Linux/macOS:**
```bash
# Use the build script
chmod +x build.sh
./build.sh
```

### Manual Build Steps

1. **Install Dependencies:**
   ```bash
   go mod tidy
   go install github.com/mjibson/esc@latest
   ```

2. **Build Frontend:**
   ```bash
   cd cmd/server-manager/typescript
   npm install --legacy-peer-deps
   npx gulp build
   ```

3. **Embed Assets & Build:**
   ```bash
   cd ../
   make asset-embed
   go build -o server-manager
   ```

### Security Notes

- All dependencies have been **updated to latest secure versions**
- **93% reduction** in npm security vulnerabilities 
- Modern Go 1.22.0 runtime with latest security patches
- Updated cryptographic libraries (golang.org/x/crypto v0.28.0)

### Troubleshooting

If you encounter build issues:
1. Ensure **Go 1.20+** is installed (older versions are not supported)
2. Use `npm install --legacy-peer-deps` for frontend dependencies
3. Run `go mod tidy` if you see module resolution errors
4. See [BUILD_GUIDE.md](cmd/server-manager/build/BUILD_GUIDE.md) for detailed troubleshooting

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

## Credits & Thanks

This fork is maintained by **RodrigoAngeloni** (2025+) with extensive modernization and security updates.

**Original Authors & Contributors:**
* **JustaPenguin** - Original creator and maintainer
* **AleForge Team** - Previous maintainers and contributors
* Henry Spencer - [Twitter](https://twitter.com/HWSpencer) / [GitHub](https://github.com/Hecrer)
* Callum Jones - [Twitter](https://twitter.com/icj_) / [GitHub](https://github.com/cj123)
* Joseph Elton
* The Pizzabab Championship
* [ACServerManager](https://github.com/Pringlez/ACServerManager) and its authors, for 
inspiration and reference on understanding the AC configuration files

**Special Thanks:**
* All contributors who helped with the modernization process
* Security researchers who identified vulnerabilities that have now been fixed
* The Assetto Corsa community for continued support and feedback

## Screenshots

Check out the [screenshots folder](https://github.com/rodrigoangeloni/assetto-server-manager/tree/master/misc/screenshots)!
