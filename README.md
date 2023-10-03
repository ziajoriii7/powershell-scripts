# powershell-scripts

true:
toggle-oh-my-posh.ps1 -activate $true

false: toggle-oh-my-posh.ps1 -activate $false


folder on PATH:
$newPath = "D:\@ziajoriii7-ggg\powershell-scripts"; $envPath = [System.Environment]::GetEnvironmentVariable('Path', 'User'); if (-not $envPath.Contains($newPath)) { [System.Environment]::SetEnvironmentVariable('Path', "$envPath;$newPath", 'User') }
