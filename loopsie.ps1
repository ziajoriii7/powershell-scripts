
param(
    [int]$StartIndex = 1,
    [int]$EndIndex = [int]::MaxValue,
    [string[]]$ExcludeDirs = @("node_modules", "bin", "obj"),
    [string[]]$ExcludeFiles = @(),
    [Alias("r")][switch]$Recursive
)

Write-Host ""
$title = "-ˋˏ ༻❁༺ ˎˊ- PYGMENTIZE FILE PROCESSOR -ˋˏ ༻❁༺ ˎˊ-"
$separatorTitle = "=" * $title.Length

Write-Host ""

$files = Get-ChildItem -File -Exclude $ExcludeDirs @if($Recursive) { -Recurse } | Where-Object {
    !$_.Attributes.ToString().Contains("Hidden") -and 
    $_.Extension -notmatch '\.pdf' -and 
    $ExcludeFiles -notcontains $_.Name
} | Sort-Object LastWriteTime -Descending

if ($EndIndex -eq [int]::MaxValue) {
    $EndIndex = $files.Count
}

if ($StartIndex -lt 1 -or $EndIndex -gt $files.Count -or $EndIndex -lt $StartIndex) {
    Write-Host "The specified index range is out of bounds." -ForegroundColor Red
    exit
}

for ($i = $StartIndex; $i -le $EndIndex; $i++) {
    $file = $files[$i - 1]

    $lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines
    if ($lineCount -gt 2000) {
        $response = Read-Host "Warning: File $($file.Name) has more than 2000 lines. Do you want to proceed? (Y/N)"
        if ($response -ne 'Y') {
            Write-Host "Skipping: $($file.Name)" -ForegroundColor Yellow
            continue
        }
    }

    $header = "`nFILE ${i}: $($file.Name)"
    $separator = "*" * $header.Length

    Write-Host $header -ForegroundColor DarkMagenta
    Write-Host $separator -ForegroundColor DarkMagenta

    & pygmentize -O style=friendly -f terminal256 $file.FullName

    Write-Host ""
}
