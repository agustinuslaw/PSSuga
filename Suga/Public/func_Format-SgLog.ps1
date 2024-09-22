Function Format-SgLog {
    Param(
		[Parameter(Mandatory=$true,Position=0)]
		[String]$Name,
		[Parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true)]
		[String[]]$Messages
	)
	
	begin {}
	
	process {
		foreach ($Message in $Messages) {		
			#return "$(Get-Date -Format o) [$Name] $Message" 		
			return "$(Get-Date -Format yyyy-MM-ddTHH:mm:ss.fff) [$Name] $Message" 
		}
	}
	
	end {}
}