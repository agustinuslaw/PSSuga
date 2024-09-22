Function Show-SgWindow {

	[CmdletBinding()]
	Param(
		[Parameter(Position=0)] 
		[Alias('Name')]
		[String] $ProcessName,
		
		[Parameter()]
		[Alias('Filter')]
		[String] $CimFilter,
		
		[Parameter(ValueFromPipelineByPropertyname='True', ValueFromPipeline='True')]
		[System.IntPtr] $MainWindowHandle
	)
	
	BEGIN {}
		
	PROCESS {
		
		if (!$MainWindowHandle) {
			$Process=Find-SgFirstProcess -ProcessName $ProcessName -CimFilter $CimFilter -ErrorAction Stop
			$MainWindowHandle=$Process.MainWindowHandle			
		} 
		
		# Activate
		Set-SgForegroundWindow -MainWindowHandle $MainWindowHandle | Out-Null
		# Show any state to front, requires Admin rights to work
		Set-SgWindowState -MainWindowHandle $MainWindowHandle -State RESTORE | Out-Null
		Set-SgWindowState -MainWindowHandle $MainWindowHandle -State SHOWNORMAL | Out-Null
		# Show to front
		Set-SgForegroundWindow -MainWindowHandle $MainWindowHandle | Out-Null
		
		$MainWindowHandle
	}
	
	END {}

}
