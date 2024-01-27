systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix* | Format-List
Get-ComputerInfo | Select-Object -Property Windows* -ExcludeProperty WindowsProductName, WindowsCurrentVersion

