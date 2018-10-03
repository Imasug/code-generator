$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "ReplaceTemplates" {
    Context "normal" {
        It "no arg" {
            [hashtable] $templateMap = @{ test1 = "test1" }
            [string] $code = "--{test1()}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1"
            [string] $code = "--{test1( )}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1"
            [string] $code = "--{test1(　)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1"
            [string] $code = "--{test1(,)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1"
        }
        It "mono arg" {
            [hashtable] $templateMap = @{ test1 = "test1 {0}" }
            [string] $code = "--{test1(aaa)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa"
            [string] $code = "--{test1( aaa)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa"
            [string] $code = "--{test1(　aaa)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa"
            [string] $code = "--{test1(aaa )}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa"
            [string] $code = "--{test1( aaa )}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa"
        }
        It "multi arg" {
            [hashtable] $templateMap = @{ test1 = "test1 {0} {1}" }
            [string] $code = "--{test1(aaa&&bbb)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa bbb"
            [string] $code = "--{test1( aaa&&bbb)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa bbb"
            [string] $code = "--{test1( aaa &&bbb)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa bbb"
            [string] $code = "--{test1( aaa && bbb)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa bbb"
            [string] $code = "--{test1( aaa && bbb )}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 aaa bbb"
        }
        It "nest" {
            [hashtable] $templateMap = @{ test1 = "test1 {0}"; test2 = "test2" }
            [string] $code = "--{test1(--{test2()}--)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 test2"
            [hashtable] $templateMap = @{ test1 = "test1 {0} {1}"; test2 = "test2" }
            [string] $code = "--{test1(--{test2()}-- && --{test2()}--)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 test2 test2"
            [hashtable] $templateMap = @{ test1 = "test1 {0}"; test2 = "test2" }
            [string] $code = "--{test1(--{test1(--{test2()}--)}--)}--"
            ReplaceTemplates $code $templateMap | Should -Be "test1 test1 test2"
        }
    }
    Context "abnormal" {
        It "no key" {
            [hashtable] $templateMap = @{ test1 = "test1" }
            [string] $code = "--{test2()}--"
            { ReplaceTemplates $code $templateMap } | Should -Throw "[test2] key isn't defined!"
        }
    }
}
