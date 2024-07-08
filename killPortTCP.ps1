param(
	[Parameter(Mandatory = $false)]
	[int]$port
)

if (-not $port) {
	$port = Read-Host -Prompt "port number you want to kill "
}

$processId = (Get-NetTCPConnection -LocalPort $port).OwningProcess

if ($processId) {
	$process = Get-Process -Id $processId -ErrorAction SilentlyContinue
	if ($process) {
		$process | Stop-Process -Force
		Write-Host "$port process has been killed."
	} else {
		Write-Host "$port process is not being used."
	}

} else {
	Write-Host "$port process is not being used."
}
