$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ParseCode" {
    Context "No arguments" {
        It "Mono unit" {
            ParseCode "--{test()}--" | Should -Be "-1-{test()}-1-"
        }
        It "Multi units" {
            ParseCode "--{test()}-- --{test()}--" | Should -Be "-1-{test()}-1- -2-{test()}-2-"
            ParseCode "--{test(--{test()}--)}--" | Should -Be "-1-{test(-2-{test()}-2-)}-1-"
            ParseCode "--{test(--{test()}--)}-- --{test()}--" | Should -Be "-1-{test(-2-{test()}-2-)}-1- -3-{test()}-3-"
        }
    }
    Context "Has arguments" {
        It "Mono unit" {
            ParseCode "--{test( &&& )}--" | Should -Be "-1-{test( &1& )}-1-"
            ParseCode "--{test( &&& &&& )}--" | Should -Be "-1-{test( &1& &1& )}-1-"
        }
        It "Multi units" {
            ParseCode "--{test( &&& )}-- --{test( &&& )}--" | Should -Be "-1-{test( &1& )}-1- -2-{test( &2& )}-2-"
            ParseCode "--{test(--{test( &&& )}--)}--" | Should -Be "-1-{test(-2-{test( &2& )}-2-)}-1-"
            ParseCode "--{test(--{test( &&& )}--)}-- --{test( &&& )}--" | Should -Be "-1-{test(-2-{test( &2& )}-2-)}-1- -3-{test( &3& )}-3-"
        }
    }
}
