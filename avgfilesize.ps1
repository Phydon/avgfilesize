param (
    [string]$directory
)

# Get the script file name dynamically
$scriptName = $MyInvocation.MyCommand.Name

# Check if the directory argument was provided
if (-not $directory) {
    Write-Output "Usage: .\$scriptName <PATH>"
    exit
}

# Check if the directory exists
if (Test-Path $directory) {
    # Get the files recursively and calculate the average size
    $stats = Get-ChildItem $directory -Recurse | Measure-Object -Property Length -Average

    if ($stats.Count -gt 0) {
        $avgSize = $stats.Average
        
        # convert bytes into human-readable format
        function Convert-Size($size) {
            if     ($size -ge 1GB) { "{0:N2} GB" -f ($size / 1GB) }
            elseif ($size -ge 1MB) { "{0:N2} MB" -f ($size / 1MB) }
            elseif ($size -ge 1KB) { "{0:N2} KB" -f ($size / 1KB) }
            else                   { "{0} B" -f $size }
        }
        
        # Output the average size in human-readable format
        Write-Output "Average File Size: $(Convert-Size $avgSize)"
    } else {
        Write-Output "No files found in the directory."
    }
} else {
    Write-Output "The specified directory does not exist."
}
