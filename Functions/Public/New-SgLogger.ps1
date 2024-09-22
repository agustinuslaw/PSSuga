Function New-SgLogger {
	Param(
		[Parameter(Position=0)][String]$Name="",
		[Parameter(Position=1)][String]$Path=""
	)
	
	if (-not $Name) {
		$Name="Console"
		if ($null -ne $MyInvocation.PSCommandPath) {
			$Name=(Get-Item $MyInvocation.PSCommandPath).Basename
		}
	}
	
	return [SgLogger]::new($Name,$Path)
}