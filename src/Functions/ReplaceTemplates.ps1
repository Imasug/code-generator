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

        [regex] $target = [regex] $codeConv.target
        [string] $templateName = $codeConv.templateName
        [string] $splitter = $codeConv.splitter

        $result = $target.Matches($parsedCode)
        foreach ($item in $result) {

            [string] $match = $item.Groups[0].Value
            [string] $arg = $item.Groups[1].Value
            [array] $argArr = $arg -split $splitter

            [string] $insert = $templateMap[$templateName]
            $insert = ReplaceTemplates $insert $templateMap
            for ($i = 0; $i -lt $argArr.Length; $i++) {
                [string] $argValue = $argArr[$i].Trim()
                if ($argValue.length -ne 0) {
                    [string] $replacement = ReplaceTemplates $argValue $templateMap
                    Write-Debug "`n$("templateName".PadRight(20)): $templateName`n$("index".PadRight(20)): {$i}`n$replacement`n"
                    $insert = $insert.Replace("{$i}", $replacement)
                }
            }
            $insert = $insert -replace "\{[\d]+\}", ""
            $insert = $insert -replace "##", ""
            $parsedCode = $parsedCode.Replace($match, $insert)
        }
    }

    return $parsedCode
}