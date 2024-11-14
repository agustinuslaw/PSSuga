Function Start-SgUserProcessOnce {
	Param(
		[Parameter(Position = 0)][String]$FilePath
		, [String]$Filter
		, [String]$WorkingDirectory
		, [String[]]$ArgumentList
		, [String]$LogPath
	)

	$Logger = New-SgLogger -Path $LogPath
	
	$Filter = Get-SgStringOrDefault $Filter "Name='$FilePath'"
	$WorkingDirectory = Get-SgStringOrDefault $WorkingDirectory "."
		
	$Logger.log("Start once: $FilePath")
	
	# Look for matching process 
	$Process = Get-CimInstance Win32_Process -Filter $Filter
	if (!$Process) {
		# No matching process, start
		Start-SgUserProcess $FilePath -Work $WorkingDirectory -ArgumentList $ArgumentList *>&1 
	}
 else {
		# Do not start if process already running
		$Logger.log("Process already started for filter: $Filter")
	}
}