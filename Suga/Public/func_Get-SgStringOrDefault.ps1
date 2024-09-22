Function Get-SgStringOrDefault {
    Param([string]$Value,[string]$Default)
	if([string]::IsNullOrEmpty($Value)){
		return $Default
	} else {
		return $Value
	}
}