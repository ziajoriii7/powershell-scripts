param(
  [Parameter(Mandatory=$true)]
  [string[]]$FileNames
)

foreach ($FileName in $FileNames) {
  if (-not (Test-Path $FileName)) {
    "Creating file: $FileName"
    New-Item -ItemType file -Path $FileName
  }
    
  $content = Get-Content $FileName 
  $header = "# " + (Split-Path $FileName -Leaf)

  if ($content.Length -eq 0 -or $content[0] -ne $header) {
    "Adding header to file: $FileName"
    $content = $header, $content 
    Set-Content -Path $FileName -Value $content
    } else {
      "Header already exists in file: $FileName"
    }
}
