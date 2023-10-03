$currentPath = Get-Location
$userConfig = @{
    "@aleeeec02" = @{
        Name = "aleeeec02"
        Email = "aleeeec02@example.com"
        Remote = "git@github.com-aleeeec02:"
    }
    "@hiyorijl" = @{
        Name = "hiyorijl"
        Email = "hiyorijl@example.com"
        Remote = "git@github.com-hiyorijl:"
    }
    "@ziajoriii7-ggg" = @{
        Name = "ziajoriii7-ggg"
        Email = "ziajoriii7-ggg@example.com"
        Remote = "git@github.com-ziajoriii7-ggg:"
    }
}

foreach ($key in $userConfig.Keys) {
    if ($currentPath -match $key) {
        git config user.name $userConfig[$key]["Name"]
        git config user.email $userConfig[$key]["Email"]
        git remote set-url origin $($userConfig[$key]["Remote"] + (Get-Item $currentPath).Name + ".git")
        break
    }
}
