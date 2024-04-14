
param(
    [int]$StartIndex,
    [int]$EndIndex
)

Write-Host ""
$title = "-ˋˏ ༻❁༺ ˎˊ- PYGMENTIZE FILE PROCESSOR -ˋˏ ༻❁༺ ˎˊ-"
$separatorTitle = "=" * $title.Length

# Write-Host ""
# Write-Host $title -ForegroundColor Cyan
# Write-Host $separatorTitle -ForegroundColor Cyan
Write-Host "" 

$files = Get-ChildItem -File | Where-Object {!$_.Attributes.ToString().Contains("Hidden")} | Sort-Object LastWriteTime -Descending

if ($StartIndex -lt 1 -or $EndIndex -gt $files.Count -or $EndIndex -lt $StartIndex) {
    Write-Host "The specified index range is out of bounds." -ForegroundColor Red
    exit
}

for ($i = $StartIndex; $i -le $EndIndex; $i++) {
    $file = $files[$i - 1]

    $header = "`nFILE ${i}: $($file.Name)"
    $separator = "*" * $header.Length

    Write-Host $header -ForegroundColor DarkMagenta # Magenta
    Write-Host $separator -ForegroundColor DarkMagenta

    & pygmentize -O style=friendly -f terminal256 $file.FullName

    Write-Host ""
}
