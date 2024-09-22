Function Show-SgPopUp {
	[CmdletBinding()]
	Param(
		[Parameter()]
		[String]$Title="Host",
		[Parameter()]
		[String]$Text="No message",
		[Parameter()]
		[ValidateSet('OK','OKCancel','AbortRetryIgnore','YesNoCancel','YesNo','RetryCancel' )]
		[String]$Button='OK',
		[ValidateSet('Stop','Question','Exclamation','Information' )]
		[String]$Icon='Information'
	)
	
	$ButtonOptions=@{
		'OK'=0 
		'OKCancel'=1 
		'AbortRetryIgnore'=2 
		'YesNoCancel'=3 
		'YesNo'=4 
		'RetryCancel'=5 
	}
	$IconOptions=@{
		'Stop'=16
		'Question'=32
		'Exclamation'=48
		'Information'=64
	}
	$ButtonResults=@{
		1='OK'
		2='Cancel'
		3='Abort'
		4='Retry'
		5='Ignore'
		6='Yes'
		7='No'
	}
    $Wshell=new-object -comobject wscript.shell
	$TypeNum=$ButtonOptions[$Button] + $IconOptions[$Icon]
	$SecondsToWait=0
    $Result=$Wshell.popup($Text,$SecondsToWait,$Title,$TypeNum)
	
	return $ButtonResults[$Result]
}