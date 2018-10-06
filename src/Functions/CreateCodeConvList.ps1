class CodeConv {

    # Fields
    [string] $target
    [string] $templateName
    [string] $splitter

    # Constructor
    CodeConv ([string] $target, [string] $templateName, [string] $splitter) {
        $this.target = $target
        $this.templateName = $templateName
        $this.splitter = $splitter
    }

    # Methods
    [bool] Equals ([object] $obj) {
        return (
            $this.target -eq $obj.target -and
            $this.templateName -eq $obj.templateName -and
            $this.splitter -eq $obj.splitter
        )
    }
}

function CreateCodeConvList {

    param (
        [string] $parsedCode
    )

    # Init
    [array] $list = @()
    [regex] $regex = [regex] "-([\d]+)-{([a-zA-z]+)\("

    # Create CodeConvList
    $regex.Matches($parsedCode) | % {
        [int] $index = $_.Groups[1].Value
        [string] $templateName = $_.Groups[2].Value
        [string] $target = "-$index-{$templateName\(([\s\S]*)\)}-$index-"
        [string] $splitter = "&$index&"
        $item = [CodeConv]::new($target, $templateName, $splitter)
        $list += $item
    }

    return $list
}
