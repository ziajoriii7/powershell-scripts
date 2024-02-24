param(
    [int]$StartIndex,
    [int]$EndIndex
)

Write-Host ""
$title = "-ˋˏ ༻❁༺ ˎˊ- PYGMENTIZE FILE PROCESSOR -ˋˏ ༻❁༺ ˎˊ-"
$separatorTitle = "=" * $title.Length
Write-Host ""

Write-Host $title -ForegroundColor Black
Write-Host $separatorTitle -ForegroundColor Black
Write-Host "" 


$files = Get-ChildItem -File | Where-Object {!$_.Attributes.ToString().Contains("Hidden")} | Sort-Object LastWriteTime -Descending

if ($StartIndex -lt 1 -or $EndIndex -gt $files.Count -or $EndIndex -lt $StartIndex) {
    Write-Host "The specified index range is out of bounds." -ForegroundColor Red
    exit
}

for ($i = $StartIndex; $i -le $EndIndex; $i++) {
    $file = $files[$i - 1]

    $header = "FILE ${i}: $($file.Name)"
    $separator = "." * $header.Length

    # Write the header in DarkRed
    Write-Host $header -ForegroundColor DarkRed
    Write-Host $separator -ForegroundColor DarkRed

    # Assuming 'pp' is an alias for pygmentize
    pp $file.FullName

    Write-Host ""
}

