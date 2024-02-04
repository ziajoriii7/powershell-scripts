
$FileArgs = @($args)
$fileCount = 0

foreach ($FilePath in $FileArgs) {
  if (Test-Path $FilePath) {
    $fileCount++
    rich $FilePath --hyperlinks --theme perldoc -n --guides --markdown --panel ascii

  } else {
    Write-Error "File not found: $FilePath`n "
  }
}

Write-Host "`nTotal files processed: $fileCount"
