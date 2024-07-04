param(
	[Alias("p")]
	[string[]]$Paths = @(Get-Location)
)

function Get-TotalItemCount {
	param([string]$path)

	$allDirs = Get-ChildItem -Directory -Path $path -Force
	$allFiles = Get-ChildItem -File -Path $path -Force

	$hiddenDirs = $allDirs | Where-Object { $_.Attributes -match 'Hidden' }
	$hiddenFiles = $allFiles | Where-Object { $_.Attributes -match 'Hidden' }

	$totalDirs = $allDirs.Count
	$totalFiles = $allFiles.Count
	$totalHiddenDirs = $hiddenDirs.Count
	$totalHiddenFiles = $hiddenFiles.Count
	$totalItems = $totalDirs + $totalFiles
	$currentDirName = Split-Path -Path $path -Leaf

	Write-Host "`n" -NoNewline
	Write-Host -ForegroundColor DarkMagenta "$currentDirName's:"
	$underline = "─" * ($currentDirName.Length + 3)
	Write-Host -ForegroundColor Gray $underline

	Write-Host -NoNewline " • [ "
	Write-Host -ForegroundColor DarkMagenta -NoNewline $totalItems
	Write-Host " ] items"

	Write-Host -NoNewline " • [ "
	Write-Host -ForegroundColor Cyan -NoNewline $totalFiles
	Write-Host -ForegroundColor Gray -NoNewline " ] files / [ "
	Write-Host -ForegroundColor Magenta -NoNewline $totalDirs
	Write-Host " ] dirs"

	Write-Host -NoNewline " • [ "
	Write-Host -ForegroundColor Cyan -NoNewline $totalHiddenFiles
	Write-Host -ForegroundColor Gray -NoNewline " ] hidden files / [ "
	Write-Host -ForegroundColor Magenta -NoNewline $totalHiddenDirs
	Write-Host " ] hidden dirs`n" -ForegroundColor Gray
}

foreach ($path in $Paths) {
	Get-TotalItemCount -Path $path
}
