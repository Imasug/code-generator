function QueueToString {

    param (
        [System.Collections.Queue] $queue
    )

    [string] $str = ""
    foreach ($item in $queue) {
        $str += $item
    }

    return $str
}

function ParseCode {

    param (
        [string] $code
    )

    # Init
    [int] $index = 0
    [int] $StrQueueMaxSize = 3
    [System.Collections.Queue] $strQueue = New-Object System.Collections.Queue
    [System.Collections.Stack] $indexStack = New-Object System.Collections.Stack
    [string] $parsedCode = ""

    # Read the code
    foreach ($c in $code.ToCharArray()) {
        
        $strQueue.Enqueue($c)

        # When the queue is full
        if ($strQueue.Count -eq $StrQueueMaxSize) {

            [string] $str = QueueToString $strQueue

            switch ($str) {
                "--{" {
                    $strQueue.Clear()
                    $indexStack.Push(++$index)
                    $parsedCode += "-$index-{"
                }
                "}--" { 
                    $strQueue.Clear()
                    $parsedCode += "}-$($indexStack.Pop())-"
                }
                "&&&" {
                    $strQueue.Clear()
                    $parsedCode += "&$($indexStack.Peek())&"
                }
                Default {
                    $parsedCode += $strQueue.Dequeue()
                }
            }
        }
    }

    while ($strQueue.Count -gt 0) {
        $parsedCode += $strQueue.Dequeue()
    }

    return $parsedCode
}