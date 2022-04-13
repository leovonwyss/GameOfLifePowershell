$paddingChar = '/'
$eolChar = '$'
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

$LivenessByCharacter = @{
    [char]"." = 0;
    [char]$paddingChar = 0;
    [char]$eolChar = 0;
    [char]"*" = 1;
}

$NonPaddingCharacter = @{
    [char]$paddingChar = 0;
    [char]$eolChar = 0;
    [char]"." = 1;
    [char]"*" = 1;
}

$KeepAsIsCharacter = @{
    [char]$paddingChar = 0;
    [char]$eolChar = 1;
    [char]"." = 0;
    [char]"*" = 0;
}

function Add-Padding {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [string] $i,
        [Parameter()]
        [int] $lineLength
    )

    Begin {
        return [string]::new($paddingChar, $lineLength+2)
    }
    Process {
        return "$paddingChar$i$eolChar"
    }
    End {
        return [string]::new($paddingChar, $lineLength+2)
    }
}

function Split-AndCleanString {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [string] $s
    )

    $s.Trim($eolChar).Split($eolChar)
}

function Process-SingleCell {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [char] $c,
        [Parameter()]
        [int] $lineLength,
        [Parameter()]
        [string] $fullStream
    )

    Begin {
        $currentPosition = 0
    }
    Process {
        $resultCharacterCount = $KeepAsIsCharacter[$c]
        [string]::new($c, $resultCharacterCount).ToCharArray()

        $resultCharacterCount = $NonPaddingCharacter[$c]
        [string]::new($c, $resultCharacterCount).ToCharArray() | 
            Process-SingleCellInternal -fullStream $fullStream -currentPosition $currentPosition -lineLength $lineLength

        $currentPosition++
    }
    End {
    }
}

function Process-SingleCellInternal {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true, Mandatory=$true)]
        [char] $c,
        [Parameter()]
        [int] $lineLength,
        [Parameter()]
        [int] $currentPosition,
        [Parameter()]
        [string] $fullStream
    )

    Begin {
        $lineLengthWithPadding = $lineLength+2
    }
    Process {
        $topLeft      = $fullStream[$currentPosition-$lineLengthWithPadding-1]
        $topCenter    = $fullStream[$currentPosition-$lineLengthWithPadding]
        $topRight     = $fullStream[$currentPosition-$lineLengthWithPadding+1]
        $left         = $fullStream[$currentPosition-1]
        $right        = $fullStream[$currentPosition+1]
        $bottomLeft   = $fullStream[$currentPosition+$lineLengthWithPadding-1]
        $bottomCenter = $fullStream[$currentPosition+$lineLengthWithPadding]
        $bottomRight  = $fullStream[$currentPosition+$lineLengthWithPadding+1]

        $livingCount = $LivenessByCharacter[$topLeft] + $LivenessByCharacter[$topCenter] + $LivenessByCharacter[$topRight] `
        + $LivenessByCharacter[$left] + $LivenessByCharacter[$right] `
        + $LivenessByCharacter[$bottomLeft] + $LivenessByCharacter[$bottomCenter] + $LivenessByCharacter[$bottomRight]
        
        $ResultByLiveNeighbourCount[$livingCount].Replace("?", $c)
    }
    End {
    }
}

function Invoke-GameOfLife {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true, Mandatory=$true)]
        [string[]]
        $oldGeneration
    )

    $lineLength = $oldGeneration[0].Length

    $characterStream = $oldGeneration | 
        Add-Padding -lineLength $lineLength | 
        Join-String
    $characterStream.ToCharArray() | 
        Process-SingleCell -lineLength $lineLength -fullStream $characterStream | 
        Join-String | 
        Split-AndCleanString
}
