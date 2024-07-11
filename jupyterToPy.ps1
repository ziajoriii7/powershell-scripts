param(
	[Parameter(ValueFromRemainingArguments = $true)] [string[]]$Files,
	[Alias("n")] [switch]$numbered,
	[Alias("cleanAll")] [switch]$deleteOriginalJupy,
	[Alias("R")] [int]$RecursiveDepth = 0
)

function Check-Command ($cmdname) {
	return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function Check-Command ($cmdname) {
	return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

if (-not (Check-Command ipynb-py-convert)) {
	$installCommand = "pip install ipynb-py-convert"
	Write-Host "ipynb-py-convert not found. You can install it using the following command:" -ForegroundColor Red
	Write-Host $installCommand -ForegroundColor Cyan

	$choice = Read-Host "Do you want to install ipynb-py-convert now? (Y/N)"
	if ($choice -eq 'Y' -or $choice -eq 'y') {
		try {
			Invoke-Expression $installCommand
			if (Check-Command ipynb-py-convert) {
				Write-Host "ipynb-py-convert has been successfully installed." -ForegroundColor Green
			} else {
				throw "Installation failed."
			}
		}
		catch {
			Write-Host "Failed to install ipynb-py-convert. Please install it manually." -ForegroundColor Red
			Set-Clipboard $installCommand
			Write-Host "The install command has been copied to your clipboard." -ForegroundColor Yellow
			exit
		}
	} else {
		Set-Clipboard $installCommand
		Write-Host "The install command has been copied to your clipboard." -ForegroundColor Yellow
		exit
	}
}

function Compare-Files {
	param(
		[string]$file1,
		[string]$file2
	)

	$content1 = Get-Content $file1
	$lineCount1 = $content1.Count

	Write-Host "File 1 ($file1) has $lineCount1 lines."
	Write-Host "First 2 lines of File 1:"
	$content1 | Select-Object -First 2 | ForEach-Object { Write-Host $_ }
	Write-Host "Last 2 lines of File 1:"
	$content1 | Select-Object -Last 2 | ForEach-Object { Write-Host $_ }

	if (Test-Path $file2) {
		$content2 = Get-Content $file2
		$lineCount2 = $content2.Count
		Write-Host "File 2 ($file2) has $lineCount2 lines."
		Write-Host "First 2 lines of File 2:"
		$content2 | Select-Object -First 2 | ForEach-Object { Write-Host $_ }
		Write-Host "Last 2 lines of File 2:"
		$content2 | Select-Object -Last 2 | ForEach-Object { Write-Host $_ }
	} else {
		Write-Host "File 2 ($file2) does not exist."
	}

	$choice = Read-Host "Choose an action: 1. Skip, 2. Overwrite, 3. Show diff"

	switch ($choice) {
		"1" { return $false }
		"2" { return $true }
		"3" {
			if (Test-Path $file2) {
				git diff --no-index $file1 $file2
			} else {
				Write-Host "Cannot show diff. $file2 does not exist."
			}
			return (Read-Host "Overwrite? (y/n)") -eq 'y'
		}
		default { return $false }
	}
}

function Remove-FileSafely {
	param(
		[string]$file
	)

	if (Get-Module -ListAvailable -Name Recycle) {
		Remove-ItemSafely -Path $file -Force
		Write-Host "$file was moved to the Recycle Bin."
	} else {
		Remove-Item $file
		Write-Host "$file was rm. Consider executing this `Install-Module -Name Recycle` in your terminal for safer deletion aka removing it to the trash bin." -ForegroundColor Yellow
	}
}


function Convert-IpynbToPy {
	param(
		[Parameter(Mandatory = $true)] [string]$inputFile,
		[int]$Index
	)

	$baseName = [System.IO.Path]::GetFileNameWithoutExtension($inputFile)
	if ($numbered) {
		$outputFileName = "{0:D2}. {1}.py" -f $Index,$baseName
	} else {
		$outputFileName = "$baseName.py"
	}

	$outputPath = Join-Path (Split-Path $inputFile -Parent) $outputFileName

	if ($deleteOriginalJupy) {
		ipynb-py-convert $inputFile $outputPath
		Write-Host "$inputFile was converted to $outputPath."
		Remove-FileSafely $inputFile
	} else {
		if (Test-Path $outputPath) {
			$shouldOverwrite = Compare-Files $outputPath $inputFile
		} else {
			$shouldOverwrite = $true
		}

		if ($shouldOverwrite) {
			ipynb-py-convert $inputFile $outputPath
			Write-Host "$inputFile was converted to $outputPath."
		} else {
			Write-Host "$inputFile skipped its conversion."
		}
	}
}

$filesToProcess = @()
foreach ($item in $Files) {
	if (Test-Path $item -PathType Container) {
		$filesToProcess += Get-ChildItem -Path $item -Filter *.ipynb -Recurse:($RecursiveDepth -ne 0) -Depth $RecursiveDepth | Select-Object -ExpandProperty FullName
	} elseif (Test-Path $item -PathType Leaf) {
		$filesToProcess += $item
	} else {
		Write-Host "$item is an invalid path." -ForegroundColor Red
	}
}

if ($filesToProcess.Count -eq 0) {
	$filesToProcess = Get-ChildItem -Path . -Filter *.ipynb -Recurse:($RecursiveDepth -ne 0) -Depth $RecursiveDepth | Select-Object -ExpandProperty FullName
}

$filesToProcess = $filesToProcess | Sort-Object CreationTime
$totalFiles = $filesToProcess.Count

for ($i = 0; $i -lt $totalFiles; $i++) {
	$file = $filesToProcess[$i]
	Write-Progress -Activity "Converting notebooks" -Status "Processing file $($i+1) of $totalFiles" -PercentComplete (($i + 1) / $totalFiles * 100)
	Convert-IpynbToPy -InputFile $file -Index ($i + 1)
}

Write-Host "$totalFiles files processed." -ForegroundColor Cyan
