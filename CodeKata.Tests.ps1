BeforeAll {
    . .\CodeKata.ps1
}

Describe 'Game of Life' {
    BeforeEach {
    }

    It "Rule examples" -ForEach @(
        @{ CurrentArea = @("....","....","....","...."); ExpectedArea = @("....","....","....","...."); };
        @{ CurrentArea = @("....","..*.","....","...."); ExpectedArea = @("....","....","....","...."); };
        @{ CurrentArea = @("....",".**.","....","...."); ExpectedArea = @("....","....","....","...."); };
        @{ CurrentArea = @("....","..*.",".**.","...."); ExpectedArea = @("....",".**.",".**.","...."); };
        @{ CurrentArea = @("....","***.",".**.","...."); ExpectedArea = @(".*..","*.*.","*.*.","...."); };
        @{ CurrentArea = @("****","****","****","****"); ExpectedArea = @("*..*","....","....","*..*"); };
    ) {
        Invoke-GameOfLife $currentArea | Should -Be $expectedArea
    }
}
