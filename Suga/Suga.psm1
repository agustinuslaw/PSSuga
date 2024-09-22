# # Load Log Formatter
# . $PSScriptRoot\func_Format-Log.ps1
# . $PSScriptRoot\func_Write-HostLog.ps1

#Get public and private function definition files.
$Base = $PSScriptRoot
$Public  = @(gci -Path $Base\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(gci -Path $Base\Private\*.ps1 -ErrorAction SilentlyContinue)

#Dot source the files
Foreach($import in @($Public + $Private))
{
	Try
	{
		. $import.fullname
	}
	Catch
	{
		Write-Error -Message "Failed to import function $($import.fullname): $_"
	}
}

# Export-ModuleMember -Function $Public.Basename