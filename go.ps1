param(
	[switch]$dir,
	[switch]$files
)

function SelectAndOpenItem {
	param(
		[switch]$dir,
		[switch]$files
	)

	$items = Get-ChildItem | Sort-Object LastWriteTime -Descending
	$index = 1

	if (-not $dir -and -not $files) {
		$dir = $true
		$files = $true
		Write-Host "Procesando: " -NoNewline
		Write-Host "Directorios" -ForegroundColor Red -NoNewline
		Write-Host ", Archivos" -ForegroundColor Blue
	} elseif ($dir) {
		$files = $false
		Write-Host "Procesando: " -NoNewline
		Write-Host "Directorios" -ForegroundColor Red
	} elseif ($files) {
		$dir = $false
		Write-Host "Procesando: " -NoNewline
		Write-Host "Archivos" -ForegroundColor Blue
	}

	foreach ($item in $items) {
		if (($item -is [System.IO.DirectoryInfo] -and $dir) -or ($item -isnot [System.IO.DirectoryInfo] -and $files)) {
			$color = if ($item -is [System.IO.DirectoryInfo]) { "Red" } else { "Blue" }
			Write-Host ("{0, 2}| {1}" -f $index,$item.Name) -ForegroundColor $color
			$index++
		}
	}

	while ($true) {
		$selection = Read-Host "Enter item number (q to quit)"
		if ($selection -eq 'q') { return }

		$selectedItem = $items[$selection - 1]
		if ($selectedItem -eq $null) {
			Write-Host "Invalid selection. Try again."
			continue
		}

		if (Test-Path $selectedItem.FullName -PathType Container) {
			Set-Location $selectedItem.FullName
		} elseif ($selectedItem.Extension -eq '.ps1') {
			& $selectedItem.FullName
		} else {
			$openWith = Read-Host "Open with (n for nvim, enter for default, or specify app)"
			switch ($openWith.ToLower()) {
				"n" { nvim $selectedItem.FullName }
				"" { Start-Process $selectedItem.FullName }
				default { Start-Process $openWith -ArgumentList $selectedItem.FullName }
			}
		}
		break
	}
}

SelectAndOpenItem -dir:$dir -files:$files
