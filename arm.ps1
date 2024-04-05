if ($args.Length -lt 2){
    Write-Host "cdex.ps1 [PartialDirectoryName] [CommandToExecute]"
}

$PartialDirectoryName = $args[0]
$CommandToExecute = $args[1..($args.Length - 1)] -join " "

$currentDirectory = Get-Location
$zoxidePath= zoxide query "$PartialDirectoryName" 


if ($zoxidePath){
    Set-Location -Path $zoxidePath
    Write-Host "Executing => " -NoNewLine
    Write-Host "'$CommandToExecute' " -NoNewLine -Foregroundcolor Green
    Write-Host "in " -NoNewLine
    Write-Host "'$zoxidePath'" -Foregroundcolor Magenta

    Invoke-Expression $CommandToExecute
    } else {
        Write-Host "$PartialDirectoryName does not exist on zoxide index."
        Set-Location -Path $currentDirectory
        exit
    }

Set-Location -Path $currentDirectory

