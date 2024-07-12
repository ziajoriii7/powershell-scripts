param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$Paths
)

function Add-SessionPath {
	param([string]$Path)

	$fullPath = Resolve-Path $Path -ErrorAction SilentlyContinue
	if (-not $fullPath) {
		Write-Host "$Path is an invalid path." -ForegroundColor Red
		return
	}
	if ($env:PATH -split ";" -contains $fullPath) {
		Write-Host "$fullPath already exists in the current session PATH." -ForegroundColor Yellow
		return
	}
	$env:PATH += ";$fullPath"
	Write-Host "$fullPath was added to the current session PATH." -ForegroundColor Green
}

if (-not $Paths) {
	$Paths = @(Get-Location | Select-Object -ExpandProperty Path)
}

$pathWord = if ($Paths.Count -eq 1) { "path " } else { "paths" }
Write-Host "$pathWord will be added to your current session PATH:" -ForegroundColor Cyan
$Paths | ForEach-Object { Write-Host $_ }

$confirmation = Read-Host "Do you want to proceed? (Y/N)"
if ($confirmation.ToLower() -ne 'y') {
	Write-Host "Operation cancelled." -ForegroundColor Yellow
	exit
}

foreach ($path in $Paths) {
	Add-SessionPath $path
}

Write-Host "$pathWord added to the current session PATH." -ForegroundColor Cyan
