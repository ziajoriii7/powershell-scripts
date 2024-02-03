param(
    [Parameter(Mandatory=$true)]
    [string[]]$FileNames
)

foreach ($FileName in $FileNames) {
  $isNewFile = $false

    if (-not (Test-Path $FileName)) {
        "Creating new file: $FileName"
        New-Item -ItemType file -Path $FileName
        $isNewFile = $true
    } else {
      "Adding header to existing file: $FileName"
    }
    
    $fileBaseName = [System.IO.Path]::GetFileNameWithoutExtension($FileName)
    $header = "# $fileBaseName`n"

    if ((Split-Path $FileName -Leaf) -eq "README.md") {
      $parentDirName = Split-Path $FileName -Parent | Split-Path -Leaf
      $header = "# $parentDirName`n"

    if ($isNewFile) {
      Set-Content -Path $FileName -Value $header
    } else { 
      $content = Get-Content $FileName -TotalCount 1

    
      if ($content -ne $header.Trim()) {
        $newContent = @($header) + @($content)
        Set-Content -Path $FileName -Value $newContent
        } else {
          "... Header already exists in file: $FileName"
        }
      }
    }
}
