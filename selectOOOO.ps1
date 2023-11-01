param (
    [switch]$dir,
    [switch]$files
)

function SelectAndOpenItemWithApp {
    param (
        [switch]$dir,
        [switch]$files
    )

    $lineNumber = 0
    $items = @()

    # ... (Same as before, no changes here)

    $continue = $true

    while ($continue) {
        Write-Host "Ingrese un número del Index" -ForegroundColor Cyan
        $selectedNumber = Read-Host

        if ($selectedNumber -eq 'q' -or $selectedNumber -eq [char]27) {
            Write-Host "Proceso cancelado"
            $continue = $false
        }
        elseif ($selectedNumber -and $selectedNumber -le $lineNumber) {
            $selectedItem = $items[$selectedNumber - 1]
            
            Write-Host "Ingrese la aplicación para abrir el archivo (ejemplo: nvim, pp, Start-Process, etc.)"
            $appToUse = Read-Host
            
            if ($appToUse) {
                Start-Process -FilePath $appToUse -ArgumentList $selectedItem.FullName
            }
            else {
                Start-Process $selectedItem.FullName
            }
            $continue = $false
        }
        else {
            Write-Host "Número inválido. Intenta de nuevo o presiona 'q' o ESC para salir."
        }
    }
}

SelectAndOpenItemWithApp -dir:$dir -files:$files

