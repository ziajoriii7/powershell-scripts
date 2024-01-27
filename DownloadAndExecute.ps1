$url = Read-Host -Prompt "Enter URL to download file"

function CleanYoutubeURL($url){
    if ($url -match "youtu\.be\/([a-zA-z0-9_-]+)"){
        return "https://youtu.be/" + $matches[1]
      } elseif ($url -match "youtube\.com\/watch\?v=([a-zA-Z0-9_-]+)"){
          return https://www.youtube.com/watch?v=" + matches[1]
        }
  }

if (![string]::IsNullOrWhiteSpace($url)) {
    try {

      # yt-dlp or not 
      if ($url -like "*youtube.com/watch?*"){
          $ytDlpCommand = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --output '%(title)s [%(id)s].%(ext)s' -- $($url)"
          Invoke-Expression $ytDlpCommand
        
        } else 

        {

        $InvalidChars = [IO.Path]::GetInvalidFileNameChars() + [char[]]@(":", "/", "?", "&")
        $FileName = [System.IO.Path]::GetFileName($url)
        $FileName = $FileName -replace "[$InvalidChars]", ""

        if ($FileName.Lenght -gt 255){
          $FileName = $FileName.Substring(0, 255)

          }

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
          $FileName += $HasExtension
          }
        }
        Invoke-WebRequest -Uri $url -OutFile $FileName 
        Start-Process $FileName 
      } catch {
          Write-Host "An error ocurred: $_"
    }
    
} else {
  Write-Host "No URL was provided. Exiting..."
}
