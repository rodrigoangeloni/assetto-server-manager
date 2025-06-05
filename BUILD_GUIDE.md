# Guía de Compilación Paso a Paso - Assetto Server Manager

Esta guía te llevará paso a paso para compilar **Assetto Server Manager** desde el código fuente en Windows y Linux.

## 📋 Requisitos Previos

### Software Necesario

| Software | Versión Mínima | Versión Probada | Enlace |
|----------|----------------|-----------------|---------|
| **Go** | 1.22.0+ | 1.24.3 | [golang.org](https://golang.org/dl/) |
| **Node.js** | 18+ | 22.15.0 | [nodejs.org](https://nodejs.org/) |
| **Git** | Cualquiera | Última | [git-scm.com](https://git-scm.com/) |
| **Make** | Cualquiera | Última | Ver instalación abajo |

### Verificar Instalaciones

```bash
# Verificar versiones instaladas
go version          # Should show go1.22+
node --version      # Should show v18+
npm --version       # Should show 8+
git --version       # Any version
make --version      # Any version
```

---

## 🖥️ Instalación por Plataforma

### Windows (Recomendado: PowerShell como Administrador)

#### Opción 1: Instalación Automática con winget
```powershell
# Instalar Go
winget install GoLang.Go

# Instalar Node.js
winget install OpenJS.NodeJS

# Instalar Git (si no está instalado)
winget install Git.Git

# Instalar Make vía Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install make

# Reiniciar PowerShell para aplicar cambios en PATH
```

#### Opción 2: Instalación Manual
1. **Go**: Descargar desde [golang.org](https://golang.org/dl/) e instalar
2. **Node.js**: Descargar desde [nodejs.org](https://nodejs.org/) e instalar
3. **Git**: Descargar desde [git-scm.com](https://git-scm.com/) e instalar
4. **Make**: Instalar vía Chocolatey (ver comando arriba)

### Linux (Ubuntu/Debian)

```bash
# Actualizar sistema
sudo apt update

# Instalar dependencias básicas
sudo apt install -y curl wget git build-essential

# Instalar Go (versión más reciente)
wget https://go.dev/dl/go1.24.3.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.24.3.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Instalar Node.js vía NodeSource
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Make ya está incluido en build-essential
```

### macOS

```bash
# Instalar Homebrew si no está instalado
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Instalar dependencias
brew install go node git make
```

---

## 📁 Preparación del Proyecto

### 1. Clonar el Repositorio

```bash
# Clonar el proyecto
git clone https://github.com/JustaPenguin/assetto-server-manager.git
cd assetto-server-manager

# O si tienes el ZIP, extraerlo y navegar al directorio
```

### 2. Verificar Estructura del Proyecto

```
assetto-server-manager/
├── cmd/
│   └── server-manager/
│       ├── typescript/          # Frontend
│       ├── config.example.yml   # Configuración ejemplo
│       └── main.go              # Aplicación principal
├── go.mod                       # Dependencias Go
├── Makefile                     # Scripts de construcción
└── README.md
```

---

## 🔨 Proceso de Compilación

### Paso 1: Configurar Variables de Entorno

**Windows (PowerShell):**
```powershell
$env:GO111MODULE = 'on'
$env:CGO_ENABLED = '0'
```

**Linux/macOS:**
```bash
export GO111MODULE=on
export CGO_ENABLED=0
```

### Paso 2: Instalar Dependencias de Go

```bash
# Descargar y actualizar dependencias
go mod tidy

# Instalar herramienta esc para embebido de assets
go install github.com/mjibson/esc@latest
```

### Paso 3: Compilar Frontend

**Navegar al directorio del frontend:**

```bash
# Windows
cd cmd\server-manager\typescript

# Linux/macOS
cd cmd/server-manager/typescript
```

**Instalar dependencias de Node.js:**

```bash
# Instalar con flag legacy para resolver conflictos de dependencias
npm install --legacy-peer-deps
```

**Compilar assets del frontend:**

```bash
# Compilar usando Gulp
npx gulp build
```

> ⚠️ **Nota**: Puedes ver warnings de deprecación de SASS. Esto es normal y no afecta la funcionalidad.

### Paso 4: Embebido de Assets

**Regresar al directorio server-manager:**

```bash
# Windows
cd ..

# Linux/macOS
cd ../
```

**Embebir assets en el binario:**

```bash
make asset-embed
```

### Paso 5: Compilar la Aplicación

**Para la plataforma actual:**

```bash
go build -o server-manager
```

**Para compilación cruzada:**

```bash
# Para Linux (desde cualquier plataforma)
# Windows PowerShell:
$env:GOOS="linux"; $env:GOARCH="amd64"; go build -o server-manager-linux

# Linux/macOS:
GOOS=linux GOARCH=amd64 go build -o server-manager-linux

# Para Windows (desde cualquier plataforma)
# Linux/macOS:
GOOS=windows GOARCH=amd64 go build -o server-manager.exe
```

---

## ⚙️ Configuración Post-Compilación

### 1. Crear Archivo de Configuración

```bash
# Copiar el archivo de ejemplo
cp config.example.yml config.yml

# Windows
copy config.example.yml config.yml
```

### 2. Configurar config.yml

Editar `config.yml` y configurar al menos:

```yaml
# Configuración básica requerida
steam:
  username: ""          # Dejar vacío si no usas Steam
  password: ""          # Dejar vacío si no usas Steam
  install_path: "./assetto"

server:
  bind: "0.0.0.0:8772"  # Puerto del web UI

# Configurar cuenta admin por defecto
accounts:
  admin_password: "changeme"  # ¡CAMBIAR ESTO!
```

### 3. Crear Estructura de Directorios de Assetto

```bash
# Crear directorios necesarios
mkdir -p assetto/content/tracks
mkdir -p assetto/content/cars
mkdir -p assetto/system

# Windows
mkdir assetto\content\tracks assetto\content\cars assetto\system
```

### 4. (Opcional) Crear Archivo acServer.exe Falso

Si no tienes Assetto Corsa Server instalado:

```bash
# Linux/macOS
touch assetto/acServer

# Windows
echo. > assetto\acServer.exe
```

---

## 🚀 Ejecutar la Aplicación

### Ejecutar por Primera Vez

```bash
# Linux/macOS
./server-manager

# Windows
.\server-manager.exe
```

### Acceder a la Interfaz Web

Abrir navegador en: [http://localhost:8772](http://localhost:8772)

**Credenciales por defecto:**
- Usuario: `admin`
- Contraseña: `changeme` (cambiar en config.yml)

---

## 📦 Script de Compilación Automática

### Windows (PowerShell)

Crear archivo `build.ps1`:

```powershell
#!/usr/bin/env pwsh
Write-Host "🔨 Compilando Assetto Server Manager..." -ForegroundColor Green

# Configurar variables
$env:GO111MODULE = 'on'
$env:CGO_ENABLED = '0'

# Instalar dependencias
Write-Host "📦 Instalando dependencias Go..." -ForegroundColor Yellow
go mod tidy
go install github.com/mjibson/esc@latest

# Compilar frontend
Write-Host "🎨 Compilando frontend..." -ForegroundColor Yellow
cd cmd\server-manager\typescript
npm install --legacy-peer-deps
npx gulp build

# Embebir assets
Write-Host "📁 Embebiendo assets..." -ForegroundColor Yellow
cd ..\
make asset-embed

# Compilar aplicación
Write-Host "⚙️ Compilando aplicación..." -ForegroundColor Yellow
go build -o server-manager.exe

# Crear configuración si no existe
if (-not (Test-Path "config.yml")) {
    Copy-Item "config.example.yml" "config.yml"
    Write-Host "📋 Archivo config.yml creado desde ejemplo" -ForegroundColor Cyan
}

# Crear estructura de directorios
Write-Host "📂 Creando estructura de directorios..." -ForegroundColor Yellow
mkdir -Force assetto\content\tracks, assetto\content\cars, assetto\system | Out-Null

Write-Host "✅ ¡Compilación completada!" -ForegroundColor Green
Write-Host "🚀 Ejecutar con: .\server-manager.exe" -ForegroundColor Cyan
Write-Host "🌐 Interfaz web: http://localhost:8772" -ForegroundColor Cyan
```

**Ejecutar:**
```powershell
.\build.ps1
```

### Linux/macOS

Crear archivo `build.sh`:

```bash
#!/bin/bash
echo "🔨 Compilando Assetto Server Manager..."

# Configurar variables
export GO111MODULE=on
export CGO_ENABLED=0

# Instalar dependencias
echo "📦 Instalando dependencias Go..."
go mod tidy
go install github.com/mjibson/esc@latest

# Compilar frontend
echo "🎨 Compilando frontend..."
cd cmd/server-manager/typescript
npm install --legacy-peer-deps
npx gulp build

# Embebir assets
echo "📁 Embebiendo assets..."
cd ../
make asset-embed

# Compilar aplicación
echo "⚙️ Compilando aplicación..."
go build -o server-manager

# Crear configuración si no existe
if [ ! -f "config.yml" ]; then
    cp config.example.yml config.yml
    echo "📋 Archivo config.yml creado desde ejemplo"
fi

# Crear estructura de directorios
echo "📂 Creando estructura de directorios..."
mkdir -p assetto/content/tracks assetto/content/cars assetto/system

echo "✅ ¡Compilación completada!"
echo "🚀 Ejecutar con: ./server-manager"
echo "🌐 Interfaz web: http://localhost:8772"
```

**Ejecutar:**
```bash
chmod +x build.sh
./build.sh
```

---

## 🔧 Solución de Problemas

### Errores Comunes y Soluciones

#### 1. Error: "node-sass no puede compilar"

**Error:**
```
Error: Node Sass does not yet support your current environment
```

**Solución:**
El proyecto ha sido actualizado para usar `sass` (Dart Sass). Si ves este error, asegúrate de ejecutar:
```bash
npm install --legacy-peer-deps
```

#### 2. Error: "make: command not found" (Windows)

**Solución:**
```powershell
choco install make
```

#### 3. Error: "esc: command not found"

**Solución:**
```bash
go install github.com/mjibson/esc@latest
```

#### 4. Error: "permission denied" (Linux)

**Solución:**
```bash
chmod +x server-manager
sudo chown -R $USER:$USER .
```

#### 5. Error: "port 8772 already in use"

**Solución:**
```bash
# Cambiar puerto en config.yml
server:
  bind: "0.0.0.0:8773"  # Usar puerto diferente
```

#### 6. Problemas con dependencias de npm

**Solución:**
```bash
# Limpiar cache y reinstalar
cd cmd/server-manager/typescript
rm -rf node_modules package-lock.json
npm cache clean --force
npm install --legacy-peer-deps
```

### Verificar Compilación Exitosa

**Archivos que deben existir después de la compilación:**

```
cmd/server-manager/
├── server-manager.exe     # Windows
├── server-manager         # Linux/macOS
├── config.yml            # Tu configuración
├── assetto/              # Directorio de Assetto Corsa
│   ├── content/
│   └── system/
└── static/               # Assets compilados
```

**Verificar que la aplicación funciona:**

```bash
# Ejecutar con ayuda
./server-manager --help

# Debe mostrar opciones sin errores
```

---

## 📚 Recursos Adicionales

- **Documentación oficial**: [README.md](README.md)
- **Configuración avanzada**: [config.example.yml](cmd/server-manager/config.example.yml)
- **Instalación de Assetto Corsa Server**: [INSTALL.txt](INSTALL.txt)
- **Notas de versión**: [CHANGELOG.md](CHANGELOG.md)

---

## 🆘 Obtener Ayuda

Si encuentras problemas durante la compilación:

1. **Revisa esta guía** completamente
2. **Verifica las versiones** de software instalado
3. **Busca en Issues** del repositorio GitHub
4. **Crea un nuevo Issue** con detalles del error

---

**¡Felicidades! 🎉 Ya tienes Assetto Server Manager compilado y listo para usar.**
