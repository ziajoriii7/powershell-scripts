# Request the port number to kill
$port = Read-Host -Prompt "Enter the port number you want to kill"

# Find the process using the specified port
$processId = (Get-NetTCPConnection -LocalPort $port).OwningProcess

# Check if any process was found
if ($processId) {
    # Get the process object
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue

    # Check if the process object was retrieved
    if ($process) {
        # Kill the process
        $process | Stop-Process -Force
        Write-Host "Process using port $port has been killed."
    }
    else {
        Write-Host "No process found using port $port."
    }
}
else {
    Write-Host "No process is using port $port."
}

