# Obtener la lista de archivos y directorios .vs
$vsFiles = git ls-files | Select-String ".vs"

# Iterar sobre cada archivo y directorio, y ejecutar git rm --cached
foreach ($file in $vsFiles) {
    $filePath = $file -replace '"', ''  # Eliminar las comillas, si las hay
    git rm --cached "$filePath"
}

# Ahora, puedes commit estos cambios
git commit -m "Eliminar archivos y directorios .vs del seguimiento de Git"
# Obtener la lista de archivos y directorios .vs
$vsFiles = git ls-files | Select-String ".vs"

# Iterar sobre cada archivo y directorio, y ejecutar git rm --cached
foreach ($file in $vsFiles) {
    $filePath = $file -replace '"', ''  # Eliminar las comillas, si las hay
    git rm --cached "$filePath"
}

# Ahora, puedes commit estos cambios
git commit -m "Eliminar archivos y directorios .vs del seguimiento de Git"

