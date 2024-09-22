<#
    .SYNOPSIS
    Removes Winget Progress from StdOut and thus logging.

    .DESCRIPTION
	Removes Winget Progress from StdOut and thus logging.

    .INPUTS
    None. You can't pipe objects to this function.

    .EXAMPLE
    Clear-SgWingetProgress {winget install dotnet}
#>
Function Clear-SgWingetProgress {
    # Taken from Strip-Progress https://gist.github.com/asheroto/96bcabe428e8ad134ef204573810041f
    # Mentioned in https://github.com/microsoft/winget-cli/issues/3494
    
    Param(
        [Parameter(Mandatory=$true,Position=0)]
        [ScriptBlock]$ScriptBlock
    )

    # Regex pattern to match spinner characters and progress bar patterns
    $ProgressPattern = '[ΓûÔÆê]|^\s+[-\\|/]\s+$'

    # Corrected regex pattern for size formatting, ensuring proper capture groups are utilized
    $SizePattern = '(\d+(\.\d{1,2})?)\s+(B|KB|MB|GB|TB|PB) /\s+(\d+(\.\d{1,2})?)\s+(B|KB|MB|GB|TB|PB)'
	$PercentPattern = '\s\d{1,3}%'

    $PreviousLineWasEmpty = $false # Track if the previous line was empty

    & $ScriptBlock 2>&1 | ForEach-Object {
        if ($_ -is [System.Management.Automation.ErrorRecord]) {
            "ERROR: $($_.Exception.Message)"
        } elseif ($_ -match '^\s*$') {
            if (-not $PreviousLineWasEmpty) {
                Write-Output ""
                $PreviousLineWasEmpty = $true
            }
        } else {
            $line = $_ -replace $ProgressPattern, '' -replace $SizePattern, '' -replace $PercentPattern, ''
            if (-not [string]::IsNullOrWhiteSpace($line)) {
                $PreviousLineWasEmpty = $false
                $line
            }
        }
    }
}
