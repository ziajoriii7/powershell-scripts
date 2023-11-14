# Solicitar al usuario el número del puerto
$port = Read-Host -Prompt "Ingrese el número del PORT"
if ($port -notmatch "^\d+$") {
  Write-Host "Por favor, introduzca un número de puerto válido."
  exit 
}

# Encontrar el ID del proceso usando netstat
$infoProceso = netstat -ano | Select-String ":$port"
if ($infoProceso){
  $idDelProceso = $infoProceso -split "\s+" | Where-Object { $_ -match "^\d+$"} | Select-Object -Last 1 
  if ($idDelProceso){
      try {
      Stop-Process -Id $idDelProceso -Force
      Write-Host "Proceso con ID $idDelProceso en el puerto $port ha sido terminado."
      } catch {
        Write-Host "No se pudo terminar el proceso con ID $idDelProceso. Puede que requiera privilegios de administrador."
      }
  } else {
      Write-Host "No se encontró un ID de proceso para el puerto $port."
    }
} else {
Write-Host "No se encontró ningún proceso usando el puerto $port."
}
