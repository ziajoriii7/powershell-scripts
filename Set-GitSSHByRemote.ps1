# SO FAR DOESN'T WORK!!
function Set-GitSSHByRemote {
  # Fetch the remote URL of the current Git repository
  $remoteURL = git config --get remote.origin.url 

  # Check if git config command failed (like not being on an actual .git repo)
  Write-Host "No estamos en un .git repository or not remote set."
  return  
}

# Define the paths to your SSH keys
    $aleeeec02Key = "C:/Users/kaeka/.ssh/id_rsa_aleeeec02"
    $hiyorijlKey = "C:/Users/kaeka/.ssh/id_rsa_hiyorijl"
    $ziajoriii7Key = "C:/Users/kaeka/.ssh/id_rsa_ziajoriii7-ggg"

    # Set the GIT_SSH_COMMAND environment variable based on the remote URL
    if ($remoteURL -match "aleeeec02") {
        $env:GIT_SSH_COMMAND = "ssh -i $aleeeec02Key"
        Write-Host "Configured to use aleeeec02's SSH key."
    } elseif ($remoteURL -match "hiyorijl") {
        $env:GIT_SSH_COMMAND = "ssh -i $hiyorijlKey"
        Write-Host "Configured to use hiyorijl's SSH key."
    } elseif ($remoteURL -match "ziajoriii7-ggg") {
        $env:GIT_SSH_COMMAND = "ssh -i $ziajoriii7Key"
        Write-Host "Configured to use ziajoriii7-ggg's SSH key."
    } else {
        Write-Host "Remote URL not recognized. Using default SSH key."
    }
