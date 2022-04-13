$ResultByLiveNeighbourCount = @{
    0 = ".";
    1 = ".";
    2 = "?";
    3 = "*";
    4 = ".";
    5 = ".";
    6 = ".";
    7 = ".";
    8 = ".";
}

function Add-Padding {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [string]
        $i
    )

    "/$i/"
}

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
        $lineAbove = $oldGeneration[$line -1] | Add-Padding
        $currentLine = $oldGeneration[$line] | Add-Padding
        $lineBelow = $oldGeneration[$line +1] | Add-Padding

        $newLine = ""
        for ($col = 1; $col -le $oldGeneration[0].Length; $col++) {
            $livingCount = Get-AliveCount -lineAbove $lineAbove -currentLine $currentLine -lineBelow $lineBelow -col $col
            $newline += $ResultByLiveNeighbourCount[$livingCount].Replace("?", $currentLine[$col])
        }
        $newLine
    }
}

$LivenessByCharacter = @{
    [char]"." = 0;
    [char]"/" = 0;
    [char]"*" = 1;
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
    $LivenessByCharacter[$lineAbove[$col-1]] + $LivenessByCharacter[$lineAbove[$col]] + $LivenessByCharacter[$lineAbove[$col+1]] `
        + $LivenessByCharacter[$currentLine[$col-1]] + $LivenessByCharacter[$currentLine[$col+1]] `
        + $LivenessByCharacter[$lineBelow[$col-1]] + $LivenessByCharacter[$lineBelow[$col]] + $LivenessByCharacter[$lineBelow[$col+1]]
}