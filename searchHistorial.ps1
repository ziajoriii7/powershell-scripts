param(
    [string]$searchTerm
)

$historyPath = Get-PSReadLineOption | Select-Object -ExpandProperty HistorySavePath

if (-not (Test-Path $historyPath)) {
    $historyPath = Join-Path $env:USERPROFILE "AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
}

$lines = rg $searchTerm $historyPath 
[array]::Reverse($lines)

$command = $lines | fzf --no-sort --exact --no-clear  
$copiedCommand = $command | Set-Clipboard

Write-Host "$command" -NoNewLine -ForegroundColor Red
Write-Host " was copied to clipboard."

