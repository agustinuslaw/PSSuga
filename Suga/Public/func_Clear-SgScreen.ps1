Function Clear-SgScreen {
	$Shell = New-Object -ComObject "Shell.Application"
	$Shell.MinimizeAll()
}