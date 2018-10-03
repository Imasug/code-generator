. .\Settings.ps1

# Read Functions
Get-ChildItem $FuncDir -Filter *.ps1 | ? { -not($_.name.Contains("Tests")) } | % {
    . $_.FullName
}

$templateMap = CreateTemplateMap "$TemplateDir"

Get-ChildItem $InputDir * | % {
    $code = Get-Content $_.FullName -Raw -Encoding UTF8
    $contents = ReplaceTemplates $code $TemplateMap
    $fileName = $_.Name
    $contents | Out-File "$OutputDir\$fileName" -Encoding utf8
    Write-Host "output $fileName"
}