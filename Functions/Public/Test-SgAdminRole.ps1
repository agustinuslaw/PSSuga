Function Test-SgAdminRole {
	$Principal=[Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()	
	return $Principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}