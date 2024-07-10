
$historyPath = Join-Path $env:USERPROFILE "AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"
$historyContent = Get-Content -Path $historyPath
$pipCommands = $historyContent | Where-Object { $_ -match "^pip install" }

$packages = @()
foreach ($cmd in $pipCommands) {
	$pkgList = $cmd -replace "^pip install ",""
	$pkgArray = $pkgList -split " "
	$packages += $pkgArray
}

$invalidArgs = @("--force-reinstall","--py","--sys-prefix","--upgrade","-m","-r","-y","install","enable","serverextension","python","pip","requirements.txt.")

$validPackages = $packages | Where-Object { $_ -notin $invalidArgs -and $_ -notmatch '[;`]+' }

$uniquePackages = $validPackages | Sort-Object -Unique

$combinedCommand = "pip install " + ($uniquePackages -join " ")
$combinedCommand
