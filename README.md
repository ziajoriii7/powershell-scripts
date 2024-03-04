# powershell-scripts


<div style="text-align:center">
  <a href="https://wakatime.com/badge/user/49dba2c5-26e1-43a7-9d07-e0f8613d1227/project/018b140f-49ff-4c9f-a2de-b9a54ccadd77"><img src="https://wakatime.com/badge/user/49dba2c5-26e1-43a7-9d07-e0f8613d1227/project/018b140f-49ff-4c9f-a2de-b9a54ccadd77.svg" alt="wakatime">
  </a>
</div>


```
$newPath = "<fullpath-of-powershell-scripts>"; $envPath = [System.Environment]::GetEnvironmentVariable('Path', 'User'); if (-not $envPath.Contains($newPath)) { [System.Environment]::SetEnvironmentVariable('Path', "$envPath;$newPath", 'User') }
``` 



