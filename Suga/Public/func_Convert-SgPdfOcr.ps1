Function Convert-SgPdfOcr {
	[CmdletBinding()]
    Param(
		[Parameter(ValueFromPipeline=$true)]
		[System.IO.FileInfo]$File
	)
	
	begin {
		$PushdCounter=0
	}
	
	process {
		Write-SgHostLog $File.Fullname

		# Switch to parent dir if necessary, wsl can't accept full windows path
		$ParentDir=Split-Path -Parent $File.Fullname
		$ChangePwd=$ParentDir -ne $PWD.ToString()
		if($ChangePwd) {
			pushd $ParentDir
			$PushdCounter = $PushdCounter + 1
		}

		wsl ocrmypdf -l eng+deu $File.Name $File.Name
	
		$File
	}
	
	end {
		for ($i=0; $i -lt $PushdCounter; $i++){
			popd
		}
	}
}