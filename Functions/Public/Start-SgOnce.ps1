Function Start-SgOnce {
    Param(
		[Parameter(Position=0)][String]$FilePath
		,[String]$Filter
		,[String]$WorkDir
		,[String[]]$Arg
		,[switch]$Admin
		,[SgLogger]$Logger
	)
	
	# Normalize inputs
	$LogPath="$HOME/log"
	if ($Logger -eq $null) {
		$Logger=New-SgLogger
	} else {
		$LogPath=$Logger.Path
	}
	
	$Filter=Get-SgStringOrDefault $Filter "Name='$FilePath'"
	$WorkDir=Get-SgStringOrDefault $WorkDir "."
		
	$Logger.log("Start once: $FilePath")
	
	# Look for matching process 
	$Process=Get-CimInstance Win32_Process -Filter $Filter
	if(!$Process) {
		# No matching process, start
		if ($AsAdmin){
			$Logger.log("With admin rights")
			Start-Process $FilePath -Work $WorkDir -ArgumentList $Arg -Verb RunAs *>&1 | tee -encoding utf8 -append -filepath $LogPath -ErrorAction Ignore
		} else {
			Start-Process $FilePath -Work $WorkDir -ArgumentList $Arg *>&1 | tee -encoding utf8 -append -filepath $LogPath -ErrorAction Ignore
		}
	} else {
		# Do not start if process already running
		$Logger.log("Process already started for filter: $Filter")
	}
}