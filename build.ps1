#!/usr/bin/env pwsh
# Script de Compilación Automática para Assetto Server Manager
# Compatible con Windows PowerShell
#
# Características especiales:
# - Limpia automáticamente archivos de recursos (resource.syso, resource.rc) en cada compilación
#   para asegurar que se use el icono más reciente si se ha cambiado
# - Genera ejecutables para Windows y Linux
# - Incluye icono y metadatos de versión en el ejecutable de Windows
# - Los binarios finales se organizan solo en build/windows/ y build/linux/
# - Limpieza automática de archivos temporales al inicio y final del proceso

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
    $goVersionOutput = go version
    $goVersionString = ($goVersionOutput -split ' ')[2] # Extrae algo como "go1.21.1"
    $goVersionInstalled = $goVersionString.Substring(2) # Extrae "1.21.1"
    $requiredGoVersion = "1.22.0"

    if ([version]$goVersionInstalled -lt [version]$requiredGoVersion) {
        Write-Host "❌ Error: Versión de Go incorrecta." -ForegroundColor Red
        Write-Host "   Instalada: $($goVersionInstalled)" -ForegroundColor Red
        Write-Host "   Requerida: $($requiredGoVersion) o superior." -ForegroundColor Red
        Write-Host "   Por favor, actualiza Go desde https://golang.org/dl/" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✅ Go: $goVersionInstalled (Cumple >= $requiredGoVersion)" -ForegroundColor Green
} catch {
    Write-Host "❌ Go no está instalado o no está en PATH." -ForegroundColor Red
    Write-Host "   Por favor, instálalo desde https://golang.org/dl/ y asegúrate de que esté en tu PATH." -ForegroundColor Yellow
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

# Paso 0: Limpieza inicial
Write-Host "🧹 Paso 0: Limpieza inicial..." -ForegroundColor Yellow
Push-Location "cmd\server-manager"

try {
    # Eliminar binarios y archivos temporales anteriores
    $cleanFiles = @("server-manager*.exe", "server-manager*-linux", "resource.syso", "resource.rc")
    $cleanedCount = 0
    
    foreach ($pattern in $cleanFiles) {
        $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            Remove-Item $file.FullName -Force
            $cleanedCount++
        }
    }
    
    if ($cleanedCount -gt 0) {
        Write-Host "✅ $cleanedCount archivo(s) temporal(es) eliminado(s)" -ForegroundColor Green
    } else {
        Write-Host "✅ No hay archivos temporales para limpiar" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️ Error en limpieza inicial (no crítico)" -ForegroundColor Yellow
}

Pop-Location
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

# Paso 4: Compilar recursos para Windows
Write-Host "⚙️ Paso 4a: Compilando recursos de Windows..." -ForegroundColor Yellow

try {
    # Limpiar archivos de recursos anteriores para asegurar que se use el icono actual
    if (Test-Path "resource.syso") {
        Remove-Item "resource.syso" -Force
        Write-Host "🧹 Archivo resource.syso anterior eliminado" -ForegroundColor Green
    }
    if (Test-Path "resource.rc") {
        Remove-Item "resource.rc" -Force
        Write-Host "🧹 Archivo resource.rc anterior eliminado" -ForegroundColor Green
    }
    
    # Verificar si goversioninfo está disponible
    try {
        goversioninfo --help | Out-Null
        Write-Host "✅ goversioninfo está disponible" -ForegroundColor Green
        
        # Compilar recursos si el archivo versioninfo.json existe
        if (Test-Path "versioninfo.json") {
            Write-Host "🎨 Generando recursos con icono..." -ForegroundColor Cyan
            goversioninfo -o resource.syso
            Write-Host "✅ Recursos con icono generados exitosamente" -ForegroundColor Green
        } else {
            Write-Host "⚠️ Archivo versioninfo.json no encontrado, continuando sin icono" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "⚠️ goversioninfo no está disponible. Instalando..." -ForegroundColor Yellow
        try {
            go install github.com/josephspurrier/goversioninfo/cmd/goversioninfo@latest
            Write-Host "✅ goversioninfo instalado exitosamente" -ForegroundColor Green
            
            if (Test-Path "versioninfo.json") {
                Write-Host "🎨 Generando recursos con icono..." -ForegroundColor Cyan
                goversioninfo -o resource.syso
                Write-Host "✅ Recursos con icono generados exitosamente" -ForegroundColor Green
            }
        } catch {
            Write-Host "⚠️ No se pudo instalar goversioninfo. El ejecutable no tendrá icono." -ForegroundColor Yellow
        }
    }
} catch {
    Write-Host "⚠️ Error compilando recursos (no crítico)" -ForegroundColor Yellow
}

Write-Host ""

# Paso 4b: Compilar aplicación
Write-Host "⚙️ Paso 4b: Compilando aplicación..." -ForegroundColor Yellow

# Leer versión del archivo versioninfo.json
$version = "unknown"
try {
    if (Test-Path "versioninfo.json") {
        $versionInfo = Get-Content "versioninfo.json" | ConvertFrom-Json
        $version = "v$($versionInfo.StringFileInfo.FileVersion -replace '\.0$', '')"
        Write-Host "📋 Versión detectada: $version" -ForegroundColor Cyan
    }
} catch {
    Write-Host "⚠️ No se pudo leer la versión, usando nombre por defecto" -ForegroundColor Yellow
    $version = "v1.7.12"
}

try {
    # Compilar para Windows
    Write-Host "🖥️ Compilando para Windows..." -ForegroundColor Cyan
    go build -o "server-manager_$version.exe"
      # Compilar para Linux
    Write-Host "🐧 Compilando para Linux..." -ForegroundColor Cyan
    $env:GOOS = "linux"
    $env:GOARCH = "amd64"
    go build -o "server-manager_$version-linux"
    
    # Restaurar variables para Windows
    $env:GOOS = "windows"
    $env:GOARCH = "amd64"
      Write-Host "✅ Aplicación compilada para ambas plataformas" -ForegroundColor Green
    
    # Limpiar archivo de recursos temporal después de la compilación
    if (Test-Path "resource.syso") {
        Remove-Item "resource.syso" -Force
        Write-Host "🧹 Archivo temporal resource.syso eliminado después de compilación" -ForegroundColor Green
    }
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

# Paso 6: Crear releases y limpieza
Write-Host "📦 Paso 6: Creando releases y organizando archivos..." -ForegroundColor Yellow
Push-Location "cmd\server-manager"

try {
    # Crear directorios de build
    New-Item -ItemType Directory -Force -Path "build\linux", "build\windows" | Out-Null
      # Buscar y mover archivos para release de Linux
    Copy-Item "config.example.yml" "build\linux\config.yml"
    $linuxBinary = Get-ChildItem -Path "server-manager*-linux" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($linuxBinary) {
        $linuxFinalName = $linuxBinary.Name -replace "-linux$", ""
        Move-Item $linuxBinary.FullName "build\linux\$linuxFinalName" -Force
        Write-Host "✅ Binario de Linux ($($linuxBinary.Name)) movido a build/linux/$linuxFinalName" -ForegroundColor Green
    }
    
    # Buscar y mover archivos para release de Windows
    Copy-Item "config.example.yml" "build\windows\config.yml"
    $windowsBinary = Get-ChildItem -Path "server-manager*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($windowsBinary) {
        Move-Item $windowsBinary.FullName "build\windows\$($windowsBinary.Name)" -Force
        Write-Host "✅ Binario de Windows ($($windowsBinary.Name)) movido a build/windows/$($windowsBinary.Name)" -ForegroundColor Green
    }
    
    # Copiar documentación
    Copy-Item "..\..\LICENSE" "build\LICENSE.txt"
    Copy-Item "..\..\CHANGELOG.md" "build\CHANGELOG.txt"
    Copy-Item "..\..\INSTALL.txt" "build\"
    Copy-Item "..\..\README.md" "build\README.txt"
    Copy-Item "..\..\BUILD_GUIDE.md" "build\"
      Write-Host "✅ Releases creados en build/linux y build/windows" -ForegroundColor Green
      # Limpieza final de archivos temporales
    Write-Host "🧹 Limpiando archivos temporales..." -ForegroundColor Cyan
    
    # Eliminar binarios que puedan haber quedado en el directorio raíz
    $tempPatterns = @("server-manager*.exe", "server-manager*-linux", "resource.syso", "resource.rc")
    foreach ($pattern in $tempPatterns) {
        $files = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            Remove-Item $file.FullName -Force
            Write-Host "  ✅ $($file.Name) eliminado" -ForegroundColor Green
        }
    }
    
    Write-Host "✅ Limpieza completada" -ForegroundColor Green
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

# Obtener nombres reales de los archivos generados
$windowsFile = Get-ChildItem -Path "build\windows\server-manager*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
$linuxFile = Get-ChildItem -Path "build\linux\server-manager*" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($windowsFile) {
    Write-Host "  • cmd\server-manager\build\windows\$($windowsFile.Name)     (Windows)" -ForegroundColor Cyan
} else {
    Write-Host "  • cmd\server-manager\build\windows\server-manager.exe     (Windows)" -ForegroundColor Cyan
}

if ($linuxFile) {
    Write-Host "  • cmd\server-manager\build\linux\$($linuxFile.Name)         (Linux)" -ForegroundColor Cyan
} else {
    Write-Host "  • cmd\server-manager\build\linux\server-manager         (Linux)" -ForegroundColor Cyan
}

Write-Host "  • cmd\server-manager\config.yml                         (Configuración)" -ForegroundColor Cyan
Write-Host "  • cmd\server-manager\build\                             (Releases completos)" -ForegroundColor Cyan
Write-Host ""
Write-Host "🚀 Para ejecutar:" -ForegroundColor White
Write-Host "  cd cmd\server-manager\build\windows" -ForegroundColor Yellow

if ($windowsFile) {
    Write-Host "  .\$($windowsFile.Name)" -ForegroundColor Yellow
} else {
    Write-Host "  .\server-manager.exe" -ForegroundColor Yellow
}
Write-Host ""
Write-Host "🌐 Interfaz web:" -ForegroundColor White
Write-Host "  http://localhost:8772" -ForegroundColor Yellow
Write-Host ""
Write-Host "🔑 Credenciales por defecto:" -ForegroundColor White
Write-Host "  Usuario: admin" -ForegroundColor Yellow
Write-Host "  Contraseña: changeme (¡cambiar en config.yml!)" -ForegroundColor Yellow
Write-Host ""
Write-Host "📖 Para más información, consulta BUILD_GUIDE.md" -ForegroundColor Cyan
