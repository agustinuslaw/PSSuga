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
    # Root is dir of .psm1
    # Requires .NET SDK 8.0 
    $ModulePath = Get-SgModulePath
 
    $Base = "$ModulePath\Csharp"
    if (!(Test-Path $Base\bin\Suga.dll)) {    
        dotnet build $Base\Suga.csproj -o $Base\bin
    }
    Add-Type -Path $Base\bin\Suga.dll
}