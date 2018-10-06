$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "CreateCodeConvList" {
    It "Mono" {
        [array] $actual = CreateCodeConvList "-1-{test()}-1-"
        [array] $expected = @()
        $expected += [CodeConv]::new("-1-{test\(([\s\S]*)\)}-1-", "test", "&1&")
        $expected.Count -eq $actual.Count | Should -Be $true
        for ($i = 0; $i -lt $expected.Count; $i++) {
            $expected[$i].Equals($actual[$i]) | Should -Be $true
        }
    }
    It "Multi" {
        [array] $actual = CreateCodeConvList "-1-{test()}-1- -2-{test()}-2-"
        [array] $expected = @()
        $expected += [CodeConv]::new("-1-{test\(([\s\S]*)\)}-1-", "test", "&1&")
        $expected += [CodeConv]::new("-2-{test\(([\s\S]*)\)}-2-", "test", "&2&")
        $expected.Count -eq $actual.Count | Should -Be $true
        for ($i = 0; $i -lt $expected.Count; $i++) {
            $expected[$i].Equals($actual[$i]) | Should -Be $true
        }
    }
}
