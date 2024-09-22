Function Get-SgScriptDir {
    # $MyInvocation is an Automatic variable that contains runtime details and
    # we can use this to get information about where the file is run from.
    $Invocation = (Get-Variable MyInvocation -Scope 1).Value
    Split-Path $Invocation.MyCommand.Path
}
