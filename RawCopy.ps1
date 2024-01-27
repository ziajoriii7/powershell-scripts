param(
	[string]$GithubFileURL
)

function Convert-GithubURLtoRAW {
	param (
		[string]$url
	)

	$parsedURL = $url -replace "github\.com", "raw.githubusercontent.com" -replace "/blob/" , "/"
	return $parsedURL
}


## SET CLIPBOARDS
$rawURL = Convert-GithubURLtoRAW -URL $GithubFileURL
$quotedRawURL = "`"$rawURL`""

Set-Clipboard -Value $quotedRawURL

$curlURL = "curl -LJO $quotedRawURL"
# $aria2URL = "aria2c -o $(basename $quotedRawURL) $quotedRawURL"
# $wgetURL = "wget --content-disposition $quotedRawURL"

$output1Raw= "$rawURL copied to clipboard."

Set-Clipboard -Value $curlURL

##OUTPUTs TO USERS


$FileName = [System.IO.Path]::GetFileName([uri]$rawURL)
$title = "RESULTS: "
# $separatorTitle = "=" * ($title.Length - 1)

Write-Host "`n"
# Write-Host $title -NoNewline
Write-Host "$FileName" -ForegroundColor DarkMagenta -BackgroundColor White -NoNewline
# Write-Host "`n$separatorTitle"

Write-Host " HAS BEEN PASTED TO YOUR CLIPBOARD.ˏˋ°•*⁀➷`n"
Write-Host "$quotedRawURL"
# Write-Host "   2. " -NoNewline

$output1Raw= "$rawURL copied to clipboard."
# $output2Curl = "$curlURL copied to clipboard."
Write-Host "$curlURL" -NoNewline -ForegroundColor Black -BackgroundColor White
Write-Host " copied to clipboard." -NoNewline
Write-Host "`n"

# Write-Host "$output2Curl" -ForegroundColor Black -BackgroundColor White

# Write-Host " * Remember you can use your clipboard with the keys " -NoNewline

# Write-Host "Win + V" -NoNewline -ForegroundColor DarkGreen -BackgroundColor White


# Write-Host " to see your pasting historial."
