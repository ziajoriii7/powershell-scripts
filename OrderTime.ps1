ls | Select-Object @{Name='LastWriteTime'; Expression={$_.LastWriteTime.ToString("hh:mm tt ddd dd/MM")}}, Length, Name | Format-Table -AutoSize

