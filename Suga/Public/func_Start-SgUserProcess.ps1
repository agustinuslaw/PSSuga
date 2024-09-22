<#
    .SYNOPSIS
    Starts a process as a new top-level process for the current user.

    .DESCRIPTION
    Starts and waits for a process. Similar to
    `Start-Process ... | Wait-Process`, except uses `Invoke-CimMethod` and
    `Win32_Process.Create` to start the process as a top-level process of the
    current user instead of as a child process of the caller.

    `Wait-Process` is used to wait on the process to complete. Any descendants
    of the process are not waited on, and will continue or be killed after the
    process completes (depending on how they were started).

    The process's standard output and error are redirected to temporary files,
    and streamed to the standard output and error of the host until the process
    completes. The temporary files are then deleted. Standard output and error
    lines may be interleaved out-of-order relative to how they were output by
    the process due to the nature of streaming the separate files
    asynchronously.

    .PARAMETER FilePath
    Passed to `Start-Process`. See the corresponding documentation.

    .PARAMETER ArgumentList
    Passed to `Start-Process`. See the corresponding documentation.

    .PARAMETER WorkingDirectory
    Passed to `Start-Process`. See the corresponding documentation. Defaults to
    $PWD.

    .INPUTS
    None. You can't pipe objects to Start-User-Process.

    .NOTES
    Sets `$LASTEXITCODE` to that of the user process.

    .EXAMPLE
    Start-User-Process -FilePath notepad.exe
    Starts Notepad as a new top-level process.
#>
Function Start-SgUserProcess
{
	# Source https://forums.powershell.org/t/how-to-start-a-process-as-a-separate-process-tree/24025/11
	
    [CmdletBinding()]
    param (
        [Parameter(
                Mandatory = $true,
				Position = 0,
                HelpMessage = "The filename (with optional path) " +
                        "to background as a process."
        )]
        [string]$FilePath,

        [Parameter(
                HelpMessage = "The arguments to use when backgrounding " +
                        "the process."
        )]
        [string[]]$ArgumentList,

        [Parameter(
                HelpMessage = "The working directory (defaults to `$PWD)."
        )]
        [string]$WorkingDirectory = $PWD
    )

    # Stop the script on uncaught errors.
    $ErrorActionPreference = "Stop"

    Set-Variable -Name HIDDEN_WINDOW -Value 0 -Option Constant

    $stdOutTempFile = "$env:TEMP\$( (New-Guid).Guid )"

    Write-Debug "Creating standard output temp file: $stdOutTempFile"
    New-Item -Path $stdOutTempFile -ItemType File | Out-Null

    $stdErrTempFile = "$env:TEMP\$( (New-Guid).Guid )"

    Write-Debug "Creating standard error temp file: $stdErrTempFile"
    New-Item -Path $stdErrTempFile -ItemType File | Out-Null

    $envVars = Get-ChildItem env: | ForEach-Object {
        "$( $_.Name )=$( $_.Value )"
    }
    Write-Debug "Including environment variables:`n$( $envVars | Out-String )`n"

    $processStartupClass = Get-CimClass -ClassName Win32_ProcessStartup

    $processStartupProperties = @{
        EnvironmentVariables = $envVars
        ShowWindow = $HIDDEN_WINDOW
    }

    $processStartupInformation = New-CimInstance -CimClass $processStartupClass `
    -Property $processStartupProperties -ClientOnly

    $commandLine = "powershell.exe -Command & { " +
            "`$process = Start-Process -FilePath '$FilePath' "

    if ( $PSBoundParameters.ContainsKey('ArgumentList'))
    {
        $commandLine += "-ArgumentList '$ArgumentList' "
    }

    $commandLine += "-RedirectStandardOutput $stdOutTempFile " +
            "-RedirectStandardError $stdErrTempFile " +
            "-WorkingDirectory $WorkingDirectory " +
            "-NoNewWindow -PassThru; " +
            "`$process | Wait-Process; " +
            "exit `$process.ExitCode " +
            "}"

    $processClass = Get-CimClass -ClassName Win32_Process
    $createProcessParams = @{
        CimClass = $processClass
        MethodName = "Create"
        Arguments = @{
            CommandLine = $commandLine
            ProcessStartupInformation = [CimInstance]$processStartupInformation
        }
    }

    Write-Debug "Invoking command: '$commandLine'..."
    $userProcessId = $( Invoke-CimMethod @createProcessParams ).ProcessId

    $getStdOutProcessParams = @{
        FilePath = "powershell.exe"
        ArgumentList = @(
            "-Command",
            "Get-Content -Path $stdOutTempFile -Wait " +
                    "-ErrorAction SilentlyContinue"
        )
        NoNewWindow = $true
        PassThru = $true
    }

    $getStdErrProcessParams = @{
        FilePath = "powershell.exe"
        ArgumentList = @(
            "-Command",
            "Get-Content -Path $stdErrTempFile -Wait " +
                    "-ErrorAction SilentlyContinue " +
                    "| ForEach-Object { `$host.ui.WriteErrorLine(`$_) }"
        )
        NoNewWindow = $true
        PassThru = $true
    }
}