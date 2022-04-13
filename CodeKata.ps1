function Invoke-GameOfLife {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string[]]
        $oldGeneration
    )

    $newGeneration = [string[]]::new($oldGeneration.Length)
    for ($line = 0; $line -lt $oldGeneration.Length; $line++) {
        $lineAbove = [string]::new('X', $oldGeneration[0].Length + 2)
        if ($line -gt 0) {
            $lineAbove = "X$($oldGeneration[$line -1])X"
        }
        $currentLine = "X$($oldGeneration[$line])X"
        $lineBelow = [string]::new('X', $oldGeneration[0].Length + 2)
        if ($line -lt $oldGeneration.Length -1) {
            $lineBelow = "X$($oldGeneration[$line +1])X"
        }

        for ($col = 1; $col -le $oldGeneration[0].Length; $col++) {
            $livingCount = Get-AliveCount -lineAbove $lineAbove -currentLine $currentLine -lineBelow $lineBelow -col $col
            switch ($livingCount) {
                3 {
                    $newGeneration[$line] = $newGeneration[$line] + '*'
                }
                2 {
                    $newGeneration[$line] = $newGeneration[$line] + $currentLine[$col]
                }
                default {
                    $newGeneration[$line] = $newGeneration[$line] + '.'
                }
            }
        }
    }
    return $newGeneration
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