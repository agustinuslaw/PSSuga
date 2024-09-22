Function Test-SgFunctionNameConsistency {   
    [CmdletBinding()]
    Param(
		[Switch]$PrintResult
	)
    $ModulePath = Get-SgModulePath
    $Results = Get-ChildItem -r $ModulePath func_*.ps1 | ForEach-Object { 
        $File = $_; 
        $Expected = $_.basename; 
        $Actual = Get-Content $file | Select-String "Function ($Expected)(\W|$)" | ForEach-Object {$_.Matches.Groups[1].Value};
        $Res = [boolean]($Actual); 
        if (!$Res -or $PrintResult) {
            Write-Host "Expected [$Expected] actual [$Actual]. Test Passed: $Res";
        }
        $Res;
    }
    
    $AnyTestFailed = $Results -contains $false
    
    -not $AnyTestFailed
}