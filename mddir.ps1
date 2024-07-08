$directoryName = $args -join " "

mkdir $directoryName
cd "$directoryName"
tf.ps1 README.md
