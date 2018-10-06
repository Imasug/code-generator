$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. $here\ParseCode.ps1
. $here\CreateCodeConvList.ps1

function ReplaceTemplates {

    param (
        [string] $code,
        [hashtable] $templateMap
    )

    [string] $parsedCode = ParseCode $code

    [array] $codeConvList = CreateCodeConvList $parsedCode

    foreach ($codeConv in $codeConvList) {

        [regex] $regex = $codeConv.target
        [string] $templateName = $codeConv.templateName
        [string] $splitter = $codeConv.splitter

        $regex.Matches($parsedCode) | % {

            [string] $match = $_.Groups[0].Value
            [string] $arg = $_.Groups[1].Value
            [array] $argArr = $arg -split $splitter

            [string] $insert = $templateMap[$templateName]
            for ($i = 0; $i -lt $argArr.Length; $i++) {
                [string] $argValue = $argArr[$i].Trim()
                if ($argValue.length -ne 0) {
                    $insert = $insert.Replace("{$i}", (ReplaceTemplates $argValue $templateMap))
                }
            }
            $parsedCode = $parsedCode.Replace($match, $insert)
        }
    }
    return $parsedCode
}