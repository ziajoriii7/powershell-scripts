param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$Args
)

$ExcludeFiles = @(".gitignore")
$ExcludeDirs = @(".git","node_modules","bin","obj")
$ExcludeExtensions = @(
	".jpg",".jpeg",".png",".gif",".webp",".ico",
	".pdf",".docx",".pptx",".xlsx",
	".mp4",".webm",".mkv",".mp3",
	".zip",".rar",".7z"
)
$Recursive = $false
$RecursionLevel = 0
$Path = "."
$MaxLines = 2000
$ExcludedFilesCount = 0
$IgnoredFiles = @()
$ExcludedFiles = @()


function Test-IsInteger ($value) {
	return $value -match '^\d+$'
}

$StartIndex = 1
$EndIndex = [int]::MaxValue
$itemsToProcess = @()

for ($i = 0; $i -lt $Args.Count; $i++) {
	$arg = $Args[$i]
	if ($arg -eq "-R") {
		$Recursive = $true
		if ($i + 1 -lt $Args.Count -and (Test-IsInteger $Args[$i + 1])) {
			$RecursionLevel = [int]$Args[$i + 1]
			$i++
		} else {
			$RecursionLevel = [int]::MaxValue
		}
	} elseif (Test-IsInteger $arg) {
		if ($EndIndex -eq [int]::MaxValue) {
			$EndIndex = [int]$arg
		} else {
			$StartIndex = $EndIndex
			$EndIndex = [int]$arg
		}
	} elseif (Test-Path $arg -PathType Leaf) {
		$itemsToProcess += @{ Type = "File"; Path = (Resolve-Path $arg).Path }
	} elseif (Test-Path $arg -PathType Container) {
		$itemsToProcess += @{ Type = "Directory"; Path = (Resolve-Path $arg).Path }
	}
}

if ($itemsToProcess.Count -eq 0) {
	$itemsToProcess += @{ Type = "Directory"; Path = (Resolve-Path $Path).Path }
}

Write-Host ""
$title = "loopsie coloring"
$separatorTitle = "∴⋮" * $($title.Length / 2)
Write-Host $title -ForegroundColor Cyan
Write-Host $separatorTitle -ForegroundColor Cyan

function Get-FilesRecursive {
	param(
		[string]$Directory,
		[int]$CurrentDepth = 0
	)
	if ($CurrentDepth -gt $RecursionLevel) {
		return @()
	}
	$allFiles = Get-ChildItem -Path $Directory -File
	$childFiles = $allFiles | Where-Object {
		!$_.Attributes.ToString().Contains("Hidden") -and
		$_.Extension -notin $ExcludeExtensions -and
		$ExcludeFiles -notcontains $_.Name
	} | Sort-Object LastWriteTime -Descending

	$ignoredFiles = $allFiles | Where-Object {
		$_.Extension -in $ExcludeExtensions -or
		$ExcludeFiles -contains $_.Name
	}
	$script:IgnoredFiles += $ignoredFiles | ForEach-Object { $_.FullName }

	$result = @() + $childFiles

	if ($CurrentDepth -lt $RecursionLevel) {
		$childDirs = Get-ChildItem -Path $Directory -Directory | Where-Object {
			$ExcludeDirs -notcontains $_.Name
		}
		foreach ($childDir in $childDirs) {
			$result += Get-FilesRecursive -Directory $childDir.FullName -CurrentDepth ($CurrentDepth + 1)
		}
	}

	return $result
}


function Process-Files {
	param(
		[System.IO.FileInfo[]]$Files,
		[int]$Start = 1,
		[int]$End = [int]::MaxValue
	)
	$currentIndex = 1
	$lastDirectory = ""
	foreach ($file in $Files) {
		if ($currentIndex -ge $Start -and $currentIndex -le $End) {
			if ($file.Directory.FullName -ne $lastDirectory) {
				Write-Host "`n-> Entering directory: $($file.Directory.FullName)" -ForegroundColor DarkGreen
				$lastDirectory = $file.Directory.FullName
			}
			$lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines
			if ($lineCount -gt $MaxLines) {
				$script:ExcludedFilesCount++
				$script:ExcludedFiles += [pscustomobject]@{
					Name = $file.Name
					Path = $file.FullName
					LineCount = $lineCount
				}
				$header = "FILE ${currentIndex}: $($file.Name) (Excluded - $lineCount lines)"
				$separator = "─" * $header.Length
				Write-Host $header -ForegroundColor Yellow
				Write-Host $separator -ForegroundColor Yellow
				$content = Get-Content $file.FullName
				Write-Host "First two lines:" -ForegroundColor Yellow
				Write-Host $content[0..1] -ForegroundColor Gray
				Write-Host "Last two lines:" -ForegroundColor Yellow
				Write-Host $content[-2..-1] -ForegroundColor Gray
			} else {
				$header = "FILE ${currentIndex}: $($file.Name)"
				$separator = "─" * $header.Length
				Write-Host $header -ForegroundColor DarkMagenta
				Write-Host $separator -ForegroundColor DarkMagenta
				& pygmentize -O style=friendly -f terminal256 $file.FullName
			}
			Write-Host ""
		}
		$currentIndex++
	}
}


foreach ($item in $itemsToProcess) {
	switch ($item.Type) {
		"Directory" {
			Write-Host "Processing directory: $($item.Path)" -ForegroundColor Yellow
			if ($Recursive) {
				$files = Get-FilesRecursive -Directory $item.Path
			} else {
				$allFiles = Get-ChildItem -Path $item.Path -File
				$files = $allFiles | Where-Object {
					!$_.Attributes.ToString().Contains("Hidden") -and
					$_.Extension -notin $ExcludeExtensions -and
					$ExcludeFiles -notcontains $_.Name
				} | Sort-Object LastWriteTime -Descending
				$script:IgnoredFiles += $allFiles | Where-Object {
					$_.Extension -in $ExcludeExtensions -or
					$ExcludeFiles -contains $_.Name
				} | ForEach-Object { $_.FullName }
			}
			Write-Host "Processing files $StartIndex to $EndIndex" -ForegroundColor Yellow
			Process-Files -Files $files -Start $StartIndex -End $EndIndex
		}
		"File" {
			Write-Host "Processing file: $($item.Path)" -ForegroundColor Yellow
			$file = Get-Item $item.Path
			if ($file.Extension -notin $ExcludeExtensions -and $ExcludeFiles -notcontains $file.Name) {
				Process-Files -Files @($file)
			} else {
				Write-Host "Skipping excluded file: $($file.Name)" -ForegroundColor Yellow
				$script:IgnoredFiles += $file.FullName
			}
		}
	}
}

Write-Host "`nProcessing complete."
Write-Host "Files excluded due to exceeding $MaxLines lines: $ExcludedFilesCount" -ForegroundColor Yellow
if ($ExcludedFiles.Count -gt 0) {
	Write-Host "Excluded files list:" -ForegroundColor Yellow
	foreach ($file in $ExcludedFiles) {
		Write-Host " $($file.Name) - $($file.lineCount) lines" -Foreground Gray
	}
}
Write-Host "Ignored files: $($IgnoredFiles.Count)" -ForegroundColor Yellow
if ($IgnoredFiles.Count -gt 0) {
	Write-Host "Ignored file list:" -ForegroundColor Yellow
	$IgnoredFiles | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
}
