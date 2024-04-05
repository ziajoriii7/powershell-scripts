$directoryName = $args -join " "

mkdir $directoryName
cd "$directoryName"
touch-first.ps1 README.md
