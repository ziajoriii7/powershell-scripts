param(
	[Parameter(Mandatory = $true)]
	[string[]]$FileNames
)

foreach ($FileName in $FileNames) {
	Write-Host "Processing file: $FileName"
	$isNewFile = $false

	$absoluteFileName = $null

	if (Test-Path $FileName) {
		$absolutePath = Resolve-Path $FileName
		Write-Host "File exists: $FileName"
	} else {
		Write-Host "Creating new file: $FileName"
		$newFile = New-Item -ItemType file -Path $FileName
		$absolutePath = $newFile.FullName
		$isNewFile = $true
	}

	$fileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)

	$header = "# $fileBaseName`n"

	$parentPath = Split-Path $absolutePath -Parent
	$parentDirName = Split-Path $parentPath -Leaf

	if ((Split-Path $absolutePath -Leaf) -eq "README.md") {
		$header = "# $parentDirName`n"
		Write-Host "Header for README.md $header"
	}

	if ($isNewFile) {
		Write-Host "Setting header for new file"
		Set-Content -Path $FileName -Value $header
	} else {
		$content = Get-Content $FileName
		$trimmedHeader = $header.Trim()
		$firstLineOfFile = $content.Length -gt 0 ? $content[0].Trim() : ""

		if ($firstLineOfFile -ne $trimmedHeader) {
			Write-Host "Adding header to existing file"
			$newContent = @($header) + @($content)
			Set-Content -Path $FileName -Value $newContent
		} else {
			Write-Host "Header already exists in file: $FileName"
		}
	}
	dos2unix $FileName
}
