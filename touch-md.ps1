function touch {
  param(
    [Parameter(Mandatory = $true)]
    [string]$filename
  )

  if (-not (Test-Path $filename)){
    New-Item -ItemType file -Path $filename
    Add-Content -Path $filename -Value "# $filename`n"
  } else {
    (Get-Itemm $filename).LastWriteTime = Get-Date
  }
}

foreach ($arg in $args) {
  touch -filename $arg
}
