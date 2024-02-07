param (
  [Alias("d")][switch]$dirs,
  [Alias("f")][switch]$files,
  [Alias("s")][int]$start = 1,
  [Alias("e")][int][Parameter(Position=0)]$end
)

function Get-TotalItemCount {
  $totalDirs = (Get-ChildItem -Directory).Count
  $totalFiles = (Get-ChildItem -File).Count
  $total = (Get-ChildItem).Count 
  $currentDirName = Split-Path -Path (Get-Location) -Leaf

  # Write-Host "`n"
    Write-Host "`n$currentDirName's" -NoNewline # -ForegroundColor DarkMagenta
    # Write-Host " has" -NoNewline
    Write-Host " $total " -NoNewline # -ForegroundColor DarkMagenta
    Write-Host "items `n ↳ $totalFiles files / $totalDirs dirs`n"
}


function loltre {
  $count = 0

  if (-not $dirs -and -not $files) {
    $dirs = $true
    $files = $true

Get-TotalItemCount
    Write-Host "Processing: " -NoNewline
    Write-Host "Directories:" -ForegroundColor Magenta -NoNewline
    Write-Host ", Files" -ForegroundColor Cyan
  }
  elseif ($dirs) {
    $files = $false
Get-TotalItemCount
    Write-Host "Processing: " -NoNewline
    Write-Host "Directories" -ForegroundColor Magenta
  }
  elseif ($files) {
Get-TotalItemCount
    $dirs = $false
    Write-Host "Processing: " -NoNewline
    Write-Host "Files" -ForegroundColor Cyan
  }

  Get-ChildItem | Sort-Object LastWriteTime -Descending | ForEach-Object {
    $count++
    
    if ($end -and $count -gt $end) { return }

    if ($count -ge $start){
      $formattedCount = "{0,2}|" -f $count


    if ($_ -is [System.IO.DirectoryInfo] -and $dirs) {
      Write-Host "$formattedCount $($_.Name)" -ForegroundColor Magenta
    }
    elseif ($_ -isnot [System.IO.DirectoryInfo] -and $files) {
      Write-Host "$formattedCount $($_.Name)" -ForegroundColor Cyan
      }

    $formattedCount = "{0,2}|" -f $count

    }
  }
}

loltre
