param (
  [string]$url
)

function FindLastCreatedFile {
  $files = Get-ChildItem -File | Sort-Object CreationTime -Descending 
  if ($files -and $files.Count -gt 0) {
  return $files[0]
} else {
  return $null
}
}

if ([string]::IsNullorWhiteSpace($url)) {
  $url = Read-Host -Prompt "Enter URL to download file"
}

if (-not $url.StartsWith('"')) {
  $url = '"' + $url + '"'
}

try {
  if ($url -like "*youtube.com/watch?*" -or $url -like "*youtube.com/*" -or $url -like "*youtu.be/*") {

    $ytDlpTitleCommand = "yt-dlp --get-filename -o ""%(title)s [%(id)s].%(ext)s"" " + $url
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($ytDlpTitleCommand)
    $ytDlpTitleCommand = [System.Text.Encoding]::UTF8.GetString($bytes)

    $title = Invoke-Expression $ytDlpTitleCommand
    Write-Host "Video Title: $title"

    $ytDlpDownloadCommand = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -- $($url)"
    Invoke-Expression $ytDlpDownloadCommand
    Write-Host "Executing: $ytDlpDownloadCommand"
  } else {
    $FileName = [System.IO.Path]::GetFileName($url)
    if (-not [System.IO.Path]::HasExtension($FileName)) {
      $FileName += ".png"
    }


    # $FileName = $FileName -replace [String]::Join('', $InvalidChars), ""

    if ($FileName.Length -gt 255){
      $FileName = $FileName.Substring(0, 255)
    }
  }
    $response = Invoke-WebRequest -Uri $url -Method Head
    $contentType = $response.Headers["Content-Type"]

    switch ($contentType) {
    "image/jpeg" { $extension = ".jpg" }
    "image/png" { $extension = ".png"}
    "image/gif" { $extension = ".gif"}
    "image/webp" { $extension = ".png"}

    "video/mp4" { $extension = ".mp4"}
    "video/webm" { $extension = ".mp4"}

    default { $extension = ""}
    }

    if (-not [System.IO.Path]::HasExtension($FileName)) {
      $FileName += $extension
    }

    Invoke-WebRequest -Uri $url -OutFile $FileName
    Write-Host $FileName

    if (Test-Path $FileName) {
      Start-Process $FileName
    } else {
      Write-Host "File not found: $FileName"
    }
} catch {
  Write-Host " An error ocurred "
}
finally {
  $lastCreatedFile = FindLastCreatedFile
  if ($lastCreatedFile) {
    Start-process $lastCreatedFile
  } else {
    Write-Host "There's no files in this directory."
  }
}
