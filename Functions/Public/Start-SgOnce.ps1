Function Start-SgOnce {
	Param(
		[Parameter(Position = 0)][String]$FilePath
		, [String]$Filter
		, [String]$WorkingDirectory
		, [String[]]$ArgumentList
		, [switch]$Admin
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
		if ($AsAdmin) {
			$Logger.log("With admin rights")
			Start-Process $FilePath -Work $WorkingDirectory -ArgumentList $ArgumentList -Verb RunAs *>&1 | tee -encoding utf8 -append -filepath $LogPath -ErrorAction Ignore
		}
		else {
			Start-Process $FilePath -Work $WorkingDirectory -ArgumentList $ArgumentList *>&1 | tee -encoding utf8 -append -filepath $LogPath -ErrorAction Ignore
		}
	}
 else {
		# Do not start if process already running
		$Logger.log("Process already started for filter: $Filter")
	}
}