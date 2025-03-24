param (
    [string]$directory
)

# Get the script file name dynamically
$scriptName = $MyInvocation.MyCommand.Name

# Check if the directory argument was provided
if (-not $directory) {
    Write-Host "Usage: ." -ForegroundColor Blue -NoNewline
    Write-Host "\$scriptName" -ForegroundColor White -NoNewLine
    Write-Host " <" -ForegroundColor Yellow -NoNewLine
    Write-Host "PATH" -ForegroundColor Red -NoNewLine
    Write-Host ">" -ForegroundColor Yellow 
    exit
}

# convert bytes into human-readable format
function Convert-Size($size) {
    if     ($size -ge 1GB) { return [math]::Round($size / 1GB, 2), "GB" }
    elseif ($size -ge 1MB) { return [math]::Round($size / 1MB, 2), "MB" }
    elseif ($size -ge 1KB) { return [math]::Round($size / 1KB, 2), "KB" }
    else                   { return [math]::Round($size, 2), "B" }
}

# Initialize variables for total size and file count
$totalSize = 0
$fileCount = 0

# Check if the directory exists
if (Test-Path $directory) {
    # Recursively process files in the directory
    Get-ChildItem $directory -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        # get the size of each file
        $totalSize += $_.Length
        $fileCount++
    }

    # If we have files to process, calculate and output the average size
    if ($fileCount -gt 0) {
        $avgSize = $totalSize / $fileCount
        $humanReadableSize, $unit = Convert-Size $avgSize
        
        # Output the average file size with color formatting
        Write-Host "Average File Size: " -NoNewline
        Write-Host "$($humanReadableSize) " -ForegroundColor Red -NoNewline
        Write-Host "$($unit)" -ForegroundColor Yellow
    } else {
        Write-Host "No accessible files found in the directory." -ForegroundColor White
    }
} else {
    Write-Host "The specified directory does not exist." -ForegroundColor White
}
