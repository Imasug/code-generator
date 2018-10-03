$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ParseFirstTemplate" {
    Context "normal" {
        It "mono" {
            (ParseFirstTemplate "--{test()}--") | Should -Be @("--{test()}--", "test", "")
            (ParseFirstTemplate "--{111()}--") | Should -Be @("--{111()}--", "111", "")
            (ParseFirstTemplate "--{test1(aaa)}--") | Should -Be @("--{test1(aaa)}--", "test1", "aaa")
        }
        It "nest" {
            (ParseFirstTemplate "--{test1(--{test2()}--)}--") | Should -Be @("--{test1(--{test2()}--)}--", "test1", "--{test2()}--")
            (ParseFirstTemplate "--{test1(a--{test2()}--)}--") | Should -Be @("--{test1(a--{test2()}--)}--", "test1", "a--{test2()}--")
            (ParseFirstTemplate "--{test1(--{test2()}--a)}--") | Should -Be @("--{test1(--{test2()}--a)}--", "test1", "--{test2()}--a")
            (ParseFirstTemplate "--{test1(a--{test2()}--a)}--") | Should -Be @("--{test1(a--{test2()}--a)}--", "test1", "a--{test2()}--a")
        }
    }
    Context "abnormal" {
        It "doesn't match the template regex" {
            { ParseFirstTemplate "--{test1}--" } | Should -Throw "[--{test1}--] doesn't match the template regex!"
            { ParseFirstTemplate "--{test1(}--" } | Should -Throw "[--{test1(}--] doesn't match the template regex!"
            { ParseFirstTemplate "--{test1)}--" } | Should -Throw "[--{test1)}--] doesn't match the template regex!"
        }
    }
}
