# Assetto Server Manager - AI Coding Agent Guide

## Project Overview

**Assetto Server Manager** is a Go-based web application for managing Assetto Corsa racing game servers. It provides race configuration, championship management, live timing, and server administration through a web UI.

- **Language**: Go 1.22+ (backend), TypeScript/JavaScript (frontend)
- **Framework**: Chi v5 router, custom template system, UDP communication with game server
- **Storage**: BoltDB or JSON-based (pluggable via `Store` interface)
- **Architecture**: Dependency injection via `Resolver` pattern with lazy initialization

## Architecture

### Core Components

1. **Resolver Pattern** (`resolver.go`): Central dependency injection container using lazy initialization
   - All managers/handlers created via `resolve*()` methods (singleton pattern)
   - Entry point: `NewResolver()` → initializes system → `ResolveRouter()` creates HTTP handler
   
2. **Manager Layer**: Business logic encapsulated in managers
   - `RaceManager`: Controls server process lifecycle, race events, scheduled races
   - `ChampionshipManager`: Multi-race championship logic, points calculation, ACSR integration
   - `RaceWeekendManager`: Sequential race weekend sessions (practice/qualifying/race)
   - `CarManager`, `TrackManager`: Content management with filesystem watching
   - `AccountManager`, `NotificationManager`, `ScheduledRacesManager`

3. **Handler Layer** (`*Handler` types): HTTP request handlers using `BaseHandler` for templating
   - Pattern: `NewXHandler(baseHandler, ...dependencies)` → methods are HTTP handlers
   - All handlers inject dependencies via resolver, use `viewRenderer` for templates

4. **Storage Layer** (`store.go`): Pluggable persistence via `Store` interface
   - Implementations: `BoltStore` (bbolt), `JSONStore` (filesystem)
   - All data types (races, championships, accounts) accessed through interface
   - Key method: `BuildStore()` in `StoreConfig` creates appropriate implementation

5. **Server Process** (`server_process.go`, `server_process_*.go`): 
   - `AssettoServerProcess`: Manages AC server binary lifecycle (start/stop/restart)
   - Platform-specific implementations via `server_process_windows.go` / `server_process_nonwindows.go`
   - UDP communication via `pkg/udp` for real-time game events

6. **Race Control** (`race_control.go`): Real-time race monitoring
   - WebSocket-based live timing/telemetry via `RaceControlHub`
   - Processes UDP messages from AC server (car positions, collisions, sessions)
   - Admin commands: kick users, restart sessions, broadcast chat

### Configuration System

- **INI Generation** (`config_ini*.go`): Go structs → Assetto Corsa `.ini` files
  - `ServerConfig` writes to `server_cfg.ini` via custom INI library (`github.com/cj123/ini`)
  - Entry lists generated in `entrylist_ini.go`
  - Pattern: Struct tags define INI sections/keys, `Write()` methods persist to disk

- **YAML Config** (`servermanager_config.go`): Application configuration
  - Read via `ReadConfig("config.yml")` at startup
  - Stores Steam credentials, HTTP settings, storage paths, plugin configs
  - Global `config` variable accessible throughout codebase

### Data Flow

```
HTTP Request → Router (router.go) 
  → Handler (championships_handler.go)
    → Manager (championship_manager.go) 
      → Store (store_bolt.go / store_json.go)
        → RaceManager → ServerProcess → AC Server (UDP)
```

## Development Workflows

### Building

**Automated (Recommended):**
```powershell
# Windows - handles all dependencies, frontend compilation, asset embedding
.\build.ps1

# Linux/macOS
./build.sh
```

**Manual Steps:**
```bash
# 1. Install Go dependencies
go mod tidy
go install github.com/mjibson/esc@latest

# 2. Build frontend (TypeScript → JavaScript, SASS → CSS)
cd cmd/server-manager/typescript
npm install --legacy-peer-deps
npx gulp build  # Runs gulpfile.js

# 3. Embed assets into Go binary
cd ../
make asset-embed  # Generates *_embed.go files via esc tool

# 4. Build application
go build -o server-manager
```

**Key Files:**
- `Makefile`: Top-level build orchestration
- `cmd/server-manager/Makefile`: Application-specific builds, cross-compilation
- `cmd/server-manager/typescript/gulpfile.js`: Frontend asset pipeline (Browserify, Babel, SASS)
- `cmd/server-manager/typescript/package.json`: Node dependencies (jQuery, Bootstrap, TypeScript)

### Testing

```bash
# Run all tests
go test -race

# Tests use fixtures in fixtures/ directory
# Example: fixtures/barbagello.json contains race session data
```

**Test Patterns:**
- `*_test.go` files alongside implementation
- Table-driven tests common (see `championships_test.go`)
- No mocking framework - uses real `Store` implementations

### Running Locally

```bash
# Development mode (reload templates from filesystem)
FILESYSTEM_HTML=true DEBUG=true ./server-manager

# Access at http://localhost:8772
# Default credentials: admin / changeme (configure in config.yml)
```

## Coding Conventions

### Go Style

- **Package Structure**: Single `servermanager` package at root (flat structure, no internal packages except `/internal/changelog`, `/pkg/*`)
- **Naming**: 
  - Exported types: `PascalCase` (e.g., `RaceManager`, `ChampionshipEvent`)
  - Unexported: `camelCase` (e.g., `currentRace`, `forceStopTimer`)
  - Handlers: `*Handler` suffix, Managers: `*Manager` suffix
- **Error Handling**: Explicit error returns, logged via `logrus` (no panics except `panicCapture` wrapper)
- **Concurrency**: Mutex protection for shared state (see `RaceManager.mutex`, `AssettoServerProcess.mutex`)

### Configuration Patterns

**INI File Generation:**
```go
// 1. Define struct with ini tags
type SessionConfig struct {
    Name     string `ini:"NAME"`
    Time     int    `ini:"TIME"`
    WaitTime int    `ini:"WAIT_TIME"`
}

// 2. Write via ini library (PrettyFormat disabled in init())
f := ini.NewFile(...)
f.Section("SESSION").ReflectFrom(&config)
f.SaveTo(filepath.Join(ServerInstallPath, "cfg", "race.ini"))
```

**Store Access Pattern:**
```go
// All persistence goes through Store interface
race, err := store.FindCustomRaceByID(uuid)
if err != nil {
    return err
}
race.Name = "Updated Name"
return store.UpsertCustomRace(race)
```

### Frontend Integration

- **Asset Embedding**: `esc` tool generates `*_embed.go` with `http.FileSystem` implementation
- **Templates**: Custom Go template system in `templates.go`, data passed via `*templateVars` structs
- **Live Updates**: WebSocket connections via `gorilla/websocket` for race control

## Critical Paths

### Starting a Race

1. User submits form → `CustomRaceHandler.submit()` or `QuickRaceHandler.submit()`
2. Handler validates → calls `RaceManager.SetupCustomRace()` or `SetupQuickRace()`
3. `RaceManager.applyConfigAndStart()`:
   - Writes `server_cfg.ini`, `entry_list.ini` via `ServerConfig.Write()`, `EntryList.Write()`
   - Calls `ServerProcess.Start()` → spawns `acServer.exe`/`acServer` subprocess
   - Initializes UDP listener on configured port
4. UDP callbacks flow: `ServerProcess.UDPCallback()` → `Resolver.UDPCallback()` → managers

### Championship Event Completion

1. AC server sends `EndSession` UDP message
2. `ChampionshipManager.ChampionshipEventCallback()` processes results
3. Points calculated via `ChampionshipPoints.ForPos()`, standings updated
4. Results persisted to `Store.UpsertChampionship()`
5. Notifications sent via `NotificationManager` (Discord, if configured)

## Integration Points

### External Dependencies

- **SteamCMD**: Downloads/updates AC server files (optional, configure in `config.yml`)
- **sTracker**: Stats tracking plugin (proxied at `/stracker/`, configured via `StrackerHandler`)
- **ACSR (Assetto Corsa Skill Ratings)**: Rating system integration (`acsr.go`, API client)
- **Discord**: Notifications via webhook (`discord.go`, `DiscordManager`)
- **Plugins**: Lua scripting support (Premium feature, `lua.go`)

### UDP Communication

- **Protocol**: Custom binary protocol in `pkg/udp` (events: car update, collision, lap completed, session end)
- **Flow**: AC Server → UDP port (9600 default) → `AssettoServerProcess` → broadcast to managers
- **Key Events**: 
  - `EventNewSession`: Race start
  - `EventCollisionWithCar`: Penalty tracking
  - `EventLapCompleted`: Timing data
  - `EventEndSession`: Results processing

## Common Tasks

### Adding a New Race Event Type

1. Define struct implementing `RaceEvent` interface (`race_event.go`)
2. Add handler methods in new `*_handler.go` file
3. Create manager in `*_manager.go` for business logic
4. Wire up in `Resolver` with `resolve*()` methods
5. Add routes in `Router()` function (`router.go`)
6. Create templates in `views/` directory
7. Add `Store` methods if persistence needed

### Modifying Server Configuration

1. Update structs in `config_ini.go` with INI tags
2. Modify HTML forms in `views/*.html` templates
3. Update `ServerConfig.Write()` if custom logic needed
4. Changes auto-applied on next race start

### Adding External Plugin Support

1. Define plugin config in `plugin_*_config.go` (struct with formulate tags)
2. Implement plugin logic in `plugin_*.go`
3. Add plugin to `ServerExtraConfig.Plugins` slice
4. Plugin processes started alongside AC server in `AssettoServerProcess.Start()`

## Known Patterns

### "Premium" Features

- Gated behind `Premium()` function (license check)
- Examples: Lua plugins, advanced live timing, race weekends
- Check before enabling features: `if Premium() { ... }`

### Session Types

- Defined as `SessionType` const (BOOK, PRACTICE, QUALIFY, RACE)
- Second races handled via `SessionTypeSecondRace` for reverse grids
- Configuration via `SessionSettings` struct with duration, laps, wait times

### Entrant Management

- `Entrant` struct represents driver/car combination
- `EntryList` is slice of `Entrant`
- "Open Entrants" mode: slots filled dynamically as players join
- "Fixed" mode: Pre-defined entry list

## Troubleshooting

### Build Issues

- **Gulp errors**: Run `npm install --legacy-peer-deps` (peer dependency conflicts expected)
- **"esc not found"**: Install via `go install github.com/mjibson/esc@latest`
- **Template errors**: Check `FILESYSTEM_HTML=true` for development, otherwise assets must be embedded

### Runtime Issues

- **Port conflicts**: Default 8772 for web UI, 9600 for UDP - check `config.yml`
- **Server won't start**: Verify `steam.install_path` points to AC server installation
- **UDP not working**: Check firewall rules, ensure `live_map.refresh_interval_ms > 0` in config

---

**When modifying this codebase:**
- Use resolver pattern for dependency injection
- Follow INI generation patterns for AC server config
- Test UDP integrations with real AC server when possible
- Respect the flat package structure (avoid creating new packages without strong justification)
- Update relevant `Store` interface methods if adding new persistence needs
