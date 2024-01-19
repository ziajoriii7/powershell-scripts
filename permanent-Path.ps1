# Solicitar al usuario que ingrese la ruta del directorio
$pathToAdd = Read-Host -Prompt "Ingrese la ruta del directorio a agregar a la variable de entorno PATH"

# Obtener la variable de entorno PATH actual del sistema
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

# Verificar si la ruta ya está en PATH
if ($currentPath -like "*$pathToAdd*") {
    Write-Host "La ruta ya está en la variable de entorno PATH."
} else {
    # Agregar la nueva ruta al PATH actual
    $newPath = $currentPath + ";" + $pathToAdd

    # Establecer la nueva variable de entorno PATH
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, [System.EnvironmentVariableTarget]::Machine)

    Write-Host "Ruta agregada correctamente a la variable de entorno PATH."
}

# Nota: Este script debe ejecutarse con privilegios de administrador para modificar la variable de entorno del sistema.
