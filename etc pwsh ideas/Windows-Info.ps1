systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix* | Format-List
Get-ComputerInfo -Property Windows*
