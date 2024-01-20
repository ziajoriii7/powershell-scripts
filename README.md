# powershell-scripts

## tasks
- `DownloadAndExecute.ps1` and FIX-or-REVIEW: `Download-File.ps1`
  - should probably use regex for detecting if
    - `jpg` is detected
    - `png`
    - popular websites: aka youtube, tumblr, etc
  - add extension depending on file
    - if image then `.png`
    - if gif then `.gif`
    - if video then .mp4
    - if audio then .mp3
  - ‼️ Just found *a better solution*: **MIME types** in HTTP headers.
    - [Common MIME types - Developer Mozilla Docs](https://www.freeformatter.com/mime-types-list.html)
      - `image/jpeg`
      - `image/png`
      - `image/gif`
      - `video/mp4`
- GetLongName.ps1 
  - write arguments limiting the list.
  - write common cases (aka common examples) on the README.mnd

#### Write common cases examples and usage of the most used scripts 
- <first example scripts with its block codes>.
![](./im)


 
## else
true:
toggle-oh-my-posh.ps1 -activate $true

false: toggle-oh-my-posh.ps1 -activate $false


folder on PATH:
$newPath = "D:\@ziajoriii7-ggg\powershell-scripts"; $envPath = [System.Environment]::GetEnvironmentVariable('Path', 'User'); if (-not $envPath.Contains($newPath)) { [System.Environment]::SetEnvironmentVariable('Path', "$envPath;$newPath", 'User') }


pwsh -c "" -NoExit

pwsh -noexit -c "command-here"
