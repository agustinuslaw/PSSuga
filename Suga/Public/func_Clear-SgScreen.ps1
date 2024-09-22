<#
    .SYNOPSIS
    Minimizes all windows.

    .DESCRIPTION
	Minimizes all windows.

    .INPUTS
    None. You can't pipe objects to this function.

    .EXAMPLE
    Clear-SgScreen
#>
Function Clear-SgScreen {
	$Shell = New-Object -ComObject "Shell.Application"
	$Shell.MinimizeAll()
}