Function Set-SgWindowState {

	[CmdletBinding()]
	Param(
		[Parameter()]
		[ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
					 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
					 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
		[String] $State='SHOWNORMAL',
		
		[Parameter(ValueFromPipelineByPropertyname='True',ValueFromPipeline='True')]
		[System.IntPtr] $MainWindowHandle
	)
	
	BEGIN {
		# For [Suga.User32]
		Add-SgTypes
		
		if (!(Test-SgAdminRole)) {
			$Logger=New-SgLogger
			$Logger.log("This function has more functionality with admin rights")
		}
						
		$WindowStates = @{
			'FORCEMINIMIZE'   = 11
			'HIDE'            = 0
			'MAXIMIZE'        = 3
			'MINIMIZE'        = 6
			'RESTORE'         = 9
			'SHOW'            = 5
			'SHOWDEFAULT'     = 10
			'SHOWMAXIMIZED'   = 3
			'SHOWMINIMIZED'   = 2
			'SHOWMINNOACTIVE' = 7
			'SHOWNA'          = 8
			'SHOWNOACTIVATE'  = 4
			'SHOWNORMAL'      = 1
		}
		
	}
		
	PROCESS {
		[Suga.User32]::ShowWindowAsync($MainWindowHandle, $WindowStates[$State]) | Out-Null
		return $MainWindowHandle
	}
	
	END {}

}