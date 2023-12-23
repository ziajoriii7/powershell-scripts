function Invoke-CustomCowsay {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    # Crear la parte superior de la burbuja del diálogo
    $topLine = " " + "-" * ($Message.Length + 2)
    # Crear la línea del mensaje
    $messageLine = "< $Message >"
    # Crear la parte inferior de la burbuja del diálogo
    $bottomLine = " " + "-" * ($Message.Length + 2)

    # Dibujar la vaca
    $cow = @"
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
"@

    # Mostrar el mensaje y la vaca
    Write-Host $topLine
    Write-Host $messageLine
    Write-Host $bottomLine
    Write-Host $cow
}

# Ejemplo de uso
# Invoke-CustomCowsay -Message "$Message"

