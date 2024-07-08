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
	[string]$Path = "$pwd"
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
$title = "-ˋˏ ༻❁༺ ˎˊ- PYGMENTIZE UNTRACKED FILES PROCESSOR -ˋˏ ༻❁༺ ˎˊ-"
$separatorTitle = "=" * $title.Length
Write-Host $title -ForegroundColor Cyan
Write-Host $separatorTitle -ForegroundColor Cyan
Write-Host "Scanning directory: $Path"

function Get-UntrackedFiles {
	param(
		[string]$Directory,
		[int]$CurrentDepth = 0
	)
	if ($CurrentDepth -ge $level) {
		return
	}

	Push-Location $Directory
	$untrackedFiles = git ls-files --others --exclude-standard
	Pop-Location

	$files = @()
	foreach ($file in $untrackedFiles) {
		$fullPath = Join-Path -Path $Directory -ChildPath $file
		if (Test-Path $fullPath -PathType Leaf) {
			$fileInfo = Get-Item $fullPath
			if (!$fileInfo.Attributes.ToString().Contains("Hidden") -and
				$fileInfo.Extension -notmatch '\.(pdf|ipynb)$' -and
				$ExcludeFiles -notcontains $fileInfo.Name) {
				$files += $fileInfo
			}
		}
	}

	if ($Recursive) {
		$childDirs = Get-ChildItem -Path $Directory -Directory | Where-Object { $_.Name -ne ".git" }
		foreach ($childDir in $childDirs) {
			$files += Get-UntrackedFiles -Directory $childDir.FullName -CurrentDepth ($CurrentDepth + 1)
		}
	}

	return $files
}

$files = Get-UntrackedFiles -Directory $Path | Sort-Object LastWriteTime -Descending

Write-Host "Untracked files found: $($files.Count)"
if ($files.Count -eq 0) {
	Write-Host "No untracked files found matching criteria." -ForegroundColor Yellow
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
