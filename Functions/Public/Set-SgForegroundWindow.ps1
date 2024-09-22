Function Set-SgForegroundWindow
{
	# Source https://stackoverflow.com/a/12802050
    [CmdletBinding()]
    param (
		[Parameter(ValueFromPipelineByPropertyname='True',ValueFromPipeline='True')]
		[System.IntPtr] $MainWindowHandle
    )
	
	begin {
		Add-SgTypes
	}

	process {
		[Suga.User32]::SetForegroundWindow($MainWindowHandle) | Out-Null
		return $MainWindowHandle
	}

	end {}
	
}