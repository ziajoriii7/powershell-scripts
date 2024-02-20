param(
	[int]$NumberPrefix,
	[string]$NewChars
)

Get-ChildItem -Filter "$NumberPrefix.*" | ForEach-Object {
	$newName = "$NumberPrefix. $NewChars; $($_.Name)"
	Rename-Item $_.FullName -NewName $newName
}
