Function Convert-SgPdfColorInverted {
	[CmdletBinding()]
    Param(
		[Parameter(ValueFromPipeline=$true)]
		[System.IO.FileInfo]$File,
		[String]$Suffix
	)
	
	begin {
		$PushdCounter=0
	}
	
	process {
		$OutFile=$File.BaseName + $Suffix + $File.Extension
		
		Write-SgHostLog "$($File.Fullname) -> $OutFile"

		# Switch to parent dir if necessary, wsl can't accept full windows path
		$ParentDir=Split-Path -Parent $File.Fullname
		$ChangePwd=$ParentDir -ne $PWD.ToString()
		if($ChangePwd) {
			pushd $ParentDir
			$PushdCounter = $PushdCounter + 1
		}

		wsl convert -density 300 -colorspace RGB -channel RGB -negate $File.Name $OutFile

		Get-Item $OutFile
	}
	
	end {		
		for ($i=0; $i -lt $PushdCounter; $i++){
			popd
		}
	}
}