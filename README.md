# 🏎️ Assetto Server Manager v1.7.12 - Complete English Guide

## 📋 Table of Contents
- [🚀 Introduction](#-introduction)
- [💻 Installation](#-installation)
- [🔧 Configuration](#-configuration)
- [🏁 Basic Usage](#-basic-usage)
- [⚙️ Advanced Features](#-advanced-features)
- [🔧 Compilation](#-compilation)
- [🐛 Troubleshooting](#-troubleshooting)
- [📖 References](#-references)

## 🚀 Introduction

**Assetto Server Manager** is a comprehensive web interface to manage an Assetto Corsa Server.

**This is a fork maintained by RodrigoAngeloni**, based on the excellent work of the original authors.

### ✨ What's New in v1.7.12
- 🎨 **Custom icon** in Windows executables
- 🧹 **Automatic cleanup system** for temporary files
- 📁 **Improved organization** of binaries in specific folders
- 🔄 **Optimized build process** with better resource handling
- 🛠️ **Automatic installation** of development tools
- 📊 **Version information** embedded in executables

## 🎯 Features

* **Quick Race Mode** - Start racing instantly
* **Custom Race Mode** with saved presets for your favorite configurations
* **Live Timings** for current sessions with real-time updates
* **Results pages** for all previous sessions, with the ability to apply penalties
* **Content Management** - Upload tracks, weather and cars easily
* **Sol Integration** - Sol weather is compatible, including 24 hour time cycles
* **Championship mode** - configure multiple race events and keep track of driver, class and team points
* **Race Weekends** - a group of sequential sessions that can be run at any time
* **Integration** with [Assetto Corsa Skill Ratings](https://acsr.assettocorsaservers.com)!
* **Automatic event looping** for continuous racing
* **Server Logs / Options Editing** with real-time monitoring
* **Accounts system** with different permissions levels
* **Linux and Windows Support** with optimized builds for both platforms

**If you like Assetto Server Manager, please consider supporting us with a [donation](https://www.paypal.com/biz/fund?id=9LE45G9P3KPQW)!**

## 🔒 Security & Modernization (v1.7.12)

This project has been **completely modernized** with significant security and performance improvements:

### ✅ **Latest Updates (v1.7.12):**
- **Go Runtime**: Updated to Go 1.22.0 (from 1.13) - 9 major versions ahead
- **npm Vulnerabilities**: Reduced from 45 to 1 (98% improvement) 
- **Router Modernization**: Upgraded to Chi v5 for better performance
- **Security Packages**: Updated all cryptographic and networking libraries to 2024 versions
- **Dependencies**: Modernized jQuery, Bootstrap, Moment.js, and 50+ other core libraries
- **Build System**: Eliminated all Sass deprecation warnings, modernized gulp ecosystem
- **Icon Integration**: Custom Windows executable icons with automated resource compilation
- **Build Organization**: Streamlined build process with automatic cleanup and organization

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
✅ Custom Windows icons with automated embedding
✅ Organized build artifacts in proper directory structure
```

## 💻 Installation

### 📋 Prerequisites

#### 🖥️ Windows
- **Go** 1.22.0 or higher
- **Node.js** 16.0 or higher
- **npm** 8.0 or higher
- **Make** (via Chocolatey: `choco install make`)
- **Git** for version control

#### 🐧 Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install golang-go nodejs npm make git

# CentOS/RHEL
sudo yum install golang nodejs npm make git
```

### 🚀 Quick Installation

#### 📥 Option 1: Download Pre-compiled Release
1. Go to the [Releases](https://github.com/JustaPenguin/assetto-server-manager/releases) page
2. Download `server-manager-v1.7.12-windows.zip` or `server-manager-v1.7.12-linux.tar.gz`
3. Extract the file to your preferred directory
4. Edit the `config.yml` to suit your preferences
5. Either:
   - Copy the server folder from your Assetto Corsa install into the directory you configured in config.yml, or
   - Make sure that you have [steamcmd](https://developer.valvesoftware.com/wiki/SteamCMD) installed and in your $PATH 
     and have configured the steam username and password in the config.yml file.
6. Start the server using `./server-manager` (on Linux) or by running `server-manager.exe` (on Windows)

🌐 **Access**: `http://localhost:8772`

👤 **Default credentials**:
- Username: `admin`
- Password: `changeme` (⚠️ Change it immediately!)

#### 📦 Option 2: Clone and Build from Source
```bash
git clone https://github.com/JustaPenguin/assetto-server-manager.git
cd assetto-server-manager
```

**Windows:**
```powershell
.\build.ps1
```

**Linux:**
```bash
chmod +x build.sh
./build.sh
```


## 🏁 Basic Usage

### 🏃‍♂️ Create Your First Race

1. **🖱️ Navigate to** "Custom Races"
2. **🏎️ Select**:
   - Track 🏁
   - Cars 🚗
   - Number of participants 👥
3. **⚙️ Configure**:
   - Session duration ⏱️
   - Weather conditions 🌤️
   - Server settings 🔧
4. **🚀 Start** the race

### 🏆 Championship Management

#### 📝 Create Championship
1. Go to "Championships" → "New Championship"
2. Configure:
   - 📛 Championship name
   - 📝 Description
   - 🎯 Points system
   - 👥 Participants

#### 📅 Schedule Events
- **⏰ Flexible scheduling** with multiple time zones
- **🔄 Recurring events** (weekly, monthly)
- **📧 Automatic notifications** for participants

## ⚙️ Advanced Features

### 🤖 Integrations

#### 📊 sTracker
```yaml
stracker:
  enabled: true
  http_config:
    listen_port: 50041
```

#### 🎮 Discord Bot
```yaml
discord:
  token: "your_discord_token"
  channel_id: "channel_id"
```

#### 🏁 Real Penalty Tool
- ⚖️ Automatic penalty system
- 📋 Customizable rule configuration
- 📊 Detailed infringement reports

### 🔐 Security and Users

#### 👥 User Management
- **🔑 Differentiated roles**: Admin, Write, Read, Delete
- **🔒 Steam authentication** (optional)
- **🛡️ Secure passwords** with configurable policies

#### 🔐 HTTPS Configuration
```yaml
tls:
  enabled: true
  cert_file: "/path/to/cert.pem"
  key_file: "/path/to/key.pem"
```

### 📊 Monitoring and Logs

#### 📈 Live Timings
- ⏱️ **Real-time timing** during races
- 🗺️ **Real-time map** of positions
- 💬 **Integrated chat** with moderation
- 📱 **Mobile-optimized** interface

#### 📋 Auditing
- 📝 **Detailed logs** of all actions
- 👤 **User tracking** and changes
- 📊 **Server usage** reports

## 🔧 Compilation

### 🛠️ Build System v1.7.12

The new system includes:

#### ✨ Build Script Features
- 🧹 **Automatic cleanup** at start and finish
- 🎨 **Automatic icon embedding**
- 📁 **Smart binary organization**
- 🔄 **Resource regeneration** on each build
- 📊 **Automatic version information**

#### 🚀 Build Process
```powershell
# The build.ps1 script automatically performs:

# 🧹 Step 0: Initial cleanup
# 📦 Step 1: Go dependencies installation
# 🎨 Step 2: Frontend compilation
# 📁 Step 3: Asset embedding
# 🎯 Step 4a: Resource compilation (icon)
# 🖥️ Step 4b: Application compilation
# 📋 Step 5: Post-compilation configuration
# 📦 Step 6: Release creation and final cleanup
```

#### 📂 Output Structure
```
cmd/server-manager/build/
├── 🖥️ windows/
│   ├── server-manager.exe  # With embedded icon
│   └── config.yml
├── 🐧 linux/
│   ├── server-manager
│   └── config.yml
└── 📚 documentation...
```

### 🎨 Icon Customization

To change the icon:
1. Replace `cmd/server-manager/static/img/servermanager.ico`
2. Run `.\build.ps1` - the new icon will be applied automatically

### 🔨 Manual Build Steps

If you prefer to build manually:

#### **Windows:**
```powershell
# Use the modernized build script
.\build.ps1
```

#### **Linux/macOS:**
```bash
# Use the build script
chmod +x build.sh
./build.sh
```

### 📋 Manual Build Steps

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

## 🐛 Troubleshooting

### ❗ Common Issues

#### 🚫 "Error: Go is not installed"
```powershell
# Install Go from https://golang.org/dl/
# Verify installation:
go version
```

#### 🚫 "Error: Make is not available"
```powershell
# Windows - install with Chocolatey:
choco install make

# Or use scoop:
scoop install make
```

#### 🚫 "Frontend compilation error"
```powershell
# Clear npm cache:
cd cmd\server-manager\typescript
npm cache clean --force
npm install --legacy-peer-deps
```

#### 🚫 "Port 8772 already in use"
```yaml
# Change port in config.yml:
port: 8773  # Or any free port
```

### 🔍 Logs and Debugging

#### 📋 Log Locations
- **Windows**: `cmd\server-manager\logs\`
- **Linux**: `cmd/server-manager/logs/`

#### 🐛 Debug Mode
```yaml
# config.yml
log_level: "debug"
```

#### 📊 Performance Monitoring
```yaml
monitoring:
  enabled: true
  metrics_port: 8773
```

### 🔧 Maintenance

#### 🗄️ Data Backup
```powershell
# Automatic backup of important data:
xcopy "cmd\server-manager\*.db" "backup\" /Y
xcopy "cmd\server-manager\config.yml" "backup\" /Y
```

#### 🔄 Updates
1. Backup `config.yml` and data files
2. Download new version
3. Replace binaries while maintaining configuration
4. Verify functionality

### 🐳 Docker

A docker image is available under the name `seejy/assetto-server-manager`. We recommend using docker-compose
to set up a docker environment for the server manager. This docker image has steamcmd pre-installed.

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
