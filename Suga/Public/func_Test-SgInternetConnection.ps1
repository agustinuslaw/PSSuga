Function Test-SgInternetConnection {
    $result=Get-NetRoute | ? DestinationPrefix -eq '0.0.0.0/0' | Get-NetIPInterface | Where ConnectionState -eq 'Connected'
	# check if there exists a connection to internet 
	$result -ne $null
}