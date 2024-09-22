Class SgLogger {
    # PROPERTIES
	[String]$Name
	[String]$Path
	
	# CONSTRUCTORS
    SgLogger([hashtable]$Properties) { 
		$this.Init($Properties)
	}
    SgLogger([string]$Name, [string]$Path) {
        $this.Init(@{Name = $Name; Path = $Path })
    }
	
	# FUNCTIONS
	# Shared initializer method
    [void] Init([hashtable]$Properties) {
        foreach ($Property in $Properties.Keys) {	
            $this.$Property = $Properties.$Property
        }
		
		if ($this.Path -ne ""){
			# Create log directory if not exist
			$LogDir=Split-Path $this.Path -Parent
			if (!(Test-Path $LogDir)) {
				New-Item $LogDir -ItemType Directory
			}
		}
    }

	# Log messages
	[void] Log([String]$Message) {
		$FormattedMessage=Format-SgLog $this.Name $Message 
		Write-Host $FormattedMessage
		# Only write to file if log path not empty
		if ($this.Path -ne ""){
			Out-File -Append -Force -Encoding utf8 -FilePath $this.Path -InputObject $FormattedMessage
		}
	}
	
    # Method to return a string representation of the book
    [string] ToString() {
        return "Logger [$($this.Name)] $($this.Path)"
    }
}
