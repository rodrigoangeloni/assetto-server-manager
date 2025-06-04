# 🏎️ Assetto Server Manager v1.7.12 - Guía Completa en Español

## 📋 Tabla de Contenidos
- [🚀 Introducción](#-introducción)
- [💻 Instalación](#-instalación)
- [🔧 Configuración](#-configuración)
- [🏁 Uso Básico](#-uso-básico)
- [⚙️ Características Avanzadas](#-características-avanzadas)
- [🔧 Compilación](#-compilación)
- [🐛 Solución de Problemas](#-solución-de-problemas)
- [📖 Referencias](#-referencias)

## 🚀 Introducción

**Assetto Server Manager** es una herramienta web completa para gestionar servidores de Assetto Corsa. Esta versión 1.7.12 incluye mejoras significativas en el sistema de compilación y nuevas características.

### ✨ Novedades v1.7.12
- 🎨 **Icono personalizado** en ejecutables de Windows
- 🧹 **Sistema de limpieza automática** de archivos temporales
- 📁 **Organización mejorada** de binarios en carpetas específicas
- 🔄 **Proceso de compilación optimizado** con mejor manejo de recursos
- 🛠️ **Instalación automática** de herramientas de desarrollo
- 📊 **Información de versión** embebida en ejecutables

## 💻 Instalación

### 📋 Requisitos Previos

#### 🖥️ Windows
- **Go** 1.22.0 o superior
- **Node.js** 16.0 o superior
- **npm** 8.0 o superior
- **Make** (via Chocolatey: `choco install make`)
- **Git** para control de versiones

#### 🐧 Linux
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install golang-go nodejs npm make git

# CentOS/RHEL
sudo yum install golang nodejs npm make git
```

### 🚀 Instalación Rápida

#### 📥 Opción 1: Descargar Release Pre-compilado
1. Ve a la página de [Releases](https://github.com/JustaPenguin/assetto-server-manager/releases)
2. Descarga `server-manager-v1.7.12-windows.zip` o `server-manager-v1.7.12-linux.tar.gz`
3. Extrae el archivo en tu directorio preferido
4. ¡Listo para usar! 🎉

#### 🛠️ Opción 2: Compilar desde Código Fuente
```powershell
# Windows PowerShell
git clone https://github.com/JustaPenguin/assetto-server-manager.git
cd assetto-server-manager
.\build.ps1
```

```bash
# Linux
git clone https://github.com/JustaPenguin/assetto-server-manager.git
cd assetto-server-manager
./build.sh
```

## 🔧 Configuración

### 🔐 Configuración Inicial

1. **📄 Archivo de Configuración**
   ```yaml
   # config.yml
   admin_password: "tu_contraseña_segura"  # 🚨 ¡Cambia esto!
   server_name: "Mi Servidor AC"
   port: 8772
   ```

2. **🎮 Configuración de Assetto Corsa**
   - Coloca tu instalación de Assetto Corsa en `./assetto/`
   - O configura la ruta en `config.yml`:
   ```yaml
   steam:
     install_path: "C:/SteamLibrary/steamapps/common/assettocorsa"
   ```

### 🌐 Primer Inicio

```powershell
# Windows
cd cmd\server-manager\build\windows
.\server-manager.exe

# Linux
cd cmd/server-manager/build/linux
./server-manager
```

🌐 **Accede a**: `http://localhost:8772`

👤 **Credenciales por defecto**:
- Usuario: `admin`
- Contraseña: `changeme` (⚠️ ¡Cámbiala inmediatamente!)

## 🏁 Uso Básico

### 🏃‍♂️ Crear tu Primera Carrera

1. **🖱️ Navega a** "Carreras Personalizadas"
2. **🏎️ Selecciona**:
   - Pista 🏁
   - Coches 🚗
   - Número de participantes 👥
3. **⚙️ Configura**:
   - Duración de sesión ⏱️
   - Condiciones climáticas 🌤️
   - Configuraciones de servidor 🔧
4. **🚀 Inicia** la carrera

### 🏆 Gestión de Campeonatos

#### 📝 Crear Campeonato
1. Ve a "Campeonatos" → "Nuevo Campeonato"
2. Configura:
   - 📛 Nombre del campeonato
   - 📝 Descripción
   - 🎯 Sistema de puntos
   - 👥 Participantes

#### 📅 Programar Eventos
- **⏰ Horarios flexibles** con múltiples zonas horarias
- **🔄 Eventos recurrentes** (semanales, mensuales)
- **📧 Notificaciones automáticas** para participantes

## ⚙️ Características Avanzadas

### 🤖 Integraciones

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
  token: "tu_token_discord"
  channel_id: "id_del_canal"
```

#### 🏁 Real Penalty Tool
- ⚖️ Sistema de penalizaciones automático
- 📋 Configuración personalizable de reglas
- 📊 Reportes detallados de infracciones

### 🔐 Seguridad y Usuarios

#### 👥 Gestión de Usuarios
- **🔑 Roles diferenciados**: Admin, Write, Read, Delete
- **🔒 Autenticación Steam** opcional
- **🛡️ Contraseñas seguras** con políticas configurables

#### 🔐 Configuración HTTPS
```yaml
tls:
  enabled: true
  cert_file: "/path/to/cert.pem"
  key_file: "/path/to/key.pem"
```

### 📊 Monitoreo y Logs

#### 📈 Live Timings
- ⏱️ **Tiempos en vivo** durante las carreras
- 🗺️ **Mapa en tiempo real** de posiciones
- 💬 **Chat integrado** con moderación
- 📱 **Interfaz móvil** optimizada

#### 📋 Auditoría
- 📝 **Logs detallados** de todas las acciones
- 👤 **Tracking de usuarios** y cambios
- 📊 **Reportes de uso** del servidor

## 🔧 Compilación

### 🛠️ Sistema de Compilación v1.7.12

El nuevo sistema incluye:

#### ✨ Características del Build Script
- 🧹 **Limpieza automática** al inicio y final
- 🎨 **Embedding automático** de iconos
- 📁 **Organización inteligente** de binarios
- 🔄 **Regeneración de recursos** en cada build
- 📊 **Información de versión** automática

#### 🚀 Proceso de Compilación
```powershell
# El script build.ps1 realiza automáticamente:

# 🧹 Paso 0: Limpieza inicial
# 📦 Paso 1: Instalación de dependencias Go
# 🎨 Paso 2: Compilación del frontend
# 📁 Paso 3: Embedding de assets
# 🎯 Paso 4a: Compilación de recursos (icono)
# 🖥️ Paso 4b: Compilación de aplicación
# 📋 Paso 5: Configuración post-compilación
# 📦 Paso 6: Creación de releases y limpieza final
```

#### 📂 Estructura de Salida
```
cmd/server-manager/build/
├── 🖥️ windows/
│   ├── server-manager.exe  # Con icono embebido
│   └── config.yml
├── 🐧 linux/
│   ├── server-manager
│   └── config.yml
└── 📚 documentación...
```

### 🎨 Personalización del Icono

Para cambiar el icono:
1. Reemplaza `cmd/server-manager/static/img/servermanager.ico`
2. Ejecuta `.\build.ps1` - el nuevo icono se aplicará automáticamente

## 🐛 Solución de Problemas

### ❗ Problemas Comunes

#### 🚫 "Error: Go no está instalado"
```powershell
# Instalar Go desde https://golang.org/dl/
# Verificar instalación:
go version
```

#### 🚫 "Error: Make no está disponible"
```powershell
# Windows - instalar con Chocolatey:
choco install make

# O usar scoop:
scoop install make
```

#### 🚫 "Error compilando frontend"
```powershell
# Limpiar caché de npm:
cd cmd\server-manager\typescript
npm cache clean --force
npm install --legacy-peer-deps
```

#### 🚫 "Puerto 8772 ya está en uso"
```yaml
# Cambiar puerto en config.yml:
port: 8773  # O cualquier puerto libre
```

### 🔍 Logs y Debugging

#### 📋 Ubicación de Logs
- **Windows**: `cmd\server-manager\logs\`
- **Linux**: `cmd/server-manager/logs/`

#### 🐛 Modo Debug
```yaml
# config.yml
log_level: "debug"
```

#### 📊 Monitoring de Rendimiento
```yaml
monitoring:
  enabled: true
  metrics_port: 8773
```

### 🔧 Mantenimiento

#### 🗄️ Backup de Datos
```powershell
# Backup automático de datos importantes:
xcopy "cmd\server-manager\*.db" "backup\" /Y
xcopy "cmd\server-manager\config.yml" "backup\" /Y
```

#### 🔄 Actualización
1. Haz backup de `config.yml` y archivos de datos
2. Descarga la nueva versión
3. Reemplaza binarios manteniendo configuración
4. Verifica funcionamiento

## 📖 Referencias

### 🔗 Enlaces Útiles
- 🏠 **Página Principal**: [GitHub](https://github.com/JustaPenguin/assetto-server-manager)
- 📚 **Wiki**: [Documentación Completa](https://github.com/JustaPenguin/assetto-server-manager/wiki)
- 🐛 **Reportar Bugs**: [Issues](https://github.com/JustaPenguin/assetto-server-manager/issues)
- 💬 **Comunidad**: [Discord](https://discord.gg/assetto-server-manager)

### 📋 Comandos Útiles

#### 🛠️ Desarrollo
```powershell
# Compilación rápida solo para Windows:
cd cmd\server-manager
go build -o server-manager.exe

# Test de funcionalidad:
go test ./...

# Verificar dependencias:
go mod tidy
```

#### 🔧 Administración
```powershell
# Reiniciar servidor:
taskkill /F /IM server-manager.exe  # Windows
./server-manager.exe

# Ver procesos:
Get-Process *server-manager*  # Windows
ps aux | grep server-manager  # Linux
```

### 📊 Configuraciones Recomendadas

#### 🏁 Servidor de Carreras Competitivas
```yaml
server:
  max_clients: 24
  pickup_mode_enabled: false
  force_virtual_mirror: true
  abs_allowed: 0
  tc_allowed: 0
```

#### 🎮 Servidor Casual/Público
```yaml
server:
  max_clients: 30
  pickup_mode_enabled: true
  abs_allowed: 1
  tc_allowed: 1
  stability_control_allowed: 1
```

#### 🏆 Campeonatos
```yaml
championship:
  sign_up_form:
    enabled: true
    require_steam_id: true
  point_system: "F1"  # O personalizado
```

---

## 🤝 Contribuir

¿Quieres ayudar a mejorar Assetto Server Manager?

1. 🍴 Fork del repositorio
2. 🌿 Crea una rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. 💾 Commit tus cambios (`git commit -am 'Añade nueva característica'`)
4. 📤 Push a la rama (`git push origin feature/nueva-caracteristica`)
5. 🔄 Crea un Pull Request

## 📄 Licencia

Este proyecto está licenciado bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

---

**🎉 ¡Disfruta gestionando tu servidor de Assetto Corsa con estilo!**

*Desarrollado con ❤️ por la comunidad de Assetto Corsa*
