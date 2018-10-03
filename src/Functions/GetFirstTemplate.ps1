$here = Split-Path -Parent $MyInvocation.MyCommand.Path
. $here\Constants.ps1

function QueueToString {
    param (
        [System.Collections.Queue] $queue
    )
    [string] $str = ""
    foreach ($c in $queue) {
        $str += $c
    }
    return $str
}

function GetFirstTemplate {
    param (
        [string] $code
    )
    [int] $startPos = 0
    [int] $endPos = 0
    [int] $unit = 0
    [System.Collections.Queue] $queue = New-Object System.Collections.Queue
    for ($i = 0; $i -lt $code.Length; $i++) {
        $queue.Enqueue($code[$i])
        if ($queue.Count -eq $ExprLen) {
            $str = QueueToString $queue
            if ($str -eq $StartExpr) {
                if ($unit -eq 0) {
                    $startPos = $i - $ExprLen + 1 
                }
                $unit++
            }
            elseif ($str -eq $EndExpr) {
                if ($unit -eq 1) {
                    $endPos = $i
                    break
                }
                $unit--
            }
            $exit = $queue.Dequeue()
        }
    }

    if ($endPos -eq 0) {
        return $null 
    }
    else {
        return $code.Substring($startPos, $endPos - $startPos + 1)
    }
}