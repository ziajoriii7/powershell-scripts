param(
	[Parameter(Position = 0)]
	[string]$FirstArg,
	[Parameter(Position = 1)]
	[string]$SecondArg,
	[int]$StartIndex = 1,
	[int]$EndIndex = [int]::MaxValue,
	[string[]]$ExcludeFiles = @(),
	[Alias("r")] [switch]$Recursive,
	[Alias("l")] [int]$level = [int]::MaxValue,
	[string]$Path = "$pwd",
	[string[]]$ExcludeDirs = @(".git","node_modules","bin","obj")
)

function Test-IsInteger ($value) {
	return $value -match '^\d+$'
}

if (Test-IsInteger $FirstArg -and Test-IsInteger $SecondArg) {
	$StartIndex = [int]$FirstArg
	$EndIndex = [int]$SecondArg
} elseif ($FirstArg -like ".\*" -or $FirstArg -like "..\*") {
	$Path = $FirstArg
} elseif ($FirstArg) {
	Write-Host "Invalid arguments. Please specify either two integers (StartIndex and EndIndex) or a valid path."
	exit
}


Write-Host ""
$title = "-ˋˏ ༻❁༺ ˎˊ- PYGMENTIZE FILE PROCESSOR -ˋˏ ༻❁༺ ˎˊ-"
$separatorTitle = "=" * $title.Length
Write-Host $title -ForegroundColor Cyan
Write-Host $separatorTitle -ForegroundColor Cyan
Write-Host "Scanning directory: $Path"


function Get-FilesRecursive {
	param(
		[string]$Directory,
		[int]$CurrentDepth = 0
	)
	if ($CurrentDepth -ge $level) {
		return
	}
	Write-Host "Entering directory: $Directory" -ForegroundColor DarkGreen

	$childFiles = Get-ChildItem -Path $Directory -File | Where-Object {
		!$_.Attributes.ToString().Contains("Hidden") -and
		$_.Extension -notmatch '\.(pdf|ipynb)$'
		$ExcludeFiles -notcontains $_.Name
	} | Sort-Object LastWriteTime -Descending

	$childFiles

	$childDirs = Get-ChildItem -Path $Directory -Directory | Where-Object {
		$ExcludeDirs -notcontains $_.Name
	}
	foreach ($childDir in $childDirs) {
		Get-FilesRecursive -Directory $childDir.FullName -CurrentDepth ($CurrentDepth + 1)
	}
}

$files = @()
if ($Recursive) {
	$files += Get-FilesRecursive -Directory $Path
} else {
	$files += Get-ChildItem -Path $Path -File | Where-Object {
		!$_.Attributes.ToString().Contains("Hidden") -and
		$_.Extension -notmatch '\.(pdf|ipynb)$'
		$ExcludeFiles -notcontains $_.Name
	} | Sort-Object LastWriteTime -Descending
}

Write-Host "Files found: $($files.Count)"
if ($files.Count -eq 0) {
	Write-Host "No files found matching criteria." -ForegroundColor Yellow
	exit
}

if ($EndIndex -eq [int]::MaxValue) {
	$EndIndex = $files.Count
}

if ($StartIndex -lt 1 -or $EndIndex -gt $files.Count -or $EndIndex -lt $StartIndex) {
	Write-Host "The specified index range is out of bounds." -ForegroundColor Red
	exit
}

$currentProcessingIndex = 1

foreach ($file in $files) {
	if ($currentProcessingIndex -lt $StartIndex -or $currentProcessingIndex -gt $EndIndex) {
		$currentProcessingIndex++
		continue
	}

	$lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines
	if ($lineCount -gt 2000) {
		$response = Read-Host "Warning: File $($file.Name) has more than 2000 lines. Do you want to proceed? (Y/N)"
		if ($response -ne 'Y') {
			Write-Host "Skipping: $($file.Name)" -ForegroundColor Yellow
			$currentProcessingIndex++
			continue
		}
	}

	$header = "`nFILE ${currentProcessingIndex}: $($file.Name)"
	$separator = "*" * $header.Length

	Write-Host $header -ForegroundColor DarkMagenta
	Write-Host $separator -ForegroundColor DarkMagenta

	& pygmentize -O style=friendly -f terminal256 $file.FullName

	Write-Host ""
	if ($currentProcessingIndex -ge $EndIndex) {
		break
	}
	$currentProcessingIndex++
}
