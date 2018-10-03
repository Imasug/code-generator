$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. $here\Constants.ps1
. $here\ParseFirstTemplate.ps1
. $here\GetFirstTemplate.ps1

function ReplaceTemplates {
    param (
        [string] $code,
        [hashtable] $templateMap
    )

    # It guarantee to have the correct template
    $template = GetFirstTemplate $code

    # If the code doesn't have template, returns the code
    if ($null -eq $template) {
        return $code
    }

    # It guarantee to match the template regex
    [array] $result = ParseFirstTemplate $template
    [string] $key = $result[1]
    [string] $arg = $result[2]
    [array] $argArr = $arg -split $Qualifier
    if (-not($templateMap.ContainsKey($key))) {
        throw "[$key] key isn't defined!"
    }
    [string] $insert = $templateMap[$key]
    for ($i = 0; $i -lt $argArr.Count; $i++) {
        $insert = $insert.Replace("{$i}", $argArr[$i].trim())
    }
    $contents = $code.Replace($template, $insert)

    return (ReplaceTemplates $contents $templateMap)
}