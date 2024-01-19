wsl ls -l | awk '{printf "%-4s %-4s %-6s %s %s %s %-15s\n", substr($1, 1, 4), $3, $5, $6, $7, $8, $9}'

