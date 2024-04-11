
param (
    [String]$folderName
)

$folderName = $folderName.TrimEnd('\')
$folderBaseName = Split-Path $folderName -Leaf
$zipFileName = "$folderBaseName.zip"

Push-Location (Get-Item $folderName).Parent.FullName

tar -a -c -f $zipFileName $folderBaseName

Pop-Location

$fullPath = Join-Path (Get-Location) $zipFileName

Write-Host " $zipFileName" -NoNewLine -ForegroundColor Green
Write-Host " was created in $(Get-Location)."

return $fullPath

