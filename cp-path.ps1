param (
	[string]$FileName = $args[0],
	[switch]$NoClipboard
)

$FullPath = (Get-Item $Filename).FullName

if ($NoClipboard){
	Write-Host "FullPath of $Filename is: \n$FullPath"
} else {
	$FullPath | Set-Clipboard
	Write-Host "FullPath of $FileName copied to clipboard: $FullPath"
}
