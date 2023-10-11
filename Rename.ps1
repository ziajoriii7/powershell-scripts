
param(
    [Parameter(Mandatory=$true)][string]$oldName,
    [Parameter(Mandatory=$true)][string]$newName
)

try {
  # Intenta renombrar el Archivo
  Rename-Item -Path $oldName -NewName $newName -ErrorAction Stop
  Write-Host "Archivo renombrado exitosamente a $newName."
  } catch {
    # Si hay un error (por ejemplo, el archivo ya existe), captura el error y muestra un mensaje
    Write-Host "Error: No se pudo renombrar el archivo. Razón: $($_.Exception.Message)" -ForegroundColor Red
  }

