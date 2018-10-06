function CreateTemplateMap {

    param (
        [string] $dir
    )

    $templateMap = @{}
    Get-ChildItem $dir * -Recurse | ? { -not($_.PSIsContainer) } | % {
        $key = $_.BaseName
        if ($templateMap.ContainsKey($key)) {
            throw "[$key] is duplicate!"
        }
        $value = Get-Content $_.FullName -Raw -Encoding UTF8
        if ($null -eq $value) {
            throw "[$key] is empty!"
        }
        $templateMap[$key] = $value
    }

    return $templateMap
}