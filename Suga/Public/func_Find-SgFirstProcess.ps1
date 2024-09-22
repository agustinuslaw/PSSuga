Function Find-SgFirstProcess {

	[CmdletBinding()]
	Param(
		[Parameter(Position=0,ValueFromPipeline=$true)] 
		[Alias('Name')]
		[String] $ProcessName,
		
		[Parameter()]
		[Alias('Filter')]
		[String] $CimFilter
	)
	
	BEGIN {}
		
	PROCESS {
		
		if ($CimFilter) {
			$Process=Get-CimInstance Win32_Process -Filter $CimFilter | Select -First 1 | %{ps -pid $_.ProcessId}				
		} elseif ($ProcessName) {
			$Process=ps $ProcessName | Select -First 1
		}
		return $Process
	}
	
	END {}

}
