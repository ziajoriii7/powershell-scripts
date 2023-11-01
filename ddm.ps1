param(
        [String]$filename
)

$pattern = 'get_ipython\(\)'

(Get-Content $filename) | Where-Object { $_ -notmatch $pattern } | Set-Content "$filename"

Write-Host "Se han eliminado los comandos mágicos de IPython del archivo '$filename'"

