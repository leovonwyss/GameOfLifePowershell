function Invoke-GameOfLife {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string[]]
        $oldGeneration
    )

    return $oldGeneration
}