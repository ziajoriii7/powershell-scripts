# Solicitar entrada del usuario (Ask for user input)
$pattern = Read-Host "Enter the command or regex pattern to search"

# Leer el archivo de historial (Read the history file)
$historyPath = "C:\Users\kaeka\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
$historyContent = Get-Content $historyPath

# Buscar coincidencias (Search for matches)
$matchedCommands = $historyContent | Select-String -Pattern $pattern
$matchCount = $matchedCommands.Count

# Mostrar conteo y pedir confirmación (Show count and ask for confirmation)
Write-Host "Found $matchCount instances of '$pattern'. Do you want to delete all? (y/n)"
$confirmation = Read-Host

# Eliminar coincidencias si se confirma (Remove matches if confirmed)
if ($confirmation -eq 'y') {
    $newHistoryContent = $historyContent | Where-Object { $_ -notmatch $pattern }
    $newHistoryContent | Set-Content $historyPath
    Write-Host "All instances of '$pattern' have been deleted."
} else {
    Write-Host "No changes were made."
}

