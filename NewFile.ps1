# Pregunta al usuario el nombre del archivo (incluyendo la extensión)
$fileName = Read-Host -Prompt 'Ingresa el fileName'

# Verifica si el archivo ya existe
if (Test-Path .\$fileName) {
  # Si el archivo existe muestra un mensaje
  Write-Host "El archivo $fileName ya existe." -ForegroundColor Red 

  #Utilizar operador llamada (&) para mostrar información del archivo
  & OrderTime .\$fileName

  # Usa Pygments para resaltar sintácticamente with pp alias on $PROFILE
 pp .\$fileName | Write-Host 
  } else {
    # Si el archivo no existe, crea un nuevo archivo
    New-Item -Path .\$fileName -ItemType File  
  }

