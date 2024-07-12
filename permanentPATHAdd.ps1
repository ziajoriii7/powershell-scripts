param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$Paths
)

function Add-PermanentPath {
	param([string]$Path)

	$fullPath = Resolve-Path $Path -ErrorAction SilentlyContinue
	if (-not $fullPath) {
		Write-Host "$Path is an invalid path." -ForegroundColor Red
		return
	}

	$currentPath = [Environment]::GetEnvironmentVariable("PATH","User")
	if ($currentPath -split ";" -contains $fullPath) {
		Write-Host "$fullPath already exists." -ForegroundColor Yellow
		return
	}

	$newPath = $currentPath + ";" + $fullPath
	[Environment]::SetEnvironmentVariable("PATH",$newPath,"User")
	Write-Host "$fullPath was added to PATH." -ForegroundColor Green
}

function Refresh-Path {
	$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") +
	";" +
	[System.Environment]::GetEnvironmentVariable("Path","User")
	Write-Host "PATH has been refreshed for the current session." -ForegroundColor Cyan
}

if (-not $Paths) {
	$Paths = @(Get-Location | Select-Object -ExpandProperty Path)
}

$pathWord = if ($Paths.Count -eq 1) { "path " } else { "paths" }
Write-Host "$pathWord will be added to your PATH:" -ForegroundColor Cyan
$Paths | ForEach-Object { Write-Host $_ }

$confirmation = Read-Host "Do you want to proceed? (Y/N)"
if ($confirmation -ne 'Y') {
	Write-Host "Operation cancelled." -ForegroundColor Yellow
	exit
}

foreach ($path in $Paths) {
	Add-PermanentPath $path
}

Write-Host "$pathWord added to user environment." -ForegroundColor Cyan
Refresh-Path
