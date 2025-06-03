#!/usr/bin/env pwsh
# Script de Compilación Automática para Assetto Server Manager
# Compatible con Windows PowerShell

Write-Host "🔨 Iniciando compilación de Assetto Server Manager..." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan

# Verificar que estamos en el directorio correcto
if (-not (Test-Path "go.mod")) {
    Write-Host "❌ Error: No se encontró go.mod. Asegúrate de estar en la raíz del proyecto." -ForegroundColor Red
    exit 1
}

# Configurar variables de entorno
Write-Host "⚙️ Configurando variables de entorno..." -ForegroundColor Yellow
$env:GO111MODULE = 'on'
$env:CGO_ENABLED = '0'

# Verificar dependencias instaladas
Write-Host "🔍 Verificando dependencias..." -ForegroundColor Yellow

try {
    $goVersion = go version
    Write-Host "✅ Go: $goVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Go no está instalado o no está en PATH" -ForegroundColor Red
    exit 1
}

try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js no está instalado o no está en PATH" -ForegroundColor Red
    exit 1
}

try {
    $npmVersion = npm --version
    Write-Host "✅ npm: v$npmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ npm no está instalado o no está en PATH" -ForegroundColor Red
    exit 1
}

try {
    make --version | Out-Null
    Write-Host "✅ Make está disponible" -ForegroundColor Green
} catch {
    Write-Host "❌ Make no está instalado. Instálalo con: choco install make" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Paso 1: Instalar dependencias Go
Write-Host "📦 Paso 1: Instalando dependencias de Go..." -ForegroundColor Yellow
try {
    go mod tidy
    Write-Host "✅ Dependencias Go instaladas" -ForegroundColor Green
} catch {
    Write-Host "❌ Error instalando dependencias Go" -ForegroundColor Red
    exit 1
}

# Instalar herramienta esc
Write-Host "🔧 Instalando herramienta esc..." -ForegroundColor Yellow
try {
    go install github.com/mjibson/esc@latest
    Write-Host "✅ Herramienta esc instalada" -ForegroundColor Green
} catch {
    Write-Host "❌ Error instalando esc" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Paso 2: Compilar frontend
Write-Host "🎨 Paso 2: Compilando frontend..." -ForegroundColor Yellow
Push-Location "cmd\server-manager\typescript"

try {
    Write-Host "📦 Instalando dependencias npm..." -ForegroundColor Cyan
    npm install --legacy-peer-deps
    
    Write-Host "🏗️ Ejecutando gulp build..." -ForegroundColor Cyan
    npx gulp build
    
    Write-Host "✅ Frontend compilado exitosamente" -ForegroundColor Green
} catch {
    Write-Host "❌ Error compilando frontend" -ForegroundColor Red
    Pop-Location
    exit 1
}

Pop-Location
Write-Host ""

# Paso 3: Embebir assets
Write-Host "📁 Paso 3: Embebiendo assets..." -ForegroundColor Yellow
Push-Location "cmd\server-manager"

try {
    make asset-embed
    Write-Host "✅ Assets embebidos exitosamente" -ForegroundColor Green
} catch {
    Write-Host "❌ Error embebiendo assets" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""

# Paso 4: Compilar aplicación
Write-Host "⚙️ Paso 4: Compilando aplicación..." -ForegroundColor Yellow

try {
    # Compilar para Windows
    Write-Host "🖥️ Compilando para Windows..." -ForegroundColor Cyan
    go build -o server-manager.exe
    
    # Compilar para Linux
    Write-Host "🐧 Compilando para Linux..." -ForegroundColor Cyan
    $env:GOOS = "linux"
    $env:GOARCH = "amd64"
    go build -o server-manager-linux
    
    # Restaurar variables para Windows
    $env:GOOS = "windows"
    $env:GOARCH = "amd64"
    
    Write-Host "✅ Aplicación compilada para ambas plataformas" -ForegroundColor Green
} catch {
    Write-Host "❌ Error compilando aplicación" -ForegroundColor Red
    Pop-Location
    exit 1
}

Write-Host ""

# Paso 5: Configuración post-compilación
Write-Host "📋 Paso 5: Configuración post-compilación..." -ForegroundColor Yellow

# Crear archivo de configuración si no existe
if (-not (Test-Path "config.yml")) {
    Copy-Item "config.example.yml" "config.yml"
    Write-Host "✅ Archivo config.yml creado desde ejemplo" -ForegroundColor Green
} else {
    Write-Host "ℹ️ config.yml ya existe, no se sobrescribe" -ForegroundColor Cyan
}

# Crear estructura de directorios de Assetto Corsa
Write-Host "📂 Creando estructura de directorios..." -ForegroundColor Cyan
try {
    New-Item -ItemType Directory -Force -Path "assetto\content\tracks", "assetto\content\cars", "assetto\system" | Out-Null
    Write-Host "✅ Estructura de directorios creada" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Algunos directorios ya existen" -ForegroundColor Yellow
}

# Crear archivo acServer.exe falso si no existe
if (-not (Test-Path "assetto\acServer.exe")) {
    "" | Out-File -FilePath "assetto\acServer.exe" -Encoding utf8
    Write-Host "✅ Archivo acServer.exe falso creado" -ForegroundColor Green
}

Pop-Location
Write-Host ""

# Paso 6: Crear releases
Write-Host "📦 Paso 6: Creando releases..." -ForegroundColor Yellow
Push-Location "cmd\server-manager"

try {
    # Crear directorios de build
    New-Item -ItemType Directory -Force -Path "build\linux", "build\windows" | Out-Null
    
    # Copiar archivos para release de Linux
    Copy-Item "config.example.yml" "build\linux\config.yml"
    Copy-Item "server-manager-linux" "build\linux\server-manager"
    
    # Copiar archivos para release de Windows
    Copy-Item "config.example.yml" "build\windows\config.yml"
    Copy-Item "server-manager.exe" "build\windows\"
    
    # Copiar documentación
    Copy-Item "..\..\LICENSE" "build\LICENSE.txt"
    Copy-Item "..\..\CHANGELOG.md" "build\CHANGELOG.txt"
    Copy-Item "..\..\INSTALL.txt" "build\"
    Copy-Item "..\..\README.md" "build\README.txt"
    Copy-Item "..\..\BUILD_GUIDE.md" "build\"
    
    Write-Host "✅ Releases creados en build/linux y build/windows" -ForegroundColor Green
} catch {
    Write-Host "⚠️ Error creando releases (no crítico)" -ForegroundColor Yellow
}

Pop-Location
Write-Host ""

# Resumen final
Write-Host "🎉 ¡COMPILACIÓN COMPLETADA EXITOSAMENTE!" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📁 Archivos generados:" -ForegroundColor White
Write-Host "  • cmd\server-manager\server-manager.exe     (Windows)" -ForegroundColor Cyan
Write-Host "  • cmd\server-manager\server-manager-linux   (Linux)" -ForegroundColor Cyan
Write-Host "  • cmd\server-manager\config.yml             (Configuración)" -ForegroundColor Cyan
Write-Host "  • cmd\server-manager\build\                 (Releases completos)" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Para ejecutar:" -ForegroundColor White
Write-Host "  cd cmd\server-manager" -ForegroundColor Yellow
Write-Host "  .\server-manager.exe" -ForegroundColor Yellow
Write-Host ""
Write-Host "🌐 Interfaz web:" -ForegroundColor White
Write-Host "  http://localhost:8772" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔑 Credenciales por defecto:" -ForegroundColor White
Write-Host "  Usuario: admin" -ForegroundColor Yellow
Write-Host "  Contraseña: changeme (¡cambiar en config.yml!)" -ForegroundColor Yellow
Write-Host ""
Write-Host "📖 Para más información, consulta BUILD_GUIDE.md" -ForegroundColor Cyan
