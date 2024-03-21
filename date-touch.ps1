
param (
    [string]$dateCmd = 't'
)

function Get-NextWeekday {
    param (
        [DateTime]$From,
        [string]$Weekday,
        [int]$WeeksInAdvance = 0
    )
    
    $dayOfWeekMapping = @{
        'l' = 'Monday'; 'm' = 'Tuesday'; 'x' = 'Wednesday';
        'j' = 'Thursday'; 'v' = 'Friday'; 's' = 'Saturday'; 'd' = 'Sunday';
    }

    $dayOfWeek = $dayOfWeekMapping[$Weekday]
    $daysToAdd = ([System.DayOfWeek]::$dayOfWeek.value__ - $From.DayOfWeek + 7) % 7
    if ($daysToAdd -eq 0) { $daysToAdd = 7 }
    $daysToAdd += 7 * $WeeksInAdvance
    return $From.AddDays($daysToAdd)
}

function Create-MarkdownFile {
    param (
        [string]$FileName
    )

    $FilePath = "$PWD\$FileName.md"
    if (-not (Test-Path $FilePath)) {
        $streamWriter = New-Object System.IO.StreamWriter($FilePath, $false, [System.Text.Encoding]::UTF8)
        $streamWriter.NewLine = "`n"
        $headerContent = "# $FileName`n`n"
        $streamWriter.Write($headerContent)
        $streamWriter.Close()
        Write-Host "$FileName.md was created."
    } else {
        Write-Host "$FileName.md already exists."
    }
}

$today = Get-Date
$currentDate = $today.ToString("dd-MM-yy")
$fileName = ""

switch -Regex ($dateCmd) {
    '^t$|^today$' {
        $fileName = $currentDate
    }
    '^tm$|^tomorrow$' {
        $fileName = $today.AddDays(1).ToString("dd-MM-yy")
    }
    '^n(l|m|x|j|v|s|d)' {
        $matches = $dateCmd -split 'n'
        $nextDay = Get-NextWeekday -From $today -Weekday $matches[1] -WeeksInAdvance 1
        $fileName = $nextDay.ToString("dd-MM-yy")
    }
    '^(l|m|x|j|v|s|d)$' {
        $nextDay = Get-NextWeekday -From $today -Weekday $dateCmd
        $fileName = $nextDay.ToString("dd-MM-yy")
    }
    Default {
        Write-Host "Command not valid."
    }
}

if ($fileName -ne "") {
    Create-MarkdownFile -FileName $fileName
} else {
    Write-Host "$fileName Command not valid."
}
