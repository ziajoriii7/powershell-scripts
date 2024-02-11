param (
  [Alias("d")][switch]$dirs,
  [Alias("f")][switch]$files,
  [Alias("s")][int]$start = 1,
  # [Parameter(Position = 0)][string]$wildOrEnd,
  [Alias("e")][int][Parameter(Position=0)]$end,
  [Alias("p")][string]$path = (Get-Location),
  [Alias("w")][string]$wild = "*"
  # [Parameter(ValueFromRemainingArguments=$true)][object[]]$argsArray
)

function Center-Text {
  param (
    [string]$text
  )

  $windowWidth = $Host.UI.RawUI.WindowSize.Width 
  $textLength = $text.Length 
  $leftPadding = ($windowWidth - $textLength) / 2 - 6
  $paddedText = " " * [Math]::Floor($leftPadding) + $text
  Write-Host "$paddedText" -NoNewline # ForegroundColor DarkMagenta

}

function Get-TotalItemCount {
  # Center-Text "───────── ⋆⋅λ⋅⋆ ────────"
  $totalDirs = (Get-ChildItem -Directory -Path $path -Force ).Count
  $totalFiles = (Get-ChildItem -File -Path $path).Count
  $total = (Get-ChildItem -Path $path).Count
  $currentDirName = Split-Path -Path $path -Leaf
  # Write-Host "`n"
  # Center-Text "$currentDirName's: "
  Write-Host " "
  Write-Host "$currentDirName" -NoNewline -ForegroundColor DarkMagenta
  Write-Host "'s: "
  $separatorDir = "─" * ($currentDirName.Length + 3)
  Write-Host $separatorDir
  Write-Host " • " -NoNewline
  Write-Host "[ $total ]" -ForegroundColor DarkMagenta -NoNewline
  Write-Host " items / [ $end ] lim"
  # Write-Host "`n"
  # Write-Host " ↳ items: " -NoNewline
  # Write-Host " has" -NoNewline
  # Write-Host " [ $total ] " -NoNewline -ForegroundColor DarkMagenta
  Write-Host " • " -NoNewline
  Write-Host "[ $totalFiles ]" -ForegroundColor Cyan -NoNewline
  Write-Host " files / " -NoNewline -ForegroundColor Gray
  Write-Host "[ $totalDirs ]" -NoNewline -ForegroundColor Magenta 
  Write-Host " dirs `n" -ForegroundColor Gray
}


function loltre {
  $count = 0
  # $end = $null
  # $wild = "*"

 # if ($wildOrEnd -match "^\d+$") {
 #   $end = [int]$wildOrEnd
 # }
 # else {
 #   $wild = $wildOrEnd
 # }


  # foreach ($arg in $argsArray) {
  #   if ($arg -match "^\d+$") {
  #   $end = [int]$arg
  #  } elseif ($arg -like "*.*") {
  #    $wild = $arg
  #  } }



 # foreach ($arg in $argsArray) {
 #   if ($arg -match "^\d+$") {
 #     $end = [int]$arg
 #   } elseif ($arg -like "*.*") {
 #     $wild = $arg
 #   } elseif ($arg -eq "-f") {
 #     $files = $true
 #     $dirs = $false
 #   } elseif ($arg -eq "-d") {
 #     $dirs = $true
 #     $files = $false
 #   }
 # }
  if (-not $dirs -and -not $files) {
    $dirs = $true
    $files = $true

    Get-TotalItemCount -Path $path
    # Write-Host "Processing: " -NoNewline
    # Write-Host "Directories," -ForegroundColor Magenta -NoNewline
    # Write-Host " Files" -ForegroundColor Cyan
  }
  elseif ($dirs) {
    $files = $false
    Get-TotalItemCount -Path $path
    Write-Host "Processing: " -NoNewline
    Write-Host "Directories" -ForegroundColor Magenta
  }
  elseif ($files) {
    Get-TotalItemCount -Path $path
    $dirs = $false
    Write-Host "Processing: " -NoNewline
    Write-Host "Files" -ForegroundColor Cyan
  }

  Get-ChildItem -Path $path -Filter $wild -Force | Sort-Object LastWriteTime -Descending | ForEach-Object {
    $count++
    
    if ($end -and $count -gt $end) { return }

    if ($count -ge $start) {
      $formattedCount = "{0,2}|" -f $count


      if ($_ -is [System.IO.DirectoryInfo] -and $dirs) {
        Write-Host "$formattedCount" -NoNewline
        if ($_.Name -eq ".git") {
          Write-Host " $($_.Name) [GIT Repo]" -ForegroundColor Yellow
          } else {
            Write-Host " $($_.Name)" -ForegroundColor Magenta
          }
      }
      elseif ($_ -isnot [System.IO.DirectoryInfo] -and $files) {
        Write-Host "$formattedCount" -NoNewline
        Write-Host " $($_.Name)" -ForegroundColor Cyan
      }

      $formattedCount = "{0,2}|" -f $count

    }

  }
  # Center-Text "───────── ⋆⋅λ⋅⋆ ────────"
}

loltre
