# 🚀 Git Workflow - Solo Rama `main`

## 📋 Configuración Actual
- **Rama Principal**: `main` ✅
- **Rama Obsoleta**: `master` (ignorar)
- **Tags**: `v1.7.11`, `v1.7.12`

## 🔄 Flujo de Trabajo Diario

### 🆕 Para Nuevas Características
```powershell
# 1. Asegúrate de estar en main y actualizado
git checkout main
git pull origin main

# 2. Crea una nueva rama para tu feature
git checkout -b feature/nueva-caracteristica

# 3. Trabaja en tu código...
# ... hacer cambios ...

# 4. Commit y push
git add .
git commit -m "feat: descripción de la característica"
git push origin feature/nueva-caracteristica

# 5. Crear Pull Request en GitHub desde feature/nueva-caracteristica → main
```

### 🐛 Para Bugfixes
```powershell
# 1. Crear rama de bugfix
git checkout main
git pull origin main
git checkout -b bugfix/descripcion-del-bug

# 2. Arreglar el bug y commitear
git add .
git commit -m "fix: descripción del bugfix"
git push origin bugfix/descripcion-del-bug

# 3. Pull Request hacia main
```

### 🏷️ Para Releases
```powershell
# 1. Desde main actualizado
git checkout main
git pull origin main

# 2. Crear tag de versión
git tag v1.7.13
git push origin v1.7.13

# 3. Opcional: crear rama de release para hotfixes
git checkout -b release/v1.7.13
git push origin release/v1.7.13
```

## 🧹 Comandos de Limpieza

### 🗑️ Limpiar Ramas Locales Obsoletas
```powershell
# Ver ramas locales
git branch

# Eliminar ramas locales ya mergeadas
git branch --merged main | grep -v "main" | xargs git branch -d

# Eliminar rama específica
git branch -D nombre-rama
```

### 🌐 Limpiar Referencias Remotas
```powershell
# Actualizar referencias remotas
git fetch origin --prune

# Ver estado de ramas remotas
git remote show origin
```

## ⚠️ Reglas Importantes

1. **Nunca usar `master`** - solo `main`
2. **Siempre crear branches** para features/bugfixes
3. **Pull Requests obligatorios** para merge a main
4. **Tags para releases** con formato `vX.Y.Z`
5. **Commits descriptivos** con prefijos:
   - `feat:` para nuevas características
   - `fix:` para bugfixes
   - `docs:` para documentación
   - `refactor:` para refactoring
   - `test:` para tests

## 🎯 Estado Ideal del Repositorio

```
main (rama principal)
├── feature/nueva-ui
├── feature/performance-mejoras
├── bugfix/conexion-db
└── release/v1.7.13
```

## 🚨 En Caso de Emergencia

Si algo sale mal:
```powershell
# Volver a estado conocido
git checkout main
git reset --hard origin/main

# Ver historial para encontrar commit bueno
git log --oneline -10

# Volver a commit específico
git reset --hard COMMIT_HASH
```
