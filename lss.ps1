# Get-ChildItem | Select-Object @{Name="Type";Expression={if ($_.PSIsContainer) {"Directory"} else {"File"}}}, LastWriteTime, Length, Name

Get-ChildItem | Select-Object @{Name="Type";Expression={if ($_.PSIsContainer) {"Directory"} else {"File"}}}, @{Name="LastWriteTime";Expression={$_.LastWriteTime.ToString("MM/dd/yy hh:mm tt")}}, Length, Name
