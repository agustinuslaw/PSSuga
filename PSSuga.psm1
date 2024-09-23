# # Load Log Formatter

#Get public and private function definition files.
$script:SugaModulePath = $PSScriptRoot

$Public  = @(Get-ChildItem -Path $SugaModulePath\Functions\Public\*.ps1 -ErrorAction SilentlyContinue)
$Private = @(Get-ChildItem -Path $SugaModulePath\Functions\Private\*.ps1 -ErrorAction SilentlyContinue)

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