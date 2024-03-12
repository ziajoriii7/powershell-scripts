
function DownloadYouTubeVideo ($url) {
	$ytDlpTitleCommand = "yt-dlp --get-title --get-id -- $($url)"
	$titleAndId = Invoke-Expression $ytDlpTitleCommand
	$title = $titleAndId[0]
	$videoId = $titleAndId[1]

	$normalizedTitle = $title -replace '[\/*?""<>|:]','_'
	$normalizedTitleWithID = "$normalizedTitle [$videoId]"

	$ytDlpDownloadCommand = "yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' --output '${PWD}\$normalizedTitleWithID.%(ext)s' -- $($url)"
	Invoke-Expression $ytDlpDownloadCommand

	$downloadedFilePath = "${PWD}\$normalizedTitleWithID.mp4"

	Write-Host "$normalizedTitleWithID.mp4" -NoNewline -ForegroundColor Green
	Write-Host " started."

	Start-Process $downloadedFilePath
}

function DownloadFile ($url) {
	if ($url -like '*youtube.com/watch?*' -or $url -like '*youtube.com/*' -or $url -like '*youtu.be/*') {
		DownloadYouTubeVideo $url
	} else {
		try {
			$FileName = [System.IO.Path]::GetFileName($url)
			Invoke-WebRequest -Uri $url -OutFile $FileName

			if (Test-Path $FileName) {
				Start-Process $FileName
			} else {
				Write-Host "File not found: $FileName"
			}
		} catch {
			Write-Host "Error occurred while downloading the file."
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
