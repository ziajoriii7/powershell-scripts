param (
    [switch]$dir,
    [switch]$files
)

function GetLongName {
    param (
        [switch]$dir,
        [switch]$files
    )

    $count = 0 # Iniciador de contador

    # Si no se especifican -dir ni -files mostrar ambos
    if (-not $dir -and -not $files) {
        $dir = $true
        $files = $true
        Write-Host "Procesando: " -NoNewline
        Write-Host "Directorios" -ForegroundColor Red -NoNewline
        Write-Host ", Archivos" -ForegroundColor Blue
    }
    elseif ($dir) {
        $files = $false
        Write-Host "Procesando: " -NoNewline
        Write-Host "Directorios" -ForegroundColor Red
    }
    elseif ($files) {
        $dir = $false
        Write-Host "Procesando: " -NoNewline
        Write-Host "Archivos" -ForegroundColor Blue
    }


    Get-ChildItem | Sort-Object LastWriteTime -Descending | ForEach-Object {
        $count++
    
        $formattedCount =  "{0,2}|" -f $count
        
        if ($_ -is [System.IO.DirectoryInfo] -and $dir) {
            Write-Host "$formattedCount $($_.Name)" -ForegroundColor Red
        }
        elseif ($_ -isnot [System.IO.DirectoryInfo] -and $files) {
            Write-Host "$formattedCount $($_.Name)" -ForegroundColor Blue
        }
    }
    
}

# Llamada a la función
GetLongName -dir:$dir -files:$files
