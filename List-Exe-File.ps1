
function xx {
  param(
      [int]$limit = 9, 
      [Alias('f')]
      [switch]$full
  )

  if ($full) {
      $limit = (Get-ChildItem).Count
  }

  Write-Host ""
  Write-Host "༊*·˚ LISTING FILES AND DIRECTORIES ༊*·˚" -ForegroundColor Magenta

  $items = Get-ChildItem | Sort-Object LastWriteTime -Descending | Select-Object -First $limit

  $index = 1

  foreach ($item in $items) {
      $formattedIndex = "{0,2}|" -f $index
      if ($item.PSIsContainer) {
          Write-Host "$formattedIndex " -NoNewline
          Write-Host "$($item.Name)" -ForegroundColor Red -NoNewline
      } else {
          Write-Host "$formattedIndex " -NoNewline
          Write-Host "$($item.Name)" -ForegroundColor Cyan -NoNewline
      }
      Write-Host ""
      $index++
  }

  if ($items.Count -gt 0) {
      $selection = Read-Host "Select the number of the file or directory"
      if ($selection -match "^\d+$" -and $selection -gt 0 -and $selection -le $items.Count) {
          $selectedItem = $items[$selection - 1]

          if ($selectedItem.Extension -eq '.py') {
              $defaultCommand = 'py'
          } else {
              $defaultCommand = ''
          }

          $command = Read-Host "Enter the command you want to execute on the file (leave empty for default action: $defaultCommand)"
          if ([string]::IsNullOrWhiteSpace($command)) {
              $command = $defaultCommand
          }

          # Execute the command if it's not empty or navigate if it's a directory
          if (![string]::IsNullOrWhiteSpace($command)) {
              $fullCommand = "$command `"$($selectedItem.FullName)`""
              Invoke-Expression $fullCommand
          } else {
              if ($selectedItem.PSIsContainer) {
                  Set-Location $selectedItem.FullName
              } else {
                  pp $selectedItem.FullName # This can be changed to another default action if needed
              }
          }
      } else {
          Write-Host "Invalid selection." -ForegroundColor Green
      }
  } else {
      Write-Host "No items to display." -ForegroundColor Yellow
  }

}


$fullFlag = $false
foreach ($arg in $args) {
  if ($arg -match "^-\d+$") { 
      $limit = $arg.TrimStart('-') 
  }
  elseif ($arg -eq '-full' -or $arg -eq '-f') {
      $fullFlag = $true 
  }
}

$fullFlag = $args -contains "-full" -or $args -contains "-f"

$limit = 9
foreach ($arg in $args) {
  if ($arg -match "^-\d+$") {
    $limit = $arg.TrimStart('-') 
    break
  }
}

xx -limit $limit -full:$fullFlag

$finalCommand =  "Final Command Applied: xx -limit $limit -full:$fullFlag"
