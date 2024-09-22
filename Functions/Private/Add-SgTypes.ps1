<#
    .SYNOPSIS
    Adds types in the compiled DLL for use in the module.

    .DESCRIPTION
    Adds types in the compiled DLL for use in the module.
    This function requires .NET SDK and will create a DLL file in <module>/Csharp/bin.
    In case no DLL found, the project <module>/Csharp will be compiled using dotnet.

    .INPUTS
    None. You can't pipe objects to this function.

    .EXAMPLE
    Add-SgTypes
#>
Function Add-SgTypes
{   
    $Artifact = Build-SgArtifactOnce "User32" "Suga.User32.dll"
    Add-Type -Path $Artifact 
}