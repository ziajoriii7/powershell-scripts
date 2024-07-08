param(
	[Parameter(ValueFromRemainingArguments = $true)]
	[string[]]$InputFiles
)

function Show-Usage {
	Write-Host "Usage:"
	Write-Host "  ps1prettify.ps1 <file1.ps1> <file2.ps1> ..."
}

$processedFiles = @()
$unchangedFiles = @()

if ($InputFiles.Count -eq 0) {
	Show-Usage
	exit
}

foreach ($file in $InputFiles) {
	$resolvedPath = Resolve-Path $file -ErrorAction SilentlyContinue
	if ($resolvedPath -and (Test-Path $resolvedPath -PathType Leaf)) {
		$fileItem = Get-Item $resolvedPath
		$originalContent = Get-Content $fileItem.FullName -Raw
		Edit-DTWBeautifyScript -Indent Tabs $fileItem.FullName
		dos2unix $fileItem.FullName
		$newContent = Get-Content $fileItem.FullName -Raw
		if ($originalContent -ne $newContent) {
			$processedFiles += $file
		} else {
			$unchangedFiles += $file
		}
	} else {
		Write-Host "$file was not found." -ForegroundColor Red
	}
}


$width = $Host.UI.RawUI.WindowSize.Width
$title = "PS1 Prettify Results"
$padding = 0
$leftPadding = " " * [math]::Floor($padding)
$rightPadding = " " * [math]::Ceiling($padding)

Write-Host "`n┌─[$title]$leftPadding$rightPadding" -NoNewline

Write-Host "$("─" * ($width - 5 - $title.Length))┐"
if ($processedFiles.Count -gt 0) {
	Write-Host "│ [+] New:  $($processedFiles.Count.ToString().PadRight(3)) | $($processedFiles[0])"
	foreach ($file in $processedFiles | Select-Object -Skip 1) {
		Write-Host "│                 $file"
	}
}
if ($unchangedFiles.Count -gt 0) {
	Write-Host "│ [=] Same: $($unchangedFiles.Count.ToString().PadRight(3)) | $($unchangedFiles[0])"
	foreach ($file in $unchangedFiles | Select-Object -Skip 1) {
		Write-Host "│                 $file"
	}
}

Write-Host "└$("─" * ($width - 2))┘"
