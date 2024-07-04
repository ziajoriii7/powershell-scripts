param(
    [switch]$noBlankLines,
    [Alias("rank")][switch]$ranking,
    [Alias("r")][switch]$recursive,
    [switch]$sum
)

function Count-Lines {
    param(
        [string]$File,
        [bool]$CountBlankLines
    )

    try {
        if ($CountBlankLines) {
            $lineCount = (Get-Content $File -ErrorAction Stop).Count
        } else {
            $lineCount = (Get-Content $File -ErrorAction Stop | Where-Object { $_.Trim() -ne "" }).Count
        }

        return [pscustomobject]@{
            FileName = (Split-Path $File -Leaf)
            LineCount = $lineCount
        }
    }
    catch {
        Write-Host "'$(Split-Path $File -Leaf)' can't be accessed."
        return $null
    }
}

$fileTypes = @("*.ps1","*.py","*.cpp","*.hpp","*.c","*.h","*.cs","*.md","*.ipynb","*.js","*.json",".gitignore","*.norg","*.html","*.css","*.txt","*.tex")
$results = @()

# Process command line arguments as file paths
if ($args.Count -eq 0) {
    $searchPath = (Get-Location).Path
    if ($recursive) {
        $files = Get-ChildItem -Path $searchPath -File -Recurse
    } else {
        $files = Get-ChildItem -Path $searchPath -File
    }

    $matchedFiles = $files | Where-Object {
        $file = $_
        ($fileTypes | ForEach-Object { $file.Name -like $_ }) -contains $true
    }

    foreach ($file in $matchedFiles) {
        $result = Count-Lines -File $file.FullName -CountBlankLines (!$noBlankLines)
        if ($null -ne $result) {
            $results += $result
        }
    }
} else {
    foreach ($path in $args) {
        if (Test-Path $path) {
            $absolutePath = Resolve-Path $path
            $result = Count-Lines -File $absolutePath -CountBlankLines (!$noBlankLines)
            if ($null -ne $result) {
                $results += $result
            }
        } else {
            Write-Host "'$path' doesn't exist."
        }
    }
}

if ($ranking) {
    $results = $results | Sort-Object LineCount -Descending
}

$results | Format-Table -Property FileName, LineCount -AutoSize

if ($sum) {
    $totalLines = ($results | Measure-Object -Property LineCount -Sum).Sum 
    Write-Host "`nTotal lines across all files: $totalLines"
}
