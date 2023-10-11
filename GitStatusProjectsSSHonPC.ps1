# link del chatgpt-4 https://chat.openai.com/share/a22bf088-dac6-4739-b817-9e8c2e4aa0c9

param (
  [string]$rutaConfigSsh = "$env:USERPROFILE\.ssh\config",
  [string]$rutaArchivoRutaDir = "env:USERPROFILE\rutaDirectorioRaiz.txt"
)

# Verificar si el archivo txt existe en la ruta raíz de usuario
if (Test-Path $rutaArchivoRutaDir){
  # Leer la ruta del directorio raíz del archivo
  $rutaDirectorioRaiz = Get-Content $rutaArchivoRutaDir
} else {
  # Solicitar al usuario raíz del archivo (TODO: Convertir esto a más user-friendly, quizás utiliza ViewGrind or similar in powershell, does it exist a tool for GUI for pwsh7)

}
