param(
	[Parameter(Mandatory = $true, ValueFromRemainingArguments = $true)]
	[string[]]$filenames,
	[Alias("md")][switch]$m,
	[Alias("py")][switch]$python,
	[switch]$c,
	[switch]$cpp,
	[switch]$js
)

function getFileExtension {
	param (
		[switch]$python,
		[switch]$c,
		[switch]$cpp,
		[switch]$m,
		[switch]$js
	)

	if ($python) {return ".py"}
	elseif($c) {return ".c"}
	elseif($cpp) {return ".cpp"}
	elseif($js) {return ".js"}
	else { return ".md"}
}

$newFiles = @()
$modifiedFiles = @()
$unchangedFiles = @()
$fileTypes = @{}

$extension = getFileExtension -python:$python -c:$c -cpp:$cpp -m:$m  -js:$js


foreach ($filename in $filenames) {
	Write-Host "Processing file: $filename"
	$isNewFile = $false
	$fileBaseName = [System.IO.Path]::GetfilenameWithoutExtension($filename)
	$fileExtension = [System.IO.Path]::GetExtension($filename)

	if (-not $fileExtension) {
		$filename = "$filename$extension"
	}
	
	$header = if ($python -or $c -or $cpp -or $js) {""} else {"# $fileBaseName`n"}


	if (Test-Path $filename) {
		$absolutePath = Resolve-Path $filename
		Write-Host "File exists: $filename"
	} else {
		Write-Host "Creating new file: $filename"
		$newFile = New-Item -ItemType file -Path $filename
		$absolutePath = $newFile.FullName
		$isNewFile = $true
	}


	$parentPath = Split-Path $absolutePath -Parent
	$parentDirName = Split-Path $parentPath -Leaf

	if ((Split-Path $absolutePath -Leaf) -eq "README$extension") {
		$header = if ($python -or $c -or $cpp -or $js) {""} else {"# $parentDirName`n"}
		Write-Host "Header for README$extension $header"
	}

	if ($isNewFile) {
		Write-Host "Setting header for new file"
		Set-Content -Path $filename -Value $header
	} else {
		$content = Get-Content $filename
		$trimmedHeader = $header.Trim()
		$firstLineOfFile = $content.Length -gt 0 ? $content[0].Trim() : ""

		if ($firstLineOfFile -ne $trimmedHeader) {
			Write-Host "Adding header to existing file"
			$newContent = @($header) + @($content)
			Set-Content -Path $filename -Value $newContent
		} else {
			Write-Host "Header already exists in file: $filename"
		}
	}
	dos2unix $filename
}
