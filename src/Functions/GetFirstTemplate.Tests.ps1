$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "GetFirstTemplate" {
    Context "normal" {
        It "mono" {
            GetFirstTemplate "--{test1()}--" | Should -Be "--{test1()}--"
            GetFirstTemplate "a--{test1()}--" | Should -Be "--{test1()}--"
            GetFirstTemplate "--{test1()}--a" | Should -Be "--{test1()}--"
            GetFirstTemplate "a--{test1()}--a" | Should -Be "--{test1()}--"
        }
        It "multi" {
            GetFirstTemplate "--{test1()}----{test2()}--" | Should -Be "--{test1()}--"
        }
        It "nest" {
            GetFirstTemplate "--{test1(--{test2()}--)}--" | Should -Be "--{test1(--{test2()}--)}--"
            GetFirstTemplate "--{test1(a--{test2()}--)}--" | Should -Be "--{test1(a--{test2()}--)}--"
            GetFirstTemplate "--{test1(--{test2()}--a)}--" | Should -Be "--{test1(--{test2()}--a)}--"
            GetFirstTemplate "--{test1(a--{test2()}--a)}--" | Should -Be "--{test1(a--{test2()}--a)}--"
        }
        It "contains new line" {
            GetFirstTemplate "--{test1()}--`n--{test2()}--" | Should -Be "--{test1()}--"
            GetFirstTemplate "--{test1(`n--{test2()}--`n)}--" | Should -Be "--{test1(`n--{test2()}--`n)}--"
        }
        It "no template" {
            GetFirstTemplate "-a-{test1()}--" | Should -Be $null
            GetFirstTemplate "--{test1()}-a-" | Should -Be $null
            GetFirstTemplate "--{test1" | Should -Be $null
            GetFirstTemplate "test1}--" | Should -Be $null
            GetFirstTemplate "test1" | Should -Be $null
        }
    }
}
