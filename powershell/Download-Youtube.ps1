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

# add subtitles to the video without re-encoding
function AddSubtitles {
    param (
        $videoPath,
        $subtitlesPath,
        $outputPath
    )

    & ffmpeg -i $videoPath -i $subtitlesPath -c copy -scodec mov_text $outputPath
}

function DownloadVideo {
    param (
        $url
    )

    python -m youtube_dl $url --config-location $youtubedlConfigFile
    $exitStatus = $LASTEXITCODE

    Write-Host "exit status: $exitStatus"

    # timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # if the exit status is not 0, throw an exception
    if ($exitStatus -ne 0) {
        # write error log to the log file
        Add-Content -Path "$currentPath\logs\error.log" -Value "[$timestamp] $url : exit status: $exitStatus"

        throw "exit status: $exitStatus"
    }

    # write success log to the log file
    Add-Content -Path "$currentPath\logs\download.log" -Value "[$timestamp] $url"
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
        $url
    )

    $restApi = "http://127.0.0.1:3000/download"
    $body = @{
        url = $url
    } | ConvertTo-Json

    try {
        $response = Invoke-RestMethod -Uri $restApi -Method Post -Body $body -ContentType "application/json"

        if ($response.status -ne 0) {
            # log error
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            Add-Content -Path "$currentPath\logs\error.log" -Value "[$timestamp] $url : udpate download status failed ${response.message} "
        }    
    }
    catch {
        # log error
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Add-Content -Path "$currentPath\logs\error.log" -Value "[$timestamp] $url : udpate download status failed ${_.Exception.Message} "
    }
    
    
}
$urlItems = getUrlItems

# loop through the list of URLs
foreach ($item in $urlItems) {
    try {
        Write-Host $item.url
        DownloadVideo $item.url
        updateDownloadStatus $item.url
    }
    catch {
        continue
    }
}
