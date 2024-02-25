param(
	[string[]]$githubLinks
)

foreach ($githubLink in $githubLinks) {
	$repoFullName = $githubLink -replace "https://github\.com/",""
	$repoName = $githubLink -replace "^.*/",""
	$fileName = $repoName -replace "\.","-"

	$luaContent = "return {`n`t `"$repoFullName`" `n}"
	$luaFileName = "$(PWD)\$fileName.lua"

	$luaContent | Out-File -FilePath $luaFileName
	$printFileName = Split-Path $luaFileName -Leaf

	dos2unix $luaFileName

	Write-Host "$printFileName was created."
}
