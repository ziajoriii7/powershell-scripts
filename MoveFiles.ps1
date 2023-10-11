param (
    [string]$currentDirectory = (Get-Location).Path
)

function Select-Files {
    param (
        [string]$directory
    )
    $files = Get-ChildItem -Path $directory -File | Out-GridView -PassThru -Title "Selecciona los archivos que deseas mover"
    return $files
}

function Select-Destination {
    param (
        [string]$directory
    )
    $folders = Get-ChildItem -Path $directory -Directory | Out-GridView -PassThru -Title "Selecciona el directorio destino"
    return $folders
}

$selectedFiles = Select-Files -directory $currentDirectory
$destinationFolder = Select-Destination -directory $currentDirectory

if ($selectedFiles -and $destinationFolder) {
    $destinationPath = $destinationFolder.FullName
    foreach ($file in $selectedFiles) {
        $sourcePath = $file.FullName
        $destinationFilePath = Join-Path -Path $destinationPath -ChildPath $file.Name
        Write-Host "Moviendo '$sourcePath' a '$destinationFilePath'" -ForegroundColor Yellow
        try {
            Move-Item -Path "$sourcePath" -Destination "$destinationFilePath" -ErrorAction Stop
        } catch {
            Write-Host "Error al mover '$sourcePath': $_" -ForegroundColor Red
        }
    }
    Write-Host "Operación completada" -ForegroundColor Green
}
else {
    Write-Host "Operación cancelada." -ForegroundColor Yellow
}

