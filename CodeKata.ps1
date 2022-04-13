function Invoke-GameOfLife {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string[]]
        $oldGeneration
    )

    # add padding on top and bottom
    $oldGeneration = ,[string]::new('X', $oldGeneration[0].Length) + $oldGeneration + ,[string]::new('X', $oldGeneration[0].Length)

    for ($line = 1; $line -lt $oldGeneration.Length - 1; $line++) {
        # prepare lines with padding
        $lineAbove = "X$($oldGeneration[$line -1])X"
        $currentLine = "X$($oldGeneration[$line])X"
        $lineBelow = [string]::new('X', $oldGeneration[0].Length + 2)
        $lineBelow = "X$($oldGeneration[$line +1])X"

        $newLine = ""
        for ($col = 1; $col -le $oldGeneration[0].Length; $col++) {
            $livingCount = Get-AliveCount -lineAbove $lineAbove -currentLine $currentLine -lineBelow $lineBelow -col $col
            switch ($livingCount) {
                3 {
                    $newLine += '*'
                }
                2 {
                    $newLine += $currentLine[$col]
                }
                default {
                    $newLine += '.'
                }
            }
        }
        $newLine
    }
}

function Get-AliveCount {
    [CmdletBinding()]
    param (
        [string]
        $lineAbove,
        [string]
        $currentLine,
        [string]
        $lineBelow,
        [int]
        $col
    )
    $livingCount = 0
    if ($lineAbove[$col -1] -eq '*') {
        $livingCount++
    }
    if ($currentLine[$col -1] -eq '*') {
        $livingCount++
    }
    if ($lineBelow[$col -1] -eq '*') {
        $livingCount++
    }

    if ($lineAbove[$col] -eq '*') {
        $livingCount++
    }
    if ($lineBelow[$col] -eq '*') {
        $livingCount++
    }

    if ($lineAbove[$col +1] -eq '*') {
        $livingCount++
    }
    if ($currentLine[$col +1] -eq '*') {
        $livingCount++
    }
    if ($lineBelow[$col +1] -eq '*') {
        $livingCount++
    }

    return $livingCount
}