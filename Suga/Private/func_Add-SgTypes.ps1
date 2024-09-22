Function Add-SgTypes
{   
    # Root is dir of .psm1
    # Requires .NET SDK 8.0 
    $Base = "$PSScriptRoot\Csharp"
    if (!(Test-Path $Base\bin\Suga.dll)) {    
        dotnet build $Base\Suga.csproj -o $Base\bin
    }
    Add-Type -Path $Base\bin\Suga.dll
}