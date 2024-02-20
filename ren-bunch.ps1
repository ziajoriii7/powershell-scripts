param(
  [int]$NumberPrefix,
  [string]$NewChars
)

$alreadyNamedCount = 0

Get-ChildItem -Filter "$NumberPrefix.*" | ForEach-Object {
  $originalName = $_.Name

  if ($originalName -like "*$NewChars*") {
    $alreadyNamedCount++
  } else {
    $newName = $originalName -replace "^\d+\.s*",""
    $newName = "$NumberPrefix. $NewChars;$newName"
    Rename-Item $_.FullName -NewName $newName
  }
}

if ($alreadyNamedCount -gt 0) {
  Write-Host "$alreadyNamedCount files already named with $NewChars"
}
