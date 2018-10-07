. .\Settings.ps1

$Timeout = 100
$ExecInterval = 300
function registFileWatcher {

    param (
        [string] $path = ".",
        [string] $filter = "*.*",
        [string] $exclude,
        [scriptblock] $action
    )

    [System.IO.FileSystemWatcher] $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = $path
    $watcher.Filter = $filter
    $history = New-Object System.Collections.Queue
    $before = Get-date

    while ($true) {

        $watcher.IncludeSubdirectories = $true
        $result = $watcher.WaitForChanged([System.IO.WatcherChangeTypes]::All, $Timeout)

        $changeType = $result.ChangeType
        $name = $result.Name

        $current = Get-Date
        if ($history.Count -gt 0) {
            $before = $history.Dequeue()
        }

        if (($name.Length -ne 0) -and (($current - $before).TotalMilliseconds -gt $ExecInterval)) {
            if ((!$exclude) -or ($name -cnotmatch $exclude)) {
                Write-Host "[$changeType] $name $((Get-Date).ToUniversalTime())"
                & $action
                $history.Enqueue($current)
            }
        }
    }
}

registFileWatcher -exclude $IgnoreDir -action $Action