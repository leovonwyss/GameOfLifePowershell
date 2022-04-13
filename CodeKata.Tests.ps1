BeforeAll {
    . .\CodeKata.ps1
}

Describe 'Game of Life' {
    BeforeEach {
    }

    Context "With an empty zone" {
        It "Does not generate any live cells" {
            $currentArea = @(   "....",
                                "....",
                                "....",
                                "....")

            $nextArea = Invoke-GameOfLife $currentArea

            $nextArea | Should -Be @(   "....",
            "....",
            "....",
            "....")
        }
    }

    Context "Sample from the kata description" {
        It "It does the right thing" {
            $currentArea = @(   "........",
                                "....*...",
                                "...**...",
                                "........")

            $nextArea = Invoke-GameOfLife $currentArea

            $nextArea | Should -Be @(   "........",
                                        "...**...",
                                        "...**...",
                                        "........")
        }
    }
}
