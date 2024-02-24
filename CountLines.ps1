
param (
    [string[]]$FilePaths
)

function Count-Lines {
    param (
        [string]$File
    )

    try {
        $lineCount = (Get-Content $File -ErrorAction Stop | Measure-Object -Line).Lines
        return [PSCustomObject]@{
            FileName = (Split-Path $File -Leaf)
            LineCount = $lineCount
        }
    }
    catch {
        Write-Host "'$(Split-Path $File -Leaf)' can't be accessed."
    }
}

$fileTypes = @("*.ps1", "*.py", "*.cpp", "*.hpp", "*.c", "*.h", "*.cs", "*.md", "*.ipynb", "*.js", "*.json", ".gitignore", "*.norg", "*.html", "*.css", "*.txt")
$results = @()

if ($FilePaths.Length -eq 0) {
    $files = Get-ChildItem -Include $fileTypes -Recurse | Sort-Object LastWriteTime -Descending
    foreach ($file in $files) {
        $result = Count-Lines -File $file.FullName
        if ($result -ne $null) {
            $results += $result
        }
    }
} else {
    foreach ($path in $FilePaths) {
        if (Test-Path $path) {
            $absolutePath = Resolve-Path $path
            $result = Count-Lines -File $absolutePath
            if ($result -ne $null) {
                $results += $result
            }
        } else {
            Write-Host "'$path' doesn't exist."
        }
    }
}

$results | Format-Table -Property FileName, LineCount -AutoSize