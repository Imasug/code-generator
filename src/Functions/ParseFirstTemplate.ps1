$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. $here\Constants.ps1

function ParseFirstTemplate {
    param (
        # Must Be treated by GetFirstTemplate
        [string] $code
    )
    $result = $TemplatePattern.match($code)

    if ($result.Success) {
        return $result.Groups
    }
    else {
        throw "[$code] doesn't match the template regex!"
    }
}