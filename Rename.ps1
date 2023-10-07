
param(
    [Parameter(Mandatory=$true)][string]$oldName,
    [Parameter(Mandatory=$true)][string]$newName
)

if (Test-Path $oldName){
    Rename-Item -Path $oldName -NewName $newName
    Write-Host "Archivo renombrado exitosamente a $newName."
} else {
    Write-Host "El archivo $oldName no existe."
}

