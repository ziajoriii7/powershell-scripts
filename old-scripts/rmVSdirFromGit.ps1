$vsFiles = git ls-files | Select-String ".vs"

foreach ($file in $vsFiles) {
	$filePath = $file -replace '"',''
	git rm --cached "$filePath"
}

git commit -m "rm files and dirs from git in .vs directory"
