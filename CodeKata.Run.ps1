. .\CodeKata.ps1

$data = @(  "..........", 
            "..**......", 
            "...*......", 
            "...*......", 
            "...***....", 
            "..........")

for ($generation = 0; $generation -lt 1000; $generation++) {
    $data = Invoke-GameOfLife $data
    
    Clear-Host
    $data | % { $_ }
    Read-Host -Prompt "Continue?"
}
