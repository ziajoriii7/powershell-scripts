# todo-scripts-possible-solutions

- DownExeLast.ps1
  - [ ]

```powershell
function FindAppropiateFile ($pattern, $timeoutSeconds) {
  $endTime = (Get-Date).AddSeconds($timeoutSeconds)
  while((Get-Date) -lt $endTime) {
    $potentialFiles = Get-ChildItem Path . -Filter $pattern
    if ($potentialFiles -gt 0) {
      return $potentialFiles[0]
    }
    Start-Sleep -Seconds 5
  }
  return $null 
}

$url = Read-Host -Prompt "Enter URL to download file"


  $potentialFiles = Get-ChildItem -Path . -Filter $pattern 
  $closestFile = $null 
  $smallestTimeDiff = [TimeSpan]::MaxValue

  foreach ($file in $potentialFiles) {
    ten/
    $timeDiff = [Math]::Abs(($file.CreationTime - $downloadStartTime).TotalSeconds)
    Write-Host "File: $($file.Name), Time difference: $timeDiff seconds"

    if ($timeDiff -lt $smallestTimeDiff) {
      $smallestTimeDiff = $timeDiff 
      $closestFile = $file
      }
  }

  return $closestFile
}
```
```powershell
function CreateFileSearchPattern($title) {
  $validCharsPattern = "[a-zA-Z0-9\s]"
  return -join ($title.toCharArray() | ForEach-Object {
    if ($_ -match $validCharsPattern) {$_ } else {"*"}
    })
  }
```

```powershell
function CreateFileSearchPattern($title) {
  $validCharsPattern = "[a-zA-Z0-9\s]"
  return -join ($title.toCharArray() | ForEach-Object {
    if ($_ -match $validCharsPattern) {$_ } else {"*"}
    })
  }
```
  - Create dynamic time 
  ```powershell
      Start-Sleep -Seconds 65
      $maxWaitTime = 600
      $checkInterval = 4 
  ```
  - Create check intervals
```powershell 
      while (-not (Test-Path $downloadedFilePath) -and $elapsedTime -lt $maxWaitTime) {
  ```

