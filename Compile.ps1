Write-Host "Start ->"

. .\Settings.ps1

# Read Functions
Get-ChildItem $FuncDir -Filter *.ps1 | ? { -not($_.name.Contains("Tests")) } | % {
    . $_.FullName
}

$templateMap = CreateTemplateMap "$TemplateDir"

Get-ChildItem $InputDir * | % {
    $execTime = Measure-Command {
        $code = Get-Content $_.FullName -Raw -Encoding UTF8
        $contents = ReplaceTemplates $code $templateMap
        $fileName = $_.Name
        $contents | Out-File "$OutputDir\$fileName" -Encoding utf8
    }
    Write-Host "  $($_.Name) -> $($execTime.TotalMilliseconds)"
}

Write-Host "End <-"