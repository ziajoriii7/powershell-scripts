
function DownloadYouTubeVideo ($url) {
	$ytDlpTitleCommand = "yt-dlp --get-title --get-id -- $($url)"
	$titleAndId = Invoke-Expression $ytDlpTitleCommand
	$title = $titleAndId[0]
	$videoId = $titleAndId[1]

	$normalizedTitle = $title -replace "[\/*?""<>|:]","_"
	$normalizedTitleWithID = "$normalizedTitle ($videoId)"

	$ytDlpDownloadCommand = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --output '$PWD\$normalizedTitleWithID.%(ext)s' -- $($url)"
	Invoke-Expression $ytDlpDownloadCommand

	$downloadedFilePath = "$PWD\$normalizedTitleWithID.mp4"

	Write-Host "$normalizedTitleWithID.mp4" -NoNewline -ForegroundColor Green
	Write-Host " started."

	Start-Process $downloadedFilePath
}

function DownloadFile ($url) {
	$url = $url -replace '&name=large$',''
	if ($url -like "*youtube.com/watch?*" -or $url -like "*youtube.com/*" -or $url -like "*youtu.be/*") {
		DownloadYouTubeVideo $url
	} else {
		try {
			$InvalidChars = [IO.Path]::GetInvalidFileNameChars() + [char[]]@(":","/","?","&")
			$FileName = [System.IO.Path]::GetFileName($url)
			$FileName = $FileName -replace "[$InvalidChars]",""


			if ($FileName.Length -gt 255) {
				$FileName = $FileName.Substring(0,255)
			}

			$response = Invoke-WebRequest -Uri $url -Method Head
			$contentType = $response.Headers. "Content-Type"
			switch ($contentType) {
				"image/jpeg" { $extension = ".jpg" }
				"image/png" { $extension = ".png" }
				"image/gif" { $entension = ".gif" }
				"image/webp" { $extension = ".png" }
				"video/mp4" { $extension = ".mp4" }
				"video/webm" { $extension = ".mp4" }
				default { $extension = "" }
			}


			if (-not [System.IO.Path]::HasExtension($FileName)) {
				$FileName += $extension
			}

			Invoke-WebRequest -Uri $url -OutFile $FileName

			Write-Host "Done download: $FileName"
			Start-Process $FileName

		} catch {
			Write-Host "An error ocurred: $_"
		}
	}
}

if ($args.Length -gt 0) {
	foreach ($url in $args) {
		DownloadFile $url
	}
} else {
	Write-Host "No URL(s) were entered. Exiting..."
}
