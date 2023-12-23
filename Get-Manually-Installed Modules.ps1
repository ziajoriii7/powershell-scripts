$UserModules = Get-Module -ListAvailable | Where-Object { $_.ModuleBase -like "$env:USERPROFILE\*" }
$UserModules | Select-Object Name, ModuleBase

