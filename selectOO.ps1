param (
    [switch]$dir,
    [switch]$files
)
function SelectAndOpenItem {
    param (
        [switch]$dir,
        [switch]$files
    )

    $lineNumber = 0 # Iniciador de contador
    $items = @() #arreglo para el numero de lineas

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
        $lineNumber++
        $items += $_ # añadir elemento al arreglo

        if ($_ -is [System.IO.DirectoryInfo] -and $dir) {
            Write-Host "$lineNumber | $($_.Name)" -ForegroundColor Red
        }
        elseif ($_ -isnot [System.IO.DirectoryInfo] -and $files) {
            Write-Host "$lineNumber | $($_.Name)" -ForegroundColor Blue
        }
    }

    $continue = $true # Variable para el control del bucle

    #Solicitar al usuario un número para seleccionar una rchivo directorio

    while($continue){
        Write-Host "Ingrese un número del Index" -ForegroundColor Cyan
        $selectedNumber = Read-Host

        if ($selectedNumber -eq 'q' -or $selectedNumber -eq [char]27){ # Si el usuario ingresa 'q' o ESC

        Write-Host "Proceso cancelado"
        $continue = $false

        }

        elseif ($selectedNumber -and [int]$selectedNumber -le $lineNumber){
            $selectedItem = $items[[int]$selectedNumber -1]
            if ($selectedItem.Extension -eq '.ps1'){
                & $selectedItem.FullName # Execute PowerShell script
            }
            Start-Process $selectedItem.FullName 
            $continue = $false
        } else {
            Write-Host "Número inválido. Intenta de nuevo o presiona 'q' or ESC para salir."
        }
    
    }
}

SelectAndOpenItem -dir:$dir -files:$files

