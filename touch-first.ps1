param(
    [Parameter(Mandatory=$true)]
    [string[]]$FileNames
)

foreach ($FileName in $FileNames) {
  Write-Host "Processing file: $FileName"
  $isNewFile = $false

  if (-not (Test-Path $FileName)) {
      Write-Host "Creating new file: $FileName"
      New-Item -ItemType file -Path $FileName
      $isNewFile = $true
  } else {
    Write-Host "File exists: $FileName"
  }
  
  $fileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
  $header = "# $fileBaseName`n"
  if ((Split-Path $FileName -Leaf) -eq "README.md") {
    $parentDirName = Split-Path $FileName -Parent | Split-Path -Leaf
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
