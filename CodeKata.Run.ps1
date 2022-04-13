. .\CodeKata.ps1

$data = @(  "..........", 
            "..**......", 
            "...*......", 
            "...*......", 
            "...***....", 
            "..........")

for ($generation = 0; $generation -lt 1000; $generation++) {
    Clear-Host
    "Generation $($generation):"
    $data | % { $_ }
    Read-Host -Prompt "Continue?"

    $data = Invoke-GameOfLife $data
}
