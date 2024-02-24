$pattern = Read-Host "Enter the command or regex pattern to search"

$historyPath = Get-PSReadLineOption | Select-Object -ExpandProperty HistorySavePath

if (-not (Test-Path $historyPath)) {
    $historyPath = Join-Path $env:USERPROFILE "AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
}

$historyContent = Get-Content $historyPath

$matchedCommands = $historyContent | Select-String -Pattern $pattern
$matchCount = $matchedCommands.Count

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

