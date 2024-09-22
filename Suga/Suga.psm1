# # Load Log Formatter
# . $PSScriptRoot\func_Format-Log.ps1
# . $PSScriptRoot\func_Write-HostLog.ps1

#Get public and private function definition files.
$script:SugaModulePath = $PSScriptRoot
$Public  = @(gci -Path $SugaModulePath\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(gci -Path $SugaModulePath\Private\*.ps1 -ErrorAction SilentlyContinue)

function Get-SgModulePath {
	$SugaModulePath
}

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

# Limit exposed functions to the ones in public
Export-ModuleMember -Function $Public.Basename