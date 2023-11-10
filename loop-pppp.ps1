param(
    [int]$StartIndex,
    [int]$EndIndex
)

# Title of the program
Write-Host ""
$title = "-ˋˏ ༻❁༺ ˎˊ- PYGMENTIZE FILE PROCESSOR -ˋˏ ༻❁༺ ˎˊ-"
$separatorTitle = "=" * $title.Length
Write-Host ""

# Write the title in Black
Write-Host $title -ForegroundColor Black
Write-Host $separatorTitle -ForegroundColor Black
Write-Host "" # Empty line for spacing

# Get the list of files in the current directory, excluding directories and hidden files.

$files = Get-ChildItem -File | Where-Object {!$_.Attributes.ToString().Contains("Hidden")} | Sort-Object LastWriteTime -Descending

# Check if the indices are within the range of available files.
if ($StartIndex -lt 1 -or $EndIndex -gt $files.Count -or $EndIndex -lt $StartIndex) {
    Write-Host "The specified index range is out of bounds." -ForegroundColor Red
    exit
}

# Loop through the files and apply the 'pp' command based on the provided index range.
# Changed from foreach to for loop to directly access files by index.
for ($i = $StartIndex; $i -le $EndIndex; $i++) {
    $file = $files[$i - 1]

    $header = "FILE ${i}: $($file.Name)"
    $separator = "." * $header.Length

    # Write the header in DarkRed
    Write-Host $header -ForegroundColor DarkRed
    Write-Host $separator -ForegroundColor DarkRed

    # Assuming 'pp' is an alias for pygmentize
    pp $file.FullName

    Write-Host "" # Add an extra newline for better readability between files
}

