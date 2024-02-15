function convertTo-WslPath {
	param(
		[string]$winPath
	)

	$wslPath = $winPath -replace "\\","/"
	$wslPath = $wslPath -replace "^([A-Za-z]):",{
		"/mnt/" + $_.Groups[1].Value.ToLower()
	}

	return $wslPath
}

$currentPath = $(Get-Location).Path
$finalPaths = @()

foreach ($relativePath in $args) {
	if ($relativePath -match "^\$") {
		$varName = $relativePath.TrimStart("$")
		if (Get-Variable -Name $varName -ErrorAction SilentlyContinue) {
			$variableValue = (Get-Variable -Name $varName).Value
			if ($variableValue -is [System.Management.Automation.PathInfo]) {
				$relativePath = $variableValue.Path
			} else {
				$relativePath = $variableValue
			}
		}
	}

	if ([System.IO.Path]::IsPathRooted($relativePath)) {
		$pathToResolve = $relativePath
	} else {
		$pathToResolve = Join-Path -Path $currentPath -ChildPath $relativePath
	}

	try {
		$resolvedPath = Resolve-Path $pathToResolve
		$wslPath = convertTo-WslPath -winPath $resolvedPath.Path
		$finalPaths += "`"$wslPath`""
	} catch {
		Write-Host "$pathToResolve cannot be resolved."
	}
}

if ($finalPaths.Count -eq 0) {
	$wslPath = convertTo-WslPath -winPath $currentPath
	Set-Clipboard -Value "`"$wslPath`""
	Write-Host "`"$wslPath`" copied to clipboard."
} elseif ($finalPaths.Count -eq 1) {
	Set-Clipboard -Value $finalPaths
	Write-Host "$finalPaths copied to clipboard."
} elseif ($finalPaths) {
	$quotedPaths = $finalPaths -join "`n"
	Set-Clipboard -Value $quotedPaths
	Write-Host ($quotedPaths -join "`n") -NoNewline
	Write-Host " were copied to clipboard."
} else {
	Write-Host "No valid paths were found"
}
