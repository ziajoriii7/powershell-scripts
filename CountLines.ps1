param (
  [Parameter(Position=0)]
  [string]$directoryPath
)

if (-not $directoryPath) {
    $directoryPath  = Read-Host "Please enter the directory path"
}

$textFileExtensions = @("*.ps1", "*.py", "*.cpp", "*.hpp", "*.c", "*.h", "*.cs", "*.md", "*.ipynb", "*.js", "*.json", ".gitignore", "*.norg", "*html", "*.css", "*.txt")

$fileLineCounts = @()

foreach ($extension in $textFileExtensions) {
  $textFiles = Get-ChildItem -Path $directoryPath -Filter $extension -File 

  foreach ($file in $textFiles) {
    $lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines 
    $fileLineCounts += New-Object PSObject -Property @{
      FileName = $file.Name 
      LineCount = $lineCount
      }
    }
}








## SEARCH FOR "Mime file type detection pwsh"
## 1. previous solution (failed yet: search for github issues of powershell)
## .. https://learn.microsoft.com/en-us/dotnet/api/system.web?view=netframework-4.8.1

# foreach ($file in $allFiles) {
#     $mimeType = [System.Web.MimeMapping]::GetMimeMapping($file.FullName)
# 
#     if ($mimeType.StartsWith("text/")) {
#         $lineCount = (Get-Content $file.FullName | Measure-Object -Line).Lines
#         $fileLineCounts += New-Object PSObject -Property @{
#             FileName = $file.Name 
#             LineCount = $lineCount
#           }
#       }
#   }
# 

$sortedFileLineCounts = $fileLineCounts | Sort-Object -Property LineCount -Descending

$sortedFileLineCounts
