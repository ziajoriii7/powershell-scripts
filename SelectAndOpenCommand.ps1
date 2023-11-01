param (
    [switch]$dir,
    [switch]$files
)

function SelectAndOpenCommand {
    param (
        [switch]$dir,
        [switch]$files
    )

    $lineNumber = 0 # Iniciador de contador (Line number initializer)
    $items = @() # Arreglo para el número de líneas (Array for line numbers)

    # Si no se especifican -dir ni -files mostrar ambos (If neither -dir nor -files is specified, show both)
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
        $items += $_ # Añadir elemento al arreglo (Add item to array)

        if ($_ -is [System.IO.DirectoryInfo] -and $dir) {
            Write-Host "$lineNumber | $($_.Name)" -ForegroundColor Red
        }
        elseif ($_ -isnot [System.IO.DirectoryInfo] -and $files) {
            Write-Host "$lineNumber | $($_.Name)" -ForegroundColor Blue
        }
    }

    $continue = $true # Variable para el control del bucle (Variable for loop control)

    while($continue){
        Write-Host "Ingrese un número del Index (Enter a number from the index)" -ForegroundColor Cyan
        $selectedNumber = Read-Host

        if ($selectedNumber -eq 'q' -or $selectedNumber -eq [char]27){
            Write-Host "Proceso cancelado (Process canceled)"
            $continue = $false
        }
        elseif ($selectedNumber -and [int]$selectedNumber -le $lineNumber){
            $selectedItem = $items[[int]$selectedNumber - 1]
            if ($selectedItem.Extension -eq '.ps1'){
                & $selectedItem.FullName # Ejecutar (Execute) PowerShell script
            } else {
                Write-Host "Ingrese la aplicación con la que desea abrir el archivo, o presione Enter para usar la predeterminada (Enter the application you'd like to use, or press Enter for the default):"
                $customApp = Read-Host
                if ($customApp) {
                    Start-Process $customApp -ArgumentList $selectedItem.FullName
                } else {
                    Start-Process $selectedItem.FullName
                }
            }
            $continue = $false
        } else {
            Write-Host "Número inválido. Intenta de nuevo o presiona 'q' o ESC para salir (Invalid number. Try again or press 'q' or ESC to exit)."
        }
    }
}

SelectAndOpenCommand -dir:$dir -files:$files

