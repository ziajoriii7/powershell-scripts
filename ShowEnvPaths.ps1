Write-Host "###########"
Write-Host "# MACHINE #"
Write-Host "###########`n"

$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

$path.Split(';') | ForEach-Object {
    if ($_ -ne "") {
        Write-Host $_
    }
}


Write-Host "`n"
Write-Host "########"
Write-Host "# USER #"
Write-Host "########`n"

$path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User)

$path.Split(';') | ForEach-Object {
    if ($_ -ne "") {
        Write-Host $_
    }
}
