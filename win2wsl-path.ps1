param (
    [string]$path = $(Get-Location).Path
)

function convertTo-WslPath {
    param(
        [string]$winPath
    )

        $wslPath = $winpath -replace "\\", "/"

        $wslPath = $wslPath -replace "^([A-Za-z]):", {
        "/mnt/" + $_.Groups[1].Value.ToLower()
    }

        return $wslPath
  }

  $wslPath = convertTo-WslPath -winPath $path 
  Set-Clipboard -Value "`"$wslPath`""
  
  Write-Host "`"$wslPath`" copied to clipboard."
