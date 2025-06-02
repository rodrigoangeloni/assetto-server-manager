#!/bin/bash
# Script de Compilación Automática para Assetto Server Manager
# Compatible con Linux y macOS

set -e  # Salir si hay algún error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

echo -e "${GREEN}🔨 Iniciando compilación de Assetto Server Manager...${NC}"
echo -e "${CYAN}=================================================${NC}"

# Verificar que estamos en el directorio correcto
if [ ! -f "go.mod" ]; then
    echo -e "${RED}❌ Error: No se encontró go.mod. Asegúrate de estar en la raíz del proyecto.${NC}"
    exit 1
fi

# Configurar variables de entorno
echo -e "${YELLOW}⚙️ Configurando variables de entorno...${NC}"
export GO111MODULE=on
export CGO_ENABLED=0

# Verificar dependencias instaladas
echo -e "${YELLOW}🔍 Verificando dependencias...${NC}"

if command -v go &> /dev/null; then
    GO_VERSION=$(go version)
    echo -e "${GREEN}✅ Go: $GO_VERSION${NC}"
else
    echo -e "${RED}❌ Go no está instalado o no está en PATH${NC}"
    exit 1
fi

if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}✅ Node.js: $NODE_VERSION${NC}"
else
    echo -e "${RED}❌ Node.js no está instalado o no está en PATH${NC}"
    exit 1
fi

if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo -e "${GREEN}✅ npm: v$NPM_VERSION${NC}"
else
    echo -e "${RED}❌ npm no está instalado o no está en PATH${NC}"
    exit 1
fi

if command -v make &> /dev/null; then
    echo -e "${GREEN}✅ Make está disponible${NC}"
else
    echo -e "${RED}❌ Make no está instalado${NC}"
    exit 1
fi

echo ""

# Paso 1: Instalar dependencias Go
echo -e "${YELLOW}📦 Paso 1: Instalando dependencias de Go...${NC}"
if go mod tidy; then
    echo -e "${GREEN}✅ Dependencias Go instaladas${NC}"
else
    echo -e "${RED}❌ Error instalando dependencias Go${NC}"
    exit 1
fi

# Instalar herramienta esc
echo -e "${YELLOW}🔧 Instalando herramienta esc...${NC}"
if go install github.com/mjibson/esc@latest; then
    echo -e "${GREEN}✅ Herramienta esc instalada${NC}"
else
    echo -e "${RED}❌ Error instalando esc${NC}"
    exit 1
fi

echo ""

# Paso 2: Compilar frontend
echo -e "${YELLOW}🎨 Paso 2: Compilando frontend...${NC}"
cd cmd/server-manager/typescript

echo -e "${CYAN}📦 Instalando dependencias npm...${NC}"
if npm install --legacy-peer-deps; then
    echo -e "${CYAN}🏗️ Ejecutando gulp build...${NC}"
    if npx gulp build; then
        echo -e "${GREEN}✅ Frontend compilado exitosamente${NC}"
    else
        echo -e "${RED}❌ Error en gulp build${NC}"
        exit 1
    fi
else
    echo -e "${RED}❌ Error instalando dependencias npm${NC}"
    exit 1
fi

cd ../
echo ""

# Paso 3: Embebir assets
echo -e "${YELLOW}📁 Paso 3: Embebiendo assets...${NC}"
if make asset-embed; then
    echo -e "${GREEN}✅ Assets embebidos exitosamente${NC}"
else
    echo -e "${RED}❌ Error embebiendo assets${NC}"
    exit 1
fi

echo ""

# Paso 4: Compilar aplicación
echo -e "${YELLOW}⚙️ Paso 4: Compilando aplicación...${NC}"

# Compilar para la plataforma actual
echo -e "${CYAN}🖥️ Compilando para plataforma actual...${NC}"
if go build -o server-manager; then
    echo -e "${GREEN}✅ Binario para plataforma actual creado${NC}"
else
    echo -e "${RED}❌ Error compilando para plataforma actual${NC}"
    exit 1
fi

# Compilar para Linux
echo -e "${CYAN}🐧 Compilando para Linux...${NC}"
if GOOS=linux GOARCH=amd64 go build -o server-manager-linux; then
    echo -e "${GREEN}✅ Binario Linux creado${NC}"
else
    echo -e "${RED}❌ Error compilando para Linux${NC}"
    exit 1
fi

# Compilar para Windows
echo -e "${CYAN}🪟 Compilando para Windows...${NC}"
if GOOS=windows GOARCH=amd64 go build -o server-manager.exe; then
    echo -e "${GREEN}✅ Binario Windows creado${NC}"
else
    echo -e "${RED}❌ Error compilando para Windows${NC}"
    exit 1
fi

echo ""

# Paso 5: Configuración post-compilación
echo -e "${YELLOW}📋 Paso 5: Configuración post-compilación...${NC}"

# Crear archivo de configuración si no existe
if [ ! -f "config.yml" ]; then
    cp config.example.yml config.yml
    echo -e "${GREEN}✅ Archivo config.yml creado desde ejemplo${NC}"
else
    echo -e "${CYAN}ℹ️ config.yml ya existe, no se sobrescribe${NC}"
fi

# Crear estructura de directorios de Assetto Corsa
echo -e "${CYAN}📂 Creando estructura de directorios...${NC}"
mkdir -p assetto/content/tracks assetto/content/cars assetto/system
echo -e "${GREEN}✅ Estructura de directorios creada${NC}"

# Crear archivo acServer falso si no existe
if [ ! -f "assetto/acServer" ]; then
    touch assetto/acServer
    chmod +x assetto/acServer
    echo -e "${GREEN}✅ Archivo acServer falso creado${NC}"
fi

echo ""

# Paso 6: Crear releases
echo -e "${YELLOW}📦 Paso 6: Creando releases...${NC}"

# Crear directorios de build
mkdir -p build/linux build/windows

# Copiar archivos para release de Linux
cp config.example.yml build/linux/config.yml
cp server-manager-linux build/linux/server-manager
chmod +x build/linux/server-manager

# Copiar archivos para release de Windows
cp config.example.yml build/windows/config.yml
cp server-manager.exe build/windows/

# Copiar documentación
cp ../../LICENSE build/LICENSE.txt 2>/dev/null || echo "LICENSE no encontrado"
cp ../../CHANGELOG.md build/CHANGELOG.txt 2>/dev/null || echo "CHANGELOG.md no encontrado"
cp ../../INSTALL.txt build/ 2>/dev/null || echo "INSTALL.txt no encontrado"
cp ../../README.md build/README.txt 2>/dev/null || echo "README.md no encontrado"
cp ../../BUILD_GUIDE.md build/ 2>/dev/null || echo "BUILD_GUIDE.md no encontrado"

echo -e "${GREEN}✅ Releases creados en build/linux y build/windows${NC}"

cd ../..
echo ""

# Resumen final
echo -e "${GREEN}🎉 ¡COMPILACIÓN COMPLETADA EXITOSAMENTE!${NC}"
echo -e "${CYAN}=========================================${NC}"
echo ""
echo -e "${WHITE}📁 Archivos generados:${NC}"
echo -e "${CYAN}  • cmd/server-manager/server-manager         (Plataforma actual)${NC}"
echo -e "${CYAN}  • cmd/server-manager/server-manager-linux   (Linux)${NC}"
echo -e "${CYAN}  • cmd/server-manager/server-manager.exe     (Windows)${NC}"
echo -e "${CYAN}  • cmd/server-manager/config.yml             (Configuración)${NC}"
echo -e "${CYAN}  • cmd/server-manager/build/                 (Releases completos)${NC}"
echo ""
echo -e "${WHITE}🚀 Para ejecutar:${NC}"
echo -e "${YELLOW}  cd cmd/server-manager${NC}"
echo -e "${YELLOW}  ./server-manager${NC}"
echo ""
echo -e "${WHITE}🌐 Interfaz web:${NC}"
echo -e "${YELLOW}  http://localhost:8772${NC}"
echo ""
echo -e "${WHITE}🔑 Credenciales por defecto:${NC}"
echo -e "${YELLOW}  Usuario: admin${NC}"
echo -e "${YELLOW}  Contraseña: changeme (¡cambiar en config.yml!)${NC}"
echo ""
echo -e "${CYAN}📖 Para más información, consulta BUILD_GUIDE.md${NC}"
