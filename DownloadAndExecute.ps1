$url = Read-Host -Prompt "Enter URL to download file"

if (![string]::IsNullOrWhiteSpace($url)) {
    try {
        $InvalidChars = [IO.Path]::GetInvalidFileNameChars() -join ""
        $FileName = [System.IO.Path]::GetFileName($url)
        $FileName = $FileName -replace "[$InvalidChars]", ""

        $response = Invoke-WebRequest -Uri $url -Method Head
        $contentType = $response.Headers."Content-Type"

        switch ($contentType) {
            "image/jpeg" { $extension = ".jpg" }
            "image/png" { $extension = ".png"}
            "image/gif" { $entension = ".gif"}
            "image/webp" { $extension = ".png"}

            "video/mp4" { $extension = .mp4}
            "video/webm" { $extension = .mp4}

            default { $extension = ""}
          }

          if (-not [System.IO.Path]::HasExtension($FileName)) {
              $FileName += $extension
            }


        Invoke-WebRequest -Uri $url -OutFile $FileName 
        Start-Process $FileName 
      } catch {
          Write-Host "An error ocurred: $_"
    }
} else {
  Write-Host "No URL was provided. Exiting..."
}
