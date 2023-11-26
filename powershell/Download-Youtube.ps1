# download the videos from a list of URLs using youtube-dl

$currentPath = Get-Location

# add youtube-dl module to the path
$youtubedlPath = "D:\Dev\repo\youtube-dl"
$env:PYTHONPATH += ";$youtubedlPath"

$youtubedlConfigFile = "$currentPath/youtube-dl.conf"

# ensure log file exists
if (-not (Test-Path "$currentPath\logs")) {
    New-Item -Path "$currentPath\logs" -ItemType Directory
}

function DownloadVideo {
    param (
        $item
    )

    python -m youtube_dl $item.url --config-location $youtubedlConfigFile
    $exitStatus = $LASTEXITCODE

    Write-Host "exit status: $exitStatus"

    # timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # if the exit status is not 0, throw an exception
    if ($exitStatus -ne 0) {
        # write error log to the log file
        Add-Content -Path "$currentPath\logs\error.log" -Value "[$timestamp] ${item.id} : exit status: $exitStatus"

        throw "exit status: $exitStatus"
    }

    # write success log to the log file
    Add-Content -Path "$currentPath\logs\download.log" -Value "[$timestamp] ${item.id}"

    updateDownloadStatus $item
}

function  getUrlItems {
    $restApi = "http://127.0.0.1:3000/not-download"
    $body = @{
        key1 = "value1"
        key2 = "value2"
    } | ConvertTo-Json
    
    $response = Invoke-RestMethod -Uri $restApi -Method Post -Body $body -ContentType "application/json"

    # get urls from response {data:[{url:'xxx'}]}
    $urls = $response.data
    
    return $urls
}

function  updateDownloadStatus {
    param (
        $item
    )

    $restApi = "http://127.0.0.1:3000/download"
    $body = @{
        url = $item.url
    } | ConvertTo-Json

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    try {
        $response = Invoke-RestMethod -Uri $restApi -Method Post -Body $body -ContentType "application/json"

        if ($response.status -ne 0) {
            # log error
            Add-Content -Path "$currentPath\logs\error.log" -Value "[$timestamp] ${item.id} : udpate download status failed ${response.message} "
        }    
    }
    catch {
        # log error
        Add-Content -Path "$currentPath\logs\error.log" -Value "[$timestamp] ${item.id} : udpate download status failed ${_.Exception.Message} "
    }
}

function Start-Download {
    
    $urlItems = getUrlItems
    
    # loop through the list of URLs
    foreach ($item in $urlItems) {
        try {
            DownloadVideo $item
        }
        catch {
            continue
        }
    }

    # sleep 5 seconds
    Start-Sleep -Seconds 5

    $urlItems = getUrlItems
    if ($urlItems.Count -gt 0) {
        Start-Download
    }
}

Start-Download