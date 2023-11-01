function sn {
    $items = Get-ChildItem | Sort-Object LastWriteTime -Descending
    $index = 1
    foreach ($item in $items) {
        "${index}: $($item.Name)"
        $index++
    }

    $selection = Read-Host "Select the number of the file or directory"
    $selectedItem = $items[$selection - 1]

    if ($selectedItem -eq $null) {
        Write-Host "Invalid selection."
        return
    } 

    elseif (Test-Path $selectedItem.FullName -PathType Container) {
        Set-Location $selectedItem.FullName
    } else {
        # Replace 'nvim' with the command you want to use to open files
        nvim $selectedItem.FullName
        # If you have a 'pp' command, you can use it instead or as an option
        # pp $selectedItem.FullName
    }
}

sn
