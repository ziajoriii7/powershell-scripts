function Start-Pomodoro {
  param (
    [string]$type,
    [int]$duration
  )

  # Check if a custom duration has been specified, if not, use the default from the $pomoOptions
  if (-not $duration) {
    if ($pomoOptions.ContainsKey($type)) {
      $duration = $pomoOptions[$type]
    } else {
      Write-Host "Invalid session type. Please use 'work' or 'break'." -ForegroundColor Red
      return
    }
  }

  Write-Host "$type session started. Duration: $duration minutes." -ForegroundColor Cyan
  Start-Sleep -Seconds ($duration * 60)

  # Use PowerShell to speak out loud.
  Add-Type -AssemblyName System.speech
  $speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
  $speak.Speak("$type session done")
}

# The aliases remain the same
Set-Alias -Name wo -Value Start-Pomodoro
Set-Alias -Name br -Value Start-Pomodoro

# Example usage with custom duration:
# wo "work" 3
# wo "work" - for the default duration
# br "break" - always uses the default duration

