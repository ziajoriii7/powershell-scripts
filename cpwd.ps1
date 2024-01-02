$currentDirectory = (Get-Location).Path
$quotedDirectory = "`"$currentDirectory`""

Set-Clipboard -Value $quotedDirectory

Write-Host "$currentDirectory copied to clipboard."

