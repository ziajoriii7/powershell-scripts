# Ask for the URL
$url = Read-Host -Prompt "Enter the download URL"

# Ask for the file name
$fileName = Read-Host -Prompt "Enter the file name (with extension)"

# Determine the destination path
$destinationPath = Join-Path -Path (Get-Location) -ChildPath $fileName

function Download-File {
    param(
        [string]$url,
        [string]$destinationPath
    )

    Invoke-WebRequest -Uri $url -OutFile $destinationPath
    Write-Host "File downloaded to: $destinationPath"
}

# Call the function with the provided parameters
Download-File -url $url -destinationPath $destinationPath

