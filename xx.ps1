
function xx {
  param(
      [int]$limit = 9, # Default limit
      [Alias('f')]
      [switch]$full
  )

  # Update the limit based on the presence of -full or -f flags.
  if ($full) {
      $limit = (Get-ChildItem).Count
  }

  Write-Host ""
  Write-Host "༊*·˚ LISTING FILES AND DIRECTORIES ༊*·˚" -ForegroundColor Magenta

  # Retrieve and display the items, applying the limit if necessary.
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

  # Ensure there are items to display before prompting for selection.
  if ($items.Count -gt 0) {
      $selection = Read-Host "Select the number of the file or directory"
      if ($selection -match "^\d+$" -and $selection -gt 0 -and $selection -le $items.Count) {
          $selectedItem = $items[$selection - 1]

          # Added: Check if the selected item is a Python file and set the default command to 'py'
          if ($selectedItem.Extension -eq '.py') {
              $defaultCommand = 'py'
          } else {
              $defaultCommand = ''
          }

          # Modified: Prompt now includes default action for Python files
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



# Check for -full or -f flags in the arguments and set the limit if a numeric value is present.
$fullFlag = $false
foreach ($arg in $args) {
  if ($arg -match "^-\d+$") { # If the argument is a number preceded by a dash
      $limit = $arg.TrimStart('-') # Set the number limit, remove the dash
  }
  elseif ($arg -eq '-full' -or $arg -eq '-f') {
      $fullFlag = $true # Set the full flag
  }
}

# Check if the -full flag is present in the arguments.
$fullFlag = $args -contains "-full" -or $args -contains "-f"

# Check if there is a numeric limit argument and set it.
$limit = 9
# Default limit
foreach ($arg in $args) {
  if ($arg -match "^-\d+$") {
    $limit = $arg.TrimStart('-') # Set the number limit, remove the dash
    break # Exit the loop once we've found the numeric argument
  }
}

# Call the exe function with the determined parameters.
xx -limit $limit -full:$fullFlag

$finalCommand =  "Final Command Applied: xx -limit $limit -full:$fullFlag"
# Write-Host $finalCommand -ForegroundColor Cyan
