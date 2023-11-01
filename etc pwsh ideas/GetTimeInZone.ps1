function Get-TimeInZone {
    [CmdletBinding()]
    param()

    dynamicparam {
        $timezoneIds = [System.TimeZoneInfo]::GetSystemTimeZones() | ForEach-Object { $_.Id }
        $attribute = New-Object System.Management.Automation.ParameterAttribute
        $attribute.Mandatory = $true

        $attributes = New-Object 'Collections.ObjectModel.Collection[System.Attribute]'
        $attributes.Add($attribute)

        $parameter = New-Object System.Management.Automation.RuntimeDefinedParameter('TimezoneId', [string], $attributes)
        $parameters = New-Object 'System.Management.Automation.RuntimeDefinedParameterDictionary'
        $parameters.Add('TimezoneId', $parameter)

        return $parameters
    }

    process {
        $inputTimeZoneId = $PSBoundParameters['TimezoneId']
        $normalizedInput = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($inputTimeZoneId))

        $timezoneIds = [System.TimeZoneInfo]::GetSystemTimeZones() | ForEach-Object { $_.Id }

        # Map of country to time zone
        $countryToTimeZone = @{
            'peru' = 'SA Pacific Standard Time';
            'korea' = 'Korea Standard Time';
            # Add more mappings here
        }

        $matchedZone = $null

        if ($countryToTimeZone.ContainsKey($normalizedInput.ToLower())) {
            $matchedZone = $countryToTimeZone[$normalizedInput.ToLower()]
        } else {
            $matchedZone = $timezoneIds | Where-Object { $_ -like "*$normalizedInput*" } | Select-Object -First 1
        }

        if ($matchedZone) {
            $utcNow = Get-Date -AsUTC
            $timeZoneInfo = [System.TimeZoneInfo]::FindSystemTimeZoneById($matchedZone)
            $convertedTime = [System.TimeZoneInfo]::ConvertTimeFromUtc($utcNow, $timeZoneInfo)
            Write-Host "Hora actual en ${matchedZone} (Current time in ${matchedZone}): $convertedTime"
        } else {
            Write-Host "No se encontró una zona horaria que coincida con la entrada: $inputTimeZoneId (No matching time zone found for input: $inputTimeZoneId)"
        }
    }
}

