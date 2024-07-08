param(
	[bool]$activate = $true
)

function Toggle-Profile {
	param(
		[bool]$activate
	)

	$profilePath = $PROFILE
	Write-Host "Profile Path: $profilePath"

	$keywords = @("oh-my-posh","Import-Module oh-my-posh-core")

	$profileContent = Get-Content $profilePath
	Write-Host "Original Content: $profileContent"

	$newContent = @()

	foreach ($line in $profileContent) {
		$modified = $false
		foreach ($keyword in $keywords) {
			if ($activate) {
				if ($line -match "^#$keyword") {
					$newContent += $line.Substring(1)
					$modified = $true
					break
				}
			} else {
				if ($line -match "^$keyword") {
					$newContent += "#" + $line
					$modified = $true
					break
				}
			}
		}

		if (-not $modified) {
			$newContent += $line
		}
	}

	Write-Host "New Content: $newContent"

	Set-Content -Path $profilePath -Value $newContent
	.$PROFILE


	if (-not $activate) {
		Remove-Module -Name 'oh-my-posh-core' -ErrorAction SilentlyContinue
		function prompt {
			"$PWD> "
		}
		Invoke-Expression -Command 'pwsh -nologo'
		write-in-terminal "pwsh"; Set-Location $env:USERPROFILE

	}
}


Toggle-Profile -activate $activate
