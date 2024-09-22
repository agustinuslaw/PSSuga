Function Write-SgHostLog {
    Param(
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true)]
        [String[]]$Messages,
        [Parameter()]
        [String]$Name
    )
    
    begin {
		# use calling script's name 
        if (-not $Name) {
            $Name="Console"
            if ($MyInvocation.PSCommandPath -ne $null) {
                $Name=(Get-Item $MyInvocation.PSCommandPath).Basename
            }
        }
    }
    
    process {
        Format-SgLog $Name $Messages | Write-Host
    }
    
    end {}
}