param (
	[Parameter(Mandatory=$true)]
	[string]$FileName
)

if (Test-Path $FileName){
	Get-Content $FileName | Set-Clipboard
	Write-Host "$FileName copied to clipboard."
} else {
	Write-Error "File not found $FileName"
}
