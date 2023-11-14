# download the videos from a list of URLs using youtube-dl

$currentPath = Get-Location

# add youtube-dl module to the path
$youtubedlPath = "D:\Dev\repo\youtube-dl"
$env:PYTHONPATH += ";$youtubedlPath"

$urlsPath = "$currentPath/youtube-urls.txt"
$youtubedlConfigFile = "$currentPath/youtube-dl.conf"

# if urls file does not exist, exit
if (-not (Test-Path $urlsPath)) {
    Write-Host "file $urlsPath does not exist"
    exit 0
}

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

function  getUrls {
    $urls = Get-Content -Path $urlsPath
    # filter out the comment line and the empty line
    $urls = $urls | Where-Object { $_ -notmatch "^#" } | Where-Object { $_ -ne "" }
    return $urls
}

$urls = getUrls

# loop through the list of URLs
foreach ($url in $urls) {
    try {
        DownloadVideo $url
    }
    catch {
        continue
    }
}
