Function Undo-SgClearScreen {
	$Shell = New-Object -ComObject "Shell.Application"
	$Shell.UndoMinimizeAll()
}