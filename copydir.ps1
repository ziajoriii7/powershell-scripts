function copydir {
  param (
      [string[]]$relativePaths
  )

  $currentDirectory = (Get-Location).Path
  $finalPaths = @()

  foreach ($relativePath in $relativePaths) {
      if ($relativePath -match "^\$") {
            $varName = $relativePath.TrimStart("$")
          if (Get-Variable -Name $varName -ErrorAction SilentlyContinue) {
              $variableValue = (Get-Variable -Name $varName).Value
              if ($variableValue -is [System.Management.Automation.PathInfo]) {
                  $relativePath = $variableValue.Path
              } else {
                  $relativePath = $variableValue
              }
          }
      }

      if ([System.IO.Path]::IsPathRooted($relativePath)) {
          $pathToResolve = $relativePath
      } else {
          $pathToResolve = Join-Path -Path $currentDirectory -ChildPath $relativePath
      }

      try {
          $resolvedPath = Resolve-Path $pathToResolve
          $finalPaths += "`"$resolvedPath`"`n"
      } catch {
          Write-Host "$pathToResolve cannot be resolved."
      }
  }

  if ($finalPaths.Count -eq 0) {
      $quotedCurrentDir = "`"$currentDirectory`""
      Set-Clipboard -Value $quotedCurrentDir
      Write-Host "$quotedCurrentDir copied to clipboard."
  } elseif ($finalPaths.Count -eq 1){
    $singlePath = $finalPaths[0].TrimEnd("`n")
    Set-Clipboard -Value $singlePath
    Write-Host "$singlePath was copied to clipboard."

  } elseif ($finalPaths) {
      $quotedPaths = $finalPaths -join ""
      Set-Clipboard -Value $quotedPaths
      Write-Host "$quotedPaths" -NoNewLine
      Write-Host " were copied to clipboard."
  } else {
      Write-Host "No valid paths were found"
  }
}

copydir $args
