$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "CreateTemplateMap" {
    Context "normal" {
        It "normal" {
            $dir = "$here/testTemplate/normal"
            $actual = CreateTemplateMap $dir
            $expected = @{ test1 = "test1"; test2 = "test2" }
            $actual.Count | Should -Be $expected.Count
            foreach ($key in $expected) {
                $actual[$key] | Should -Be $expected[$key]
            }
        }
    }
    Context "abnormal" {
        It "the template is duplicate" {
            $dir = "$here/testTemplate/abnormal/dup"
            { CreateTemplateMap $dir } | Should -Throw "[test] is duplicate!"
        }
        It "the template is empty" {
            $dir = "$here/testTemplate/abnormal/empty"
            { CreateTemplateMap $dir } | Should -Throw "[test] is empty!"
        }
    }
}
