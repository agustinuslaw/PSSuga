Function Build-SgArtifactOnce ([String]$Subproject, [String]$ArtifactName) {
    $ModulePath = Get-SgModulePath
    $Base = "$ModulePath\$Subproject"
    
    $ArtifactPath = "$Base\bin\$ArtifactName"

    if (!(Test-Path $ArtifactPath)) {    
        dotnet build $Base -o $Base\bin

        # Check again
        if (!(Test-Path $ArtifactPath)) {    
            throw "Error: artifact $ArtifactPath was not created. See '$Base\bin'"
        }
    }
    
    return $ArtifactPath
}