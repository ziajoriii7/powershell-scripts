function touch {
  param(
    [Parameter(Mandatory = $true)]
    [string]$filename
  )

  if (-not (Test-Path $filename)){
    New-Item -ItemType file -Path $filename
  } else {
    (Get-Itemm $filename).LastWriteTime = Get-Date
  }
}

if ($args.Count -gt 0){
  touch -filename $args[0]
}
    
